<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>����ϵͳ�û���ɫ</title>	

	<script>
		$(function(){
			$('#userRoles').datagrid({
				title:'ϵͳ�û��б�',
				width: 650,
				nowrap: false,
				striped: true,
				collapsible:false,
				url:'JsonServlet',
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '��ѯϵͳ�û�',	 
							list:[{
								supid : '',
								supsgcode : User.sgcode,
								sutype : 'I'
							}]
						}
					)
				},
				singleSelect:true,
				remoteSort: true,
				fitColumns:true,
				loadMsg:'��������,���Ե�...',
				fit:true,						
				columns:[[
					{field:'sucode',title:'�û�����',width:100,sortable:true,align:'center',
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editUserRole("' + rec.sucode + '");>' + rec.sucode + '</a>';
						}
					},
					{field:'suname',title:'�û�����',width:240,sortable:true},						
					{field:'sutype',title:'�û�����',width:120,sortable:true,
						formatter:function(value,rec){
							return '�ڲ��û�';
						}
					},					
					{field:'HADROLES',title:'�ѷ����ɫ',width:180,
						formatter:function(value,rec){							
							return '<select style="width:160" onclick=loadUserRoles(this,"' + rec.sucode + '");></select>';
						}
					}	
				]],				
				pagination:true,				
				onDblClickRow:function(rowIndex, rowData){
					edit( rowData );
				}				
			});	

		});	
		
		function search(){
			var searchData = getFormData( 'userRolesForm' );
			searchData['sgcode'] = User.sgcode;
			searchData['sutype'] = 'I';
			
			//��ѯ����ֱ�������queryParams��
		    $('#userRoles').datagrid('options').url = 'JsonServlet';        
			$('#userRoles').datagrid('options').queryParams = {
				data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '��ѯ��Ӧ���û�',	 
							list:[ searchData ]
						}
					)
			};        
			$("#userRoles").datagrid('reload');	
		}		
		
		function loadUserRoles( list, sucode ){
			if( $(list).attr('isLoad') == undefined ){
				
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'hadRoles',
								ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
								ACTION_MANAGER : 'userManager',	
								list:[{
									sucode : sucode,
									sgcode : User.sgcode
								}]
						})
						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){ 
	                    	 $(list).empty();
	                    	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }
	                    	 else{
	                    	 	$(list).append("<option value='none'>û�����ý�ɫ</option>");
	                    	 }
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�û���ɫ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		
		function cancelUserRole(){
			$('#userRolesWindow').window('close');
		}
		
		function clear(){
			clearForm('userRolesForm');
		}
		
		function editUserRole( sucode ){			
			
			$('#selSgcode').val( User.sgcode );
			$('#selSucode').val( sucode );
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'hadRoles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	
							list:[{
								sucode : sucode,
								sgcode : User.sgcode,
								rltype : 'I'
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
								sucode : sucode,
								sgcode : User.sgcode,
								rltype : 'I'
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
			
			$('#userRolesWindow').window('open');
		}
		
		function saveUserRole(){
			var userRoles = [];			
			$.each( $('#hadRoles option'), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
				userRoles.push({
					sgcode : $('#selSgcode').val(),
					sucode : $('#selSucode').val(),
					rlcode : $(this).val()
				});  
			});
			
			if( userRoles.length == 0 ){
				$.messager.alert('����','ÿ���û�������Ҫ����һ����ɫ��','warning');
				return;
			}
		
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
                    	$('#userRolesWindow').window('close');
                    }else{ 
                        $.messager.alert('��ʾ','�����û���ɫʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		/* ���ѡ����� */  
	    function Add(ObjSource, ObjTarget) {  
	       if(ObjSource.val() ==null) return;    // ���û��ѡ�����˳�����������仰�Ļ�IE6�ᱨ��  
	        $.each(ObjSource.find("option:selected"), function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
	            var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";  
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
	<div title="����ϵͳ�û���ɫ" id="userRolesForm" collapsible="true" minimizable="false" maximizable=false closable="false" style="width:800px;padding:10px;">
		<table style="line-height:20px; text-align:left; border:none; font-size:12px">	  		
	  		<tr>
	  			<td colspan="2" align="left" style="border:none; color:#4574a0;">����ϵͳ�û���ɫ</td>
	  		</tr>
	  		<tr>
			    <td colspan="2" width="300" style="border:none;">
					�û����룺<input type="text" id="sucode" name="sucode" value="" width="110" />					
				</td>
			    
	  		</tr>
			<tr>
			    <td colspan="2" width="300" style="border:none;">
					�û����ƣ�<input type="text" id="suname" name="suname" value="" width="110" />
				</td>			    
			</tr>		  
			<tr>
				<td align="right" style="border:none; padding-right:85px;"><img src="images/sure.jpg" border="0" onclick="search();" /></td>
		    	<td align="right" style="border:none; padding-right:135px;"><img src="images/back.jpg"  border="0" onclick="clear();" style="margin-left:40px;" /></td>
			</tr>
		</table>
	</div>		
	<div style="width:800px;height:360">	
		<table id="userRoles"></table>
	</div>	
	
	<div id="userRolesWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�����ɫ" style="width:560px;height:360px;">
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
			        <input type="button" value="&gt;" class="btn" onclick="Add($('#hadRoles'),$('#notRoles'))" />  
			        <input type="button" value="&gt;&gt;" class="btn" onclick="AddAll($('#hadRoles'),$('#notRoles'))" />  
			        <input type="button" value="&lt;" class="btn" onclick="Add($('#notRoles'),$('#hadRoles'))" />  
			        <input type="button" value="&lt;&lt;" class="btn" onclick="AddAll($('#notRoles'),$('#hadRoles'))" />  
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