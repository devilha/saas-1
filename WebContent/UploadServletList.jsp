<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%		
		// 获取当前登录用户信息
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	
		// 执行图片处理操作
		FileItemFactory  factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		try {
			request.setCharacterEncoding("UTF-8");
			List<FileItem> list = upload.parseRequest(request);
			
			FileItem fileItem = list.get(0);
			
			Long filesize = fileItem.getSize()/1024; // 单位kb

			if(filesize > 5120){ // 如果大于5M
				PrintWriter ou = response.getWriter(); 
	          	ou.println("f");
			}else{
				String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\") + 1);
				
				String picend = ".jpg";// name.substring(name.indexOf("."));
				name = currUser.getSgcode() + "_md" + picend; 	// 实例编码 + _md + 后缀
					
				// String uploadAbsolutePath = getServletContext().getInitParameter( "uploadAbsolutePath" ); // 项目外
				// String uploadRelativePath = getServletContext().getInitParameter( "uploadRelativePath" ); // 项目内
				
				fileItem.write(new File( Constants.FileImgUrl + name));  // 虚拟目录形式
				// System.out.println("上传项目外：" + uploadAbsolutePath + File.separator + name);
				// fileItem.write(new File( uploadAbsolutePath + File.separator + name ));		// 用于linux下，项目外
				
				
				// String webuploadpath = request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath );
				// System.out.println("上传项目内: " + webuploadpath + File.separator + name);
				
				// fileItem.write(new File( webuploadpath + File.separator + name)); // 项目内
				
				
			}
			
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
 %>