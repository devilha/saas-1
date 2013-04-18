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
				loadMsg:'��������...',
				frozenColumns:[[
					{field:'select',checkbox:true}
				]],				
				columns:[[	
					{field:'rlcode',title:'��ɫ����',width:100,align:'center'},					
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
		}		
		function saveRole(){
			if( $('#hadUser').val() == 'Y' ){
				$.messager.alert('û��ͨ����֤','��ɫ[' + $('#rlcode').val() + ']�Ѵ��ڣ�','warning');
				return;
			}
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
							optType : 'add',
							optContent : '������ɫ',			 
							list:[ getFormData( 'uiform' ) ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','�����û��ɹ�!','info');
                    	$("#role").datagrid('reload');
                    }else{ 
                        $.messager.alert('��ʾ','�����û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
            clearForm('uiform');

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
						$.messager.alert('��ʾ','��ȡ�û���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
					} 
				},
				'json'
			);
		}
	</script>
</head>
<body>	
	<div id="roleWindow"  iconCls="" minimizable="false" maximizable="false"  title="������ý�ɫ" style="width:650px;height:120px;">
				<table id="uiform" style="line-height:20px; text-align:left; border:none;font-size:12px">
					<tr>
    					<td colspan="2" align="left" style="border:none; color:#4574a0;">������ý�ɫ</td>
    				</tr>
					<tr>
						<td>��ɫ���룺</td>
						<td><input required="true" id="rlcode" name="rlcode" type="text" onblur="checkRole();"/></td>
						<td>��ɫ���ƣ�</td>
						<td><input name="rlname" id="rlname" required="true" type="text"/></td>
						<td><div id="hadUserInfo" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;�ý�ɫ�����Ѿ����ڣ�</div></td>
						<input id="hadUser" type="hidden">	
					</tr>					
					<tr>
						<td>��ɫ���ͣ�</td>
						<td>
							<select name="rltype" id="rltype">
							    <option value="L">������</option>
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
					<tr>
						<td align="right" style="border:none; padding-right:85px;"><img src="images/add_js.jpg" border="0" onclick="saveRole();" /></td>
		    			<td align="right" style="border:none; padding-right:135px;"><img src="images/back.jpg" style="margin-left:40px;" onclick="clearRoleWindow();" /></td>
					</tr>

	</div>
	<div >	
		<tr>
    		<td colspan="2" align="left" style="border:none; color:#4574a0;">ϵͳ��ɫ��ѯ</td>
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