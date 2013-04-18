<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.StringUtil"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.SysScmuserManager"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="java.util.List"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>修改个人信息及密码</title>	

	<script>	
		
		$(function(){			
		
			$('#userInfoForm input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });
		});	
		
		function resetForm(){
			document.getElementById("companycode").value="";
			document.getElementById("web").value="";
			document.getElementById("sutel").value="";
			document.getElementById("bank").value="";
			document.getElementById("shortname").value="";
			document.getElementById("region").value="";
			document.getElementById("account").value="";
			document.getElementById("legalperson").value="";
			document.getElementById("mobile").value="";
			document.getElementById("email").value="";
			document.getElementById("address").value="";
			document.getElementById("companydescrib").value="";
			document.getElementById("area").value="";
			document.getElementById("zipcode").value="";
			document.getElementById("memo").value="";
			document.getElementById("supwdq").value="";
			document.getElementById("supwda").value="";
			alert("重置个人资料");
		}
		
		function saveUserInfo(){
			if( !checkForm( 'userInfoForm' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}		
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'checkUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',									 
							list:[
								{
									sucode : User.sucode
								}
							]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	if( data.rows != undefined && data.rows.length > 0 ){
                    		var userdata = data.rows[0];
                    		var now = new Date();
                    		clearObject(userdata);
                    		
                    		var userData = getFormData( 'userInfoForm' );
                    		copyObject( userData , userdata );
                    		userdata['editFlag'] = 'Y';                    		
                    		userdata['lastUpdateTime'] = now.format('yyyy-MM-dd HH:mm:ss');
                    		
                    		$.post( 'JsonServlet',				
								{
									data : obj2str({		
											ACTION_TYPE : 'update',
											ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
											ACTION_MANAGER : 'userManager',
											optType : 'update',
											optContent : '修改个人信息',		 
											list:[ userdata ]
									})
									
								}, 
								function(data){ 
				                    if(data.returnCode == '1' ){ 
				                    	$.messager.alert('提示','修改用户个人信息成功!','info');
				                    	backMain(); //是成功了返回。清空返回什么呢？
				                    }else{ 
				                        $.messager.alert('提示','修改用户个人信息失败!<br>原因：' + data.returnInfo,'error');
				                    } 
				            	},
				            	'json'
				            );
                    	}
                    	else{                    		                  		                    		
                    		$.messager.alert('提示','没有找到对应的用户信息，请核对后重新输入!' + data.returnInfo,'error');
                    		return;
                    	}
                    }else{ 
                        $.messager.alert('提示','读取用户信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
	</script>
	
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		
		SysScmuser currUser = (SysScmuser)obj;
		
		AppSpringContext appContext = AppSpringContext.getInstance();
		SysScmuserManager userManager = (SysScmuserManager)appContext.getAppContext().getBean("userManager");
		
		SysScmuser tempUser = new SysScmuser();
		tempUser.setSucode( currUser.getSucode() );
		ReturnObject ro = userManager.ExecOther( "checkUser", new Object[]{ tempUser } );
		
		if( ro != null ){
			List lstUsers = ro.getRows();
			if( lstUsers != null  && lstUsers.size() > 0 ){
				currUser = (SysScmuser)lstUsers.get( 0 );
			}
		}
		
	%>
</head>
<body>
	<div title="修改个人信息" align="center"> 
		<table id="userInfoForm" cellpadding="5" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr>
				<td colspan="8" align="left" style="color:#33CCFF;">
					<% 
						if( "L".equals(StringUtil.nullToBlank( currUser.getSutype() ) ) ){
					%>
						零售商信息
					<%
						}else{
					%>
						供应商信息
					<%} %>
				</td>
			</tr>
			<tr>
				<td align="left" style="text-align:justify; text-justify:inter-ideograph">用户编码：</td>
				<td align="left"><%= StringUtil.nullToBlank( currUser.getSucode() )%></td>
				<td align="left" style="">用户中文：</td>
				<td align="left"><input name="suname" type="text" id="suname" required="true" value="<%= StringUtil.nullToBlank( currUser.getSuname() )%>" size="18" /></td>
				<td align="left" style="">部门编码：</td>
				<td align="left"><input name="companycode" type="text" id="companycode" value="<%= StringUtil.nullToBlank( currUser.getCompanycode() )%>" size="18" /></td>
				<td align="left" style="">网址：</td>
				<td align="left"><input name="web" type="text" id="web" value="<%= StringUtil.nullToBlank( currUser.getWeb() )%>" size="18" /></td>
			</tr>
			<tr>
				<td align="left" style="">电话号码：</td>
				<td align="left"><input name="sutel" type="text" id="sutel" required="true" value="<%= StringUtil.nullToBlank( currUser.getSutel() )%>" size="18" /></td>
				<td align="left" style="">开户行：</td>
				<td align="left"><input name="bank" type="text" id="bank" value="<%= StringUtil.nullToBlank( currUser.getBank() )%>" size="18" /></td>
				<td align="left" style="">用户英文：</td>
				<td align="left"><input name="shortname" type="text" id="shortname" value="<%= StringUtil.nullToBlank( currUser.getShortname() )%>" size="18" /></td>
				<td align="left" style="">省份：</td>
				<td align="left"><input name="region" type="text" id="region" value="<%= StringUtil.nullToBlank( currUser.getRegion() )%>" size="18" /></td>
			</tr>
			<tr>
				<td align="left" style="">帐号：</td>
				<td align="left"><input name="account" type="text" id="account" value="<%= StringUtil.nullToBlank( currUser.getAccount() )%>" size="18" /></td>
				<td align="left" style="">户名：</td>
				<td align="left"><input name="legalperson" type="text" id="legalperson" value="<%= StringUtil.nullToBlank( currUser.getLegalperson() )%>" size="18" /></td>
				<td align="left" style="">手机号码：</td>
				<td align="left"><input name="mobile" id="mobile" class="easyui-numberbox" min="0" precision="0" required="true" value="<%= StringUtil.nullToBlank( currUser.getMobile() )%>" validType="mobile" size="18" /></td>
				<td align="left" style="">电子邮件：</td>
				<td align="left"><input name="email" type="text" id="email" size="18" value="<%= StringUtil.nullToBlank( currUser.getEmail() )%>" /></td>
  			</tr>
			<tr>
				<td align="left" style="">用户地址：</td>
				<td align="left"><input name="address" type="text" id="address" required="true" value="<%= StringUtil.nullToBlank( currUser.getAddress() )%>" size="18" /></td>
				<td align="left" style="">城市：</td>
				<td align="left"><input name="companydescrib" type="text" id="companydescrib" value="<%= StringUtil.nullToBlank( currUser.getCompanydescrib() )%>" size="18" /></td>
				<td align="left" style="">国家：</td>
				<td align="left"><input name="area" type="text" id="area" value="<%= StringUtil.nullToBlank( currUser.getArea() )%>" size="18" /></td>
				<td align="left" style="">邮编：</td>
				<td align="left"><input name="zipcode" type="text" id="zipcode" value="<%= StringUtil.nullToBlank( currUser.getZipcode() )%>" size="18" /></td>
			</tr>
			<tr>
				<td align="left" style="">备注：</td>
				<td align="left" style=""><input name="memo" type="text" id="memo" size="18" value="<%= StringUtil.nullToBlank( currUser.getMemo() )%>" /></td>
				<td align="left" style="">密保问题：</td>
				<td align="left" style=""><input name="supwdq" type="text" id="supwdq" size="18" value="<%= StringUtil.nullToBlank( currUser.getSupwdq() )%>" /></td>
				<td align="left" style="">密保答案：</td>
				<td align="left" style=""><input name="supwda" type="text" id="supwda" size="18" value="<%= StringUtil.nullToBlank( currUser.getSupwda() )%>" /></td>
				<td align="left" style="">&nbsp;</td>
				<td align="left" style="">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="8" align="left" >&nbsp;</td>
			</tr>
			<tr>
				<td colspan="8" align="left" ><div align="center"><img src="images/sure.jpg" border="0" onclick="saveUserInfo();" /><img src="images/back.jpg" onclick="resetForm();" style="margin-left:40px;"/></div></td>
			</tr>			
		</table> 
	</div>
</body>
</html>