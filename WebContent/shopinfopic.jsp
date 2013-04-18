<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>门店分布查询</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
		
		// request.getLocalAddr(); // ip
		// request.getLocalPort(); // 端口
		
	%>
</head>
<body>


<div style="width:970px;" >
	<table width="970" style="line-height:20px; text-align:center; border:none;" >
	  <tr>
	    <td align="left" style="border:none; color:#33CCFF; font-size: 12px;">门店分布图<%=currUser.getSgcode() %></td>
	  </tr>
	</table>
	
	<div style="margin-top:5px; overflow:auto; float:center; text-align:center; width:747px; height: 580px;">
	  <div align="center">
	  	<a href="javaScript:openUrl( 'shopInfo.jsp', 'Y' ,false);"><img src="<%=Constants.HttpImgUrl%><%=currUser.getSgcode() %>_md.jpg" border="0" /></a>
	  </div>
	</div>
</div>

</body>
</html>