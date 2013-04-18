package com.bfuture.app.saas.clientapp.servlet;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bfuture.app.basic.clientapp.servlet.BasicServlet;

/**
 * 用于采购洽谈上传模板的下载
 */
public class NoticeDownServlet extends BasicServlet{

	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {
		
		String name = "inform.xls"; // request.getParameter("fileName");

		  // web绝对路径
		  String path = request.getSession().getServletContext().getRealPath("/");
		  String savePath = path + "doc";

		  // 设置为下载application/x-download
		  response.setContentType("application/x-download");
		  // 即将下载的文件在服务器上的绝对路径
		  String filenamedownload = savePath + "/" + name;
		  // 下载文件时显示的文件保存名称
		  String filenamedisplay = name;
		  
		  try {
			  
			// 中文编码转换
			  filenamedisplay = URLEncoder.encode(filenamedisplay, "UTF-8");
			  response.addHeader("Content-Disposition", "attachment;filename=" + filenamedisplay);
			  
		   java.io.OutputStream os = response.getOutputStream();
		   java.io.FileInputStream fis = new java.io.FileInputStream(
		     filenamedownload);
		   byte[] b = new byte[1024];
		   int i = 0;
		   while ((i = fis.read(b)) > 0) {
		    os.write(b, 0, i);
		   }
		   fis.close();
		   os.flush();
		   os.close();
		  } catch (Exception e) {

		  }

		 }

	
}
