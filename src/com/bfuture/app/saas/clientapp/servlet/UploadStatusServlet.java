package com.bfuture.app.saas.clientapp.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.saas.clientapp.upload.FileUploadStatus;
import com.bfuture.app.saas.clientapp.upload.UploadControler;

/**
 * Servlet implementation class UploadServlet
 */
public class UploadStatusServlet extends BasicServlet {	
	
	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {		
		PrintWriter out = null;
		try {
			response.setCharacterEncoding("GBK");
			out = response.getWriter();			
		} catch (IOException e) {			
			e.printStackTrace();
			return;
		}
		
		// 
		FileUploadStatus satusBean = null;		
		
		try {
			satusBean = UploadControler.getStatusBean( request, request.getRemoteAddr() );			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			if( satusBean != null ){
				out.println( JSONObject.fromObject( satusBean ).toString() );
			}
			else{
				out.println( "{\"info\":\"no upload\"}" );
			}
			out.close();
		}
	}
}
