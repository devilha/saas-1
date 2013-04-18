<%@page import="com.ibm.db2.jcc.a.se"%>
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
				// name = currUser.getSgcode() + "_" + currUser.getSupcode() + "_" + new Date().getTime() + "_" + picend; 	// 实例编码 + _ + 供应商编号 + _ + 当前时间(转为毫秒值) + _ +后缀
				
				// 拼成的图片名称，不含后缀
				String serverPicName = currUser.getSgcode()+ currUser.getSupcode() + name.substring(0,name.indexOf("."));
				
				String serverPicNameMD5 = Constants.EncoderByMd5(serverPicName);
				
				name = currUser.getSgcode() +"_"+ currUser.getSupcode() +"_"+ serverPicNameMD5 + picend;
				//fileItem.write(new File(request.getRealPath("/upload/")+"/"+ name));  // 本地与147使用
				fileItem.write(new File( Constants.FileImgUrl + name));  // 虚拟目录形式
			}
			
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
 %>