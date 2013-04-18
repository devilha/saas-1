<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%

		//获取当前登录用户信息
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;		
		request.setCharacterEncoding("UTF-8");
		String fileName = request.getParameter("fileName");
		
		// 拼成的图片名称，不含后缀
		String serverPicName = currUser.getSgcode()+ currUser.getSupcode() + fileName.substring(0,fileName.indexOf("."));
		
		String serverPicNameMD5 = Constants.EncoderByMd5(serverPicName);
		
		if(fileName != null) {
			try{
					
				String picend = ".jpg"; // value.toString().substring(value.toString().indexOf("."));
				fileName = currUser.getSgcode() +"_"+ currUser.getSupcode() +"_"+ serverPicNameMD5 + picend;
				
				File file = new File( Constants.FileImgUrl + fileName);
				if(file.exists()) {
					file.delete();
				}
			}catch(Exception e) {
				return;
			}
			
		}
%>