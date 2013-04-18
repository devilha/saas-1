<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="x-ua-compatible" content="ie=7"/ >
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>证照发布查询</title>
<!-- 供应商用 -->
<%     
       //从浏览器获取参数
        String nameURL =request.getParameter("name");
      
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;		
	%>
<style type="text/css">

.STYLE2 {color: #FFFFFF}
.STYLE3 {
	font-size: 18px;
	font-weight: bold;
}
.STYLE6 {color: #FF0000}
.STYLE4 {color: #3399FF}
.STYLE7 {color: #00FFFF}
</style>

<script>
		$(function(){
			// 填充列表
			$('#LicenceSearchGYSList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect : false,
				remoteSort: true,
				fitColumns:false,
				idField: 'ID',
				loadMsg:'加载数据...',
				columns:[[
						{field:'select',checkbox:true},
						{field:'CRT_BY_TIME',title:'上传时间',width:90,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'DEADLINE',title:'有效时间',width:100,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},
						{field:'LICENCE_NAME',title:'证件名称',width:220,sortable:true},
						{field:'MEMO',title:'证件备注',width:150,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'ID',title:'是否过期',width:100,sortable:true,
							formatter:function(value,rec){
								if( rec.DEADLINE != null && rec.DEADLINE.time != undefined ){
									if(new Date(rec.DEADLINE.time).format('yyyy-MM-dd') >= '<%=new SimpleDateFormat("yyyy-MM-dd").format(new Date())%>')
										return '否';
									else 
										return '是';
								}
							}
						},
						{field:'STATUS',title:'状态',width:100,sortable:true,
							formatter:function(value,rec){
								if( value == 0 )
									return '已提交'
								else if( value == 1 )
									return '已审核'
								else
									return '已驳回'
							}
						},
						{field:'REFUSE_MEMO',title:'驳回原因',width:100,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'URL',title:'操作',width:76,sortable:true,
							formatter:function(value,rec){
								return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + value + '","'+rec.ID+'");>查看</a>';
							}
						}
				]],				
				pagination:true,
				rownumbers:true
				,toolbar:[{
					id:'btnAdd',
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},'-',{
					id:'btnDelete',
					text:'删除',					
					iconCls:'icon-remove',
					handler:function(){
						removeCert();
					}
				}
				]
			});
			
			
			$('#certificatesManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });//must表单验证初始化
	        
	        // ===============
	        // 上传部分
	        uploadIt();
	        deleteFile();
	        var nameURL=$('#nameURL').val();
	        if(nameURL==2 ){	
		    reloadgrid();
		    }
		    $('#nameURL').val('');
	        
		}); // load end   
		
		// 弹出模式窗口才，查看图片
		function showPic(picurl,id){

	        // window.showModalDialog("imgpic.jsp?picurl=" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no");
            window.showModalDialog("<%=Constants.HttpImgUrl %>" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // 服务器上使用
			//window.showModalDialog("<=request.getContextPath() %>"+"/upload/" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // 本机机器测试使用
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'updateViewStatus',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
						    ACTION_MANAGER : 'InfLicenceManager',	 
							list:[{
								id : id
							}]
					})
				},
            	'json'
            );
		}

		// 加载列表
		function reloadgrid()  {  
        	var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // 实例编码
			searchData['supid'] = User.supcode; // 供应商编码
				var nameURL=$('#nameURL').val();
			
	     if(nameURL!=''){
		 searchData['status']=nameURL;
		 searchData['view_status']='is null';
		 }else{ 
		 searchData['status']=$('#status').val();
		}
		
	        //查询参数直接添加在queryParams中
	        $('#LicenceSearchGYSList').datagrid('options').url = 'JsonServlet';        
			$('#LicenceSearchGYSList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchInfLicence',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
						ACTION_MANAGER : 'InfLicenceManager',
						optType : 'query',
						optContent : '查询证件',			 
						list:[searchData]
					}
				)
			};        
			$('#showLicence').show(); // 显示数据显示层
			$("#LicenceSearchGYSList").datagrid('reload');
			$("#LicenceSearchGYSList").datagrid('resize'); 
        
    	}
    	
    	// 弹出添加框
		function add(){			
			clearForm('certificatesManager_form'); // 清一下表单中之前的数据
				
			// $('#url').val(''); // 这里需要单独清一下，上传附件框
			$('#upload1').attr('disabled' , ''); // 让上传按钮可用hou add
			
			$(".uploadAndOkImg").hide(); // hou add
			$(".deleteImg").hide(); // hou add
							
			$('#addCertificates').window('open');
		}
		
		// 添加框和编辑框的关闭
		function cancel(what){
			$(what).window('close');
		}
		
		// 重置查询条件输入框
		function searchReset(){
			$('#licence_name').val( '' ); 		// 证件名称
			$('#starttime_temp').val( '' ); 	// 起始日期
			$('#endtime_temp').val( '' ); 		// 结束日期
			$('#status').val( '' );				// 状态		
		}
		
		// 保存(添加)
		function saveCertificates(){
		
			// 表单的验证
			if( !checkForm( 'certificatesManager_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
		
			var certificatesData = getFormData( 'certificatesManager_form' );
				certificatesData['ins_c'] = User.sgcode; 	// 实例编码
				certificatesData['supid'] = User.supcode; 	// 供应商编码
				certificatesData['supname'] = User.suname; 	// 供应商名称
				certificatesData['crt_by_c'] = User.sucode; // 上传人
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'AddInfLicence',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
							ACTION_MANAGER : 'InfLicenceManager',
							optType : 'add',
							optContent : '新增证件',		 
							list:[certificatesData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','保存证件成功!','info');
                    	
                    	$('#LicenceSearchGYSList').datagrid('reload');
                    	
                    	cancel('#addCertificates');                    	
                    }else{ 
                        $.messager.alert('提示','保存证件失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		// 删除操作
		function removeCert(){
			var rows = $('#LicenceSearchGYSList').datagrid('getSelections'); // getSelected getSelections 
			if( rows.length == 0 ){
				$.messager.alert('警告','请先至少选择一行记录！','warning');
				return;				
			}
			
			// 下面是一个循环的填充操作
			var certlist = [];
			for(var i = 0;i < rows.length;i++){
				certlist.push({ id : rows[i].ID });
				
				if( rows[i].STATUS == '1'){ // 1=已审核
					$.messager.alert('警告','[' + rows[i].LICENCE_NAME + ']已审核不能删除！','warning');
					return;
				}
				if( rows[i].STATUS == '2'){ // 2=已驳回
					$.messager.alert('警告','[' + rows[i].LICENCE_NAME + ']已驳回不能删除！','warning');
					return;
				}
			}
			
			$.messager.confirm('确认操作', '确认要删除这' + rows.length + '条数据吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'DelInfLicence',
									ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
									ACTION_MANAGER : 'InfLicenceManager',
									optType : 'delete',
									optContent : '删除证件',		 
									list: certlist
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('提示','删除成功！','info');
		                    	
		                    	$('#LicenceSearchGYSList').datagrid('reload');	// 重新加载列表
		                    	$('#LicenceSearchGYSList').datagrid('clearSelections'); 		// 清除之前选择的记录
		                    	
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});	
		}
		
		// excel导出
		function exportExcelGYS(){
		
			var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // 实例编码
			searchData['supid'] = User.supcode; // 供应商编码
			searchData['exportExcel'] = true; 
			searchData['enTitle'] = ['CRT_BY_TIME','DEADLINE','LICENCE_NAME','MEMO','DEADLINE','STATUS','REFUSE_MEMO' ];
			searchData['cnTitle'] = ['上传时间','有效时间','证件名称','证件备注','是否过期','状态','驳回原因'];
			searchData['sheetTitle'] = '证照发布';
		
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'SearchInfLicence',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
								ACTION_MANAGER : 'InfLicenceManager',											 
								list:[searchData]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	location.href = data.returnInfo;	                    	 
	                    }else{ 
	                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		} 
		
		// 图片上传部分===============================================================
		// 保存图片事件
		function uploadIt() {
    		//$(".uploadAndNext").click(function() {
    			var uploadId = "#" + $("#upload1").attr("id");
				//var uploadId = "#" + $(this).attr("id");
    			//var btn = $(this);
    			var btn = $("#upload1");
    			new AjaxUpload( uploadId + "" , {
   					 	action : "CertificatesUpl.jsp" , 
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
   					 		$("#url").attr("disabled" , true); // 上传后屏蔽url文本框禁止编辑
   					 	},   					 	
   					 	onComplete: function(file, response) {
							if(response != ''){ // 控制图片的大小
								$.messager.alert('没有通过验证','图片大小不能超过3M！','warning');
								
	   							// 重新加载一下本页面
	   							openUrl('CertificatesGYS_vigo.jsp','Y',false);
	   							return false;
	   							
							}
							
							$(uploadId + "").parent().find(".uploadAndOkImg").attr("src" , "images/ok.gif");
							$(uploadId + "").parent().find(".deleteImg").attr("src" , "images/delete.gif").show();
							
							//uploadIt();
							// deleteFile();
   					 	}
    			});
    		//});
    	}
    	
    	// 删除图片事件
    	function deleteFile() {
    		$("#uploaddiv .deleteImg").click(function() {
	    			var fileName = $(this).parent().find("input").val();
	    			var thisObj = $(this);
	    			$.post("CertificatesDel.jsp" , {
	    				"fileName" : fileName
	    			},
	    				function(data) {
	    					// thisObj.parent().remove(); // 这里试着用隐藏，不用删除
	    					// thisObj.parent().hide();
	    					
	    					$("#url").attr("value" ,''); // 清空url文本框
	    					$("#url").attr("disabled" , true ); // 让url文本框可编辑
	    					$('#upload1').attr('disabled' , ''); // 让上传按钮可用hou add
							$(".uploadAndOkImg").hide(); // hou add
							$(".deleteImg").hide(); // hou add
	    					
	    					// add();
	    					// 删除图片后再重新加载一下本页
	    					// openUrl('CertificatesGYS.jsp','Y',false);
	    					// uploadIt();
	    				}
	    			);
	    		});
    	}

</script>

</head>


<body>
<center>
<input type="hidden" name="nameURL" id="nameURL" value="<%=nameURL %>"/>

<!-- 查询条件区域开始 -->
  <table width="1000" id="LicenceSearch" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
  <tr>
    <td colspan="3" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">我的工作</span>-&gt;证书管理</td>
  </tr>
  <tr>
    <td width="333" style="border:none;">证件名称：
      <input name="licence_name" type="text" id="licence_name" size="20" />
    </td>
    <td width="333" style="border:none;">起始日期：
      <input type="text" name="starttime_temp" id="starttime_temp" value="" size="20" onClick="WdatePicker();"/></td>
    <td width="333" style="border:none;">结束日期：
      <input type="text" name="endtime_temp" id="endtime_temp" value="" size="20" onClick="WdatePicker();"/></td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态：
      <select name="status" id="status" style="width: 155px;">
          <option value="">--请选择--</option>
          <option value="0">已提交</option>
          <option value="1">已审核</option>
          <option value="2">已驳回</option>
      </select></td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">
    	<div align="left">
    		<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
    		<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onclick="searchReset();" style="margin-left:40px;" /></a>
    	</div>
    </td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">
     <!-- 表格列表开始 -->
     <div id="showLicence" style="display: none;">
   	    <div id="excel" align="right" style="color:#33CCFF;"><a href="javascript:exportExcelGYS();">>>导出Excel表格</a></div>
	    <table id="LicenceSearchGYSList"></table>
     </div> 
     <!-- 表格列表结束 -->    
    </td>
  </tr>
</table>
<!-- 查询条件区域结束 -->
    
    <!-- 添加框start -->
	<div id="addCertificates" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="证件发布" style="width:400px;height:400px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="certificatesManager_form" class="tableClass">
				  <tr>
				    <td colspan="2" style="font-size: 12px;"><span class="STYLE6">注：*为必填信息</span></td>
				  </tr>
				  
				   <tr>
				    <td style="font-size: 12px;">证件名称：</td>
				    <td><input type="text" name="licence_name" id="licence_name" required="true"/><span class="STYLE6">*</span></td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">有效期：</td>
					<td><input type="text" name="deadline_temp" id="deadline_temp" required="true" onClick="WdatePicker();"/><span class="STYLE6">*</span></td>
				  </tr>
				  
				  <!-- 图片上传区开始 -->
				  <tr>
				    <td colspan="2" style="font-size: 12px;">
				    	<!-- 上传附件：&nbsp;&nbsp;&nbsp;      
				      		<input type="file" name="url" id="url" />
				      		<span class="STYLE6">*</span>&nbsp;&nbsp;&nbsp;&nbsp;
				       -->
				       <div id="uploaddiv">
			  				上传图片：&nbsp;&nbsp;<input type="text" id="url" name="url" required="true" /><span style="color:#FF0000">*</span>
			  				<!--<button class="uploadAndNext" id="upload1">浏 览</button> -->
			  				<input type="button" id="upload1" value="浏 览" />&nbsp;&nbsp; 
			  				<img src="" width="20px" height="20px" class="uploadAndOkImg" style="display: none"/>
			  				<img src="" width="20px" height="20px" class="deleteImg" style="display:none;cursor: pointer;" alt="删除"/><br/>
  					  </div>
				      
				    </td>
				  </tr>
				  <!-- 图片上传区结束 -->
				  
				  <tr>
				    <td>&nbsp;</td>
				    <td style="font-size: 12px;">注：上传的文件最大容量为5M。</td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">备注：</td>
					<td>
					
					<textarea id="memo" name="memo" rows="10" cols="20"></textarea>
					
					</td>
				  </tr>
				  
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveCertificates();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addCertificates');">取消</a> 
			</div> 
		</div>
	</div>	
	<!-- 添加框end -->
</center>
</body>
</html>
