<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>公告管理</title>	

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
		out.println("当前用户已超时,请重新登陆!");
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
				loadMsg:'加载数据,请稍等...',
				fit:false,				
				columns:[[					
					{field:'mnTitle',title:'标题',sortable:true,width:370,
						formatter:function(value,rec){
							
							var mtdName = (User['sutype'] == 'L' ? 'edit' : 'view' );
							
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=' + mtdName + '("' + rec.id + '");>' + value +'</a>';
							
						}
					},
					{field:'crtByCn',title:'发布人',sortable:true,width:150},
					{field:'mnFbDate',title:'发布时间',sortable:true,width:150,
						formatter:function(value,rec){
							if( value != null )
								return new Date(value.time).format('yyyy-MM-dd HH:mm:ss');
							
						}
					}
					<% if( !isSupplier ){ %>
					,
					{field:'enabled',title:'操作',width:120,align:'center',
						formatter:function(value,rec){
							var url = '';
							var status = rec.mnStatus;
							
							if( status == 'draft' ){
								url = '<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=removeNotice("' + rec.id +'");>删除</a>&nbsp;&nbsp;<a href=javascript:void(0) style="color:green; font-weight:bold;" onclick=publishNotice("' + rec.id +'","official");>发布</a>';
							}
							else{
								url = '&nbsp;&nbsp;<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=publishNotice("' + rec.id +'","draft");>撤消</a>';
							
								if( value === 'Y' ){
									url = '<a href=javascript:void(0) style="color:red; font-weight:bold;" onclick=enableNotice("' + rec.id + '","N");>禁用</a>' + url;
								}
								else{
									url = '<a href=javascript:void(0) style="color:green; font-weight:bold;" onclick=enableNotice("' + rec.id +'","Y");>启用</a>' + url;
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
					text:'新建',
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
				upBtnText: '上传',
				upLinkUrl: 'EditorUpload',
				upLinkExt: 'zip,rar,txt',
				upImgUrl: 'EditorUpload',
				upImgExt: 'jpg,jpeg,gif,png',
				upFlashUrl: 'EditorUpload',
				upFlashExt: 'swf',
				upMediaUrl: 'EditorUpload',
				upMediaExt: 'wmv,avi,wma,mp3,mid',
				defLinkText:'点击下载'
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
			
			//查询参数直接添加在queryParams中
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
                        $.messager.alert('提示','获取公告信息失败!<br>原因：' + data.returnInfo,'error');
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
                        $.messager.alert('提示','获取公告信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function publishNotice( id,status ){
			var rows = $('#noticeManager').datagrid( 'getRows' );
			var rowInx = $('#noticeManager').datagrid( 'getRowIndex', id );
			
			var optName = (status === 'draft' ? '撤消' : '发布');
			
			$.messager.confirm('确认操作', '确认要' + optName + '[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]吗?', function(r){
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
		                    	 $.messager.alert('提示', optName + '成功！','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示', optName + '失败!<br>原因：' + data.returnInfo,'error');
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
			
			var optName = (flag === 'N' ? '禁用' : '启用');
			
			$.messager.confirm('确认操作', '确认要' + optName + '[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]吗?', function(r){
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
		                    	 $.messager.alert('提示', optName + '成功！','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示', optName + '失败!<br>原因：' + data.returnInfo,'error');
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
			$.messager.confirm('确认操作', '确认要删除[ <span style="color:#4574a0;">' + rows[rowInx]['mnTitle'] + '</span> ]吗?', function(r){
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
		                    	 $.messager.alert('提示','删除成功！','info');
		                    	 $("#noticeManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveNotice(){
			if( !checkForm( 'noticeManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
		
			var content = $('#mnContent').val();
			if( content == '' ){
				$.messager.alert('没有通过验证','请填写正文！','warning');
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
                    	$.messager.alert('提示','保存公告成功!','info');
                    	$("#noticeManager").datagrid('reload');
                    	cancel(); 
                    }else{                    	 
                        $.messager.alert('提示','保存公告失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function publish(){
			if( !checkForm( 'noticeManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
		
			var content = $('#mnContent').val();
			if( content == '' ){
				$.messager.alert('没有通过验证','请填写正文！','warning');
				return;
			}
			
			$.messager.confirm('确认操作', '确认要直接发布此公告吗?', function(r){			
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
		                    	$.messager.alert('提示','发布公告成功!','info');
		                    	$("#noticeManager").datagrid('reload');
		                    	cancel(); 
		                    }else{                    	 
		                        $.messager.alert('提示','发布公告失败!<br>原因：' + data.returnInfo,'error');
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
		    	<td><div align="left" style=" text-align:left; border:none; font-size: 12px; color:#4574a0;">公告管理</div></td>
			</tr>
			<tr>
				<td style="border:none;">&nbsp;</td>
		    </tr>
		</table>
		<table id="noticeManager"></table>
	<div>		
	
	<% if(!isSupplier){ %>
	
	<div id="noticeWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="公告信息" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="noticeManager_form" style="font-size: 12px" width="100%">
					<tr>
						<td style="font-weight:bold;width:70px"><input type="hidden" id="noticeId" name="id"/>
							有效时间：
						</td>
						<td style="width:80px"><input type="text" name="startDate" id="startDate" value="" size="20" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
						<td style="font-weight:bold;text-align:left;vertical-align:middle;width:30px">至</td>
						<td style="width:150px"><input type="text" name="endDate" id="endDate" value="" size="20" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}'});" /></td>						
					</tr>
					<tr>
						<td style="font-weight:bold;width:70px">标题：</td>
						<td colspan="3"><input required="true" id="mnTitle" name="mnTitle" type="text" size="72" /></td>						
					</tr>
					<tr>
						<td colspan="4" style="font-weight:bold;" width="100%">正文：</td>
					</tr>					
					<tr>						
						<td colspan="4" width="100%">
							<textarea style="width:675px;height:275px"  id="mnContent" name="mnContent"></textarea>	
						</td>						
					</tr>					
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a id="btnSave_" class="easyui-linkbutton" iconCls="icon-save" href="javascript:void(0)" onclick="saveNotice();">保存</a>
				<a id="btnPublish" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="publish();">发布</a> 
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">取消</a> 
			</div> 
		</div>
	</div>
	
	<% }else{ %>
	<div id="noticeWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="公告信息" style="width:720px;height:500px;">
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