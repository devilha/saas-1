<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>用户管理</title>	

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
				title:'用户管理',
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
							optContent : '查询用户',	 
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
					{field:'sucode',title:'用户编码',width:100,sortable:true,align:'center'}
				]],				
				columns:[[
					{field:'suname',title:'用户名称',width:240,sortable:true},					
					{field:'sutype',title:'用户类型',width:100,sortable:true,
						formatter:function(value,rec){
							if( value === 'L' )
								return '零售商';
							else if( value === 'S' )
								return '供应商';
						}
					},
					{field:'suenable',title:'启用',width:50,sortable:true,align:'center',
						formatter:function(value,rec){
							if( value === 'Y' ){
								return '<img src=themes/icons/ok.png>';
							}else{
								return '<img src=themes/icons/no.png>';
							}
								
						}
					},
					{field:'address',title:'地址',width:250},
					{field:'salemethod',title:'经营方式',width:150},
					{field:'fax',title:'传真',width:150},
					{field:'linkman',title:'联系人',width:150},
					{field:'linkmantel',title:'联系人电话',width:150},
					{field:'sumemo',title:'备注',width:250}		
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
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						search();
					}
				},{
					id:'btnAdd',
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},{
					id:'btnEdit',
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						edit();
					}
				},{
					id:'btnDelete',
					text:'删除',					
					iconCls:'icon-remove',
					handler:function(){
						remove();
					}
				},
				'-',
				{
					id:'btnRole',
					text:'分配角色',
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
			//查询参数直接添加在queryParams中
		    $('#userManager').datagrid('options').url = 'JsonServlet';        
			$('#userManager').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
						ACTION_MANAGER : 'userManager',
						optType : 'query',
						optContent : '查询用户',		 
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
					$.messager.alert('警告','请先选择一行记录！','warning');
					return;
				}
				/*
				if( rows.length > 1 ){
					$.messager.alert('警告','只能选择一行记录进行编辑！','warning');
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
                        $.messager.alert('提示','获取用户信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		
		function remove(){
			var rows = $('#userManager').datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
				return;
			}
			
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ sucode : rows[i].sucode }
				);
			}			
			
			$.messager.confirm('确认操作', '确认要删除选中的记录吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
									ACTION_MANAGER : 'userManager',
									optType : 'delete',
									optContent : '删除用户',
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('提示','删除成功！','info');
		                    	 $("#userManager").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除用户失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});				
						
		}
		
		function saveUser(){
			if( !checkForm( 'userManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
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
							optContent : isNew ? '新增用户':'修改用户',		 
							list:[searchData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存用户成功!','info');
                    	$("#userManager").datagrid('reload');
                    	cancel(); 
                    }else{ 
                        $.messager.alert('提示','保存用户失败!<br>原因：' + data.returnInfo,'error');
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
			/*
			if( rows.length > 1 ){
				$.messager.alert('警告','只能选择一行记录！','warning');
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
                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
					            $('#hadRoles').append(html);  
					        });
                    	 }
                    }else{ 
                        $.messager.alert('提示','获取用户角色信息失败!<br>原因：' + data.returnInfo,'error');
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
		
		function saveUserRole(){
		var getAllRows = $('#userManager').datagrid( 'getSelections' );//获取所有选中的用户编码
		
			var userRoles = [];	
				/*
			$.each( $('#hadRoles option'), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
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
			$.each( $('#hadRoles option'), function(j, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
			//alert($(this).val());
						userRoles.push({
										sgcode : getAllRows[i].sgcode,
										sucode : getAllRows[i].sucode,
										rlcode : $(this).val()
												});
										});
					}
				
			if( userRoles.length == 0 ){
				$.messager.alert('警告','每个用户至少需要分配一个角色！','warning');
				return;
			}
			/*
			if( userRoles.length > 1 ){
				$.messager.alert('警告','每个用户只能分配一个角色！','warning');
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
							optContent : '保存用户角色',	 
							list: userRoles
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
		
		function changeSup(){
		var supcode = $('#supcode').val();
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'changeUserExist',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysSurl',
							ACTION_MANAGER : 'userManager',	
							optType : 'select',
							optContent : '查询用户',	 
							list:[{
								sucode : supcode,
								sgcode : User.sgcode
							}]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '2' ){ 
                    	$.messager.alert('提示','该供应商已存在!','info');                    	
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
	<div id="userWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="用户信息" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="userManager_form" class="tableClass" style="font-size: 12px">
					<tr>
						<td>供应商编码：</td>
						<td><input required="true" id="supcode" name="supcode" type="text" onblur="changeSup();"/></td>
						<td>供应商名称：</td>
						<td><input name="suname" required="true" type="text"/></td>
					</tr>
					<tr>
						<td>供应商密码：</td>
						<td>
							<input type="hidden" id="editFlag" name="editFlag" value=""/>
							<input validType="safepass"  required="true" name="supwd" type="password" onkeydown="changeEditFlag();"/>
						</td>
						<td>供应商类型：</td>
						<td>
							<select id="sutype" name="sutype">
							    <option value="S" selected="selected">供应商</option>
							</select>						
						</td>
					</tr>
					<tr>
						<td>密码提示问题：</td>
						<td><input name="supwdq" type="text" required="true"/></td>
						<td>答案：</td>
						<td><input name="supwda" type="text" required="true"/></td>
					</tr>
					<tr>
						<td>名称缩写：</td>
						<td><input id="txtMobile" name="shortname" type="text" /></td>
						<td>经营方式：</td>
						<td>
							<select name="salemethod">
							    <option value="J">经销</option>
							    <option value="L">联营</option>
							    <option value="D">代销</option>
							    <option value="">其它</option>
							</select>
							启用：
							<input id="suenable" name="suenable" type="checkbox"/>							
						</td>
					</tr>
					<tr>
						<td>地区：</td>
						<td><input name="region" type="text" /></td>
						<td>手机：</td>
						<td><input name="mobile" class="easyui-numberbox" min="0" precision="0" /></td>						
					</tr>
					<tr>
						<td>面积：</td>
						<td><input name="area" class="easyui-numberbox" min="0" precision="2" /></td>
						<td>公司编码：</td>
						<td><input name="companycode" type="text" /></td>
					</tr>
					<tr>
						<td>邮编：</td>
						<td><input id="zipcode" name="zipcode" type="text"/></td>
						<td>行业：</td>
						<td><input name="industry" type="text"/></td>
					</tr>
					<tr>
						<td>传真：</td>
						<td><input id="fax" name="fax" type="text"/></td>
						<td>电子邮件：</td>
						<td><input id="email" name="email" type="text"/></td>
					</tr>					
					<tr>
						<td>银行：</td>
						<td><input id="bank" name="bank" type="text"/></td>
						<td>账户：</td>
						<td><input id="account" name="account" type="text"/></td>
					</tr>
					<tr>
						<td>年销售：</td>
						<td><input name="yearsale" class="easyui-numberbox" min="0" precision="2" /></td>
						<td>注册资金：</td>
						<td><input name="capital" class="easyui-numberbox" min="0" precision="2" /></td>
					</tr>
					<tr>
						<td>公司性质：</td>
						<td><input name="nature" type="text"/></td>
						<td>行业类别：</td>
						<td><input name="companycategory" type="text"/></td>
					</tr>
					<tr>
						<td>组织编码：</td>
						<td><input name="organizationcode" type="text"/></td>
						<td>法人：</td>
						<td><input id="legalperson" name="legalperson" type="text"/></td>
					</tr>
					<tr>
						<td>法人编码：</td>
						<td><input name="legalpersonid" type="text"/></td>
						<td>法人电话：</td>
						<td><input name="legalpersontel" class="easyui-numberbox" min="0" precision="0" /></td>
					</tr>
					<tr>
						<td>代理人：</td>
						<td><input name="agent" type="text"/></td>
						<td>代理人编码：</td>
						<td><input name="agentid" type="text"/></td>
					</tr>
					<tr>
						<td>联系人：</td>
						<td><input id="linkman" name="linkman" type="text"/></td>
						<td>联系人职位：</td>
						<td><input id="linkmanoffice" name="linkmanoffice" type="text"/></td>
					</tr>
					<tr>
						<td>联系人电话：</td>
						<td><input id="linkmantel" name="linkmantel" class="easyui-numberbox" min="0" precision="0"/></td>
						<td>销售面积：</td>
						<td><input name="salearea" class="easyui-numberbox" min="0" precision="2"/></td>
					</tr>
					<tr>
						<td>注册地址：</td>
						<td colspan="3"><input style="width:80%" name="regaddress" type="text"/></td>
					</tr>
					<tr>
						<td>地址：</td>
						<td colspan="3"><input style="width:80%" id="address" name="address" type="text"/></td>
					</tr>
					<tr>
						<td>备注：</td>
						<td colspan="3"> <textarea style="width:80%" name="memo"></textarea></td>
					</tr>					 
					<tr>
						<td>公司描述：</td>
						<td colspan="3"> <textarea style="width:80%" name="companydescrib"></textarea></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveUser();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel();">取消</a> 
			</div> 
		</div>
	</div>
	<div id="searchUser" class="easyui-window" iconCls="icon-search" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="查询用户" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;"> 
				<table id="userManager_form" class="tableClass">
					<tr>
						<td>用户编码：</td>
						<td><input name="sucode" type="text" /></td>						
					</tr>					
					<tr>
						<td>用户名称：</td>
						<td><input name="suname" type="text"/></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchUser();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">取消</a> 
			</div> 
		</div>
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