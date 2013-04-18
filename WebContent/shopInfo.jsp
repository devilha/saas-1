<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<title>门店信息管理</title>	
	<script type="text/javascript" src="script/ajaxupload.3.5.js"></script>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	%>
	<script>
		var isNew = false; // 标记一条数据是否是新的
		
		$(function(){
			$('#dept').datagrid({
				width: 900,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:false,
				loadMsg:'加载数据...',			
				columns:[[					
					{field:'shopid',title:'门店编码',width:80,sortable:true},
					{field:'shopname',title:'门店名称',width:80,sortable:true},
					{field:'shopadd',title:'地址',width:280,sortable:true},
					{field:'shopcont',title:'联系人',width:60,sortable:true},
					{field:'shoptel',title:'电话',width:80,sortable:true},
					{field:'shopfax',title:'传真',width:80,sortable:true},
					{field:'shopmail',title:'邮箱',width:100,sortable:true},
					{field:'remarks',title:'备注',width:103,sortable:true}
				]],
				pagination:true,
				rownumbers:true
				
				<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
				,toolbar:[{
					id:'btnSearch',
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						search();
					}
				},'-',{
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
				}
				]
				
				<%
					}
				%>
				
			});
			reloadgrid();
			
			$('#deptManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });//must表单验证初始化
	        
	        // ===============
	        // 上传部分
	        uploadIt();
	        deleteFile();
	        
		});	// load end	
		
		function reloadgrid ()  {  
        
	        //查询参数直接添加在queryParams中
	        $('#dept').datagrid('options').url = 'JsonServlet';        
			$('#dept').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SeaShopInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
						ACTION_MANAGER : 'ShopInfoManager',		 
						list:[{
							sisgcode : User.sgcode
						}]
					}
				)
			};        
			$("#dept").datagrid('reload'); 
        
    	}
    	
    	function search(){
			$('#searchDept').window('open');
		}
		
		function cancelSearch(){
			$('#searchDept').window('close');
		}
		
		// 查询的方法
		function searchDept(){
			var searchData = getFormData( 'searchDept' );
			
			//查询参数直接添加在queryParams中
		    $('#dept').datagrid('options').url = 'JsonServlet';        
			$('#dept').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SeaShopInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
						ACTION_MANAGER : 'ShopInfoManager',		 
						list:[{
							 shopcode : $('#queryid').attr('value'),
							 shopname : $('#queryname').attr('value')
						}]
					}
				)
			};        
			$("#dept").datagrid('reload');				 
			
			cancelSearch();
		}
		
		// 弹出添加框
		function add(){			
			
			clearForm('deptManager_form');			
			$('#id').attr('disabled', '');// 设置部门编码可添加
			isNew = true;
			$('#addDept').window('open');
		}
		
		// 添加框和编辑框的关闭
		function cancel(what){
			$(what).window('close');
		}
		
		// 保存(添加或更改)
		function saveDept(){
		
			// 表单的验证
			if( !checkForm( 'deptManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
		
			var deptData = getFormData( 'deptManager_form' );
			deptData['sisgcode'] = User.sgcode;
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : isNew ? 'AddShopInfo' : 'UpShopInfo',
							ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
							ACTION_MANAGER : 'ShopInfoManager',
							optType : isNew ? 'add':'update',
							optContent : isNew ? '新增门店':'修改门店',		 
							list:[deptData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存门店成功!','info');
                    	
                    	$('#dept').datagrid('reload');
                    	
                    	cancel('#addDept');                    	
                    }else{ 
                        $.messager.alert('提示','保存门店失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		// 删除操作
		function remove(){
			var row = $('#dept').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			
			if( row.length > 1 ){
				$.messager.alert('警告','只能选择一行记录进行删除！','warning');
				return;
			}
			
			$.messager.confirm('确认操作', '确认要删除[ ' + row[0].shopname + ' ]部门吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'DelShopInfo',
									ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
									ACTION_MANAGER : 'ShopInfoManager',
									optType : 'delete',
									optContent : '删除门店',		 
									list: [
										{
											sisgcode : User.sgcode,
											shopcode : row[0].shopid
										}
									]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('提示','删除成功！','info');
		                    	$('#dept').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});		
			
						
		}
		
		// 弹出修改框 加载修改数据
		function edit(){			
			var row = $('#dept').datagrid('getSelections'); // getSelected
			clearForm('deptManager_form');
			
			if( row.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			
			if( row.length > 1 ){
				$.messager.alert('警告','只能选择一行记录进行编辑！','warning');
				return;
			}
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'SeaShopInfo',  //  deptload
							ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
							ACTION_MANAGER : 'ShopInfoManager',		 
							list:[{
								sisgcode : User.sgcode,
								shopcode : row[0].shopid
							}]
					})
					
				}, 
				function(data){
				
					// alert('data.rows.length : ' + data.rows.length)					
                
                    if( data.rows.length != undefined && data.rows.length > 0 ){
                    	var sm = data.rows[0];                    	
                    	fillForm('deptManager_form', sm);
                    	isNew = false;
                    	
                    	$('#shopcode').attr('value', sm['shopid']);
                    	$('#shopcode').attr('disabled', 'disabled');		// 设置部门编码不可编辑
                    					
						$('#addDept').window('open');						
                    	 
                    }else{
                        $.messager.alert('提示','没有获取到此门店的信息!','error');
                    }
                    
            	},
            	'json'
            );			
		}
		
		// 图片上传部分===============================================================
		// 保存图片事件
		function uploadIt() {
    		$(".uploadAndNext").click(function() {
				var uploadId = "#" + $(this).attr("id");
    			var btn = $(this);
    			new AjaxUpload( uploadId + "" , {
   					 	action : "UploadServletList.jsp" , 
	   					onChange: function(file, extension){
	   					
	   						// 图片类型的验证
	   						if(/^(jpg|png|jpeg|gif|bmp)$/.test(extension)){
	   							// 图片大小的验证
	   							// 这里暂时在服务器端验证
	   						}else {
	   							$.messager.alert('没有通过验证','文件类型不合法，请重新上传！','warning');
	   							return false;
	   						}
	   						
   							$(uploadId + "").parent().find("input")[0].value = file;
   					 		$(uploadId + "").parent().find(".uploadAndOkImg").show().attr("src" , "images/spinner.gif");
   					 		btn.attr("disabled" , "disabled");
   					 		
   					 		$("#pic").attr("disabled" , true); // 上传后屏蔽url文本框禁止编辑
   					 	},
   					 	
   					 	onComplete: function(file, response) {
							if(response != ''){ // 控制图片的大小
								$.messager.alert('没有通过验证','图片大小不能超过3M！','warning');
								
	   							// 重新加载一下本页面
	   							openUrl('shopInfo.jsp','Y',false);
	   							return false;
	   							
							}
							
							$(uploadId + "").parent().find(".uploadAndOkImg").attr("src" , "images/ok.gif");
							$(uploadId + "").parent().find(".deleteImg").attr("src" , "images/delete.gif").show();
							
							uploadIt();
							// deleteFile();
   					 	}
    			});
    		});
    	}
    	
    	// 删除图片事件
    	function deleteFile() {
    		$("#uploaddiv .deleteImg").click(function() {
	    			var fileName = $(this).parent().find("input").val();
	    			var thisObj = $(this);
	    			$.post("DeleteServletList.jsp" , {
	    				"fileName" : fileName
	    			},
	    				function(data) {
	    					thisObj.parent().remove();
	    					
	    					// 删除图片后再重新加载一下本页
	    					openUrl('shopInfo.jsp','Y',false);
	    					// uploadIt();
	    				}
	    			);
	    		});
    	}
		
	</script>
</head>
<body>
	
	<!-- 上传部分开始 -->
	<table width="900" style="line-height:20px; text-align:left; border:none;font-size: 12px;" align="center">
	  
	  <%
		 if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
	  %>
	  <tr>
	    <td colspan="3" align="left" style="border:none; color:#33CCFF;">门店分布管理</td>
	  </tr>
	  <tr>
	    <td width="333" style="border:none;"><span class="STYLE3">上传文件</span></td>
	    <td width="333" style="border:none;">&nbsp;</td>
	    <td width="333" style="border:none;">&nbsp;</td>
	  </tr>
  		<tr>
		   <td style="border:none;"><span class="STYLE4">注：上传文件最大容量为5M。</span></td>
		   <td style="border:none;">&nbsp;</td>
	    <td style="border:none;">&nbsp;</td>
	  </tr>
	  
	  <tr>
	    <td colspan="3" style="border:none;">    
	      	<div id="pictureManager_Form">
  				
  				<div id="uploaddiv">
	  				上传图片：<input type="text" id="pic" name="pic" required="true" /><span style="color:#FF0000">*</span>
	  				<button class="uploadAndNext" id="upload1">浏 览</button>
	  				<img src="" width="20px" height="20px" class="uploadAndOkImg" style="display: none"/>
	  				<img src="" width="20px" height="20px" class="deleteImg" style="display:none;cursor: pointer;" alt="删除"/><br/>
  				</div>
  				
  			</div>
	      </td>
	  </tr>
	  
	  <tr>
	    <td colspan="3" style="border:none;">&nbsp;</td>
	  </tr>
	  <% 
		 }else{
	  %>
	  <tr>
	    <td colspan="3" align="left" style="border:none; color:#33CCFF;">门店分布查看</td>
	  </tr>
	  <% 
		 }
	  %>
	  
	</table>
	<!-- 上传部分结束 -->
	
	<!-- 列表显示start -->
	<div align="center">
		<table id="dept"></table>
	</div>
	<!-- 列表显示end -->
	
	<!-- 查询条件框start -->
	<div id="searchDept" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="查询门店" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table class="tableClass">
					<tr>
						<td style="font-size: 12px;">门店编码：</td>
						<td><input id="queryid" name="queryid" type="text" /></td>						
					</tr>					
					<tr>
						<td style="font-size: 12px;">门店名称：</td>
						<td><input id="queryname" name="queryname" type="text"/></td>
					</tr>
				</table>
			</div> 
			
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchDept();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">取消</a> 
			</div>
			 
		</div>
	</div>
	<!-- 查询条件框end -->
	
	<!-- 添加框start -->
	<div id="addDept" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="门店信息" style="width:300px;height:340px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="deptManager_form" class="tableClass">
					<tr>
						<td style="font-size: 12px;">门店编号：</td>
						<td><input id="shopcode" name="shopcode" type="text" required="true"/></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">门店名称：</td>
						<td><input id="shopname" name="shopname" type="text" required="true"/></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">地址：</td>
						<td><input id="shopadd" name="shopadd" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">联系人：</td>
						<td><input id="shopcont" name="shopcont" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">电话：</td>
						<td><input id="shoptel" name="shoptel" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">传真：</td>
						<td><input id="shopfax" name="shopfax" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">邮箱：</td>
						<td><input id="shopmail" name="shopmail" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">备注：</td>
						<td><input id="remarks" name="remarks" type="text" /></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveDept();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addDept');">取消</a> 
			</div> 
		</div>
	</div>	
	<!-- 添加框end -->
	
</body>
</html>