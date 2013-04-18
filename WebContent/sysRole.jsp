<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>

	<title>��ɫ����</title>	
	<script>
		$(function(){
			$('#role').datagrid({
				title:'��ɫ�б�',
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
							optContent : '��ѯ��ɫ',	 	 
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
				loadMsg:'��������...',
				frozenColumns:[[
					{field:'select',checkbox:true}
				]],				
				columns:[[	
					{field:'rlcode',title:'��ɫ����',width:100,align:'center'},					
					{field:'rlname',title:'��ɫ����',width:120},
					{field:'rltype',title:'��ɫ���',width:120,sortable:true,
						formatter:function(value,rec){
							if( value === 'I' )
								return '������';
							else if( value === 'S' )
								return '��Ӧ��';
						}
					},
					{field:'rlflag',title:'��ɫ״̬',width:150,sortable:true,
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
					text:'��ѯ',
					iconCls:'icon-search',
					handler:function(){
						search();
					}
				},{
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
				'-',
				{
					id:'btnMenu',
					text:'�����ɫȨ��',
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
        
	        //��ѯ����ֱ�������queryParams��
	        $('#role').datagrid('options').url = 'JsonServlet';        
			$('#role').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
						ACTION_MANAGER : 'sysRoleManager',
						optType : 'query',
						optContent : '��ѯ��ɫ',	 		 
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
					$.messager.alert('����','����ѡ��һ�м�¼��','warning');
					return;
				}
				if( rows.length > 1 ){
					$.messager.alert('����','ֻ��ѡ��һ�м�¼���б༭��','warning');
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
							optContent : '�޸Ľ�ɫ',		 
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
                        $.messager.alert('��ʾ','��ȡ�û���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}

		function remove(){
			var rows = $('#role').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
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
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��ѡ�еļ�¼��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
									ACTION_MANAGER : 'sysRoleManager',	
									optType : 'query',
									optContent : 'ɾ����ɫ',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $("#role").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','��ȡ�û���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
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
							optContent : '������ɫ',			 
							list:[ getFormData( 'uiform' ) ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','�����û��ɹ�!','info');
                    	$("#role").datagrid('reload');
                    	cancel(); 
                    }else{ 
                        $.messager.alert('��ʾ','�����û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
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
			
			//��ѯ����ֱ�������queryParams��
		    $('#role').datagrid('options').url = 'JsonServlet';        
			$('#role').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysRole',
						ACTION_MANAGER : 'sysRoleManager',	
						optType : 'query',
						optContent : '��ѯ��ɫ',		 
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
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;
			}
			if( rows.length > 1 ){
				$.messager.alert('����','ֻ��ѡ��һ�м�¼��','warning');
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
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
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
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ����ѡ�еļ�¼��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'saveRlMeu',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysRlmeu',
									ACTION_MANAGER : 'sysRoleManager',	
									optType : 'query',
									optContent : '�޸Ľ�ɫȨ��',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','���³ɹ���','info');
		                    	 $("#role").datagrid('reload');
		                    	 $("#treeWindow").window("close");
		                    }else{ 
		                        $.messager.alert('��ʾ','����ʧ��!<br>ԭ��' + data.returnInfo,'error');
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
	
	<div id="roleWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�½���ɫ" style="width:700px;height:400px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="uiform" class="tableClass">
					<tr>
						<td>��ɫ���룺</td>
						<td><input required="true" id="rlcode" name="rlcode" type="text" /></td>
						<td>��ɫ���ƣ�</td>
						<td><input name="rlname" id="rlname" required="true" type="text"/></td>
					</tr>
					
					<tr>
						<td>��ɫ���ͣ�</td>
						<td>
							<select name="rltype" id="rltype">
							    <option value="I">������</option>
							    <option value="S">��Ӧ��</option>
							</select>
							<input id="sgcode" type="hidden" name="sgcode" value=""/>
						</td>
						<td>�Ƿ����ã�</td>
						<td>
							<input type="checkbox" id="rlflag" name="rlflag" value=""/>						
						</td>
					</tr>

				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveRole();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">ȡ��</a> 
			</div> 
		</div>
	</div>
	<div id="searchRole" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="��ѯ��ɫ" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="i_form" class="tableClass">
					<tr>
						<td>��ɫ���룺</td>
						<td><input name="rlcode" type="text" /></td>						
					</tr>					
					<tr>
						<td>��ɫ���ƣ�</td>
						<td><input name="rlname" type="text"/></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchRole();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">ȡ��</a> 
			</div> 
		</div>
	</div>	
	
	
	<div id="treeWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="true" shadow="true" closed="true" modal="true" title="�����ɫȨ��" style="width:400px;height:500px;">
		<ul id="tree" ></ul>
		<p/>
		<input id="selRlcode" type="hidden" value=""/>
		<input id="selSgcode" type="hidden" value=""/>
		<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
			<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveRlMeu();">ȷ��</a> 
			<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSaveRlmeu();">ȡ��</a> 
		</div> 
	</div>	
</body>
</html>