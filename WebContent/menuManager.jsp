<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<title>�˵�����</title>
	
	<script>
		var isNew = false;
		
		$(function(){
			$('#menuManager').treegrid({
				title:'�˵�����',
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
				loadMsg:'��������,���Ե�...',
				fit:true,
				idField:'meucode',
				treeField:'meucode',
				frozenColumns:[[
					{field:'meucode',title:'�˵�����',width:220},
					{field:'meuname',title:'�˵�����',width:200}
				]],				
				columns:[[					
					{field:'meupcode',title:'�ϼ��˵�����',width:100},
					{field:'relationC',title:'��ϵ��',width:180},
					{field:'meulevel',title:'����',width:40,align:'center'},
					{field:'meuleaf',title:'Ҷ�ӽڵ�',width:80,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src="themes/icons/ok.png">';
						}
					},
					{field:'meuenable',title:'����',width:50,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src="themes/icons/ok.png">';
						}
					},
					{field:'meuhref',title:'����',width:260},
					{field:'fullscreen',title:'ȫ��',width:50,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' )
								return '<img src=themes/icons/ok.png>';
						}
					},
					{field:'meumemo',title:'��ע',width:260}						
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
					text:'�½�',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},{
					id:'btnEdit',
					text:'�޸�',
					iconCls:'icon-edit',
					handler:function(){
						edit();
					}
				},{
					id:'btnDelete',
					text:'ɾ��',					
					iconCls:'icon-remove',
					handler:function(){
						remove();
					}
				},
				'-'
				,{
					id:'btnRefresh',
					text:'ˢ��',					
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
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
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
                        $.messager.alert('��ʾ','û�л�ȡ���˲˵�����Ϣ!','error');
                    } 
            	},
            	'json'
            );			
		}
		
		function remove(){
			var row = $('#menuManager').treegrid('getSelected');
			
			if( !row ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;				
			}
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��[' + row['meuname']+ ']�������µĲ˵���?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysMenu',
									ACTION_MANAGER : 'sysMenuManager',
									optType : 'delete',
									optContent : 'ɾ���˵�',		 
									list: [
										{
											relationC : row['relationC']
										}
									]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	if( row['meulevel'] == 1 ){
		                    		$('#menuManager').treegrid('reload');
		                    	}
		                    	else{
		                    		$('#menuManager').treegrid('reload', row['meupcode']);
		                    	}
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveMenu(){
			if( !checkForm( 'menuManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
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
							optContent : isNew ? '�����˵�':'�޸Ĳ˵�',		 
							list:[ menuData ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','����˵��ɹ�!','info');
                    	if( menuData['meulevel'] == 1 ){
                    		$('#menuManager').treegrid('reload');
                    	}
                    	else{
                    		$('#menuManager').treegrid('reload', menuData['meupcode']);
                    	}
                    	cancel();                    	
                    }else{ 
                        $.messager.alert('��ʾ','����˵�ʧ��!<br>ԭ��' + data.returnInfo,'error');
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
		<div onclick="add();" iconCls="icon-add">�½�</div>
		<div onclick="edit();" iconCls="icon-edit">�޸�</div>
		<div onclick="remove();" iconCls="icon-remove">ɾ��</div>
		<div class="menu-sep"></div>
		<div onclick="unselect();" iconCls="icon-cancel">ȡ��ѡ��</div>
		<div onclick="refresh();" iconCls="icon-reload">ˢ��</div>
	</div>
	<div id="menuWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�˵���Ϣ" style="width:520px;height:300px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="menuManager_form" class="tableClass">
					<tr>
						<td>�˵����룺</td>
						<td><input required="true" id="meucode" name="meucode" type="text"/></td>
						<td>�˵����ƣ�</td>
						<td><input name="meuname" required="true" type="text"/></td>
					</tr>
					<tr>
						<td>�ϼ��˵����룺</td>
						<td><input id="meupcode" name="meupcode" type="text" readonly="readonly" /></td>
						<td>���Σ�</td>
						<td><input id="meulevel" name="meulevel" type="text" readonly="readonly" /></td>
					</tr>
					<tr>
						<td>��ϵ�룺</td>
						<td><input id="relationC" name="relationC" type="text" required="true"/></td>
						<td>ͼ�꣺</td>
						<td>
							<input id="iconCls" name="iconCls" type="text"/>
						</td>
					</tr>
					<tr>
						<td>���ӣ�</td>
						<td><input name="meuhref" type="text" /></td>
						<td>�Ƿ�Ҷ�ӣ�</td>
						<td><input id="meuleaf" name="meuleaf" type="checkbox" /></td>
						
					</tr>
					<tr>
						<td>�Ƿ���ã�</td>
						<td><input id="meuenable" name="meuenable" type="checkbox"/></td>
						<td>�Ƿ�ȫ����</td>
						<td><input id="fullscreen" name="fullscreen" type="checkbox" /></td>						
					</tr>					
					<tr>
						<td>��ע��</td>
						<td colspan="3"> <textarea style="width:80%" name="meumemo"></textarea></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveMenu();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">ȡ��</a> 
			</div> 
		</div>
	</div>	
</body>
</html>