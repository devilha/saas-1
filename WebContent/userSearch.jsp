<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>系统用户管理</title>	

	<script>
			
		$(function(){
			$('#userList').datagrid({
				title:'',
				width: 650,				
				nowrap: false,
				striped: true,
				collapsible:false,
				url:'JsonServlet',
				fitColumns:false,
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '查询系统用户',	 
							list:[{
								sgcode : User.sgcode
							}]
						}
					)
				},   
				loadMsg:'加载数据,请稍等...',				
				columns:[[
					{field:'crttime',title:'注册时间',width:100,
						formatter:function(value,rec){
							if( value != null && value.time != undefined )
								return new Date(value.time).format('yyyy-MM-dd');
						}
					},
					{field:'sumemo',title:'公司名称',width:140},
					{field:'sucode',title:'用户名',width:100,
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editUser("' + value + '");>' + value + '</a>';
						}
					},
					{field:'sutel',title:'移动电话',width:130},						
					{field:'email',title:'注册邮箱',width:170}
											
				]],				
				pagination:true				
			});	
			
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
		
			$('#userForm2 input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });

		});	
		
		function editUser( sucode ){
			clearForm('userForm2');
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[ {sucode: sucode } ]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1'  ){
                    	if( data.rows != undefined && data.rows.length > 0 ){ 
                    		var userData = data.rows[0];
                    		fillForm( 'userForm2', userData );
                    		$('#divUserList').hide();
                    		$('#divUserForm').show();	
                    	}
                    	else{
                    		$.messager.alert('提示','没有获取到任何用户信息','error');
                    	}
                    }else{ 
                        $.messager.alert('提示','获取用户信息列表失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}	
		
		function saveUser(){
			if( !checkForm( 'userForm2' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
			
			var userdata = getFormsData( ['userForm2'] );
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'update',
							optContent : '修改后台用户',		 
							list:[ userdata ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	$.messager.alert('提示','修改用户成功!','info');
						cancel();
						$('#userList').datagrid('reload');
						$('#userList').datagrid('resize');
                    }else{ 
                        $.messager.alert('提示','修改用户失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		function cancel(){
			$('#divUserList').show();
            $('#divUserForm').hide();	
		}		
		
	</script>
</head>
<body>		
	<div id="divUserList" style="width: 650px">	
		<table id="userList"></table>
	</div>	 
	
	<div id="divUserForm" title="用户信息维护" style="display: none;"> 
		<table id="userForm2" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td align="left" style="border:none; color:#4574a0;">
					用户信息维护
					<input type="hidden" name="sucode">
					<input type="hidden" name="sgcode">
				</td> 
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
		    <td>手&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：<input name="sutel" required="true"  validType="mobile" class="easyui-numberbox" min="0" precision="0" /></td> 
		  </tr> 
		  <tr> 
		    <td style="padding-left:100px;">
		    	<a href="javascript:void(0)" onclick="saveUser();"><img src="images/tj_an.jpg" border="0" /></a>
		    	<a href="javascript:void(0)" onclick="cancel();"><img src="images/goback.jpg" border="0" /></a>
		    </td> 
		  </tr> 
	  		
		</table> 	 
		
	</div>
</body>
</html>