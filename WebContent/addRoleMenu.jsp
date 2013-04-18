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

	<title>��ɫ����</title>	
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
							optContent : '��ѯ��ɫ',	 	 
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
				loadMsg:'��������...',	
				columns:[[	
					{field:'rlcode',title:'��ɫ����',width:100,sortable:true,align:'center',
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editRoleMenu("' + value + '");>' + value + '</a>';
						}
					},					
					{field:'rlname',title:'��ɫ����',width:120},
					{field:'rltype',title:'��ɫ���',width:120,sortable:true,
						formatter:function(value,rec){
							if( value === 'L' )
								return '������';
							else if( value === 'S' )
								return '��Ӧ��';
							else
								return '����Ա';
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
				rownumbers:true
			});
			$('#uiform input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });		
		});
		
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

		function searchRole(){
			var searchData = getFormData( 'searchRole' );
			searchData['sgcode'] = User.sgcode;
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
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
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
		                    	 $("#role").datagrid('resize');
		                    	 $("#treeWindow").window("close");
		                    }else{ 
		                        $.messager.alert('��ʾ','����ʧ��!<br>ԭ��' + data.returnInfo,'error');
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
		
		//��ձ�������
		function clearSearchRole(){
			clearForm('searchRole');
		}
		
	</script>
</head>
<body>	

	<div style="color:#4574a0; text-align:left;margin-top: 5px;margion-bottom:10px;">�����ɫȨ��</div>
	<div id="searchRole"  iconCls="" minimizable="false" maximizable="false" collapsible="false"  title="" style="width:640px;height:60px;">
				<table id="i_form" class="tableClass">
					<tr>
						<td>��ɫ���룺<input name="rlcode" type="text" /></td>
						<td>��ɫ���ƣ�<input name="rlname" type="text"/><input id="sgcode" type="hidden" name="sgcode" value=""/></td>
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
	
	<div id="treeWindow" class="easyui-window" iconCls="" minimizable="false" maximizable="false" collapsible="true" shadow="true" closed="true" modal="true" title="�����ɫȨ��" style="width:400px;height:500px;">
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