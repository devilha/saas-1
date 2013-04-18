package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.impl.ShopInfoManagerImpl;
import com.bfuture.app.saas.util.Constants;

public class DownServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		final Log log = LogFactory.getLog(ShopInfoManagerImpl.class);
		try {
			request.setCharacterEncoding("utf-8");
			String filename = request.getParameter("filename");
			filename = new String(filename.getBytes("iso-8859-1"), "utf-8");
			//String name = filename.substring(filename.indexOf("_") + 1);
			Object obj = request.getSession().getAttribute("LoginUser");
			if (obj == null) {
				response.sendRedirect("login.jsp");
				return;
			}
			SysScmuser currUser = (SysScmuser) obj;
			//response.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(filename, "utf-8"));
			response.setHeader("content-disposition", "attachment;filename=" + filename);
			//filename = toUtf8String(filename);
			//log.info("filename2="+filename);
			File uploadedFile = new File(Constants.PromotionApplUrl + File.separator + currUser.getSgcode() + "_" + filename);
			log.info("--项目路径--" + uploadedFile.getPath());
			OutputStream out = response.getOutputStream();
			InputStream in = new FileInputStream(uploadedFile);
			Streams.copy(in, out, false);
		} catch (Exception e) {
			log.error("DownServlet:" + e.getMessage());
		}

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);

	}
	
	public static String toUtf8String(String s) {
	    StringBuffer sb = new StringBuffer();
	     for (int i=0;i<s.length();i++) {
	         char c = s.charAt(i);
	         if (c >= 0 && c <= 255) {
	             sb.append(c);
	         } else {
	             byte[] b;
	             try {
	                 b = Character.toString(c).getBytes("utf-8");
	             } catch (Exception ex) {
	                 System.out.println(ex);
	                 b = new byte[0];
	             }
	             for (int j = 0; j < b.length; j++) {
	                  int k = b[j];
	                  if (k < 0) k += 256;
	                  sb.append("%" + Integer.toHexString(k).
	                  toUpperCase());
	             }
	        }
	     }
	     return sb.toString();
	}

}
