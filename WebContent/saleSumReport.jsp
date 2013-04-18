<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
		//获得经营方式
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>

<title>销售汇总查询</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script>	 
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'))
	    
	    function reloadItemStockgrid (zsgdid,SUPID)  {
    		//根据用户是供应商还是零售商，获取供应商编码 
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
	        //查询参数直接添加在queryParams中
	        $('#itemStockList').datagrid('options').url = 'JsonServlet';   
			$('#itemStockList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsDetailStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').val(),	// 起始时间
							endDate : $('#endDate').val(), 		// 结束时间
							zsmfid : $('#gsmfid').val(),	
							zsgdid : zsgdid					
						}]
					}
				)
			}; 
			$("#saledatagrid").hide();		
			$("#stockdatagrid").show();		
			$("#itemStockList").datagrid('reload');  
			$("#itemStockList").datagrid('resize');   
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
		
		$(function(){
			$('#saleShopSummary').datagrid({	
			    title: '',	
				width: User.sutype == 'L' ? 836 : 836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'加载数据...',			
				columns:[[
					{field:'GDBARCODE',title:'商品条码',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '合计'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
				    },
				    {field:'GDID',title:'商品编码',width:100,align:'center',sortable:true},	
				    {field:'GDNAME',title:'商品名称',width:150,align:'left',sortable:true},
				    {field:'GDSPEC',title:'规格',width:100,align:'center',sortable:true},
					{field:'GDUNIT',title:'单位',width:100,align:'center',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:100,align:'center',sortable:true},
					<%if("3011".equals(currUser.getSgcode())){%>
					{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSHSJJJE',title:'进价成本',width:100,align:'center',sortable:true},
						{field:'TEMP5',title:'合同编码',width:100,align:'center',sortable:true}
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true},
						{field:'TEMP5',title:'合同编码',width:100,align:'center',sortable:true}
					<%}else{%>
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,width:100,align:'center',sortable:true},
						{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true}
						<%if("3007".equals(currUser.getSgcode().toString())){%>,{field:'TEMP5',title:'合同编码',width:100,align:'center',sortable:true}<%}%>
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},
					{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
				    <%
					}
					%>	
					<%if("L".equalsIgnoreCase( currUser.getSutype().toString())  && "3027".equals(currUser.getSgcode())){%>
					,{field:'TEMP5',title:'合同编码',width:100,align:'center',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true	
			});
			
			//如果是零售商，就显示供应商输入框
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#temp5sDiv").show();
			    $("#temp5Div").hide();
				$("#saleExportExcel").width(836);
			}else{
				$("#temp5Div").show();
				$("#temp5sDiv").hide();
				$("#supcodeDiv").hide();
			}
			//
			
			//
			$('#itemStockList').datagrid({
				width:  User.sutype == 'L' ? 935 : 685,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'SHPCODE',title:'门店编码',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'门店名称',width:300,align:'center',sortable:true},	
				     <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true,formatter:function(value,rec){
							if(parseFloat(value)>0){
								return value;
							}else{
								return 0;
							}
						}},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined && parseFloat(value)>0){
								return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
							}else{
								return 0;
							}
						}}
					<%}else{%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			//如果是供应商用户就隐藏供应商编码输入框，否则显示
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#temp5sDiv").show();
			    $("#temp5Div").hide();
				$("#saleExportExcel").width(1110);
				$("#mainTab").width(1110);
				$("#mainTabTd").width(380);
				$("#mainTabStartDateTd").width(450);
			}else{
				$("#temp5sDiv").hide();
			    $("#temp5Div").show();
				$("#supcodeDiv").hide();
			}
		});		
		
		
		//查询
		function reloadgrid (value)  {  
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			var temp5 = '';
			if(User.sutype == 'L'){
			    temp5 = $("#temp5s").val();
				supcode = $("#supcode").val();
			}else{
			    temp5 = $("#temp5").val();
				supcode = User.supcode;
			}  
	        //查询参数直接添加在queryParams中
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleSum',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
						    temp5 : temp5,
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),        //门店
							gdbarcode : $('#gdbarcode').attr('value'),        //商品代码
							gsgdname : $('#gsgdname').attr('value'),        //商品名称
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value') 		// 结束时间
						}]
					}
				)
			};	
			/*
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();		
			$("#saledatagrid").hide();	
			*/	
			$("#saledatagrid").show();
			$("#stockdatagrid").hide();
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
    	}  	     	

		function backSaleGsrqgrid ()  {
    		$("#stockdatagrid").hide(); 
			$("#saledatagrid").show();   
    	}  
    	
    	//导出excel
		function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}
		var temp5 = '';
	    if(User.sgcode=='3007'){
			if(User.sutype == 'L'){
			    temp5 = $("#temp5s").val();
				supcode = $("#supcode").val();
			}else{
			    temp5 = $("#temp5").val();
				supcode = User.supcode;
			}
		 }
 
			if(User.sgcode=='3007'){
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		

								ACTION_TYPE : 'getSaleSum',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
										enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','TEMP5','GSSUPID','SUPNAME' ],
										cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,'销售金额','合同编码','供应商编码','供应商名称'],
									<%
									}else{
									%>
										enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','TEMP5' ],
										cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,'销售金额','合同编码'],
									<%}%>
									sheetTitle: '销售汇总查询',
									temp5 : temp5,
									gssgcode : User.sgcode,
									supcode : supcode,                          // 供应商编码
									startDate : $('#startDate').attr('value'),	// 起始时间
									endDate : $('#endDate').attr('value'), 		// 结束时间
									gsmfid : $('#gsmfid').attr('value'),        //门店
									gdbarcode : $('#gdbarcode').attr('value'),        //商品代码
									gsgdname : $('#gsgdname').attr('value')        //商品名称
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
			}else{
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',

								ACTION_TYPE : 'getSaleSum',

								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString())){
										if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','GSHSJJJE','GSXSJE','GSSUPID','SUPNAME' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','售价','进价成本','销售金额','供应商编码','供应商名称'],
										<%}else{%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','GSSUPID','SUPNAME' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','进价成本','销售金额','供应商编码','供应商名称'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','进价成本'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','销售金额'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','GSHSJJJE','GSXSJE' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','售价','进价成本','销售金额'],
										<%}else{%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE' ],
											cnTitle: ['商品条码','商品编码','商品名称','规格','单位','销售数量','进价成本','销售金额'],
										<%}
									}%>
									sheetTitle: '销售汇总查询',
									gssgcode : User.sgcode,
									supcode : supcode,                          // 供应商编码
									startDate : $('#startDate').attr('value'),	// 起始时间
									endDate : $('#endDate').attr('value') 		// 结束时间
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
			
		}
	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售商品汇总查询<%if(currUser.getSgcode().equals("3007")){%>( 说明：预估销售成本是以商品的最新进价进行核算,和月结后的成本可能不一样)<%}%></td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">起始日期：<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">结束日期：<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" align="right" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店： <select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>所有门店</option>
		</select></td>
	</tr>
	<tr>
		<!-- <td colspan="1" style="border: none;">品&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;牌： <select
			style="width: 150px;" name='category' id="category" size='1'
			onclick="loadAllBrand(this);">
			<option value=''>所有品牌</option>
		</select></td> -->

		<td width="250" style="border: none;">商品条码：<input type="text"
			id="gdbarcode" name="gdbarcode" width="110" value="" /></td>

		<td style="border: none;">商品名称：<input type="text" id="gsgdname"
			name="gsgdname" width="110" /></td>
		<td style="border: none;" align="right" >
			
	        <%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">供应商编码：<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else{%>
			<div id="supcodeDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
			
			<%if("3007".equals(currUser.getSgcode())&&!("L".equalsIgnoreCase( currUser.getSutype().toString()))){%>
			<div id="temp5Div" style="">合同编码：<input type="text" id="temp5" name="temp5" value="" size="20" /></div>
			<%} %>
			
		</td>
	</tr>
	<tr>
	
		<td width="250"  style="border: none;">
			<%if("3007".equals(currUser.getSgcode())&&"L".equalsIgnoreCase( currUser.getSutype().toString())){%>
			<div id="temp5sDiv" style="">合同编码：<input type="text" id="temp5s" name="temp5s" value="" size="20" /></div>
			<%} %>		
			
		</td>
		
			<td style="border: none;"><input type="hidden" id="gdbarcode"
			name="gdbarcode" value="" /></td>

		<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 786px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a>
				</div>
				<table id="saleShopSummary" width="786" ></table>
			</div>
		</td>
	</tr>
	
	<tr>
		<td colspan="3">
			<div id="stockdatagrid" style="display: none;">
				<table id="itemStockList"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">返回</a> -->
					<img src="images/goback.jpg" border="0" onclick="backSaleGsrqgrid();" />
				</div>
			</div>
		</td>
	</tr>
	
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>





