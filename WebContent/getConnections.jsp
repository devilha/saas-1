<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>

<%@page import="com.bfuture.app.basic.AppSpringContext"%>

<%@page import="org.apache.commons.dbcp.BasicDataSource"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>连接池状态</title>

</head>

<%
	
	AppSpringContext appContext = AppSpringContext.getInstance();
	BasicDataSource ds = (BasicDataSource)appContext.getAppContext().getBean("dataSource");	
%>
<body>
	初始化连接数:<%= ds.getInitialSize()%><br>
	当前活动连接:<%= ds.getNumActive()%><br>
	当前空闲连接:<%= ds.getNumIdle()%><br>	
</body>
</html>