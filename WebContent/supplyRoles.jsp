<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
	%>
	
	<title>设置供应商用户角色</title>	
	<style>
		.btn{
			text-align:center;
 			padding:0px;
 			vertical-align:middle;
 			line-height:22px;
 			margin:0px;  
		}
	</style>
	<script>
		$(function(){
			$('#supplyRoles').datagrid({
				title:'供应商用户列表',
				width: 650,
				nowrap: false,
				striped: true,
				collapsible:false,
				url:'JsonServlet',
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'supplyUsers',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '查询供应商用户',	 
							list:[{
								supid : '',
								supsgcode : User.sgcode,
								sutype : 'S'
							}]
						}
					)
				},
				singleSelect:true,
				remoteSort: true,
				fitColumns:true,
				loadMsg:'加载数据,请稍等...',
				fit:true,						
				columns:[[
					{field:'SUCODE',title:'用户编码',width:100,sortable:true,align:'center',
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editUserRole("' + rec.SUCODE + '");>' + rec.SUCODE + '</a>';
						}
					},
					{field:'SUNAME',title:'用户名称',width:240,sortable:true},						
					{field:'SUTYPE',title:'用户类型',width:120,sortable:true,
						formatter:function(value,rec){
							return '供应商用户';
						}
					},					
					{field:'HADROLES',title:'已分配角色',width:180,
						formatter:function(value,rec){							
							return '<select style="width:160" onclick=loadUserRoles(this,"' + rec.SUCODE + '");></select>';
						}
					}	
				]],				
				pagination:true				
			});	

		});	
		//查询供应商信息
		function search(){
			var searchData = getFormData( 'supplyRolesForm' );
			searchData['supsgcode'] = User.sgcode;
			searchData['sutype'] = 'S';
			
			//查询参数直接添加在queryParams中
		    $('#supplyRoles').datagrid('options').url = 'JsonServlet';        
			$('#supplyRoles').datagrid('options').queryParams = {
				data :obj2str(
						{		
							ACTION_TYPE : 'supplyUsers',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '查询供应商用户',	 
							list:[ searchData ]
						}
					)
			};        
			$("#supplyRoles").datagrid('reload');	
			$("#supplyRoles").datagrid('resize');	
		}		
		//加载供应商已赋角色信息
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
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }
	                    	 else{
	                    	 	$(list).append("<option value='none'>没有设置角色</option>");
	                    	 }
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取用户角色信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		//取消修改角色信息
		function cancelSupplyRole(){
			$('#supplyRolesWindow').window('close');
		}
		//清空表单中数据
		function clearsupplyRolesForm(){
			clearForm('supplyRolesForm');
		}
		//修改角色信息
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
								rltype : 'S'
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
								sucode : sucode,
								sgcode : User.sgcode,
								rltype : 'S'
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
			
			$('#supplyRolesWindow').window('open');
			$('#supplyRolesWindow').window('resize');
		}
		//保存修改后的角色信息
		function saveUserRole(){
			var userRoles = [];			
			$.each( $('#hadRoles option'), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
				userRoles.push({
					sgcode : $('#selSgcode').val(),
					sucode : $('#selSucode').val(),
					rlcode : $(this).val()
				});  
			});
			
			if( userRoles.length == 0 ){
				$.messager.alert('警告','每个用户至少需要分配一个角色！','warning');
				return;
			}
		
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
                    	$('#supplyRolesWindow').window('close');
                    }else{ 
                        $.messager.alert('提示','保存用户角色失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		/* 添加选择的项 */  
	    function Add(ObjSource, ObjTarget) {  
	       if(ObjSource.val() ==null) return;    // 如果没有选择则退出函数，无这句话的话IE6会报错  
	        $.each(ObjSource.find("option:selected"), function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
	            var html = "<option value='" + $(this).val() + "'>" + $(this).text() + "</option>";  
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
	<div title="设置供应商用户角色" id="supplyRolesForm" collapsible="true" minimizable="false" maximizable=false closable="false" style="width:800px;padding:10px;">
		<table style="line-height:20px; text-align:left; border:none; font-size:12px">	  		
	  		<tr>
	  			<td colspan="2" align="left" style="border:none; color:#4574a0;">设置供应商用户角色</td>
	  		</tr>
	  		<tr>
			    <td colspan="2" width="300" style="border:none;">
					供应商名称：<input type="text" id="supname" name="supname" value="" width="110" />
				</td>
			    
	  		</tr>
			<tr>
			    <td colspan="2" width="300" style="border:none;">
					供应商编码：<input type="text" id="supid" name="supid" value="" width="110" />
				</td>			    
			</tr>		  
			<tr>
				<td align="right" style="border:none; padding-right:85px;"><img src="images/sure.jpg" border="0" onclick="search();" /></td>
		    	<td align="right" style="border:none; padding-right:135px;"><img src="images/back.jpg"  border="0" onclick="clearsupplyRolesForm();" style="margin-left:40px;" /></td>
			</tr>
		</table>
	</div>		
	<div style="width:800px;height:360">	
		<table id="supplyRoles"></table>
	</div>	
	
	<div id="supplyRolesWindow" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="分配角色" style="width:850px;height:650px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;width:650px;height:420px;"> 
				<div  style="float:left;width: 200px;">
					<input id="selSucode" type="hidden" value=""/>
					<input id="selSgcode" type="hidden" value=""/>
					<div><b>已经拥有的角色</b></div>  
			        <select id="hadRoles" name="hadRoles" class="normal" multiple="multiple" style="width:100%;height: 160px;" ondblclick="Add($('#hadRoles'),$('#notRoles'));"> 
			        </select>  
			    </div>  
			    <div style="float:left;width:120px;">  
			        <input type="button" value="&gt;" class="btn" onclick="Add($('#hadRoles'),$('#notRoles'))" /><br>  
			        <input type="button" value="&gt;&gt;" class="btn" onclick="AddAll($('#hadRoles'),$('#notRoles'))" /><br>  
			        <input type="button" value="&lt;" class="btn" onclick="Add($('#notRoles'),$('#hadRoles'))" /><br>  
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
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSupplyRole();">取消</a> 
			</div> 
		</div>
	</div> 
</body>
</html>