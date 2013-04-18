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
								sgcode : User.sgcode
							}]
						}
					)
				},   
				sortOrder: 'desc',
				singleSelect:true,
				remoteSort: true,
				fitColumns:true,
				loadMsg:'加载数据...',	
				columns:[[	
					{field:'rlcode',title:'角色编码',width:100,sortable:true,align:'center',
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editRoleMenu("' + value + '");>' + value + '</a>';
						}
					},					
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
						optType : 'query',
						optContent : '查询角色',	 		 
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

		function searchRole(){
			var searchData = getFormData( 'searchRole' );
			searchData['sgcode'] = User.sgcode;
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
			
			
		}
		
		
		function editRoleMenu( v_rlcode ){

			$('#selRlcode').val( v_rlcode );
			$('#tree').tree({
				checkbox: true,
				animate: true,
				url:'JsonServlet',
				onBeforeLoad:function(rlcode,param){
					param['data'] = obj2str(
							{		
								ACTION_TYPE : 'tree',
								ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
								ACTION_MANAGER : 'sysRoleManager',		 
								list:[{
									rlcode : v_rlcode,
									sgcode : User.sgcode
								}]
							}
						);
																
				},
				onClick:function(node){
					$(this).tree('toggle', node.target);
				}
						
			});
						
			$('#treeWindow').window('open');


		}

		function collapseAll(){
			var node = $('#tree').tree('getSelected');
			if (node){
				$('#tree').tree('collapseAll', node.target);
			} else {
				$('#tree').tree('collapseAll');
			}
		}
			
		function expandAll(){
			var node = $('#tree').tree('getSelected');
			if (node){
				$('#tree').tree('expandAll', node.target);
			} else {
				$('#tree').tree('expandAll');
			}
		}
		
		
		function saveRlMeu(){
			var node = $('#tree').tree('getChecked');
			if( node.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
				return;
			}
			if (node){
				var children = $('#tree').tree('getChildren', node.target);
			} else {
				var children = $('#tree').tree('getChildren');
			}
			var list = [];
			var s = '';
			for(var i=0; i<children.length; i++){
				if ($(children[i].target).find('.tree-checkbox0').length == 0){
					list.push(
						{ meucode : children[i].id,
						  rlcode : $('#selRlcode').val(),
						  sgcode : User.sgcode
						 }
					);
				}
			}	
			$.messager.confirm('确认操作', '确认要更新选中的记录吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'saveRlMeu',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysRlmeu',
									ACTION_MANAGER : 'sysRoleManager',	
									optType : 'query',
									optContent : '修改角色权限',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('提示','更新成功！','info');
		                    	 $("#role").datagrid('reload');
		                    	 $("#role").datagrid('resize');
		                    	 $("#treeWindow").window("close");
		                    }else{ 
		                        $.messager.alert('提示','更新失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
			//$("#role").datagrid('reload');				
		}
				
		function cancelSaveRlmeu(){
			$('#treeWindow').window('close');
		}
		
		//清空表单中数据
		function clearSearchRole(){
			clearForm('searchRole');
		}
		
	</script>
</head>
<body>	

	<div style="color:#4574a0; text-align:left;margin-top: 5px;margion-bottom:10px;">定义角色权限</div>
	<div id="searchRole"  iconCls="" minimizable="false" maximizable="false" collapsible="false"  title="" style="width:640px;height:60px;">
				<table id="i_form" class="tableClass">
					<tr>
						<td>角色编码：<input name="rlcode" type="text" /></td>
						<td>角色名称：<input name="rlname" type="text"/><input id="sgcode" type="hidden" name="sgcode" value=""/></td>
					</tr>					
					<tr>
						<td align="right" style="border:none; padding-right:85px;"><img src="images/cx.jpg" border="0" onclick="searchRole();" /></td>
		    			<td align="right" style="border:none; padding-right:135px;"><img src="images/back.jpg" border="0" onclick="clearSearchRole();" style="margin-left:40px;" /></td>
					</tr>
				</table>
	</div>	
	<div style="width:800px;height:600">	
		<table id="role"></table>
	</div>	
	
	<div id="treeWindow" class="easyui-window" iconCls="" minimizable="false" maximizable="false" collapsible="true" shadow="true" closed="true" modal="true" title="分配角色权限" style="width:400px;height:500px;">
		<ul id="tree" ></ul>
		<p/>
		<input id="selRlcode" type="hidden" value=""/>
		<input id="selSgcode" type="hidden" value=""/>
		<tr align="center">
			<td align="right" style="border:none; padding-right:85px;"><img src="images/sure.jpg" border="0" onclick="saveRlMeu();" /></td>
		    <td align="right" style="border:none; padding-right:135px;"><img src="images/goback.jpg" style="margin-left:40px;" onclick="cancelSaveRlmeu();" /></td>
		</tr>
	</div>	

</body>
</html>