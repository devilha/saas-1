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
		
		if(fileName != null) {
			try{
					
				String picend = ".jpg"; // value.toString().substring(value.toString().indexOf("."));
				fileName = currUser.getSgcode() + "_md" + picend;
				
				//String uploadAbsolutePath = getServletContext().getInitParameter( "uploadAbsolutePath" ); // 项目外
				//String uploadRelativePath = getServletContext().getInitParameter( "uploadRelativePath" ); // 项目内
				
				// 删除实体图片
				//File file = new File( uploadAbsolutePath + File.separator + fileName ); // 项目外
				//System.out.println("删除项目外：" + uploadAbsolutePath + File.separator + fileName);
				//if(file.exists()) {
				//	file.delete();
				//}
				
				//String webuploadpath = request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath );
				//File webfile = new File( webuploadpath + File.separator + fileName ); // 项目内
				//System.out.println("删除项目内：" + webuploadpath + File.separator + fileName);
				//if(webfile.exists()) {
				//	webfile.delete();
				//}
				
				File file = new File( Constants.FileImgUrl + fileName);
				if(file.exists()) {
					file.delete();
				}
			}catch(Exception e) {
				return;
			}
			
		}
%>