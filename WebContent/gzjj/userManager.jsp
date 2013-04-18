<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�û�����</title>	

	<style type="text/css">         
        .proxy{
			border:1px solid #ccc;
			width:200px;
			background:#9FECFF;
			position:'absolute';
			z-Index:99999;
		}
		.over{
			border:1px solid red;			
		}
		.normal{
			border:1px solid #ccc;
		}
        .btn  
        {  
            display: block;  
            margin: 10px auto;  
            width: 80px;  
        }  
	</style>
	
	
	<script>
		var isNew = false;
		var editFlag = false;
	
		$(function(){
			$('#userManager').datagrid({
				title:'�û�����',
				width: 650,
				singleSelect:true,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'JsonServlet',
				singleSelect:false,
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		
							optType : 'query',
							optContent : '��ѯ�û�',	 
							list:[{
								sgcode : User.sgcode
							}]
						}
					)
				},   
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:false,
				loadMsg:'��������,���Ե�...',
				fit:true,
				frozenColumns:[[
					{field:'select',checkbox:true},
					{field:'sucode',title:'�û�����',width:100,sortable:true,align:'center'}
				]],				
				columns:[[
					{field:'suname',title:'�û�����',width:240,sortable:true},					
					{field:'sutype',title:'�û�����',width:100,sortable:true,
						formatter:function(value,rec){
							if( value === 'L' )
								return '������';
							else if( value === 'S' )
								return '��Ӧ��';
						}
					},
					{field:'suenable',title:'����',width:50,sortable:true,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' ){
								return '<img src=themes/icons/ok.png>';
							}else{
								return '<img src=themes/icons/no.png>';
							}
								
						}
					},
					{field:'address',title:'��ַ',width:250},
					{field:'salemethod',title:'��Ӫ��ʽ',width:150},
					{field:'fax',title:'����',width:150},
					{field:'linkman',title:'��ϵ��',width:150},
					{field:'linkmantel',title:'��ϵ�˵绰',width:150},
					{field:'sumemo',title:'��ע',width:250}		
				]],
				onHeaderContextMenu: function(e, field){
					e.preventDefault();
					if (!$('#tmenu').length){
						createColumnMenu('#userManager');
					}
					$('#tmenu').menu('show', {
						left:e.pageX,
						top:e.pageY
					});
				},
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
					id:'btnRole',
					text:'�����ɫ',
					iconCls:'icon-redo',
					handler:function(){
						editUserRole();
					}
				}				
				]
			});					
			
			$('#userManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });

		});		
		
		function cancel(){
			$('#userWindow').window('close');
		}
		
		function cancelSearch(){
			$('#searchUser').window('close');
		}
		
		function cancelUserRole(){
			$('#userRoles').window('close');
		}
		
		function search(){
			$('#searchUser').window('open');
		}
		
		function searchUser(){
			var searchData = getFormData( 'searchUser' );
			searchData['sgcode'] = User.sgcode; 
			//��ѯ����ֱ�������queryParams��
		    $('#userManager').datagrid('options').url = 'JsonServlet';        
			$('#userManager').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
						ACTION_MANAGER : 'userManager',
						optType : 'query',
						optContent : '��ѯ�û�',		 
						list:[ searchData ]
					}
				)
			};        
			$("#userManager").datagrid('reload');				 
			
			cancelSearch();
		}
		
		function add(){
			isNew = true;
			isEdit = false;
			clearForm('userManager_form');
			$('#sgcode').val( User.sgcode );
			$('#sucode').removeAttr('disabled');
			$('#suenable').attr('checked','true');
			$('#sutype').val('S');
			$('#userWindow').window('open');
		}
		
		function edit( rowData ){
			var data;
			
			if( rowData ){
				data = rowData;
			}
			else{			
				var rows = $('#userManager').datagrid('getSelections');
				if( rows.length == 0 ){
					$.messager.alert('����','����ѡ��һ�м�¼��','warning');
					return;
				}
				/*
				if( rows.length > 1 ){
					$.messager.alert('����','ֻ��ѡ��һ�м�¼���б༭��','warning');
					return;
				}
				*/
				data = rows[0];
			}
			
			isNew = false;
			isEdit = true;
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[{
								sucode : data.sucode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var su = data.rows[0];
                    	 	fillForm('userManager_form', su);
                    	 	$('#editFlag').val('true');
                    	 	$('#supcode').attr('disabled', 'disabled');
							$('#userWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�û���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function remove(){
			var rows = $('#userManager').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
				return;
			}
			
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ sucode : rows[i].sucode }
				);
			}			
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��ѡ�еļ�¼��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
									ACTION_MANAGER : 'userManager',
									optType : 'delete',
									optContent : 'ɾ���û�',
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $("#userManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ���û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveUser(){
			if( !checkForm( 'userManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			var supcode = $('#supcode').val();
		    var searchData = getFormData( 'userManager_form' );
		    searchData['sgcode'] = User.sgcode; 
		    searchData['sucode'] = User.sgcode + supcode;
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'insert',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : isNew ? 'add':'update',
							optContent : isNew ? '�����û�':'�޸��û�',		 
							list:[searchData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','�����û��ɹ�!','info');
                    	$("#userManager").datagrid('reload');
                    	cancel(); 
                    }else{ 
                        $.messager.alert('��ʾ','�����û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
		}
		
		function editUserRole(){
			var data;
						
			var rows = $('#userManager').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;
			}
			/*
			if( rows.length > 1 ){
				$.messager.alert('����','ֻ��ѡ��һ�м�¼��','warning');
				return;
			}
			*/
			data = rows[0];
			$('#selSgcode').val( data.sgcode );
			$('#selSucode').val( data.sucode );
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'hadRoles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	
							list:[{
								sucode : data.sucode,
								sgcode : data.sgcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	$('#hadRoles').empty();
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
					            $('#hadRoles').append(html);  
					        });
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�û���ɫ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'notRoles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',		 
							list:[{
								sucode : data.sucode,
								sgcode : data.sgcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	$('#notRoles').empty();
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
					            $('#notRoles').append(html);  
					        });
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�û���ɫ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
			$('#userRoles').window('open');
		}
		
		function saveUserRole(){
		var getAllRows = $('#userManager').datagrid( 'getSelections' );//��ȡ����ѡ�е��û�����
		
			var userRoles = [];	
				/*
			$.each( $('#hadRoles option'), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
				var rlcode = $(this).val();
				$('#rlcode_hidden').val(rlcode);
				//userRoles.push({
					//sgcode : $('#selSgcode').val(),
					//sucode : $('#selSucode').val(),
					//rlcode : $(this).val()
				//});  
			});
			*/
			for(var i=0;i<getAllRows.length;i++){
			$.each( $('#hadRoles option'), function(j, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
			//alert($(this).val());
						userRoles.push({
										sgcode : getAllRows[i].sgcode,
										sucode : getAllRows[i].sucode,
										rlcode : $(this).val()
												});
										});
					}
				
			if( userRoles.length == 0 ){
				$.messager.alert('����','ÿ���û�������Ҫ����һ����ɫ��','warning');
				return;
			}
			/*
			if( userRoles.length > 1 ){
				$.messager.alert('����','ÿ���û�ֻ�ܷ���һ����ɫ��','warning');
				return;
			}
			*/
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUserRole',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	
							optType : 'update',
							optContent : '�����û���ɫ',	 
							list: userRoles
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','�����ɫ�ɹ�!','info');                    	
                    	cancelUserRole(); 
                    }else{ 
                        $.messager.alert('��ʾ','�����û���ɫʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		function changeSup(){
		var supcode = $('#supcode').val();
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'changeUserExist',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	
							optType : 'select',
							optContent : '��ѯ�û�',	 
							list:[{
								sucode : supcode,
								sgcode : User.sgcode
							}]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '2' ){ 
                    	$.messager.alert('��ʾ','�ù�Ӧ���Ѵ���!','info');                    	
                    	$('#supcode').val('');
                    }
            	},
            	'json'
            );
		}
		
		function changeEditFlag(){
			if( isEdit ){
				$('#editFlag').val('');
			}
		}
		
		function addDragDrop( src, tar ){
			src.draggable({
				revert:true,
				deltaX:10,
				deltaY:10,
				proxy:function(source){
					var proxyHtml = $('<div class="proxy"><table></table></div>');
					var html = '';					
					$.each( src.find("option:selected"), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
			            html += "<tr><td>" + $(this).text() + "</td></tr>";
			        });
					proxyHtml.html( html ).appendTo('body');
					return proxyHtml;
				}
			});
			tar.droppable({
				onDragEnter:function(e,source){
					$(this).removeClass('normal');
					$(this).addClass('over');
				},
				onDragLeave:function(e,source){
					$(this).removeClass('over');
					$(this).addClass('normal');
				},
				onDrop:function(e,source){					
					$(this).removeClass('over');
					$(this).addClass('normal');
					var html = '';					
					$.each( src.find("option:selected"), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
			        	var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";
			        	tar.append( html );	
			        });					
					src.find("option:selected").remove();									
				}
			});	
		}
		
		/* ���ѡ����� */  
	    function Add(ObjSource, ObjTarget) {  
	       if(ObjSource.val() ==null) return;    // ���û��ѡ�����˳�����������仰�Ļ�IE6�ᱨ��  
	        $.each(ObjSource.find("option:selected"), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
	            var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";  
	            ObjSource.append(ObjTarget.html());
	            ObjTarget.empty();
	            ObjTarget.append(html);  
	        });  
	        ObjSource.find("option:selected").remove();  // ԭ�б���ѡ�е�ֵɾ��  
	    }  
	    
	    /* ���ȫ�� */  
	    function AddAll(ObjSource, ObjTarget) {  
	        ObjTarget.append(ObjSource.html());  // Ŀ���б��HTML����ԭ�б������HTML  
	        ObjSource.empty();  // ԭ�б����  
	    }
		
	</script>
