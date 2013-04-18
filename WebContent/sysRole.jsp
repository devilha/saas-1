<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>

	<title>角色管理</title>	
	<script>
		$(function(){
			$('#role').datagrid({
				title:'角色列表',
				width: 650,
				iconCls:'icon-save',
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
				loadMsg:'加载数据...',
				frozenColumns:[[
					{field:'select',checkbox:true}
				]],				
				columns:[[	
					{field:'rlcode',title:'角色编码',width:100,align:'center'},					
					{field:'rlname',title:'角色名称',width:120},
					{field:'rltype',title:'角色类别',width:120,sortable:true,
						formatter:function(value,rec){
							if( value === 'I' )
								return '零售商';
							else if( value === 'S' )
								return '供应商';
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
				rownumbers:true,
				onDblClickRow:function(rowIndex, rowData){
					edit( rowData );
				},
				toolbar:[{
					id:'btnSearch',
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						search();
					}
				},{
					id:'btnAdd',
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},{
					id:'btnEdit',
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						
						edit();
					}
				},{
					id:'btnDelete',
					text:'删除',					
					iconCls:'icon-remove',
					handler:function(){
						
						remove();
					}
				},
				'-',
				{
					id:'btnMenu',
					text:'分配角色权限',
					iconCls:'icon-redo',
					handler:function(){
						editRoleMenu();
					}
				}
				]
			});
			$('#uiform input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });		

		});
		
		function obj2str(o){
		   var r = [];
		   if(typeof o == "string" || o == null) {
		   	if( o == '' ) return '""';
		     return '"' + o + '"';
		   }
		   if(typeof o == "object"){
		     if(!o.sort){
		       r[0]="{"
		       for(var i in o){
		         r[r.length]=i;
		         r[r.length]=":";
		         r[r.length]=obj2str(o[i]);
		         r[r.length]=",";
		       }
		       r[r.length-1]="}"
		     }else{
		       r[0]="["
		       for(var i =0;i<o.length;i++){
		         r[r.length]=obj2str(o[i]);
		         r[r.length]=",";
		       }
		       r[r.length-1]="]"
		     }
		     return r.join("");
		   }
		   return o.toString();
		}

		
		
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
    	
    	
		function cancel(){
			$('#roleWindow').window('close');
		}
		
		function add(){
			$('#roleWindow').window('open');
		}
		
		function edit( rowData ){
			var data;
			
			if( rowData ){
				data = rowData;
			}
			else{			
				var rows = $('#role').datagrid('getSelections');
				if( rows.length == 0 ){
					$.messager.alert('警告','请先选择一行记录！','warning');
					return;
				}
				if( rows.length > 1 ){
					$.messager.alert('警告','只能选择一行记录进行编辑！','warning');
					return;
				}
				data = rows[0];
			}
			
					
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
							ACTION_MANAGER : 'sysRoleManager',	
							optType : 'query',
							optContent : '修改角色',		 
							list:[{
								rlcode : data.rlcode,
								sgcode : User.sgcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var rl = data.rows[0];
                    	 	fillForm('uiform', rl);
							$('#roleWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('提示','获取用户信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
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
			$("#role").datagrid('reload');				
		}		
		function saveRole(){
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
							optType : 'query',
							optContent : '新增角色',			 
							list:[ getFormData( 'uiform' ) ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存用户成功!','info');
                    	$("#role").datagrid('reload');
                    	cancel(); 
                    }else{ 
                        $.messager.alert('提示','保存用户失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			$("#role").datagrid('reload');	
		}

		
		function cancelSearch(){
			$('#searchRole').window('close');
		}
		
		function search(){
			$('#searchRole').window('open');
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
		
		
		function editRoleMenu(){
		
			var data;						
			var rows = $('#role').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;
			}
			if( rows.length > 1 ){
				$.messager.alert('警告','只能选择一行记录！','warning');
				return;
			}
			data = rows[0];
			$('#selRlcode').val( data.rlcode );
			$('#tree').tree({
				checkbox: true,
				animate: true,
				cascadeCheck: true,
				onlyLeafCheck: false,
				align:'left',
				url:'JsonServlet',
				onBeforeLoad:function(row,param){
					param['data'] = obj2str(
							{		
								ACTION_TYPE : 'tree',
								ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
								ACTION_MANAGER : 'sysRoleManager',		 
								list:[{
									rlcode : data.rlcode,
									sgcode : User.sgcode
								}]
							}
						);
																
				},
				onClick:function(node){
					$(this).tree('toggle', node.target);
					//alert('you dbclick '+node.text);
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
			var rows = $('#tree').tree('getChecked');
			if( rows.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
				return;
			}
			
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ meucode : rows[i].id,
					  rlcode : $('#selRlcode').val(),
					  sgcode : User.sgcode
					 }
				);
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
		                    	 $("#treeWindow").window("close");
		                    }else{ 
		                        $.messager.alert('提示','更新失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
			$("#role").datagrid('reload');				
		}
				
		function cancelSaveRlmeu(){
			$('#treeWindow').window('close');
		}
		
	</script>
</head>
<body>	

	<div style="width:800px;height:600">	
		<table id="role"></table>
	</div>
	
	<div id="roleWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="新建角色" style="width:700px;height:400px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="uiform" class="tableClass">
					<tr>
						<td>角色编码：</td>
						<td><input required="true" id="rlcode" name="rlcode" type="text" /></td>
						<td>角色名称：</td>
						<td><input name="rlname" id="rlname" required="true" type="text"/></td>
					</tr>
					
					<tr>
						<td>角色类型：</td>
						<td>
							<select name="rltype" id="rltype">
							    <option value="I">零售商</option>
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
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveRole();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">取消</a> 
			</div> 
		</div>
	</div>
	<div id="searchRole" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="查询角色" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="i_form" class="tableClass">
					<tr>
						<td>角色编码：</td>
						<td><input name="rlcode" type="text" /></td>						
					</tr>					
					<tr>
						<td>角色名称：</td>
						<td><input name="rlname" type="text"/></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchRole();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">取消</a> 
			</div> 
		</div>
	</div>	
	
	
	<div id="treeWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="true" shadow="true" closed="true" modal="true" title="分配角色权限" style="width:400px;height:500px;">
		<ul id="tree" ></ul>
		<p/>
		<input id="selRlcode" type="hidden" value=""/>
		<input id="selSgcode" type="hidden" value=""/>
		<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
			<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveRlMeu();">确定</a> 
			<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSaveRlmeu();">取消</a> 
		</div> 
	</div>	
</body>
</html>