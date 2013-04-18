<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>批量开户</title>	

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
				title:'需要开户的供应商列表',
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
							ACTION_TYPE : 'getBatchOpenUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',	
							list:[{
								sgcode : User.sgcode
							}]
						}
					)
				},   
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:false,
				loadMsg:'加载数据,请稍等...',
				fit:true,
				frozenColumns:[[
					{field:'select',checkbox:true},
					{field:'SUCODE',title:'用户编码',width:100,sortable:true,align:'center'}
				]],				
				columns:[[
					{field:'SUPID',title:'供应商编码',width:240,sortable:true},
					{field:'SUNAME',title:'供应商名称',width:240,sortable:true},					
					{field:'SUTYPE',title:'用户类型',width:100,sortable:true,
						formatter:function(value,rec){
							if( value === 'L' )
								return '零售商';
							else if( value === 'S' )
								return '供应商';
						}
					},
					{field:'SUENABLE',title:'启用',width:50,sortable:true,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' ){
								return '<img src=themes/icons/ok.png>';
							}else{
								return '<img src=themes/icons/no.png>';
							}
								
						}
					},
					{field:'ADDRESS',title:'地址',width:250},
					{field:'SALEMETHOD',title:'经营方式',width:150},
					{field:'FAX',title:'传真',width:150},
					{field:'LINKMAN',title:'联系人',width:150},
					{field:'LINKMANTEL',title:'联系人电话',width:150},
					{field:'SUMEMO',title:'备注',width:250}		
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
				toolbar:[{
					id:'btnRole',
					text:'批量开户',
					iconCls:'icon-redo',
					handler:function(){
						batchAddUser();
					}
				},{
					id:'btnRole',
					text:'分配角色',
					iconCls:'icon-redo',
					handler:function(){
						editUserRole();
					}
				}]
			});					

		});	
		
		
		function batchAddUser(){
			var rows = $('#userManager').datagrid('getSelections');
			if(rows.length==0){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return ;
			}
			var sgcode = rows[0].SGCODE;
			var sucode = rows[0].SUCODE;
			var supidList = "";
			for(var i = 0 ; i<rows.length ; i++){
				supidList += rows[i].SUPID + ",";
			}
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUserList',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[{
								sgcode : sgcode,
								sucode : sucode,
								supcode : supidList
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','批量开户成功','info');
                    }else{ 
                        $.messager.alert('提示','获取用户角色信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
		}
		
		function editUserRole(){
			var data;			
			var rows = $('#userManager').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;
			}
			data = rows[0];
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'notRoles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',		 
							list:[{
								sgcode : data.SGCODE
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows ){
                    	 	$('#notRoles').empty();
                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
					            $('#notRoles').append(html);  
					        });
                    	 }
                    }else{ 
                        $.messager.alert('提示','获取用户角色信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
			
			$('#userRoles').window('open');
		}
		
		
			
		
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
		
		
		
		function saveUserRole(){
			var getAllRows = $('#userManager').datagrid( 'getSelections' );//获取所有选中的用户编码	
			var userRoles = [];
				$.each( $('#hadRoles option'), function(j, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					userRoles.push({
						rlcode : $(this).val()
					});
				});
			if( userRoles.length == 0 ){
				$.messager.alert('警告','每个用户至少需要分配一个角色！','warning');
				return;
			}
			if( userRoles.length > 1 ){
				$.messager.alert('警告','每个用户只能分配一个角色！','warning');
				return;
			}
			var sgcode = getAllRows[0].SGCODE;
			var sucodeList = "";
			for(var i = 0 ; i<getAllRows.length ; i++){
				sucodeList += getAllRows[i].SUCODE + ",";
			}
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveBatchOpenUserRole',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	 
							list:[{
								sgcode : sgcode,
								sucode : sucodeList,
								rlcode : userRoles[0].rlcode
							}]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','分配角色成功!','info');                    	
                    	cancelUserRole(); 
                    }else{ 
                        $.messager.alert('提示','保存用户角色失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		function addDragDrop( src, tar ){
			src.draggable({
				revert:true,
				deltaX:10,
				deltaY:10,
				proxy:function(source){
					var proxyHtml = $('<div class="proxy"><table></table></div>');
					var html = '';					
					$.each( src.find("option:selected"), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
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
					$.each( src.find("option:selected"), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
			        	var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";
			        	tar.append( html );	
			        });					
					src.find("option:selected").remove();									
				}
			});	
		}
		
		/* 添加选择的项 */  
	    function Add(ObjSource, ObjTarget) {  
	       if(ObjSource.val() ==null) return;    // 如果没有选择则退出函数，无这句话的话IE6会报错  
	        $.each(ObjSource.find("option:selected"), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
	            var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";  
	            ObjSource.append(ObjTarget.html());
	            ObjTarget.empty();
	            ObjTarget.append(html);  
	        });  
	        ObjSource.find("option:selected").remove();  // 原列表中选中的值删除  
	    }  
	    
	    /* 添加全部 */  
	    function AddAll(ObjSource, ObjTarget) {  
	        ObjTarget.append(ObjSource.html());  // 目标列表的HTML加上原列表的所有HTML  
	        ObjSource.empty();  // 原列表清空  
	    }
		
	</script>
</head>
<body>	
	<div style="width:800px;height:560">	
		<table id="userManager"></table>
	</div>

	<div id="userRoles" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="分配角色" style="width:560px;height:360px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<div  style="float:left;width: 200px;">
					<input id="selSucode" type="hidden" value=""/>
					<input id="selSgcode" type="hidden" value=""/>
					<div><b>已经拥有的角色</b></div>  
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
			    	<div><b>没有分配的角色</b></div>  
			        <select id="notRoles" name="notRoles" class="normal" multiple="multiple" style="width:100%;height: 160px;" ondblclick="Add($('#notRoles'),$('#hadRoles'));">  
			        </select>  
			    </div>  
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveUserRole();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelUserRole();">取消</a> 
			</div> 
		</div>
	</div>
</body>
</html>