<%@page import="com.bfuture.app.saas.util.Tools"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.File"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%		
// 获取当前登录用户信息
request.setCharacterEncoding("UTF-8");
Object obj = session.getAttribute( "LoginUser" );
if( obj == null ){
	response.sendRedirect( "login.jsp" );
	return;
}
SysScmuser currUser = (SysScmuser)obj;
// 执行文档上传操作
FileItemFactory  factory = new DiskFileItemFactory();
ServletFileUpload upload = new ServletFileUpload(factory);
PrintWriter pw = response.getWriter(); 
JSONObject ro = new JSONObject();
String msg = "";
try {
	String spbm = request.getParameter("spbm");
	List<FileItem> list = upload.parseRequest(request);
	
	String uploadAbsolutePath = getServletContext().getInitParameter( Constants.UPLOAD_ABSOLUTE_PATH );
	String uploadRelativePath = getServletContext().getInitParameter( "uploadRelativePath" ); // 项目内
	
	for(int i=0; i<list.size()-1;i++){
		FileItem fileItem = list.get(i);
		
		Long filesize = fileItem.getSize()/1024; // 单位kb

		if(filesize > 5120){ // 如果大于5M
			msg="-1";//附件不能大于5M
			return;
		}else{
			String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\")+1);
			String fileType = name.substring(name.lastIndexOf("."));
			name=currUser.getSgcode()+"_"+currUser.getSupcode()+"_"+spbm+"_"+(Constants.EncoderByMd5(name)+"")+fileType;
			File uploadedDir = new File(Constants.FileImgUrl);
			File uploadedFile = new File(uploadedDir.getPath() + File.separator + name);
			
			if(uploadedFile.exists()){
				msg = "-2";//同名附件已经存在，请重新命名上传附件
				return;
			}			
		}
	}
	for(int i=0; i<list.size()-1;i++){
		FileItem fileItem = list.get(i);
		String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\")+1);
		String fileType = name.substring(name.lastIndexOf("."));
		name=currUser.getSgcode()+"_"+currUser.getSupcode()+"_"+spbm+"_"+(Constants.EncoderByMd5(name)+"")+fileType;
		try{
			
			
			File uploadedDir = new File( request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath + "/" + currUser.getSupcode() ).replace( "./", "") );
			File uploadedFile = new File( uploadedDir.getPath()	+ File.separator + name );
			if( !uploadedDir.exists() ){
				uploadedDir.mkdir();
			}
			
			fileItem.write( uploadedFile ); // 项目内
			msg = (i+1)+"";
			
			//备份文件到绝对路径
			File backupDir = new File( uploadAbsolutePath + File.separator + currUser.getSupcode() );
			if( !backupDir.exists() ){
				backupDir.mkdirs();
			}
			Tools.copyFile( uploadedFile.getAbsolutePath(), backupDir.getAbsolutePath() + File.separator + uploadedFile.getName() );
			
		}catch(Exception e){
			System.out.println("路径不存在");
			msg="-3";
			return ;
		}
	}
} catch (FileUploadException e) {
	e.printStackTrace();
} catch (Exception e) {
	e.printStackTrace();
}finally {
	pw.println(JSONObject.fromObject(ro).toString());
	pw.println("<script>window.parent.Finish('"+msg+"');</script>");
	pw.close();
}
 %>