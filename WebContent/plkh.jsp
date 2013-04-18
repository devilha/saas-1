<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>批量开户</title>
<!-- 供应商用 -->
<%
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
			$('#supinfoSerachList').datagrid({	
			    title: '',	
				width: 1085,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				showFooter:true,				
				loadMsg:'加载数据...',				
				columns:[[
					{field:'select',checkbox:true},				
					{field:'SUPID',title:'供应商编码',width:80,align:'center'},
					{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true},
					{field:'SUPCONT',title:'联系人',width:100,align:'center',sortable:true},					
					{field:'SUPCONTPHONE',title:'联系人电话',width : 80,sortable:true,align:'center'},
					{field:'SUPCONTEMAIL',title:'联系人Email',width:80,align:'center',sortable:true},
					{field:'SUPDUTYNO',title:'企业税号',width:100,align:'center',sortable:true},
					{field:'SUPFAX',title:'传真',width:80,align:'center',sortable:true},
					{field:'SUPBANK',title:'开户行',width:100,align:'center',sortable:true},
					{field:'SUPZIP',title:'邮编',width:80,align:'center',sortable:true},
					{field:'SUPADD',title:'供应商地址',width:150,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true	
			});
			//加载角色信息
			$.post('JsonServlet',
				{
					data : obj2str({	
						ACTION_TYPE : 'getRoleInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'query',
						optContent : '查询角色信息',		 
						list : [{
							supsgcode : User.sgcode
						}]
					})
				},function(data){
					if(data.returnCode == '1' ){
                   	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                   	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
				            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
				            $("#selectionRole").append(html);  
				        });						        
                   	 }	                    	 
                   }else{ 
                   	  $.messager.alert('提示','获取角色信息失败!<br>原因：' + data.returnInfo,'error');
                   } 
				},
				'json'
			); 
			
			// 初始化验证框架
			$('#userinfo_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        }); 
		});
		 
		// 加载列表
		function reloadgrid()  { 
	        //查询参数直接添加在queryParams中
	        $('#supinfoSerachList').datagrid('options').url = 'JsonServlet';        
			$('#supinfoSerachList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'query',
						optContent : '查询未开户供应商信息',			 
						list:[{
							supsgcode : User.sgcode,
							supid : $("#supid").val(),
							supname : $("#supname").val()
						}]
					}
				)
			};        
			$('#showSupinfo').show(); // 显示数据显示层
			$("#supinfoSerachList").datagrid('reload');
			$("#supinfoSerachList").datagrid('resize'); 
    	}
    	
    	//  点击批量开户按钮，弹出批量开户填写信息框
    	function plkh(){
    		//获取选中记录
    		var rows = $('#supinfoSerachList').datagrid('getSelections');
    		if( rows.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
				return;
			}
			// 弹出添加用户信息
			$("#addUser").window('open');
    	}
    	
    	//批量添加用户信息
		function addUserInfo(){
			//验证用户输入是否合法
			if( !checkForm( 'userinfo_form' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
			//获取表单中数据
			var params = getFormData('userinfo_form');
			//获取选中记录
			var rows = $('#supinfoSerachList').datagrid('getSelections');
			var supids = "";
			$.each( rows, function(i, n) {    
				// 循环原列表中选中的供应商编码
				supids = supids + "'" +n.SUPID + "',";
			});
			supids = supids.substring(0 ,supids.length - 1);
			params['sgcode'] = User.sgcode;
			params['supcodes'] = supids;
			params['rlcode'] = $("#selectionRole").val();
			params['isSetMd'] = getRadioValue('userinfo_form');
			
			//批量开户
			$.post('JsonServlet',
				{
					data : obj2str({	
						ACTION_TYPE : 'plkh',
						ACTION_CLASS : 'com.bfuture.app.saas.model.Plkh',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'addUserinfo',
						optContent : '批量开户',		 
						list : [params]
					})
				},function(data){
					if(data.returnCode == '1' ){ 
						//重新加载还未开户的供应商信息
                    	$("#supinfoSerachList").datagrid('reload');
						$("#supinfoSerachList").datagrid('resize');
						// 关闭填写信息框
						cancel();
                    	$.messager.alert('提示','批量开户成功!','info');
                    }else{ 
                        $.messager.alert('提示','批量开户失败!<br>原因：' + data.returnInfo,'error');
                    } 
				},
				'json'
			); 	
		}
		
		// 关闭填写信息框
		function cancel(){
			$("#addUser").window('close');
		}
		//返回radio的值
		function getRadioValue(formId){
			var radioValue = "";
			if( formId ){
				$( '#' + formId + ' :radio' ).each(function () {
				    if ( $(this).attr('checked') ) {	
				    	radioValue = $(this).val();
				    }
				});
			}
			return radioValue;
		}
		
</script>

</head>

<body>

<!-- 查询条件区域开始 -->
	<table width="1085" align="center" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
	  <tr>
	    <td colspan="4" align="left" style="border:none; color:#33CCFF;">批量创建用户</td>
	  </tr>
	  <tr>
	    <td colspan="4">
	    	供应商编码：<input name="supid" type="text" id="supid" size="20" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	供应商名称：<input type="text" name="supname" id="supname" size="20"/>
	    </td>
	  </tr>
	  <tr>
	    <td colspan="4" style="border:none;">
	    	<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
	    	&nbsp;
	    	<a href="javascript:void(0);"><img src="images/qx.jpg" border="0" onclick="back();" style="margin-left:40px;" /></a>
	    </td>
	  </tr>
	  <tr>
	  	<td colspan="4" style="border:none;">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="4" style="border:none;">
	  		<!-- 表格列表开始  -->
			<div id="showSupinfo" style="margin-top:5px; width:1085px;display: none;">
			   	<div align="right" style="color:#33CCFF;">>>导出Excel表格</div>
				<table id="supinfoSerachList"></table><br/>
				<div align="right">
					<a href="javascript:void(0);"><img src="images/plkh.jpg" border="0" onclick="plkh();" style="margin-left:40px;" /></a>
				</div>
			</div> 
	  	</td>
	  </tr>
	</table>
<!-- 查询条件区域结束 -->

    
    <!-- 添加框start -->
	<div id="addUser" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="批量开户初始化数据" style="width:400px;height:300px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="userinfo_form" class="tableClass">
				  <tr>
				    <td colspan="2" style="font-size: 12px;"><span class="STYLE6">注：*为必填信息</span></td>
				  </tr>
				   <tr>
				    <td style="font-size: 12px;">初始化密码&nbsp;：</td>
				    <td>
				    	<input type="password" name="password" id="password" required="true" size="22" />
				    	<span class="STYLE6">*</span>
				    </td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">密码开始时间：</td>
					<td>
						<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}',minDate:'%y-%M-%d'});"size="20" />
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">密码结束时间：</td>
					<td>
						<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}'});" size="20" />
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">是否设置门店：</td>
					<td>
						<input type="radio" name="isSetMd" checked="checked" value="Y" />是
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="isSetMd" value="N" />否
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
				  	<td style="font-size: 12px;">角&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;色：</td>
					<td>
						<select id="selectionRole" name="selectionRole" style="width:140px;"></select>
						<span class="STYLE6" >*</span>
					</td>
				  </tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="addUserInfo();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('');">取消</a> 
			</div> 
		</div>
	</div>	
    
</body>
</html>
