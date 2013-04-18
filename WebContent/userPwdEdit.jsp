<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>修改个人信息及密码</title>	

	<script>	
		
		$(function(){
			
			$( '#mobile' ).val( User.mobile );
		
			$('#userPwdForm input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });
		});
		
		function saveUserInfo(){
			if( !checkForm( 'userPwdForm' ) ){
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
									sucode : User.sucode,
									supwd : $('#oldpwd').val()
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
                    		userdata['supwd'] = $('#supwd').val();                    		
                    		userdata['suname'] = $('#suname').val();
                    		userdata['mobile'] = $('#mobile').val();
                    		userdata['lastUpdateTime'] = now.format('yyyy-MM-dd HH:mm:ss');
                    		
                    		$.post( 'JsonServlet',				
								{
									data : obj2str({		
											ACTION_TYPE : 'update',
											ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
											ACTION_MANAGER : 'userManager',
											optType : 'update',
											optContent : '修改密码信息',		 
											list:[ userdata ]
									})
									
								}, 
								function(data){ 
				                    if(data.returnCode == '1' ){ 
				                    	alert('修改用户密码信息成功，请重新登录!');
				                    	location.href = 'Logout';
				                    }else{ 
				                        $.messager.alert('提示','修改用户个人信息失败!<br>原因：' + data.returnInfo,'error');
				                    } 
				            	},
				            	'json'
				            );
                    	}
                    	else{
                    		$('#oldpwd').val('');                    		                    		
                    		$.messager.alert('提示','密码错误，请核对后重新输入!' + data.returnInfo,'error');
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
	%>
</head>
<body>
	<div title="修改密码"> 
		<table id="userPwdForm" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
		    	<td colspan="2" align="left" style="border:none; color:#4574a0;">修改密码&nbsp;&nbsp;（<span style="color:#FF0000; margin-left:5px;">*</span>为必填）</td> 
		    </tr> 
			<tr> 
		    	<td width="145" align="right" style="border:none;"> 
					请输入旧密码：	
				</td> 
				<td width="350" style="border:none;">
					<input id="oldpwd" name="oldpwd" required="true" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					请输入新的密码：	
				</td> 
		    	<td style="border:none;"> 
					<input validType="safepass" required="true" id="supwd" name="supwd" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					请再次输入新密码：	
				</td> 
		    	<td style="border:none;"> 
					<input name="resupwd" required="true" validType="equalTo[supwd]" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>	
				</td> 
			</tr>			
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					请输入您的姓名：	
				</td> 
		    	<td style="border:none;"> 
					<input type="text" id="suname" name="suname" required="true" width="120" value="<%=currUser.getSuname()%>"/><span style="color:#FF0000; margin-left:5px;">*</span>	
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					联系电话：	
				</td> 
		    	<td style="border:none;"> 
					<input id="mobile" name="mobile" class="easyui-numberbox" min="0" precision="0" width="120" />
				</td> 
			</tr> 
			<tr> 
		    	<td colspan="2" align="left" style="border:none; padding-left:290px;"> 
			    	<img src="images/sure.jpg" onclick="saveUserInfo();" />	
				</td> 
			</tr> 
		</table> 
	</div>
</body>
</html>