<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.bfuture.app.saas.util.Constants"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title></title>
<%     
       //���������ȡ���� 
        String nameURL =request.getParameter("name");     
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
	//Constants.HttpImgUrl ��������,request.getContextPath()/upload/ ���ػ���
	%>
</head>
<script>
  
</script>
<body>
<img  height="696px" width="996px"  src=<%=Constants.HttpImgUrl%><%=request.getParameter("picurl")%>>
</body>
</html>