</head>
<body>	
	<div style="width:800px;height:560">	
		<table id="userManager"></table>
	</div>
	<div id="userWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�û���Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="userManager_form" class="tableClass" style="font-size: 12px">
					<tr>
						<td>��Ӧ�̱��룺</td>
						<td><input required="true" id="supcode" name="supcode" type="text" onblur="changeSup();"/></td>
						<td>��Ӧ�����ƣ�</td>
						<td><input name="suname" required="true" type="text"/></td>
					</tr>
					<tr>
						<td>��Ӧ�����룺</td>
						<td>
							<input type="hidden" id="editFlag" name="editFlag" value=""/>
							<input validType="safepass"  required="true" name="supwd" type="password" onkeydown="changeEditFlag();"/>
						</td>
						<td>��Ӧ�����ͣ�</td>
						<td>
							<select id="sutype" name="sutype">
							    <option value="S" selected="selected">��Ӧ��</option>
							</select>						
						</td>
					</tr>
					<tr>
						<td>������ʾ���⣺</td>
						<td><input name="supwdq" type="text" required="true"/></td>
						<td>�𰸣�</td>
						<td><input name="supwda" type="text" required="true"/></td>
					</tr>
					<tr>
						<td>������д��</td>
						<td><input id="txtMobile" name="shortname" type="text" /></td>
						<td>��Ӫ��ʽ��</td>
						<td>
							<select name="salemethod">
							    <option value="J">����</option>
							    <option value="L">��Ӫ</option>
							    <option value="D">����</option>
							    <option value="">����</option>
							</select>
							���ã�
							<input id="suenable" name="suenable" type="checkbox"/>							
						</td>
					</tr>
					<tr>
						<td>������</td>
						<td><input name="region" type="text" /></td>
						<td>�ֻ���</td>
						<td><input name="mobile" class="easyui-numberbox" min="0" precision="0" /></td>						
					</tr>
					<tr>
						<td>�����</td>
						<td><input name="area" class="easyui-numberbox" min="0" precision="2" /></td>
						<td>��˾���룺</td>
						<td><input name="companycode" type="text" /></td>
					</tr>
					<tr>
						<td>�ʱࣺ</td>
						<td><input id="zipcode" name="zipcode" type="text"/></td>
						<td>��ҵ��</td>
						<td><input name="industry" type="text"/></td>
					</tr>
					<tr>
						<td>���棺</td>
						<td><input id="fax" name="fax" type="text"/></td>
						<td>�����ʼ���</td>
						<td><input id="email" name="email" type="text"/></td>
					</tr>					
					<tr>
						<td>���У�</td>
						<td><input id="bank" name="bank" type="text"/></td>
						<td>�˻���</td>
						<td><input id="account" name="account" type="text"/></td>
					</tr>
					<tr>
						<td>�����ۣ�</td>
						<td><input name="yearsale" class="easyui-numberbox" min="0" precision="2" /></td>
						<td>ע���ʽ�</td>
						<td><input name="capital" class="easyui-numberbox" min="0" precision="2" /></td>
					</tr>
					<tr>
						<td>��˾���ʣ�</td>
						<td><input name="nature" type="text"/></td>
						<td>��ҵ���</td>
						<td><input name="companycategory" type="text"/></td>
					</tr>
					<tr>
						<td>��֯���룺</td>
						<td><input name="organizationcode" type="text"/></td>
						<td>���ˣ�</td>
						<td><input id="legalperson" name="legalperson" type="text"/></td>
					</tr>
					<tr>
						<td>���˱��룺</td>
						<td><input name="legalpersonid" type="text"/></td>
						<td>���˵绰��</td>
						<td><input name="legalpersontel" class="easyui-numberbox" min="0" precision="0" /></td>
					</tr>
					<tr>
						<td>�����ˣ�</td>
						<td><input name="agent" type="text"/></td>
						<td>�����˱��룺</td>
						<td><input name="agentid" type="text"/></td>
					</tr>
					<tr>
						<td>��ϵ�ˣ�</td>
						<td><input id="linkman" name="linkman" type="text"/></td>
						<td>��ϵ��ְλ��</td>
						<td><input id="linkmanoffice" name="linkmanoffice" type="text"/></td>
					</tr>
					<tr>
						<td>��ϵ�˵绰��</td>
						<td><input id="linkmantel" name="linkmantel" class="easyui-numberbox" min="0" precision="0"/></td>
						<td>���������</td>
						<td><input name="salearea" class="easyui-numberbox" min="0" precision="2"/></td>
					</tr>
					<tr>
						<td>ע���ַ��</td>
						<td colspan="3"><input style="width:80%" name="regaddress" type="text"/></td>
					</tr>
					<tr>
						<td>��ַ��</td>
						<td colspan="3"><input style="width:80%" id="address" name="address" type="text"/></td>
					</tr>
					<tr>
						<td>��ע��</td>
						<td colspan="3"> <textarea style="width:80%" name="memo"></textarea></td>
					</tr>					 
					<tr>
						<td>��˾������</td>
						<td colspan="3"> <textarea style="width:80%" name="companydescrib"></textarea></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveUser();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">ȡ��</a> 
			</div> 
		</div>
	</div>
	<div id="searchUser" class="easyui-window" iconCls="icon-search" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="��ѯ�û�" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;"> 
				<table id="userManager_form" class="tableClass">
					<tr>
						<td>�û����룺</td>
						<td><input name="sucode" type="text" /></td>						
					</tr>					
					<tr>
						<td>�û����ƣ�</td>
						<td><input name="suname" type="text"/></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchUser();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">ȡ��</a> 
			</div> 
		</div>
	</div>
	<div id="userRoles" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�����ɫ" style="width:560px;height:360px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<div  style="float:left;width: 200px;">
					<input id="selSucode" type="hidden" value=""/>
					<input id="selSgcode" type="hidden" value=""/>
					<div><b>�Ѿ�ӵ�еĽ�ɫ</b></div>  
			        <select id="hadRoles" name="hadRoles" class="normal" multiple="multiple" style="width:100%;height: 160px;" ondblclick="Add($('#hadRoles'),$('#notRoles'));"> 
			        </select>  
			    </div>  
			    <div style="float:left;width:120px;">    
			       <!--
			        <input type="button" value="&gt;" class="btn" onclick="Add($('#hadRoles'),$('#notRoles'))" />  
			        <input type="button" value="&gt;&gt;" class="btn" onclick="AddAll($('#hadRoles'),$('#notRoles'))" />  
			        -->
			        <input type="button" value="&lt;" class="btn" onclick="Add($('#notRoles'),$('#hadRoles'))" />  
			         <!--
			        <input type="button" value="&lt;&lt;" class="btn" onclick="AddAll($('#notRoles'),$('#hadRoles'))" />  
			         -->
			    </div>  
			    <div style="float:left;width: 200px;">
			    	<div><b>û�з���Ľ�ɫ</b></div>  
			        <select id="notRoles" name="notRoles" class="normal" multiple="multiple" style="width:100%;height: 160px;" ondblclick="Add($('#notRoles'),$('#hadRoles'));">  
			        </select>  
			    </div>  
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveUserRole();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelUserRole();">ȡ��</a> 
			</div> 
		</div>
	</div>
</body>
</html>