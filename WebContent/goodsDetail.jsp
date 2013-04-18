<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品信息查询</title>
<%
	Object obj = session.getAttribute("LoginUser");
	if (obj == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	SysScmuser currUser = (SysScmuser) obj;
%>

<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">
	$(function(){
		$('#goodsdetail').datagrid({
			width: 1000,
			nowrap: false,
			striped: true,			
			collapsible:true,
			url:'',	 
			showFooter:true,	
			sortOrder: 'desc',
			singleSelect : true,
			remoteSort: true,
			fitColumns:false,
			loadMsg:'加载数据...',		
			columns:[[
			    {field:'GDID',title:'商品编码',width:70,align:'left',sortable:true},
				{field:'GDBARCODE',title:'销售条码',width:120,align:'left',sortable:true},
			    {field:'GDNAME',title:'商品名称',width:250,align:'left',sortable:true},
			    {field:'GDPPNAME',title:'品牌名称',width:85,align:'left',sortable:true},		    
			    {field:'GDSPEC',title:'规格',width:80,align:'left',sortable:true},
			    {field:'GDUNIT',title:'单位',width:45,align:'left',sortable:true},
			    {field:'GDTAX',title:'税率',width:45,align:'left',sortable:true},	
			    {field:'GDAREA',title:'产地',width:60,align:'left',sortable:true},
			    {field:'GDCATID',title:'类别编码',width:100,align:'left',sortable:true},
			    {field:'GDCATNAME',title:'类别名称',width:150,align:'left',sortable:true},				    	
			    {field:'TEMP1',title:'进价',width:60,align:'left',sortable:true,
			    	formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}
			    }	
			  	<%if ("L".equalsIgnoreCase(currUser.getSutype().toString())) {%>	
			    ,{field:'TEMP2',title:'售价',width:60,align:'left',sortable:true,
					formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}
				}
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
		//如果是零售商，就显示供应商输入框
		if(User.sutype == 'L'){
			$("#gssupidDiv").show();
			
		}else{
			$("#gssupidDiv").hide();
		}
	});	
		
	function reloadgrid ()  {
   		var supcode = '';
		if(User.sutype == 'L'){
			supcode = $('#supcode').val();
		}else {
			supcode = User.supcode;
		}  
        //查询参数直接添加在queryParams中
        $('#goodsdetail').datagrid('options').url = 'JsonServlet';        
		$('#goodsdetail').datagrid('options').queryParams = {
			data :obj2str(
				{		
					ACTION_TYPE : 'getDetail',
					ACTION_CLASS : 'com.bfuture.app.saas.model.InfGoods',
					ACTION_MANAGER : 'goods',		 
					list:[{
					 gdsgcode : User.sgcode,
					 supcode : supcode,
					 gdcatid : $('#catid').attr('value'),
					 gdcatname : $('#catname').attr('value'),
					 gdid : $('#gdid').attr('value'),
					 gdbarcode : $('#gdbarcode').attr('value'),
					 gdname : $('#gdname').attr('value')
					}]
				}
			)
		};		
		$("#goodsdetail").datagrid('reload'); 
		$("#goodsdetail").datagrid('resize');
		$("#goodsdetailTd").show();
   	}
	
	function exportExcel(){
   		var supcode = '';
		if(User.sutype == 'L'){
			supcode = $('#supcode').val();
		}else {
			supcode = User.supcode;
		}  
		$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'getDetail',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfGoods',
							ACTION_MANAGER : 'goods',											 
							list:[{
								exportExcel : true,
								<%if ("L".equalsIgnoreCase(currUser.getSutype().toString())) {%>
								enTitle: ['GDID','GDBARCODE','GDNAME','GDPPNAME','GDSPEC','GDUNIT','GDTAX','GDAREA','GDCATID','GDCATNAME','TEMP1','TEMP2'],
								cnTitle: ['商品编码','商品条码','商品名称','品牌名称','规格','单位','税率','产地','类别编码','类别名称','进价','售价'],
								<%} else {%>
								enTitle: ['GDID','GDBARCODE','GDNAME','GDPPNAME','GDSPEC','GDUNIT','GDTAX','GDAREA','GDCATID','GDCATNAME','TEMP1','TEMP2'],
								cnTitle: ['商品编码','商品条码','商品名称','品牌名称','规格','单位','税率','产地','类别编码','类别名称','进价','售价'],
								<%}%>
								sheetTitle: '商品明细查询',
								gdsgcode : User.sgcode,
								supcode : supcode,  
								gdcatid : $('#catid').attr('value'),
								gdcatname : $('#catname').attr('value'),
								gdid : $('#gdid').attr('value'),
					 			gdbarcode : $('#gdbarcode').attr('value'),
					 			gdname : $('#gdname').attr('value')
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
   	
   	function reset(){
   		$("#gdid").val('');
    	$("#gdbarcode").val('');
    	$("#gdname").val('');
    	$("#supcode").val('');
   	}
    	   
 	</script>
</head>
<body>
	<center>
		<!-- ---------- 查询条件输入区开始 ---------- -->
		<table width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
			<tr>
				<td colspan="4" align="left" style="border: none; color: #4574a0;">商品信息查询</td>
			</tr>
			<tr>
				<td width="250" style="border: none;">商品编码：<input type="text" id="gdid" name="gdid" value="" size="20" /></td>
				<td width="250" style="border: none;">商品名称：<input type="text" id="gdname" name="gdname" value="" size="20" /></td>
				<td width="250" style="border: none;">销售条码：<input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
				<td width="250" style="border: none;">&nbsp;</td>
			</tr>
			<tr>
				<td width="250" style="border: none;">类别编码：<input type="text" id="catid" name="catid" value="" size="20" /></td>
				<td width="250" style="border: none;">类别名称：<input type="text" id="catname" name="catname" value="" size="20" /></td>
				<td width="250" style="border: none;">
					<div id="gssupidDiv" style="">
						供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" />
					</div>
				</td>
				<td width="250" style="border: none;">&nbsp;</td>
			</tr>
			<tr>
				<td style="border: none;" colspan="4">
					<img src="images/sure.jpg" border="0" onclick="reloadgrid();" /> 
					<img src="images/back.jpg" border="0" onclick="reset();" />
				</td>
			</tr>
			<tr>
				<td id="goodsdetailTd" colspan="4" style="display: none;">
					<table id="goodsdetail"></table>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>