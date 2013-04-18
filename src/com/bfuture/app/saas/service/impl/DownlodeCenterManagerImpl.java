package com.bfuture.app.saas.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.DownlodeCenter;
import com.bfuture.app.saas.model.InfGoods;
import com.bfuture.app.saas.model.InvoiceDZDXFX;
import com.bfuture.app.saas.model.report.Downlode;
import com.bfuture.app.saas.service.DownlodeCenterManager;

public class DownlodeCenterManagerImpl extends BaseManagerImpl implements
		DownlodeCenterManager {
	protected final Log log = LogFactory
			.getLog(DownlodeCenterManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public DownlodeCenterManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if ("upfile".equals(actionType)) {
			DownlodeCenter dc = (DownlodeCenter) o[0];
			dc.setCrtByTime(new Date());
			dc.setForm_id(user.getSucode());
			System.out.println("--" + dc.getInsC() + "--" + dc.getCrtByC()
					+ "--" + dc.getTitle() + "--" + dc.getUrl());
			try {
				// dao.save(dc);
				dao.saveEntity(dc);
				result.setReturnCode(Constants.SUCCESS_FLAG);
			} catch (Exception ex) {
				result.setReturnCode(Constants.ERROR_FLAG);
			}
		} else if ("getDocument".equals(actionType)) {
			DownlodeCenter dc = (DownlodeCenter) o[0];
			try {
				StringBuffer sql = new StringBuffer(
						"select dc.id,dc.ins_c,dc.title,dc.url,dc.crt_by_c,dc.memo,to_char(dc.crt_by_time,'yyyy-MM-dd') as crt_by_time from downlode_center  dc where 1=1 ");

				/**if (!StringUtil.isBlank(user.getSucode())) {
					sql.append(" and dc.to_id='").append(user.getSucode())
							.append("' ");					
				}**/
				if (!StringUtil.isBlank(dc.getInsC())) {
					sql.append(" and dc.ins_c='").append(dc.getInsC()).append(
							"' ");
				}
				if (!StringUtil.isBlank(dc.getStartDate())) {
					sql.append(" and dc.CRT_BY_TIME >= to_date('").append(
							dc.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(dc.getEndDate())) {
					sql.append(" and dc.CRT_BY_TIME <= to_date('").append(
							dc.getEndDate()).append("','yyyy-MM-dd')");
				}
				sql.append(" order by dc.crt_by_time desc ");
				int limit = dc.getRows();
				int start = (dc.getPage() - 1) * dc.getRows();
				List lstResult = dao.executeSql(sql.toString(), start, limit);

				StringBuffer count = new StringBuffer(
						"select count(*) from downlode_center dc where 1=1 ");
				
				/**if (!StringUtil.isBlank(user.getSucode())) {
					count.append(" and dc.to_id='").append(user.getSucode())
							.append("' ");
				}**/
				if (!StringUtil.isBlank(dc.getInsC())) {
					count.append(" and dc.ins_c='").append(dc.getInsC())
							.append("' ");
				}
				if (!StringUtil.isBlank(dc.getStartDate())) {
					count.append(" and dc.CRT_BY_TIME >= to_date('").append(
							dc.getStartDate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(dc.getEndDate())) {
					count.append(" and dc.CRT_BY_TIME <= to_date('").append(
							dc.getEndDate()).append("','yyyy-MM-dd')");
				}

				List lstcountResult = dao.executeSqlCount(count.toString());

				if (lstResult != null) {
					result.setRows(lstResult);
					result.setTotal(Integer.parseInt(lstcountResult.get(0)
							.toString()));
					result.setReturnCode(Constants.SUCCESS_FLAG);
				}
			} catch (Exception ex) {
				log.error("DownLodeCenterManagerImpl.getDocument() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());

			}

		} else if ("deleteDocument".equals(actionType)) {
			// 多个对象 删除
			try {
				for (Object obj : o) {
					DownlodeCenter dc = (DownlodeCenter) obj;
					StringBuffer hql = new StringBuffer(
							"from com.bfuture.app.saas.model.DownlodeCenter dc where 1 = 1 ");
					if (!StringUtil.isBlank(user.getSucode())) {
						hql.append(" and dc.form_id='").append(user.getSucode())
								.append("' ");
					}
					if (!StringUtil.isBlank(dc.getInsC())) {
						hql.append(" and dc.ins_c= '").append(dc.getInsC())
								.append("' ");
					}
					if (!StringUtil.isBlank(dc.getId().toString())) {
						hql.append(" and dc.id = '" + dc.getId() + "'");

						List lstResult = dao.executeHql(hql.toString());
						if (lstResult != null && lstResult.size()>0) {
							DownlodeCenter deleteDocument = (DownlodeCenter) lstResult
									.get(0);
							// 此处删除文件
							String sgcode = deleteDocument.getInsC();
							String title = deleteDocument.getUrl();
							String classpath = this.getClass().getResource("/")
									.getPath();
							String webpath = classpath.substring(0, classpath
									.indexOf("saasweb71"))
									+ "saasweb71"
									+ File.separator
									+ "upload"
									+ File.separator;
							String filepath = webpath + sgcode + "_" + title;
							File thisfile = new File(filepath);
							try {
								if (thisfile.exists()) {
									thisfile.delete();// web删除
								}
							} catch (Exception ex) {
								log.error("文件删除失败，位置：" + filepath);
							}
							System.out.println(webpath);
							String sql = "delete from DOWNLODE_CENTER dc where 1 = 1  and dc.form_id='"+user.getSucode()+"'  and dc.id = '"+dc.getId() +"'";
							dao.updateSql(sql);
							// remove(deleteDocument);// 删除记录
						}
					}
				}
				result.setReturnCode(Constants.SUCCESS_FLAG);

			} catch (Exception e) {
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
				e.printStackTrace();
			}

		}
		return result;
	}

	@Override
	public ReturnObject getResult(Object o) {

		ReturnObject result = new ReturnObject();
		try {

			Downlode downlode = (Downlode) o;

			StringBuffer countSql = new StringBuffer(
					"select count(*) from DOWNLODE_CENTER dc WHERE 1 =1 ");

			/**if (!StringUtil.isBlank(user.getSucode())) {
				log.debug("user.getSucode()" + user.getSucode());
				countSql.append(" and dc.to_id='").append(user.getSucode())
						.append("' ");
			}**/
			if (!StringUtil.isBlank(downlode.getSucode())) {
				log.debug("user.getSucode()" + downlode.getSucode());
				countSql.append(" and dc.to_id='").append(downlode.getSucode())
						.append("' ");
			}
			if (!StringUtil.isBlank(user.getSgcode())) {
				log.debug("user.getSgcode()" + user.getSgcode());
				countSql.append(" and INS_C = '").append(user.getSgcode())
						.append("'");
			}
			if (!StringUtil.isBlank(downlode.getStartDate())) {
				log
						.debug("downlode.getStartDate(): "
								+ downlode.getStartDate());
				countSql.append(" and CRT_BY_TIME >= to_date('").append(
						downlode.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(downlode.getEndDate())) {
				log.debug("downlode.getEndDate(): " + downlode.getEndDate());
				countSql.append(" and CRT_BY_TIME <= to_date('").append(
						downlode.getEndDate()).append("','yyyy-MM-dd')");
			}
			log.info(countSql);
			List lstResult = dao.executeSql(countSql.toString());
			log.info("DownlodeCenterManagerImpl.getDetail() lstResult"
					+ lstResult);

			if (lstResult != null) {
				result.setTotal(Integer.parseInt(((Map) lstResult.get(0)).get(
						"COUNT(*)").toString()));
			}

			StringBuffer sql = new StringBuffer(
					"select * from DOWNLODE_CENTER WHERE 1 =1 ");

			int limit = downlode.getRows();

			int start = (downlode.getPage() - 1) * downlode.getRows();

			/**if (!StringUtil.isBlank(user.getSucode())) {
				log.debug("user.getSgcode()" + user.getSucode());
				sql.append(" and dc.to_id='").append(user.getSucode())
						.append("' ");
			}**/
			if (!StringUtil.isBlank(downlode.getSucode())) {
				log.debug("user.getSucode()" + downlode.getSucode());
				countSql.append(" and dc.to_id='").append(downlode.getSucode())
						.append("' ");
			}
			if (!StringUtil.isBlank(user.getSgcode())) {
				log.debug("user.getSgcode()" + user.getSgcode());
				sql.append(" and INS_C = '").append(user.getSgcode()).append(
						"'");
			}
			if (!StringUtil.isBlank(downlode.getStartDate())) {
				log
						.debug("downlode.getStartDate(): "
								+ downlode.getStartDate());
				sql.append(" and CRT_BY_TIME >= to_date('").append(
						downlode.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(downlode.getEndDate())) {
				log.debug("downlode.getEndDate(): " + downlode.getEndDate());
				sql.append(" and CRT_BY_TIME <= to_date('").append(
						downlode.getEndDate()).append("','yyyy-MM-dd')");
			}
			sql.append(" order by CRT_BY_TIME desc");
			log.info("------sql-------" + sql);

			lstResult = dao.executeSql(sql.toString(), start, limit);

			if (lstResult != null && lstResult.size() > 0) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);

			}

		} catch (Exception ex) {
			log.error("DownlodeCenterManagerImpl error : " + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
			ex.printStackTrace();
		}

		return result;
	}

}
