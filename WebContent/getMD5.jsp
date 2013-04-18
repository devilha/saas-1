<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysMenu"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.SysScmuserManager"%>
<%@page import="com.bfuture.app.basic.dao.UniversalAppDao"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%@page import="com.bfuture.app.basic.util.xml.StringUtil"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>获取MD5密码</title>
	
</head>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
		
	AppSpringContext appContext = AppSpringContext.getInstance();
	UniversalAppDao dao = (UniversalAppDao)appContext.getAppContext().getBean("universalAppDao");
	SysScmuserManager userManager = (SysScmuserManager)appContext.getAppContext().getBean("userManager");
	String[] pwds = new String[]{"6006339643"};
	
	for( String pwd : pwds ){
		out.println( "原始密码：" + pwd + " 加密后：" + userManager.encoder( pwd ) + "<BR>" );
	}
%>

<body>
</body>
</html>