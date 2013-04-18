<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�޸ĸ�����Ϣ������</title>	

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
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
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
											optContent : '�޸�������Ϣ',		 
											list:[ userdata ]
									})
									
								}, 
								function(data){ 
				                    if(data.returnCode == '1' ){ 
				                    	alert('�޸��û�������Ϣ�ɹ��������µ�¼!');
				                    	location.href = 'Logout';
				                    }else{ 
				                        $.messager.alert('��ʾ','�޸��û�������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
				                    } 
				            	},
				            	'json'
				            );
                    	}
                    	else{
                    		$('#oldpwd').val('');                    		                    		
                    		$.messager.alert('��ʾ','���������˶Ժ���������!' + data.returnInfo,'error');
                    		return;
                    	}
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�û���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
	<div title="�޸�����"> 
		<table id="userPwdForm" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
		    	<td colspan="2" align="left" style="border:none; color:#4574a0;">�޸�����&nbsp;&nbsp;��<span style="color:#FF0000; margin-left:5px;">*</span>Ϊ���</td> 
		    </tr> 
			<tr> 
		    	<td width="145" align="right" style="border:none;"> 
					����������룺	
				</td> 
				<td width="350" style="border:none;">
					<input id="oldpwd" name="oldpwd" required="true" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					�������µ����룺	
				</td> 
		    	<td style="border:none;"> 
					<input validType="safepass" required="true" id="supwd" name="supwd" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					���ٴ����������룺	
				</td> 
		    	<td style="border:none;"> 
					<input name="resupwd" required="true" validType="equalTo[supwd]" type="password" width="120" /><span style="color:#FF0000; margin-left:5px;">*</span>	
				</td> 
			</tr>			
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					����������������	
				</td> 
		    	<td style="border:none;"> 
					<input type="text" id="suname" name="suname" required="true" width="120" value="<%=currUser.getSuname()%>"/><span style="color:#FF0000; margin-left:5px;">*</span>	
				</td> 
			</tr> 
			<tr> 
		    	<td align="right" width="145" style="border:none;"> 
					��ϵ�绰��	
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