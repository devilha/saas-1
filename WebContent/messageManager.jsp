<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>��Ϣ����</title>	

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
	String sutype = currUser.getSutype()+"";
	String sgcode = currUser.getSgcode();
	
	boolean isSupplier = "S".equalsIgnoreCase( currUser.getSutype().toString() );
	
%>		
	
	<script>
	
		$(function(){
			$('#myMessage').datagrid({
				nowrap: false,
				striped: true,
				width: 705,	
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns: false,
				loadMsg:'��������,���Ե�...',
				fit:false,				
				columns:[[
					{field:'select',checkbox:true},					
					{field:'mmTitle',title:'����',width:342,sortable:true,
						formatter:function(value,rec){
							if( rec['mmStatus'] == 'official' )
								return '<a href=javascript:void(0) style="color:#4574a0;font-weight:bold;" onclick=view("' + rec.id + '","Y","#myMessage");>' + value +'</a>';
							else
								return '<a href=javascript:void(0) style="color:#000000;" onclick=view("' + rec.id + '","Y");>' + value +'</a>';							
						}
					},
					{field:'mmSendCn',title:'������',sortable:true,width:150},
					{field:'mmFbDate',title:'����ʱ��',sortable:true,width:150,
						formatter:function(value,rec){
							if( value != null )
								return new Date(value.time).format('yyyy-MM-dd HH:mm:ss');
							
						}
					}							
				]],
				pagination:true,
				rownumbers:true,
				toolbar:[				
				{
					id:'btnDelete',
					text:'ɾ��',
					iconCls:'icon-remove',
					handler:function(){
						remove('#myMessage');
					}
				}				
				]
			});
			
			$('#backMessage').datagrid({
				nowrap: false,
				striped: true,
				width: 705,	
				sortOrder: 'desc',
				singleSelect: true,
				remoteSort: true,
				fitColumns: false,
				loadMsg:'��������,���Ե�...',
				columns:[[
					{field:'PROVIDID',title:'��Ӧ��',width:120,sortable:true},
					{field:'SETTLENO',title:'���ʵ���',width:100,sortable:true},
					{field:'MDATE',title:'ȷ��ʱ��',width:200,sortable:true},
					{field:'MDATE1',title:'����',width:150,sortable:true,
						formatter:function(value,rec){
						var backdate=(rec.MDATE).replace(" ","$");
								return '<a href=javascript:void(0) onclick=viewBackMessage("' +rec.SETTLENO + '","'+rec.PROVIDID+ '","'+backdate+'")>��ӡ</a>';
						}},
					{field:'PSTATE',title:'��ӡ����',width:100,sortable:true}					
				]],
				pagination:true,
				rownumbers:true
			});
			
			$('#sendMessage').datagrid({
				nowrap: false,
				striped: true,
				width: 705,
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns: false,
				loadMsg:'��������,���Ե�...',
				fit:false,				
				columns:[[
					{field:'select',checkbox:true},					
					{field:'mmTitle',title:'����',width:342,sortable:true,
						formatter:function(value,rec){
							return '<a href=javascript:void(0) onclick=view("' + rec.id + '","N","#sendMessage");>' + value +'</a>';
							
						}
					},
					{field:'mmReByC',title:'������',sortable:true,width:150},
					{field:'mmFbDate',title:'����ʱ��',sortable:true,width:150,
						formatter:function(value,rec){
							if( value != null )
								return new Date(value.time).format('yyyy-MM-dd HH:mm:ss');
							
						}
					}							
				]],
				pagination:true,
				rownumbers:true,
				toolbar:[				
				{
					id:'btnDelete',
					text:'ɾ��',
					iconCls:'icon-remove',
					handler:function(){
						remove('#sendMessage');
					}
				}				
				]
			});
			
			$('#draftMessage').datagrid({
				nowrap: false,
				striped: true,
				width: 705,							
				fitColumns: false,
				sortOrder: 'desc',
				remoteSort: true,				
				loadMsg:'��������,���Ե�...',
				fit:false,				
				columns:[[
					{field:'select',checkbox:true},					
					{field:'mmTitle',title:'����',sortable:true,width:342,
						formatter:function(value,rec){
							
							return '<a href=javascript:void(0) onclick=edit("' + rec.id + '");>' + value +'</a>';
							
						}
					},
					{field:'mmReByC',title:'������',sortable:true,width:150},
					{field:'crtByTime',title:'����ʱ��',sortable:true,width:150,
						formatter:function(value,rec){
							if( value != null )
								return new Date(value.time).format('yyyy-MM-dd HH:mm:ss');
							
						}
					}							
				]],
				pagination:true,
				rownumbers:true,
				toolbar:[				
				{
					id:'btnDelete',
					text:'ɾ��',
					iconCls:'icon-remove',
					handler:function(){
						remove('#draftMessage');
					}
				}				
				]
			});	
		
			if("3031"=="<%=sgcode%>" && "S"=="<%=sutype%>"){
				$('#messageManager').tabs({
					onSelect: function( title ){
						if( title == '�յ�����Ϣ' ){
							reload('#myMessage','getMyMessages');
						}
						else if( title == '�ѷ��͵���Ϣ' ){
							reload('#sendMessage','getSendMessages');
						}
						else if( title == 'δ���͵���Ϣ' ){
							reload('#draftMessage','getDraftMessages');
						}
						else if( title == '�յ���ȷ�ϻ�ִ��' ){
							reload2('#backMessage');
						}
					}
				});
			}else{
				$('#messageManager').tabs({
					tools:[{
						iconCls:'icon-add',
						text:'д����Ϣ',
						handler: function(){
							add();
						}
					}],
					onSelect: function( title ){
						if( title == '�յ�����Ϣ' ){
							reload('#myMessage','getMyMessages');
						}
						else if( title == '�ѷ��͵���Ϣ' ){
							reload('#sendMessage','getSendMessages');
						}
						else if( title == 'δ���͵���Ϣ' ){
							reload('#draftMessage','getDraftMessages');
						}
						else if( title == '�յ���ȷ�ϻ�ִ��' ){
							reload2('#backMessage');
						}
					}
				});
			}
			
			
			$('#mmContent').xheditor({
				tools:'Cut,Copy,Paste,Pastetext,|,Blocktag,Fontface,FontSize,|,Bold,Italic,Underline,Strikethrough,|,FontColor,BackColor,|,SelectAll,Removeformat,|,Align,List,Outdent,Indent,|,Link,Unlink,Anchor,Img,Flash,Media,Hr,Emot,Table,Print,Fullscreen',
				layerShadow:0,
				skin:'o2007blue',
				upBtnText: '�ϴ�',
				upLinkUrl: 'EditorUpload',
				upLinkExt: 'zip,rar,txt,doc,docx,xlsx,xls,jpg,png,gif,pdf',
				upImgUrl: 'EditorUpload',
				upImgExt: 'jpg,jpeg,gif,png',
				upFlashUrl: 'EditorUpload',
				upFlashExt: 'swf',
				upMediaUrl: 'EditorUpload',
				upMediaExt: 'wmv,avi,wma,mp3,mid',				
				defLinkText:'�������'
			});
			
			$('#msgManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });
	        
	        $('#mmReByC').combobox({
				width: 250,
				valueField:'SUCODE',
				textField:'SUNAME',						
				keyHandler:{
					query:function(newValue,oldValue){
						var queryValue = $('#mmReByC').combobox('textbox').val();
						
						if( queryValue.length < 3 )return;
						
						var receivers = $('#mmReByC').data(queryValue);
																	
						if( receivers ){
							$('#mmReByC').combobox('loadData', receivers );
							$('#mmReByC').combobox('setValue', queryValue);														
						}
						else{
							$.post( 'JsonServlet',				
								{
									data : obj2str({		
											ACTION_TYPE : 'getReceivers',
											ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
											ACTION_MANAGER : 'msgManager',
											list:[{
												mmReByC : queryValue
											}]
									})
								}, 
								function(data){ 
					                 if(data.returnCode == '1' ){ 
					                   	 if( data.rows ){
					                   	 	$('#mmReByC').combobox('loadData', data.rows );					                  	 	
					                  	 	$('#mmReByC').combobox('setValue', queryValue);
					                  	 	$('#mmReByC').data(queryValue, data.rows);					                   	 	
					                   	 }
						        	} 
					            },
					         	'json'
					    	);
						}
					}
				}		
			});       
		});		
		
		function viewBackMessage(settleno,provid,mdate){
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ��ӡ��?', function(r){
				if (r){
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'updatePstate',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Bill_FLCS',
								ACTION_MANAGER : 'settleFLCSManagerImpl',										 
								list:[{
								    sgcode:User.sgcode,
									settleno:settleno
								}]
							}
						)			
					}, 
	            	'json'
	            );
					var url = "jxsettledetPrint_FLCS_BACK.jsp?settleno="+settleno+"&provid="+provid+"&mdate="+mdate;
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
				}
			});
			}
		
		function cancel(windowId){
			$('#'+windowId).window('close');
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
		
		function reload( gridid, actionType){
			$(gridid).datagrid('options').url = 'JsonServlet';        
			$(gridid).datagrid('options').queryParams = {
				data :obj2str(
					{	
						ACTION_TYPE : actionType,
						ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
						ACTION_MANAGER : 'msgManager',		 
						list:[ {id : ''} ]
					}
				)
			};        
			$(gridid).datagrid('reload');
			$(gridid).datagrid('resize');
		}
		
		function reload2( gridid){
			$(gridid).datagrid('options').url = 'JsonServlet';        
			$(gridid).datagrid('options').queryParams = {
				data :obj2str(
					{	
						ACTION_TYPE : 'getBackMessage',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Bill_FLCS',
						ACTION_MANAGER : 'settleFLCSManagerImpl',		 
						list:[ {sgcode : User.sgcode} ]	 
					}
				)
			};        
			$(gridid).datagrid('reload');
			$(gridid).datagrid('resize');
		}
		
		function add(){
			$('#editId').val('');
			$('#mmTitle').val('');
			$('#mmContent').val('');
			$('#mmReByC').combobox('setValue','');
			
			$('#newMsgWindow').window('open');
		}
		
		function view( id, viewflag, gridId ){			
			
			$('#msgId').val( id );
			$('#gridId').val( gridId );
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'editMsg',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
							ACTION_MANAGER : 'msgManager',
							list:[{
								id : id,
								viewFlag : viewflag
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var msg = data.rows[0];                    	 	                    	 	
                    	 	
                    	 	$('#mmTitleView').text( msg['mmTitle'] );
                    	 	$('#mmContentView').html( msg['mmContent'] );
                    	 	
							$('#msgWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function edit( id ){			
					
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'editMsg',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
							ACTION_MANAGER : 'msgManager',		 
							list:[{
								id : id
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	var msg = data.rows[0];
                    	 	fillForm('msgManager_form', msg);                    	 	
                    	 	
                    	 	$('#mmReByC').combobox('setValue', msg['mmReByC'] );							
                    	 	
							$('#newMsgWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function remove( gridid ){
			
			var rows = $(gridid).datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
				return;
			}
			
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ id : rows[i].id }
				);
			}			
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��ѡ�е���Ϣ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'removeMsg',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
									ACTION_MANAGER : 'msgManager',
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $( gridid ).datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});
						
		}
		
		function removeMessage(){
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ������Ϣ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'removeMsg',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
									ACTION_MANAGER : 'msgManager',
									list: [{id:$('#msgId').val()}]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $( $('#gridId').val() ).datagrid('reload');
		                    	 
		                    	 cancel('msgWindow');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );
				}
			});				
						
		}
		
		function saveMessage(){
			if( !checkForm( 'msgManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			
			var mmReByC = $('#mmReByC').combobox('getValue');
			
			if( mmReByC == '' ){
				$.messager.alert('û��ͨ����֤','��ѡ������ˣ�','warning');
				return;
			}
			
			var content = $('#mmContent').val();
			if( content == '' ){
				$.messager.alert('û��ͨ����֤','����д���ģ�','warning');
				return;
			}
			
			$('a.easyui-linkbutton').linkbutton('disable');
		
			var msg = getFormData( 'msgManager_form' );
			msg['mmContent'] = content.replace(/\"/g,"'");
			msg['mmReByC'] = mmReByC;			
		
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveMsg',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
							ACTION_MANAGER : 'msgManager',		 
							list:[ msg ]
					})
					
				}, 
				function(data){
					$('a.easyui-linkbutton').linkbutton('enable'); 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','������Ϣ�ɹ�!','info');
                    	$('#messageManager').tabs('select','δ���͵���Ϣ');
                    	cancel('newMsgWindow'); 
                    }else{                    	 
                        $.messager.alert('��ʾ','������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function send(){
			if( !checkForm( 'msgManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
		
			var mmReByC = $('#mmReByC').combobox('getValue');
			if( mmReByC == '' ){
				$.messager.alert('û��ͨ����֤','��ѡ������ˣ�','warning');
				return;
			}		
		
			var content = $('#mmContent').val();
			if( content == '' ){
				$.messager.alert('û��ͨ����֤','����д���ģ�','warning');
				return;
			}
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫֱ�ӷ�����Ϣ��?', function(r){			
				if(r){
					$('a.easyui-linkbutton').linkbutton('disable');
		
					var msg = getFormData( 'msgManager_form' );
					msg['mmContent'] = content.replace(/\"/g,"'");
					msg['mmReByC'] = mmReByC;			
				
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'send',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
									ACTION_MANAGER : 'msgManager',		 
									list:[ msg ]
							})
							
						}, 
						function(data){
							$('a.easyui-linkbutton').linkbutton('enable'); 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','������Ϣ�ɹ�!','info');
		                    	$('#messageManager').tabs('select','�ѷ��͵���Ϣ');
		                    	cancel('newMsgWindow'); 
		                    }else{                    	 
		                        $.messager.alert('��ʾ','������Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
		    	<td><div align="left" style=" text-align:left; border:none; font-size: 12px; color:#4574a0;">��Ϣ����</div></td>
			</tr>
			<tr>
				<td style="border:none;">&nbsp;</td>
		    </tr>
		</table>
		
		<div id="messageManager" style="width:709px " align="center">		
			<div title="�յ�����Ϣ" closable="false">
				<table id="myMessage"></table>
			</div>
			<div title="�ѷ��͵���Ϣ" closable="false">
				<table id="sendMessage"></table>
			</div>
			<div title="δ���͵���Ϣ" closable="false">
				<table id="draftMessage"></table>
			</div>	
			<%if(currUser.getSucode().equals("3007_lss")){%>
			<div title="�յ���ȷ�ϻ�ִ��" closable="false">
				<table id="backMessage"></table>
			</div>	
			<%}%>
		</div>
	<div>
	
	<div id="newMsgWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�½���Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="msgManager_form" style="font-size: 12px" width="100%">					
					<tr>
						<td style="font-weight:bold;width:70px">���⣺</td>
						<td>
							<input type="hidden" id="editId" name="id"/>
							<input required="true" id="mmTitle" name="mmTitle" type="text" size="72" />
						</td>						
					</tr>
					<tr>
						<td style="font-weight:bold;width:70px">
							�����ˣ�
						</td>						
						<td>
							<input class="easyui-combobox" name="mmReByC" id="mmReByC" size="80" panelHeight="auto">
						</td>
					</tr>
					<tr>
						<td colspan="2" style="font-weight:bold;" width="100%">���ģ�</td>
					</tr>					
					<tr>						
						<td colspan="2" width="100%">
							<textarea style="width:675px;height:275px"  id="mmContent" name="mmContent"></textarea>	
						</td>						
					</tr>					
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a id="btnSave" class="easyui-linkbutton" iconCls="icon-save" href="javascript:void(0)" onclick="saveMessage();">����</a>
				<a id="btnSend" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="send();">����</a>				
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('newMsgWindow');">ȡ��</a> 
			</div>
		</div>
	</div>	
	<div id="msgWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�鿴��Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table style="font-size: 12px" width="100%">					
					<tr>						
						<td align="center">
							<input type="hidden" id="msgId" name="id"/>
							<input type="hidden" id="gridId" />
							<span id="mmTitleView" style="font-size: large; vertical-align: middle;"></span>
						</td>						
					</tr>					
					<tr>						
						<td>						
							<div style="width:645px;height:405px;" id="mmContentView" ></div>	
						</td>
					</tr>										
				</table>
			</div>
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a id="btnSave" class="easyui-linkbutton" iconCls="icon-remove" href="javascript:void(0)" onclick="removeMessage();">ɾ��</a>				
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('msgWindow');">ȡ��</a> 
			</div>
		</div>
	</div>	
</body>
</html>