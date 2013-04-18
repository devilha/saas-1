<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�������</title>	

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

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	boolean isSupplier = "S".equalsIgnoreCase( currUser.getSutype().toString() );
%>		
	
	<script>
	
		$(function(){
			$('#noticeManager').datagrid({
				nowrap: false,
				striped: true,
				width: User['sutype'] == 'S' ? 705 : 825,
				url:'JsonServlet',
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
							ACTION_MANAGER : 'noticeManager',							 
							list:[{
								id : ''
							}]
						}
					)
				},   
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns: false,
				idField: 'id',
				loadMsg:'��������,���Ե�...',
				fit:false,				
				columns:[[					
					{field:'mnTitle',title:'����',sortable:true,width:370,
						formatter:function(value,rec){
							
							var mtdName = (User['sutype'] == 'L' ? 'edit' : 'view' );
							
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=' + mtdName + '("' + rec.id + '");>' + value +'</a>';
							
						}
					},
					{field:'crtByCn',title:'������',sortable:true,width:150},
					{field:'mnFbDate',title:'����ʱ��',sortable:true,width:150,
						formatter:function(value,rec){
							if( value != null )
								return new Date(value.time).format('yyyy-MM-dd HH:mm:ss');
							
						}
					}
					<% if( !isSupplier ){ %>
					,
					{field:'enabled',title:'����',width:120,align:'center',
						formatter:function(value,rec){
							var url = '';
							var status = rec.mnStatus;
							
							if( status == 'draft' ){
								url = '<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=removeNotice("' + rec.id +'");>ɾ��</a>&nbsp;&nbsp;<a href=javascript:void(0) style="color:green; font-weight:bold;" onclick=publishNotice("' + rec.id +'","official");>����</a>';
							}
							else{
								url = '&nbsp;&nbsp;<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=publishNotice("' + rec.id +'","draft");>����</a>';
							
								if( value === 'Y' ){
									url = '<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=enableNotice("' + rec.id + '","N");>����</a>' + url;
								}
								else{
									url = '<a href=javascript:void(0) style="color:green; font-weight:bold;" onclick=enableNotice("' + rec.id +'","Y");>����</a>' + url;
								}
							}
							
							return url;
						}
					}
					<% } %>		
				]],
				pagination:true,
				rownumbers:true				
				<% if( !isSupplier ){ %>
				,
				toolbar:[				
				{
					id:'btnAdd',
					text:'�½�',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				}				
				]
				<% } %>
			});	

		<% if( !isSupplier ){ %>
			
			$('#mnContent').xheditor({
				tools:'Cut,Copy,Paste,Pastetext,|,Blocktag,Fontface,FontSize,|,Bold,Italic,Underline,Strikethrough,|,FontColor,BackColor,|,SelectAll,Removeformat,|,Align,List,Outdent,Indent,|,Link,Unlink,Anchor,Img,Flash,Media,Hr,Emot,Table,Print,Fullscreen',
				layerShadow:0,
				skin:'o2007blue',
				upBtnText: '�ϴ�',
				upLinkUrl: 'EditorUpload',
				upLinkExt: 'zip,rar,txt',
				upImgUrl: 'EditorUpload',
				upImgExt: 'jpg,jpeg,gif,png',
				upFlashUrl: 'EditorUpload',
				upFlashExt: 'swf',
				upMediaUrl: 'EditorUpload',
				upMediaExt: 'wmv,avi,wma,mp3,mid',
				defLinkText:'�������'
			});
			
			$('#noticeManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });
	    
	    <% } %>    
	        
		});		
		
		function cancel(){
			$('#noticeWindow').window('close');
		}
		
		function cancelSearch(){
			$('#searchNotice').window('close');
		}
		
		function search(){
			$('#searchNotice').window('open');
		}
		
		function searchNotice(){
			var searchData = getFormData( 'searchNotice' );
			
			//��ѯ����ֱ�������queryParams��
		    $('#noticeManager').datagrid('options').url = 'JsonServlet';        
			$('#noticeManager').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
						ACTION_MANAGER : 'noticeManager',		 
						list:[ searchData ]
					}
				)
			};        
			$("#noticeManager").datagrid('reload');				 
			
			cancelSearch();
		}
		
		function add(){
			clearForm('noticeManager_form');
			
			var now = new Date();
			var startDate = new Date();
			now.setMonth( now.getMonth() + 1 );
			$('#startDate').val( startDate.format('yyyy-MM-dd') );
			$('#endDate').val( now.format('yyyy-MM-dd') );	
			$('#btnSave_').linkbutton('enable');
            $('#btnPublish').linkbutton('enable'); 
			$('#noticeWindow').window('open');
		}
		
		function view( id ){			
					
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'editNotice',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
							ACTION_MANAGER : 'noticeManager',		 
							list:[{
								id : id,
								temp1:'S'
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var notice = data.rows[0];                    	 	                    	 	
                    	 	
                    	 	$('#mnTitle').text( notice['mnTitle'] );
                    	 	$('#mnContent').html( notice['mnContent'] );
                    	 	
							$('#noticeWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function edit( id ){			
					
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'editNotice',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
							ACTION_MANAGER : 'noticeManager',		 
							list:[{
								id : id,
								temp1:'L'
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var notice = data.rows[0];
                    	 	fillForm('noticeManager_form', notice);                    	 	
                    	 	
                    	 	if( notice['mnBeginDate'] != undefined ){
                    	 		$('#startDate').val( new Date(notice['mnBeginDate'].time).format('yyyy-MM-dd') );
                    	 	}
                    	 	if( notice['mnEndDate'] != undefined ){
                    	 		$('#endDate').val( new Date(notice['mnEndDate'].time).format('yyyy-MM-dd') );
                    	 	}							
                    	 	
                    	 	if( notice['mnStatus'] == 'draft' ){
                    	 		$('#btnSave_').linkbutton('enable');
                    	 		$('#btnPublish').linkbutton('enable');                    	 		
                    	 	}
                    	 	else{
                    	 		$('#btnSave_').linkbutton('disable');
                    	 		$('#btnPublish').linkbutton('disable');
                    	 	}
                    	 	
							$('#noticeWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function publishNotice( id,status ){
			var rows = $('#noticeManager').datagrid( 'getRows' );
			var rowInx = $('#noticeManager').datagrid( 'getRowIndex', id );
			
			var optName = (status === 'draft' ? '����' : '����');
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ' + optName + '[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'publishNotice',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
									ACTION_MANAGER : 'noticeManager',
									list: [{
										id : id,
										mnStatus : status
									}]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ', optName + '�ɹ���','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ', optName + 'ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});
		}
		
		function enableNotice( id, flag ){
		  var rows = $('#noticeManager').datagrid( 'getRows' );
			var rowInx = $('#noticeManager').datagrid( 'getRowIndex', id );
			
			var optName = (flag === 'N' ? '����' : '����');
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ' + optName + '[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'enableNotice',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
									ACTION_MANAGER : 'noticeManager',
									list: [{
										id : id,
										enabled : flag
									}]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ', optName + '�ɹ���','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ', optName + 'ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});
		}
		
		function removeNotice( id){
			 var rows = $('#noticeManager').datagrid( 'getRows' );
			var rowInx = $('#noticeManager').datagrid( 'getRowIndex', id );
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'removeNotice',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
									ACTION_MANAGER : 'noticeManager',
									list: [{
										id : id
									}]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveNotice(){
			if( !checkForm( 'noticeManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
		
			var content = $('#mnContent').val();
			if( content == '' ){
				$.messager.alert('û��ͨ����֤','����д���ģ�','warning');
				return;
			}
			
			$('a.easyui-linkbutton').linkbutton('disable');
		
			var notice = getFormData( 'noticeManager_form' );
			notice['mnContent'] = content.replace(/\"/g,"'").replace(/\"/g,"''");			
		
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveNotice',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
							ACTION_MANAGER : 'noticeManager',		 
							list:[ notice ]
					})
					
				}, 
				function(data){
					$('a.easyui-linkbutton').linkbutton('enable'); 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','���湫��ɹ�!','info');
                    	$("#noticeManager").datagrid('reload');
                    	cancel(); 
                    }else{                    	 
                        $.messager.alert('��ʾ','���湫��ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function publish(){
			if( !checkForm( 'noticeManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
		
			var content = $('#mnContent').val();
			if( content == '' ){
				$.messager.alert('û��ͨ����֤','����д���ģ�','warning');
				return;
			}
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫֱ�ӷ����˹�����?', function(r){			
				if(r){
					$('a.easyui-linkbutton').linkbutton('disable');
		
					var notice = getFormData( 'noticeManager_form' );
					notice['mnContent'] = content.replace(/\"/g,"'").replace(/\'/g,"''");			
				
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'publish',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgNotice',
									ACTION_MANAGER : 'noticeManager',		 
									list:[ notice ]
							})
							
						}, 
						function(data){
							$('a.easyui-linkbutton').linkbutton('enable'); 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','��������ɹ�!','info');
		                    	$("#noticeManager").datagrid('reload');
		                    	cancel(); 
		                    }else{                    	 
		                        $.messager.alert('��ʾ','��������ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );
				}
			});
		}
	</script>
</head>
<body>	
	<div align="center">
		<table style="line-height:20px; width:709px; text-align:left; border:none;">
			<tr>
				<td style="border:none;">&nbsp;</td>
		    </tr>
			<tr>
		    	<td><div align="left" style=" text-align:left; border:none; font-size: 12px; color:#4574a0;">�������</div></td>
			</tr>
			<tr>
				<td style="border:none;">&nbsp;</td>
		    </tr>
		</table>
		<table id="noticeManager"></table>
	<div>		
	
	<% if(!isSupplier){ %>
	
	<div id="noticeWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="������Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="noticeManager_form" style="font-size: 12px" width="100%">
					<tr>
						<td style="font-weight:bold;width:70px"><input type="hidden" id="noticeId" name="id"/>
							��Чʱ�䣺
						</td>
						<td style="width:80px"><input type="text" name="startDate" id="startDate" value="" size="20" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
						<td style="font-weight:bold;text-align:left;vertical-align:middle;width:30px">��</td>
						<td style="width:150px"><input type="text" name="endDate" id="endDate" value="" size="20" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}'});" /></td>						
					</tr>
					<tr>
						<td style="font-weight:bold;width:70px">���⣺</td>
						<td colspan="3"><input required="true" id="mnTitle" name="mnTitle" type="text" size="72" /></td>						
					</tr>
					<tr>
						<td colspan="4" style="font-weight:bold;" width="100%">���ģ�</td>
					</tr>					
					<tr>						
						<td colspan="4" width="100%">
							<textarea style="width:675px;height:275px"  id="mnContent" name="mnContent"></textarea>	
						</td>						
					</tr>					
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a id="btnSave_" class="easyui-linkbutton" iconCls="icon-save" href="javascript:void(0)" onclick="saveNotice();">����</a>
				<a id="btnPublish" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="publish();">����</a> 
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">ȡ��</a> 
			</div> 
		</div>
	</div>
	
	<% }else{ %>
	<div id="noticeWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="������Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="noticeManager_form" style="font-size: 12px" width="100%">					
					<tr>						
						<td align="center"><span id="mnTitle" name="mnTitle" style="font-size: large; vertical-align: middle;"></span></td>						
					</tr>					
					<tr>						
						<td>						
							<div style="width:675px;height:425px;"  id="mnContent" ></div>	
						</td>
					</tr>					
				</table>
			</div>			 
		</div>
	</div>
	<% } %>
		
</body>
</html>