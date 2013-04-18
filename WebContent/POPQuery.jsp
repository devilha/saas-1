<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>优惠单查询</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sucode= currUser.getSucode();
	String suType = currUser.getSutype()+"";
%>
<script type="text/javascript">
	var now = new Date();
	now.setDate( now.getDate() - 7 );
	$("#startDate").val( now.format('yyyy-MM-dd') );
	$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
	
	$(function(){
		$('#POP').datagrid({
			width:1000,
			nowrap: false,
			striped: true,
			collapsible:true,
			url:'',		
			singleSelect: true,
			remoteSort: true,
			loadMsg:'加载数据...',				
			columns:[[
			    {field:'POPSEQUECE',title:'优惠单号',width:150,align:'center',sortable:true},
				{field:'PPLB',title:'促销类型',width:100,align:'center',sortable:true},
				{field:'PPMARKET',title:'门店编号',width:60,align:'center',sortable:true},
		    	{field:'SHPNAME',title:'门店名称',width:150,align:'center',sortable:true},
			    {field:'PPGDID',title:'商品编码',width:100,align:'center',sortable:true},				
			    {field:'PPBARCODE',title:'商品条码',width:150,sortable:true},
			    {field:'GDNAME',title:'商品名称',width:250,sortable:true},
			    {field:'PPSHRQ',title:'审核日期',width:100,sortable:true},
			    {field:'PPKSRQ',title:'开始日期',width:65,align:'center',sortable:true},
			    {field:'PPJSRQ',title:'结束日期',width:65,align:'center',sortable:true},
			    {field:'PPCXSJ',title:'促销售价',width:80,align:'center',sortable:true},
			    {field:'PPYSSJ',title:'原销售单价',width:80,align:'center',sortable:true}
				<%
				if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
					,{field:'PPSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:250,align:'center',sortable:true}
				<%}%>
			]],
			toolbar:[{
				text:'导出Excel',
				iconCls:'icon-redo',
				handler:function(){
					exportExcel();
				}
			}],
			pagination:true,
			rownumbers:true
		});
	});
        
	function reloadgrid ()  {
        $('#POP').datagrid('options').url = 'JsonServlet';        
		$('#POP').datagrid('options').queryParams = {
			data :obj2str(
				{		
					ACTION_TYPE : 'getPOP',
					ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
					ACTION_MANAGER : 'popQueryManager',	
					list:[{
						sgcode : User.sgcode,
						popsupcode : $('#supcodequery').val(),
						popgdid : $('#gdid').attr('value'),//商品编码
						popgdname : $('#gdname').attr('value'),//商品名称
						popmarket : $('#shopcode').attr('value'),// 门店编码
						startDate : $('#startDate').attr('value'),
						endDate : $('#endDate').attr('value')
					}]
				}
			)
		};		
		$("#POPdatagrid").show();
		$("#POP").datagrid('reload'); 
		$("#POP").datagrid('resize'); 
   	}   
 
   	function exportExcel(){ 
		$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'getPOP',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
							ACTION_MANAGER : 'popQueryManager',										 
							list:[{
								exportExcel : true,
								<%
								if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
								%>
								enTitle: ['POPSEQUECE','PPLB','PPMARKET','PPGDID','PPBARCODE','GDNAME','PPSHRQ','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ','PPSUPID','SUPNAME'],
								cnTitle: ['优惠单号','促销类型','门店编码','商品编码','商品条码','商品名称','审核日期','开始日期','金结束日期','促销售价','原销售单价','供应商编码','供应商名称'],
								<%}else{%>
								enTitle: ['POPSEQUECE','PPLB','PPMARKET','PPGDID','PPBARCODE','GDNAME','PPSHRQ','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ' ],
								cnTitle: ['优惠单号','促销类型','门店编码','商品编码','商品条码','商品名称','审核日期','开始日期','金结束日期','促销售价','原销售单价'],
								<%}%>
								sheetTitle: '商品优惠单查询',
								sgcode : User.sgcode,
								popsupcode : $('#supcodequery').val(),
								popgdid : $('#gdid').attr('value'),//商品编码
								popgdname : $('#gdname').attr('value'),//商品名称
								popmarket : $('#shopcode').attr('value'),// 门店编码 
								startDate : $('#startDate').attr('value'),
								endDate : $('#endDate').attr('value')
							}]
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
   //获取所有门店信息
	function loadAllShop( list ){
		if( $(list).attr('isLoad') == undefined ){
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.Shop',
							ACTION_MANAGER : 'shopManager',	
							list:[{									
								sgcode : User.sgcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
					            $(list).append(html);  
					        });						        
                    	 }	                    	 
                    	 $(list).attr('isLoad' , true );
                    }else{ 
                        $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );				
		}
	}

</script>
</head>
<body>
<center>
<table id="QueryTable" width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="6" align="left" style="border: none; color: #4574a0;">商品优惠单查询</td>
	</tr>
	<tr>
		<td align="right" width="100">门店：</td>
		<td align="left" width="230">
			<select style="width: 154px;" name='shopcode' id="shopcode" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
		<td align="right" width="100">起始日期：</td>
		<td align="left" width="230">
			<input type="text" id="startDate" name="startDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td align="right" width="100">结束日期：</td>
		<td align="left" width="240">
			<input type="text" id="endDate" name="endDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
	</tr>
	<tr>
		<td align="right" width="100">商品编码：</td>
		<td align="left" width="230"><input type="text" id="gdid" name="gdid" size="20"/></td>
		<td align="right" width="100">商品名称：</td>
		<td align="left" width="230"><input type="text" id="gdname" name="gdname" size="20"/></td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">供应商编码：</td>
		<td align="left" width="240" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="supcodequery" name="supcodequery" size="20" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>"/>
		</td>
	</tr>
	<tr>
	</tr>
	<tr>
		<td colspan="6"><img src="images/sure.jpg" border="0" onclick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="6" id="POPdatagrid"  style="display: none">
			<table id="POP"></table>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>