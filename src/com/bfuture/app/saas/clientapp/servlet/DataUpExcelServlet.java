package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.clientapp.upload.UploadControler;
import com.bfuture.app.saas.model.DataUpExcel;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.DataUpExcelManager;
import com.bfuture.app.saas.service.impl.DataUpExcelManagerImpl;
import com.bfuture.app.saas.util.DataConfigFactory;
import com.bfuture.util.ini.IniSection;

/**
 * Servlet implementation class for Servlet: DataUpExcelServlet
 * 
 */
public class DataUpExcelServlet extends BasicServlet {

	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {
		ReturnObject ro = new ReturnObject();
		PrintWriter out = null;
		try {
			response.setCharacterEncoding("GBK");
			out = response.getWriter();
		} catch (IOException e1) {
			e1.printStackTrace();
			return;
		}
		// 变量定义
		int count = 0;
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// 设置内存缓冲区，超过后写入临时文件
		factory.setSizeThreshold(10240000);
		// 设置临时文件存储位置
		factory.setRepository(new File(request.getSession().getServletContext()
				.getRealPath("/" + UploadControler.UPLOAD_DIR + "/temp")));
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置单个文件的最大上传值
		upload.setFileSizeMax(102400000);
		// upload.setFileSizeMax(Integer.MAX_VALUE);
		// 设置整个request的最大值
		upload.setSizeMax(102400000);
		// upload.setSizeMax(Integer.MAX_VALUE);

		upload.setHeaderEncoding("GBK");

		boolean bo = false;
		try {
			List items = upload.parseRequest(request);
			// 要导入excel模板名字
			String excelTempleName = "";
			// 实例名
			String sgcode = "";
			// 块名称
			String sectionName = "";
			// 执行manager名字
			String manager = "";
			// 处理请求参数
			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);
				if (item.isFormField()
						&& "excelTempleName".equals(item.getFieldName())) {
					excelTempleName = item.getString();
				}
				if (item.isFormField() && "sgcode".equals(item.getFieldName())) {
					sgcode = item.getString();
				}
				if (item.isFormField()
						&& "sectionName".equals(item.getFieldName())) {
					sectionName = item.getString();
				}
				if (item.isFormField()
						&& "ACTION_MANAGER".equals(item.getFieldName())) {
					manager = item.getString();
				}
			}
			Map<String, IniSection> mapSection = null;
			// 取出对应块信息
			if (sectionName != null && !"".equals(sectionName)) {
				mapSection = DataConfigFactory.getSectionsByName(sectionName);
			}
			// 取出对应模板信息
			IniSection section = null;
			if (mapSection != null) {
				section = mapSection.get(excelTempleName);
			}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssss");
			StringBuilder filepath = new StringBuilder();
			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);
				// 获取当前用户
				SysScmuser smUser = getCurrentUser(request);
				if (smUser == null) {
					ro.setReturnCode(Constants.ERROR_FLAG);
					ro.setReturnInfo("登录已超时，请重新登录");
				}
				// 保存文件
				if (!item.isFormField() && item.getName().length() > 0) {
					if (section != null) {
						// 获取文件上传目录
						filepath.append(request.getSession()
								.getServletContext().getRealPath(
										section.getItemValue("DataUpDir", "")));
						// 判断目录是否存在，如果不存在，就创建这个目录
						File dir = new File(filepath.toString());
						if (!dir.isDirectory()) {
							dir.mkdir();
						}
					}
					// 获取文件后缀名
					String fileExtName = getFileExtName(item.getName());
					// 用时间戳作为文件名
					filepath.append(File.separator).append(
							sdf.format(new Date())).append(fileExtName);
					item.write(new File(filepath.toString()));
					log.info("NewSaaS写入文件地址：" + filepath.toString());
					log.info("上传文件成功！！");
					// 获取导入manager
					BaseManager excelDataUp = (BaseManager) super
							.getSpringBean(manager);
					try {
						// 导入excel里面数据
						DataUpExcel dataUpExcel = new DataUpExcel();
						dataUpExcel.setIniSection(section);
						dataUpExcel.setImportFilePath(filepath.toString());
						dataUpExcel.setSgcode(sgcode);
						ro = excelDataUp.ExecOther("import",
								new Object[] { dataUpExcel });
					} catch (Exception ex) {
						ro.setReturnCode(Constants.ERROR_FLAG);
						ro.setReturnInfo("导入文件时发生错误:" + ex.getMessage());
						log.debug("导入文件时发生错误:" + ex.getMessage());
					}
				}
			}
		} catch (FileUploadException e) {
			ro.setReturnCode(Constants.ERROR_FLAG);
			ro.setReturnInfo("上传文件时发生错误:" + e.getMessage());
			log.info("上传文件时发生错误:" + e.getMessage());
		} catch (Exception e) {
			ro.setReturnCode(Constants.ERROR_FLAG);
			ro.setReturnInfo("保存上传文件时发生错误:" + e.getMessage());
			log.info("保存上传文件时发生错误:" + e.getMessage());
		} finally {
			out.println(JSONObject.fromObject(ro).toString());
			out.close();
		}
	}

	/**
	 * 获取上传文件后缀名
	 * 
	 * @param s
	 * @return
	 */
	private String getFileExtName(String filePath) {
		int pos = filePath.lastIndexOf(".");
		if (pos > 0) {
			return filePath.substring(pos);
		} else {
			return filePath;
		}
	}

	/**
	 * 获取系统当前用户
	 * 
	 * @return 系统当前用户HttpServletRequest request
	 */
	public SysScmuser getCurrentUser(HttpServletRequest request) {
		SysScmuser smUser = null;
		smUser = (SysScmuser) request.getSession().getAttribute(
				Constants.LOGIN_USER);
		return smUser;
	}

}