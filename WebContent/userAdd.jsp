<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>增加新用户</title>	

	<script>	
		
		$(function(){
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'roles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[ {sucode:''} ]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
							var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
							$('#role').append(html);  
						});	
                    }else{ 
                        $.messager.alert('提示','获取角色列表失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );		
		
			$('#userForm1 input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });	        
		});	
		
		function clear(){
			clearForm('userForm1');
		}		
		
		function saveNewUser(){
			if( !checkForm( 'userForm1' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
			
			var userdata = getFormsData( ['userForm1'] );
			userdata['suenable'] = 'Y';			
			userdata['sgcode'] = User.sgcode;
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'add',
							optContent : '新增后台用户',		 
							list:[ userdata ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	if( data.rows != undefined && data.rows.length > 0 ){
                    		var usr = data.rows[0]; 
	                    	$.messager.alert('提示','新增用户成功!<BR>用户名：【' + usr.sucode + '】<BR>初始密码：【' + usr.sucode + '】','info');
	                    	clearForm('userForm1');
                    	}
                    	else{
                    		$.messager.alert('提示','新增用户失败!请稍后再重新尝试','error');
                    	}
                    }else{ 
                        $.messager.alert('提示','新增用户失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
	</script>
</head>
<body>
	<div title="增加新用户"> 
		<table id="userForm1" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td align="left" style="border:none; color:#4574a0;">添加新用户</td> 
	    	</tr> 
	  		<tr> 
			    <td>用户角色：
			    	<select style="width:150px;" id='role' name='role' size='1'>			         
			    	</select>
				</td> 
		  </tr> 
		  <tr> 
		  	<td>公司名称：<input name="sumemo" required="true" type="text" value="" /></td> 
		  </tr> 
		  <tr> 
		    <td>联&nbsp;&nbsp;系&nbsp;&nbsp;人：<input name="suname" required="true" type="text" /></td> 
		  </tr> 
		  <tr> 
		    <td>邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;箱：<input name="email" required="true"  validType="email" /><span style="color:#FF0000; margin-left:5px;">说明：请填写正确的公司邮箱，以防信息丢失。</span></td> 
		  </tr> 
		  <tr> 
		    <td>手&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：<input name="sutel" required="true"  validType="mobile" class="easyui-numberbox" min="0" precision="0" maxlength="11" /></td> 
		  </tr> 
		  <tr> 
		    <td style="padding-left:170px;"><a href="javascript:void(0)" onclick="saveNewUser();"><img src="images/tj_an.jpg" border="0" /></a></td> 
		  </tr> 
	  		
		</table> 	 
		
	</div>
</body>
</html>