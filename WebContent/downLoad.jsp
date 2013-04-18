<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head> 
<title>文件下载</title>
</head> 
<body>
<% 
// response.setContentType("text/html");
System.out.println("11111111");
System.out.println("11111111");
javax.servlet.ServletOutputStream ou = response.getOutputStream();
String filepath="contract/3040/";
String filename=new String(request.getParameter("filename").getBytes("ISO8859_1"),"UTF-8").toString();
System.out.println("DownloadFile filepath:" + filepath);
System.out.println("DownloadFile filename:" + filename);
java.io.File file = new java.io.File(filepath + filename);
if (!file.exists()) {
System.out.println(file.getAbsolutePath() + " 文件不存在!");
return;
}
// 读取文件流
java.io.FileInputStream fileInputStream = new java.io.FileInputStream(file);
// 下载文件
// 设置响应头和下载保存的文件名
if (filename != null && filename.length() > 0) {
response.setContentType("application/x-msdownload");
response.setHeader("Content-Disposition", "attachment; filename=" + new String(filename.getBytes("UTF-8"),"iso8859-1") + "");
if (fileInputStream != null) {
int filelen = fileInputStream.available();
//文件太大时内存不能一次读出,要循环
byte a[] = new byte[filelen];
fileInputStream.read(a);
ou.write(a);
}
fileInputStream.close();
ou.close();
}
%> 
</body>
</html>

