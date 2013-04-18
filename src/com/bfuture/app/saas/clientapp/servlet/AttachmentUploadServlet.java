package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.util.Tools;

@SuppressWarnings("serial")
public class AttachmentUploadServlet extends BasicServlet {
	@Override
	public void performTask(HttpServletRequest request, HttpServletResponse response) {
		response.setContentType("text/html; charset=GBK");
		JSONObject ro = new JSONObject();

		String uploadAbsolutePath = getServletContext().getInitParameter("uploadAbsolutePath");
		String uploadRelativePath = getServletContext().getInitParameter("uploadRelativePath");

		DiskFileItemFactory factory = new DiskFileItemFactory();

		// 设置内存缓冲区，超过后写入临时文件
		factory.setSizeThreshold(10240000);

		// 设置临时文件存储位置
		File tempDir = new File(request.getSession().getServletContext().getRealPath("/" + uploadRelativePath + "/temp"));

		if (!tempDir.exists()) {
			tempDir.mkdirs();
		}

		factory.setRepository(tempDir);
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置单个文件的最大上传值
		upload.setFileSizeMax(102400000);
		// upload.setFileSizeMax(Integer.MAX_VALUE);
		// 设置整个request的最大值
		upload.setSizeMax(102400000);
		// upload.setSizeMax(Integer.MAX_VALUE);

		upload.setHeaderEncoding("GBK");

		SysScmuser smUser = getCurrentUser(request);

		PrintWriter out = null;
		try {
			response.setCharacterEncoding("GBK");
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}

		if (smUser == null) {
			ro.put("err", "当前登录已超时，请重新登录！");
			ro.put("msg", "");
			out.println(JSONObject.fromObject(ro).toString());
			out.close();
			return;
		}

		try {
			List items = upload.parseRequest(request);

			// 处理文件上传
			FileItem item = (FileItem) items.get(0);

			if (item.getSize() > 5 * 1024 * 1024) {
				ro.put("err", "不能上传大小超过5M的文件");
				ro.put("msg", "");
				return;
			}

			// 保存文件
			if (!item.isFormField() && item.getName().length() > 0) {
				// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
				// String filename = sdf.format(new Date()) + "_" + smUser.getSucode() + item.getName().substring(item.getName().lastIndexOf("\\") + 1);
				String filename = item.getName().substring(item.getName().lastIndexOf("\\") + 1);
				File uploadedDir = new File(request.getSession().getServletContext().getRealPath("/" + uploadRelativePath + "/" + smUser.getSucode()));
				File uploadedFile = new File(uploadedDir.getPath() + File.separator + filename);
				if (!uploadedDir.exists()) {
					uploadedDir.mkdirs();
				}

				log.debug("uploadFilePath:" + uploadedFile.getPath());

				// 开始上传文件
				item.write(uploadedFile);

				Thread.sleep(500);

				// 备份文件到绝对路径
				File backupDir = new File(uploadAbsolutePath + File.separator + smUser.getSucode());
				if (!backupDir.exists()) {
					backupDir.mkdirs();
				}
				Tools.copyFile(uploadedFile.getAbsolutePath(), backupDir.getAbsolutePath() + File.separator + uploadedFile.getName());

				ro.put("err", "");
				ro.put("msg", uploadRelativePath + "/" + smUser.getSucode() + "/" + uploadedFile.getName());
			}

		} catch (FileUploadException e) {
			ro.put("err", "上传文件时发生错误:" + e.getMessage());
			ro.put("msg", "");
		} catch (Exception e) {
			ro.put("err", "保存上传文件时发生错误:" + e.getMessage());
			ro.put("msg", "");
		} finally {
			out.println(JSONObject.fromObject(ro).toString());
			out.close();
		}
	}

	/**
	 * 获取系统当前用户
	 * 
	 * @return 系统当前用户HttpServletRequest request
	 */
	public SysScmuser getCurrentUser(HttpServletRequest request) {
		SysScmuser smUser = null;
		smUser = (SysScmuser) request.getSession().getAttribute(Constants.LOGIN_USER);
		return smUser;
	}
}
