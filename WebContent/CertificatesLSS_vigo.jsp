<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="x-ua-compatible" content="ie=7"/ >
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>证照发布</title>
<!-- 零售商用 -->
<%
        //从浏览器获取参数
        String nameLSS =request.getParameter("name");
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
			$('#LicenceSearchLSSList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect :false,
				remoteSort: true,
				fitColumns:false,
				idField: 'ID',
				loadMsg:'加载数据...',
				columns:[[
						{field:'select',checkbox:true},
						{field:'CRT_BY_TIME',title:'上传时间',width:70,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'DEADLINE',title:'有效时间',width:70,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},
						{field:'SUPID',title:'供应商编号',width:70,sortable:true},
						{field:'SUPNAME',title:'供应商名称',width:100,sortable:true},
						{field:'LICENCE_NAME',title:'证件名称',width:193,sortable:true},
						{field:'MEMO',title:'证件备注',width:110,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'INS_C',title:'是否过期',width:60,sortable:true,
							formatter:function(value,rec){
								if( rec.DEADLINE != null && rec.DEADLINE.time != undefined ){
									if(new Date(rec.DEADLINE.time).format('yyyy-MM-dd') >= '<%=new SimpleDateFormat("yyyy-MM-dd").format(new Date())%>')
										return '否';
									else 
										return '是';
								}
							}
						},
						{field:'STATUS',title:'状态',width:50,sortable:true,
							formatter:function(value,rec){
								if( value == 0 )
									return '已提交'
								else if( value == 1)
									return '已审核'
								else 
									return '已驳回'
							}
						},
						{field:'REFUSE_MEMO',title:'驳回原因',width:90,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'ID',title:'操作',width:120,sortable:true,
							formatter:function(value,rec){
								if(rec.STATUS == '0'){
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + rec.URL + '");>查看</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=audit_cert("' + value + '","1");>审核</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=reject_cert("' + value + '");>驳回</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=window.location.href="CertDownServlet?picname='+ rec.URL +'">下载</a>';
								}else {
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + rec.URL + '");>查看</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=window.location.href="CertDownServlet?picname='+ rec.URL +'&sgocde=4005">下载</a>';
								}
								
							}
						}
				]],				
				pagination:true,
				rownumbers:true
				,toolbar:[{
					id:'btnDelete',
					text:'删除',					
					iconCls:'icon-remove',
					handler:function(){
						removeCert();
					}
				}
				]
			});
		  var nameLSS=$('#nameLSS').val();
		if(nameLSS==0){
		   reloadgrid();
		   }
		   $('#nameLSS').val('');
		}); // load end
		
		// 弹出模式窗口，查看图片
		function showPic(picurl){
	        //window.showModalDialog("imgpic.jsp?picurl=" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no");
			//window.showModalDialog("<=request.getContextPath() %>"+"/upload/" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // 本地机器测试使用
			window.showModalDialog("<%=Constants.HttpImgUrl %>" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // 服务器上使用
		}
		
		// 审核操作
		function audit_cert(id_temp,states_temp){
			
			$.messager.confirm('确认操作', '确认要审核通过吗?', function(r){
				if (r){ 
			
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'UpdInfLicence',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
								ACTION_MANAGER : 'InfLicenceManager',
								optType : 'update',
								optContent : '更改证件',		 
								list:[{
									id :id_temp, // 主键id
									status :states_temp, // 状态
									opt_by_c : User.sucode // 审核人
								}]
						})
						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){ 
	                    	$.messager.alert('提示','审核证件成功!','info');
	                    	
	                    	$('#LicenceSearchLSSList').datagrid('reload');
	                    	
	                    }else{ 
	                        $.messager.alert('提示','审核证件失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
            
            } });
		}
		
		// 弹出驳回框
		function reject_cert(id_temp){
			clearForm('certificatesManager_form'); // 清一下表单中之前的数据
			
			$('#id').attr('value',id_temp);
				
			$('#addCertificates').window('open');
		}
		
		// 添加框和编辑框的关闭
		function cancel(what){
			$(what).window('close');
		}
		 
		// 加载列表
		function reloadgrid()  {  
        	var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // 实例编码
			
			  var nameLSS=$('#nameLSS').val();
			  if(nameLSS!='')
		      searchData['status']=nameLSS;
		      else 
		      searchData['status']=$('#status').val();
        	
	        //查询参数直接添加在queryParams中
	        $('#LicenceSearchLSSList').datagrid('options').url = 'JsonServlet';        
			$('#LicenceSearchLSSList').datagrid('options').queryParams = {
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
			$("#LicenceSearchLSSList").datagrid('reload');
			$("#LicenceSearchLSSList").datagrid('resize'); 
        
    	}
    	
		// 重置查询条件输入框
		function searchReset(){
			$('#licence_name').val( '' ); 		// 证件名称
			$('#starttime_temp').val( '' ); 	// 起始日期
			$('#endtime_temp').val( '' ); 		// 结束日期
			$('#status').val( '' );				// 状态		
		}
		
		// 驳回操作
		function saveCertificates(){
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'UpdInfLicence',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
							ACTION_MANAGER : 'InfLicenceManager',
							optType : 'update',
							optContent : '更改证件',		 
							list:[{
								id :$('#id').val(), // 主键id
								status :'2', // 状态
								opt_by_c : User.sucode, // 审核人
								refuse_memo :$('#refuse_memo').val() // 驳回原因
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('提示','驳回证件成功!','info');
                    	
                    	$('#LicenceSearchLSSList').datagrid('reload');
                    	
                    	cancel('#addCertificates');  
                    	
                    }else{ 
                        $.messager.alert('提示','驳回证件失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		// 删除操作
		function removeCert(){
			var rows = $('#LicenceSearchLSSList').datagrid('getSelections'); // getSelected getSelections 
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
		                    	
		                    	$('#LicenceSearchLSSList').datagrid('reload');					// 重新加载列表
		                    	$('#LicenceSearchLSSList').datagrid('clearSelections'); 		// 清除之前选择的记录
		                    	
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
		function exportExcelLSS(){
		
			var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // 实例编码
			searchData['exportExcel'] = true; 
			searchData['enTitle'] = ['CRT_BY_TIME','DEADLINE','SUPID','SUPNAME','LICENCE_NAME','MEMO','DEADLINE','STATUS','REFUSE_MEMO' ];
			searchData['cnTitle'] = ['上传时间','有效时间','供应商编号','供应商名称','证件名称','证件备注','是否过期','状态','驳回原因'];
			searchData['sheetTitle'] = '证照管理';
		
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
		
</script>

</head>


<body>
<center>
<input type="hidden" name="nameLSS" id="nameLSS" value="<%=nameLSS %>"/>

<!-- 查询条件区域开始 -->
  <table width="1000" id="LicenceSearch" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
  <tr>
    <td colspan="3" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">我的工作</span>-&gt;证照管理</td>
  </tr>
  <tr>
    <td width="333" style="border:none;">证件名称：
      <input name="licence_name" type="text" id="licence_name" size="20" />
    </td>
    <td width="333" style="border:none;">起&nbsp;始&nbsp;日&nbsp;期&nbsp;：
      <input type="text" name="starttime_temp" id="starttime_temp" value="" size="20" onClick="WdatePicker();"/></td>
    <td width="333" style="border:none;">结束日期：
      <input type="text" name="endtime_temp" id="endtime_temp" value="" size="20" onClick="WdatePicker();"/></td>
  </tr>
  <tr>
    <td style="border:none;">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态：
      <select name="status" id="status" style="width:155px;">
          <option value="">--请选择--</option>
          <option value="0">已提交</option>
          <option value="1">已审核</option>
          <option value="2">已驳回</option>
      </select>
    </td>
    <td width="333" style="border:none;">供应商编号：
      <input type="text" name="supid" id="supid" value="" size="20" />
    </td>
    <td width="333" style="border:none;">商品条码：
    	<input type="text" name="gdbarcode" id="gdbarcode" value="" size="20" />
    </td>
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
   	  <div align="right" style="color:#33CCFF;"><a href="javascript:exportExcelLSS();">>>导出Excel表格</a></div>
	  <table id="LicenceSearchLSSList"></table>
      </div> 
      <!-- 表格列表结束 -->    
    </td>
  </tr>
</table>
<!-- 查询条件区域结束 -->

<!-- 驳回原因框start -->
	<div id="addCertificates" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="驳回操作" style="width:400px;height:300px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="certificatesManager_form" class="tableClass">
				  
				   <tr>
				    <td style="font-size: 12px;"></td>
				    <td><input type="hidden" name="id" id="id" /></td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">驳回原因：</td>
					<td>
					
					<textarea id="refuse_memo" name="refuse_memo" rows="11" cols="30"></textarea>
					
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
	<!-- 驳回原因框end -->
    
</center>
</body>
</html>
