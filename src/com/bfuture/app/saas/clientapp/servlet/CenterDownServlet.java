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

public class CenterDownServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		final Log log = LogFactory.getLog(ShopInfoManagerImpl.class);
		try {
			request.setCharacterEncoding("utf-8");
			String filename = request.getParameter("filename");
			filename = new String(filename.getBytes("iso-8859-1"), "utf-8");
			String name = filename.substring(filename.indexOf("_") + 1);
			Object obj = request.getSession().getAttribute("LoginUser");
			if (obj == null) {
				response.sendRedirect("login.jsp");
				return;
			}
			SysScmuser currUser = (SysScmuser) obj;
			response.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(name, "utf-8"));
			String uploadAbsolutePath = getServletContext().getInitParameter( "uploadAbsolutePath" ); // 项目外
			name=currUser.getSgcode()+"_"+name;
			String realpath= uploadAbsolutePath + File.separator + name;
			
			OutputStream out = response.getOutputStream();
			InputStream in = new FileInputStream(realpath);
			Streams.copy(in, out, false);
			
		} catch (Exception e) {
			log.error("DownServlet:" + e.getMessage());
		}

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);

	}

}
