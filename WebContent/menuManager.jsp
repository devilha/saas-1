<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<title>菜单管理</title>
	
	<script>
		var isNew = false;
		
		$(function(){
			$('#menuManager').treegrid({
				title:'菜单管理',
				width: 650,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'JsonServlet',
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'treegrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
							ACTION_MANAGER : 'sysMenuManager',		 
							list:[{
								meupcode : '0'
							}]
						}
					)
				},   
				animate:true,
				fitColumns:false,
				loadMsg:'加载数据,请稍等...',
				fit:true,
				idField:'meucode',
				treeField:'meucode',
				frozenColumns:[[
					{field:'meucode',title:'菜单编码',width:220},
					{field:'meuname',title:'菜单名称',width:200}
				]],				
				columns:[[					
					{field:'meupcode',title:'上级菜单编码',width:100},
					{field:'relationC',title:'关系码',width:180},
					{field:'meulevel',title:'级次',width:40,align:'center'},
					{field:'meuleaf',title:'叶子节点',width:80,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src="themes/icons/ok.png">';
						}
					},
					{field:'meuenable',title:'启用',width:50,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src="themes/icons/ok.png">';
						}
					},
					{field:'meuhref',title:'链接',width:260},
					{field:'fullscreen',title:'全屏',width:50,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src=themes/icons/ok.png>';
						}
					},
					{field:'meumemo',title:'备注',width:260}						
				]],
				onBeforeLoad:function(row,param){
					var meupcode = '';
					if (row){
						meupcode = row['meucode'];
					}
					else{
						meupcode = '0';
					}					
					
					param['data'] = obj2str(
							{		
								ACTION_TYPE : 'treegrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
								ACTION_MANAGER : 'sysMenuManager',		 
								list:[{
									meupcode : meupcode
								}]
							}
						);
										
				},
				onContextMenu: function(e, row){
					e.preventDefault();
					$(this).treegrid('unselectAll');
					$(this).treegrid('select', row['meucode']);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				},
				onDblClickRow:function(rowIndex, rowData){
					edit();
				},
				toolbar:[{
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
				'-'
				,{
					id:'btnRefresh',
					text:'刷新',					
					iconCls:'icon-reload',
					handler:function(){
						refresh();
					}
				}
				]
			});
			
			
			
			$('#iconCls').combobox({  
			    url:'script/iconConfig.json',  
			    valueField:'class',
			    textField:'text',
			    formatter:function(row){  
			        return '<img style="float:left;" src="themes/' + row.url + '"/><div>'+row.text+'</div>';  
			    }  
			});
				
			
			$('#menuManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });

		});		
		
		function cancel(){
			$('#menuWindow').window('close');
		}
		
		function unselect(){
			$('#menuManager').treegrid('unselectAll');
		}
		
		function refresh(){
			var node = $('#menuManager').treegrid('getSelected');
			if (node){
				$('#menuManager').treegrid('reload', node['meucode']);
			} else {
				$('#menuManager').treegrid('reload');
			}
		}
		
		function add(){			
			var row = $('#menuManager').treegrid('getSelected');
			$('#meucode').attr('disabled', '');
			clearForm('menuManager_form');			
			$('#meuenable').attr('checked','true');
			
			if( row ){
				$('#meupcode').val( row['meucode'] );
				$('#meulevel').val( parseInt(row['meulevel']) + 1 );
			}
			else{
				$('#meupcode').val( '0' );
				$('#meulevel').val( 1 );
			}
			
			isNew = true;
			$('#menuWindow').window('open');
		}
		
		function edit(){			
			var row = $('#menuManager').treegrid('getSelected');
			clearForm('menuManager_form');
			
			if( !row ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'treegrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
							ACTION_MANAGER : 'sysMenuManager',		 
							list:[{
								meucode : row['meucode']
							}]
					})
					
				}, 
				function(data){					
                    if( data.length != undefined && data.length > 0 ){
                    	var sm = data[0];                    	
                    	fillForm('menuManager_form', sm);
                    	isNew = false;
                    	$('#meucode').attr('disabled', 'disabled');						
						$('#menuWindow').window('open');						
                    	 
                    }else{
                        $.messager.alert('提示','没有获取到此菜单的信息!','error');
                    } 
            	},
            	'json'
            );			
		}
		
		function remove(){
			var row = $('#menuManager').treegrid('getSelected');
			
			if( !row ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			
			$.messager.confirm('确认操作', '确认要删除[' + row['meuname']+ ']及其以下的菜单吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
									ACTION_MANAGER : 'sysMenuManager',
									optType : 'delete',
									optContent : '删除菜单',		 
									list: [
										{
											relationC : row['relationC']
										}
									]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('提示','删除成功！','info');
		                    	if( row['meulevel'] == 1 ){
		                    		$('#menuManager').treegrid('reload');
		                    	}
		                    	else{
		                    		$('#menuManager').treegrid('reload', row['meupcode']);
		                    	}
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveMenu(){
			if( !checkForm( 'menuManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
		
			var menuData = getFormData( 'menuManager_form' );
		
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'insert',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
							ACTION_MANAGER : 'sysMenuManager',
							optType : isNew ? 'add':'update',
							optContent : isNew ? '新增菜单':'修改菜单',		 
							list:[ menuData ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存菜单成功!','info');
                    	if( menuData['meulevel'] == 1 ){
                    		$('#menuManager').treegrid('reload');
                    	}
                    	else{
                    		$('#menuManager').treegrid('reload', menuData['meupcode']);
                    	}
                    	cancel();                    	
                    }else{ 
                        $.messager.alert('提示','保存菜单失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
		}
		
		
		
	</script>
</head>
<body>	
	<div style="width:800px;height:560">	
		<table id="menuManager"></table>
	</div>
	<div id="mm" class="easyui-menu" style="width:120px;">
		<div onclick="add();" iconCls="icon-add">新建</div>
		<div onclick="edit();" iconCls="icon-edit">修改</div>
		<div onclick="remove();" iconCls="icon-remove">删除</div>
		<div class="menu-sep"></div>
		<div onclick="unselect();" iconCls="icon-cancel">取消选择</div>
		<div onclick="refresh();" iconCls="icon-reload">刷新</div>
	</div>
	<div id="menuWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="菜单信息" style="width:520px;height:300px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="menuManager_form" class="tableClass">
					<tr>
						<td>菜单编码：</td>
						<td><input required="true" id="meucode" name="meucode" type="text"/></td>
						<td>菜单名称：</td>
						<td><input name="meuname" required="true" type="text"/></td>
					</tr>
					<tr>
						<td>上级菜单编码：</td>
						<td><input id="meupcode" name="meupcode" type="text" readonly="readonly" /></td>
						<td>级次：</td>
						<td><input id="meulevel" name="meulevel" type="text" readonly="readonly" /></td>
					</tr>
					<tr>
						<td>关系码：</td>
						<td><input id="relationC" name="relationC" type="text" required="true"/></td>
						<td>图标：</td>
						<td>
							<input id="iconCls" name="iconCls" type="text"/>
						</td>
					</tr>
					<tr>
						<td>链接：</td>
						<td><input name="meuhref" type="text" /></td>
						<td>是否叶子：</td>
						<td><input id="meuleaf" name="meuleaf" type="checkbox" /></td>
						
					</tr>
					<tr>
						<td>是否可用：</td>
						<td><input id="meuenable" name="meuenable" type="checkbox"/></td>
						<td>是否全屏：</td>
						<td><input id="fullscreen" name="fullscreen" type="checkbox" /></td>						
					</tr>					
					<tr>
						<td>备注：</td>
						<td colspan="3"> <textarea style="width:80%" name="meumemo"></textarea></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveMenu();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">取消</a> 
			</div> 
		</div>
	</div>	
</body>
</html>