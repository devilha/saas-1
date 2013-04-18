<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>

<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
	%>

	<title>角色管理</title>	
	<script>
		$(function(){
			$('#role').datagrid({
				title:'',
				width: 650,
				iconCls:'',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'JsonServlet',
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
							ACTION_MANAGER : 'sysRoleManager',	
							optType : 'query',
							optContent : '查询角色',	 	 
							list:[{
								rlcode : '',
								sgcode : User.sgcode
							}]
						}
					)
				},   
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:true,
				singleSelect:true,
				loadMsg:'加载数据...',
				frozenColumns:[[
					{field:'select',checkbox:true}
				]],				
				columns:[[	
					{field:'rlcode',title:'角色编码',width:100,align:'center'},					
					{field:'rlname',title:'角色名称',width:120},
					{field:'rltype',title:'角色类别',width:120,sortable:true,
						formatter:function(value,rec){
							if( value === 'L' )
								return '零售商';
							else if( value === 'S' )
								return '供应商';
							else 
								return '管理员';
						}
					},
					{field:'rlflag',title:'角色状态',width:150,sortable:true,
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src=themes/icons/ok.png>';
						}
					}
				]],
				pagination:true,
				rownumbers:true
			});
			$('#uiform input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });		

		});
		function reloadgrid ()  {  
        
	        //查询参数直接添加在queryParams中
	        $('#role').datagrid('options').url = 'JsonServlet';        
			$('#role').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
						ACTION_MANAGER : 'sysRoleManager',		 
						list:[{
							rlcode : $('#rlcode').attr('value'),
							rlname : $('#rlname').attr('value'),
							sgcode : User.sgcode
						}]
					}
				)
			};        
			$("#role").datagrid('reload'); 
        
    	}
    	

		function remove(){
			var rows = $('#role').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
				return;
			}
			
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ rlcode : rows[i].rlcode ,
					  sgcode : User.sgcode
					}
				);
			}			
			
			$.messager.confirm('确认操作', '确认要删除选中的记录吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
									ACTION_MANAGER : 'sysRoleManager',	
									optType : 'query',
									optContent : '删除角色',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('提示','删除成功！','info');
		                    	 $("#role").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','获取用户信息失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});					
		}		
		function saveRole(){
			if( $('#hadUser').val() == 'Y' ){
				$.messager.alert('没有通过验证','角色[' + $('#rlcode').val() + ']已存在！','warning');
				return;
			}
			if( !checkForm( 'uiform' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
			$('#sgcode').val( User.sgcode );
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'insert',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
							ACTION_MANAGER : 'sysRoleManager',
							optType : 'add',
							optContent : '新增角色',			 
							list:[ getFormData( 'uiform' ) ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存用户成功!','info');
                    	$("#role").datagrid('reload');
                    }else{ 
                        $.messager.alert('提示','保存用户失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
            clearForm('uiform');

		}


		
		function searchRole(){
			var searchData = getFormData( 'searchRole' );
			
			//查询参数直接添加在queryParams中
		    $('#role').datagrid('options').url = 'JsonServlet';        
			$('#role').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
						ACTION_MANAGER : 'sysRoleManager',	
						optType : 'query',
						optContent : '查询角色',		 
						list:[ searchData ]
					}
				)
			};        
			$("#role").datagrid('reload');				 
			
			cancelSearch();
		}
		
		
		function clearRoleWindow(){
			clearForm('roleWindow');
		}
		
		function cancelSelected(){
			$('#role').datagrid('clearSelections');
		}
		
		
		function checkRole(){
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
							ACTION_MANAGER : 'sysRoleManager',		 
							list:[{								
								rlcode : $('#rlcode').val(),
								sgcode : User.sgcode
							}]
					})							
				}, 
				function(data){ 
		        	if(data.returnCode == '1' ){ 
						if( data.rows != undefined && data.rows.length > 0 ){
		                	$('#hadUserInfo').show();
		                	$('#hadUser').val('Y');		                	
						}
						else{
							$('#hadUserInfo').hide();
		                	$('#hadUser').val('N');
						} 
					}else{ 
						$.messager.alert('提示','获取用户信息失败!<br>原因：' + data.returnInfo,'error');
					} 
				},
				'json'
			);
		}
	</script>
</head>
<body>	
	<div id="roleWindow"  iconCls="" minimizable="false" maximizable="false"  title="定义可用角色" style="width:650px;height:120px;">
				<table id="uiform" style="line-height:20px; text-align:left; border:none;font-size:12px">
					<tr>
    					<td colspan="2" align="left" style="border:none; color:#4574a0;">定义可用角色</td>
    				</tr>
					<tr>
						<td>角色编码：</td>
						<td><input required="true" id="rlcode" name="rlcode" type="text" onblur="checkRole();"/></td>
						<td>角色名称：</td>
						<td><input name="rlname" id="rlname" required="true" type="text"/></td>
						<td><div id="hadUserInfo" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;该角色编码已经存在！</div></td>
						<input id="hadUser" type="hidden">	
					</tr>					
					<tr>
						<td>角色类型：</td>
						<td>
							<select name="rltype" id="rltype">
							    <option value="L">零售商</option>
							    <option value="S">供应商</option>
							</select>
							<input id="sgcode" type="hidden" name="sgcode" value=""/>
						</td>
						<td>是否启用：</td>
						<td>
							<input type="checkbox" id="rlflag" name="rlflag" value=""/>						
						</td>
					</tr>

				</table>
					<tr>
						<td align="right" style="border:none; padding-right:85px;"><img src="images/add_js.jpg" border="0" onclick="saveRole();" /></td>
		    			<td align="right" style="border:none; padding-right:135px;"><img src="images/back.jpg" style="margin-left:40px;" onclick="clearRoleWindow();" /></td>
					</tr>

	</div>
	<div >	
		<tr>
    		<td colspan="2" align="left" style="border:none; color:#4574a0;">系统角色查询</td>
    		</tr>			
		<table id="role"></table>
		<p>
			<tr align="center">
				<td align="center" style="border:none; padding-right:85px;"><img src="images/delete.jpg" border="0" onclick="remove();" /></td>
		    	<td align="center" style="border:none; padding-right:135px;"><img src="images/del_all.jpg" border="0" onclick="cancelSelected();" /></td>
			</tr>
	</div>

</body>
</html>