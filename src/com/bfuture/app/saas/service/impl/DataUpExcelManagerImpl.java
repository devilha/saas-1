package com.bfuture.app.saas.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.log4j.Logger;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.DataUpExcel;
import com.bfuture.app.saas.service.DataUpExcelManager;
import com.bfuture.app.saas.util.ResourceProperties;
import com.bfuture.app.saas.util.Tools;
import com.bfuture.sms.util.StringUtils;
import com.bfuture.util.ini.IniSection;

public class DataUpExcelManagerImpl extends BaseManagerImpl implements
		DataUpExcelManager {

	final Logger log = Logger.getLogger(DataUpExcelManagerImpl.class);

	private Workbook workBook;
	private IniSection iniSection;
	private ResourceProperties properties;

	public DataUpExcelManagerImpl() {
		// 初始化资源文件
		properties = new ResourceProperties(Constants.PROPERTIESNAME);
	}

	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		// 导入数据
		if ("import".equals(actionType)) {
			DataUpExcel dataupExcel = (DataUpExcel) o[0];
			InputStream excelResource = null;
			try {
				excelResource = new FileInputStream(dataupExcel
						.getImportFilePath());
				workBook = Workbook.getWorkbook(excelResource);
				iniSection = dataupExcel.getIniSection();
				// 导入文件内容
				result = billheadkxItemDataUp(dataupExcel.getSgcode(),
						dataupExcel.getImportFilePath());
			} catch (Exception e) {
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo("解析数据文件出错：" + e.getMessage());
			} finally {
				try {
					excelResource.close();
				} catch (Exception e) {
				}
			}
		}
		return result;
	}

	/***************************************************************************
	 * 导入扣项信息
	 * 
	 * @return 实例名 ，文件路径
	 */
	public ReturnObject billheadkxItemDataUp(String sgcode, String srcfilepath) {
		ReturnObject result = new ReturnObject();
		// 获取目标文件名
		String srcFilename = getFileName(srcfilepath);
		log.info("页信息："
				+ properties.getProperty(iniSection.getItemValue("sheet", "")));
		Sheet sheet = workBook.getSheet(properties.getProperty(iniSection
				.getItemValue("sheet", "")));
		if (sheet == null) {
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo("Excel里没有结算扣项明细信息页");
			log.info("Excel里没有结算扣项明细信息页");
			return result;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");

		BasicDataSource ds = (BasicDataSource) getSpringBean("dataSource");
		// 所有列数
		int rsColumns = sheet.getColumns();
		// 获取Sheet表中所包含的总行数
		int rsRows = sheet.getRows();
		Cell cell = null;
		// 失败数量
		int faileCount = 0;
		// 导入成功数
		int successCount = 0;
		// 总条数
		int totalCount = 0;
		boolean flag = true;
		int count = 0;
		// 获取配置文件里面insert sql
		String InsertSql = iniSection.getItemValue("InsertSql", "");
		// 获取配置文件里面的deletesql
		String deleteSql = iniSection.getItemValue("DeleteSql", "");
		// 验证配置文件里面是否配置插入sql、删除sql和验证字段是否为必填
		if ("".equals(InsertSql) && "".equals(deleteSql)) {
			log
					.error("NewSaaS DataUp.cfg配置文件有误，isNull、InsertSql或DeleteSql没有配置");
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo("导入发生错误！");
			return result;
		}
		// 获取insertsql 和参数信息
		Map<String, Object> insertSqlMap = getSqlParam(InsertSql);
		// 获取deletesql 和参数信息
		Map<String, Object> deleteSqlMap = getSqlParam(deleteSql);
		Connection conn = null;
		PreparedStatement insertPs = null;
		PreparedStatement deletePs = null;
		try {
			// 获取对应导入sql
			String iSql = (String) insertSqlMap.get("sql");
			String dSql = (String) deleteSqlMap.get("sql");
			// 获取对应导入参数
			String[] insertParams = (String[]) insertSqlMap.get("params");
			String[] deleteParams = (String[]) deleteSqlMap.get("params");
			// 获取excel单元格的值是否为空
			String[] isnulls = iniSection.getItemValue("isNull", "").split(",");
			// 验证导入模板是否存在
			if ((StringUtils.isEmpty(iSql) || insertParams == null)
					|| (StringUtils.isEmpty(dSql) || deleteParams == null)
					|| (isnulls.length == 0)) {
				log.error("NewSaaS没有找到对应导入模板");
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo("导入发生错误！");
				return result;
			}
			conn = ds.getConnection();
			if (conn == null) {
				log.error("NewSaaS没有获取到数据库连接");
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo("没有获取到数据库连接！");
				return result;
			}
			insertPs = conn.prepareStatement(iSql.replace("[sgcode]",
					"'" + sgcode + "'").replace("[filename]",
					"'" + srcFilename + "'"));
			log.info("插入sql："
					+ iSql.replace("[sgcode]", sgcode).replace("[filename]",
							srcFilename));
			deletePs = conn.prepareStatement(dSql.replace("[sgcode]", "'"
					+ sgcode + "'"));
			log.info("删除sql：" + dSql.replace("[sgcode]", sgcode));
			for (int i = 1; i < rsRows; i++) {
				if (rsRows == i + 1
						&& "N".equals(isnulls[0])
						&& StringUtils.isEmpty(sheet.getCell(0, i)
								.getContents())) {
					break;
				}
				flag = true;
				totalCount++;
				// 遍历每个单元格
				for (int j = 0; j < rsColumns; j++) {
					cell = sheet.getCell(j, i);
					String content = cell.getContents();
					if ("N".equals(isnulls[j]) && StringUtils.isEmpty(content)
							&& rsRows != i + 1) {
						flag = false;
						faileCount++;
						break;
					}
					// 删除
					if (deleteParams.length > j) {
						try {
							if ("s".equalsIgnoreCase(deleteParams[j])) {
								deletePs.setString(j + 1, content);
							} else if ("n".equalsIgnoreCase(deleteParams[j])) {
								if (StringUtils.isEmpty(content))
									deletePs.setDouble(j + 1, 0);
								else
									deletePs.setDouble(j + 1, Double
											.parseDouble(content));
							} else if ("d".equalsIgnoreCase(deleteParams[j])) {
								if (StringUtils.isEmpty(content))
									deletePs.setTimestamp(j + 1, null);
								else {
									try {
										deletePs.setTimestamp(j + 1,
												new Timestamp(sdf
														.parse(content)
														.getTime()));
									} catch (ParseException e) {
										try {
											deletePs
													.setTimestamp(
															j + 1,
															new Timestamp(
																	sdf1
																			.parse(
																					content)
																			.getTime()));
										} catch (ParseException pe) {
											deletePs.setDate(j + 1,
													new java.sql.Date(sdf2
															.parse(content)
															.getTime()));
										}

									}
								}
							}
						} catch (Exception exception) {
							flag = false;
							faileCount++;
							deletePs.clearParameters();
							break;
						}
					}
					// 插入
					try {
						if ("s".equalsIgnoreCase(insertParams[j])) {
							insertPs.setString(j + 1, content);
						} else if ("n".equalsIgnoreCase(insertParams[j])) {
							if (StringUtils.isEmpty(content))
								insertPs.setDouble(j + 1, 0);
							else
								insertPs.setDouble(j + 1, Double
										.parseDouble(content));
						} else if ("d".equalsIgnoreCase(insertParams[j])) {
							if (StringUtils.isEmpty(content))
								insertPs.setTimestamp(j + 1, null);
							else {
								try {
									insertPs.setTimestamp(j + 1, new Timestamp(
											sdf.parse(content).getTime()));
								} catch (ParseException e) {
									try {
										insertPs.setTimestamp(j + 1,
												new Timestamp(sdf1.parse(
														content).getTime()));
									} catch (ParseException pe) {
										insertPs.setDate(j + 1,
												new java.sql.Date(sdf2.parse(
														content).getTime()));
									}
								}
							}
						}
					} catch (Exception exception) {
						flag = false;
						faileCount++;
						insertPs.clearParameters();
						break;
					}
				}
				if (flag) {
					count++;
					successCount++;
					deletePs.addBatch();
					insertPs.addBatch();
				}
				if (count == 500) {
					count = 1;
					try {
						deletePs.executeBatch();
						insertPs.executeBatch();
						conn.commit();
					} catch (Exception exp) {
						successCount -= count;
						faileCount += count;
						conn.rollback();
					} finally {
						deletePs.clearBatch();
						insertPs.clearBatch();
					}
				}
			}
			try {
				deletePs.executeBatch();
				insertPs.executeBatch();
				conn.commit();
			} catch (Exception exp) {
				successCount -= count;
				faileCount += count;
				conn.rollback();
				log.info("导入数据出现错误：" + exp.getMessage());
			} finally {
				deletePs.clearBatch();
				insertPs.clearBatch();
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setReturnInfo("共有" + totalCount + "条数据，成功导入"
						+ successCount + "条，失败" + faileCount + "条");
				log.info("共有" + totalCount + "条数据，成功导入" + successCount + "条，失败"
						+ faileCount + "条");
				// 备份文件
				backFile(srcfilepath, sgcode);
			}
		} catch (Exception ex) {
			log.info("导入发生错误：" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo("导入发生错误：" + ex.getMessage());
		} finally {
			if (deletePs != null) {
				try {
					deletePs.close();
				} catch (SQLException e) {
				}
			}
			if (insertPs != null) {
				try {
					insertPs.close();
				} catch (SQLException e) {
				}
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception ex) {
				}
			}
		}
		return result;
	}

	/**
	 * 解析配置文件里面的sql
	 * 
	 * @param sql
	 * @return
	 */
	private Map<String, Object> getSqlParam(String sql) {
		Map<String, Object> result = new HashMap<String, Object>();
		StringBuffer stmp = new StringBuffer();
		StringBuffer ctmp = new StringBuffer();
		ArrayList<String> params = new ArrayList<String>();

		int len = sql.length();
		boolean flag = false;
		for (int i = 0; i < len; i++) {
			char c = sql.charAt(i);
			if (c == '{') {
				flag = true;
				ctmp.delete(0, ctmp.length());
			} else if (c == '}') {
				flag = false;
				ctmp.trimToSize();

				String t = ctmp.toString();
				params.add(t);
				stmp.append("?");
			} else if (flag) {
				ctmp.append(c);
			} else {
				stmp.append(c);
			}
		}
		String[] pams = new String[params.size()];
		for (int i = 0; i < params.size(); i++) {
			pams[i] = params.get(i);
		}
		result.put("params", pams);
		result.put("sql", stmp.toString());

		return result;
	}

	/**
	 * 备份导入文件
	 * 
	 * @param srcfilepath要备份文件完整路径
	 */
	private void backFile(String srcfilepath, String sgcode) {
		StringBuilder dstpath = new StringBuilder();
		dstpath.append(iniSection.getItemValue("BackDir", ""));
		String fullname = getFileFullName(srcfilepath);
		if (StringUtils.isEmpty(dstpath.toString())) {
			log.error("NewSaaS备份文件目录不存在！！");
		} else {
			try {
				log.info("源文件路径：" + srcfilepath);
				dstpath.append(File.separator).append(sgcode).append(
						File.separator).append(fullname);
				log.info("备份文件目录：" + dstpath.toString());
				Tools.copyFile(srcfilepath, dstpath.toString());
			} catch (Exception e) {
				log.error("NewSaaS备份文件出错：" + e.getMessage());
			}
		}
	}

	/**
	 * 获取文件名
	 * 
	 * @param 文件路径
	 * @return
	 */
	private String getFileName(String s) {
		int i = 0;
		i = s.lastIndexOf('/');
		if (i != -1)
			return s.substring(i + 1, s.lastIndexOf("."));
		i = s.lastIndexOf('\\');
		if (i != -1)
			return s.substring(i + 1, s.lastIndexOf("."));
		else
			return s;
	}

	/**
	 * 获取文件全（加后缀名）名
	 * 
	 * @param 文件路径
	 * @return
	 */
	private String getFileFullName(String s) {
		int i = 0;
		i = s.lastIndexOf('/');
		if (i != -1)
			return s.substring(i + 1, s.length());
		i = s.lastIndexOf('\\');
		if (i != -1)
			return s.substring(i + 1, s.length());
		else
			return s;
	}

}
