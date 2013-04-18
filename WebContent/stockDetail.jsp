<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品库存明细查询</title>
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}		
	SysScmuser currUser = (SysScmuser)obj;
	String suType = currUser.getSutype() + "" ;
%>
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">
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
  
	$(function(){
		$('#stockDetail').datagrid({
			width: 1000,
			iconCls:'icon-save',
			nowrap: false,
			striped: true,
			collapsible:true,
			url:'',
			sortOrder: 'desc',
			remoteSort: true,	
			singleSelect : true,
			fitColumns:false,
			showFooter:true,	
			loadMsg:'加载数据...',				
			columns:[[
				{field:'ZSGXTIME',title:'库存统计日期',width:80,align:'center',sortable:true,
					   formatter:function(value,rec){
						if( value != null && value != undefined && value != '合计：' )
							return new Date(value.time).format('yyyy-MM-dd');
							else 
							return value;
					}
				},
				{field:'ZSMFID',title:'门店编码',width:60,align:'center',sortable:true}, 
				{field:'SHPNAME',title:'门店名称',width:160,align:'left',sortable:true},
				{field:'ZSGDID',title:'商品编码',width:60,align:'center',sortable:true},
				{field:'ZSBARCODE',title:'商品条码',width:100,align:'center',sortable:true},
				{field:'GDNAME',title:'商品名称',width:250,align:'left',sortable:true},
				{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true},
				{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true},
				{field:'GDSPEC',title:'规格',width:45,align:'center',sortable:true},
				{field:'GDUNIT',title:'单位',width:45,align:'center',sortable:true}
				<%if("L".equals(suType)){%>
				,{field:'ZSSUPID',title:'供应商编码',width:70,align:'center',sortable:true},	
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
	        $('#stockDetail').datagrid('options').url = 'JsonServlet';        
			$('#stockDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'ywZrstockDetails',		 
						optType : 'query',
						optContent : '昨日库存商品明细查询',		 
						list:[{
						 sgcode : User.sgcode,
						 supcode : $('#supcode').val(),
						 zsmfid : $('#zsmfid').attr('value'),
						 zsgdid : $('#zsgdid').attr('value'),
						 zsgdname : $('#zsgdname').attr('value'),
						 gdbarcode :$('#gdbarcode').attr('value')
						}]
					}
				)
			};		
			
			$("#stockDetailList").show();
			$("#stockDetail").datagrid('reload'); 
			$("#stockDetail").datagrid('resize'); 
    	}
    	function exportExcel(){
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
								ACTION_MANAGER : 'ywZrstockDetails',											 
								list:[{
									exportExcel : true,
									<%if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
									enTitle: ['ZSGXTIME','ZSMFID','SHPNAME','ZSGDID','ZSBARCODE','GDNAME','GDSPEC','GDUNIT','ZSSUPID','SUPNAME','ZSKCSL','ZSKCJE' ],
									cnTitle: ['库存统计日期','门店编号','门店名称','商品编码','商品条码','商品名称','规格','单位','供应商编码','供应商名称','库存数量','库存金额(不含税)'],
									<%}else{%>
									enTitle: ['ZSGXTIME','ZSMFID','SHPNAME','ZSGDID','ZSBARCODE','GDNAME','GDSPEC','GDUNIT','ZSKCSL','ZSKCJE' ],
									cnTitle: ['库存统计日期','门店编号','门店名称','商品编码','商品条码','商品名称','规格','单位','库存数量','库存金额(不含税)'],
									<%}%>
									sheetTitle: '昨日库存商品明细查询',
									sgcode : User.sgcode,
									supcode : $('#supcode').val(),
									zsmfid : $('#zsmfid').attr('value'),
									zsgdid : $('#zsgdid').attr('value'),
									zsgdname : $('#zsgdname').attr('value')
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
 	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="6" align="left" style="border: none; color: #4574a0;">昨日库存商品明细查询</td>
	</tr>
	<tr>
		<td align="right" width="100">门店：</td>
		<td align="left" width="230">
			<select style="width: 155px;" name='zsmfid' id="zsmfid" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
		<td align="right" width="100">商品名称：</td>
		<td align="left" width="230">
			<input type="text" id="zsgdname" name="zsgdname" value="" size="20"/>
		</td>
		<td align="right" width="100">商品编码：</td>
		<td align="left" width="240"><input type="text" id="zsgdid" name="zsgdid" value="" size="20"/></td>
	</tr>
	<tr>
		<td align="right" width="100">商品条码：</td>
		<td align="left" width="230"><input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">供应商编码：</td>
		<td align="left" width="230" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="supcode" name="supcode" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>" size="20" />
		</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="240">&nbsp;</td>
	</tr>
	<tr>
	<td colspan="6">
		<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />     
	</tr>
	<tr>
		<td colspan="6" id="stockDetailList" style="display: none;">
			<table id="stockDetail" ></table>
		</td>
	</tr>	
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("zsmfid");
loadAllShop(obj);
</script>
</html>