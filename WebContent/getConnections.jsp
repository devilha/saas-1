<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>

<%@page import="com.bfuture.app.basic.AppSpringContext"%>

<%@page import="org.apache.commons.dbcp.BasicDataSource"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>���ӳ�״̬</title>

</head>

<%
	
	AppSpringContext appContext = AppSpringContext.getInstance();
	BasicDataSource ds = (BasicDataSource)appContext.getAppContext().getBean("dataSource");	
%>
<body>
	��ʼ��������:<%= ds.getInitialSize()%><br>
	��ǰ�����:<%= ds.getNumActive()%><br>
	��ǰ��������:<%= ds.getNumIdle()%><br>	
</body>
</html>