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
		String suType = currUser.getSutype() + "";
	%>

<title>销售汇总查询</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">	 
		var now = new Date(); 
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
	    
		$(function(){
			$('#saleShopSummary').datagrid({	
				width: 836 ,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'加载数据...',				
				columns:[[				
					{field:'SHPCODE',title:'门店编码',width:150,align:'center',
						formatter:function(value,rec){
								if(value == '合计'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
								var shopCode = "'" + value + "'";
								var supid = "'" + rec.GSSUPID + "'";
								return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadShopSalegrid(' +  shopCode + ','+ supid +');">' + value + '</a>';											
						}
					},
					{field:'SHPNAME',title:'门店名称',width:"<%if("S".equals(suType)){%>300<%}else{%>200<%}%>",align:'left',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:"<%if("S".equals(suType)){%>170<%}else{%>120<%}%>",align:'center',sortable:true},				
					{field:'GSHSJJJE',title:'进价成本', width:"<%if("S".equals(suType)){%>183<%}else{%>120<%}%>",sortable:true,align:'center'}
					<% if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){ %>
					,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true},
					{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:200,align:'left',sortable:true}
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
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(836);
			}else{
				$("#supcodeDiv").hide();
			}
			
			//
			$('#saleShopDetail').datagrid({		
				title: '',	
				width: 836,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'加载数据...',				
				columns:[[
			        {field:'GSRQ',title:'销售日期',width:"<%if("S".equals(suType)){%>200<%}else{%>100<%}%>",align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if(value == '合计'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}	
			        		var gsrq = "'" + value + "'";
			        		var supid = "'" + rec.GSSUPID + "'";
			        		return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadGsrqSalegrid(' +  gsrq + ','+supid+');">' + value + '</a>';	       		        	 	        		
						
						}
			        },
					{field:'GSXSSL',title:'销售数量',width:"<%if("S".equals(suType)){%>300<%}else{%>120<%}%>",sortable:true,align:'center'},
					{field:'GSHSJJJE',title:'进价成本',width:"<%if("S".equals(suType)){%>305<%}else{%>120<%}%>",sortable:true,align:'center'} 
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSJE',title:'销售金额',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'GSSUPID',title:'供应商编码',width:111,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:250,align:'left',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true			
			});
			
			$('#saleGsrqDetail').datagrid({
				width: 836,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				fitColumns:false,			
				remoteSort: true,	
				singleSelect: true,	
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[	
						{field:'GSGDID',title:'商品编码',width:80,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}			  
			        		else
			        		{
			        			if(value == '合计'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
			        			var gdid = "'" + value + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        				return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' +  gdid + ','+supid+');">' + value + '</a>';	
			        		} 							
						}
			        },
			        {field:'GSBARCODE',title:'商品条码',width:120,align:'left',sortable:true},	
				    {field:'GDNAME',title:'商品名称',width:297,align:'left',sortable:true},	
				    {field:'GDSPEC',title:'规格',width:80,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:80,align:'center',sortable:true}			
					,{field:'GSHSJJJE',title:'进价成本',width:90,align:'center',sortable:true}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSJE',title:'销售金额',width:100,align:'center',sortable:true}
					,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:250,align:'center',sortable:true}
					<%}%>	
				]],
				pagination:true,
				rownumbers:true
			});

			$('#ItemStock').datagrid({
				width:836,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				showFooter:true,
				fitColumns:false,				
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'ZSMFID',title:'门店编码',width:80,align:'center',sortable:true},
				    {field:'SHPNAME',title:'门店名称',width:120,align:'left',sortable:true},	
					{field:'ZSGDID',title:'商品编码',width:100,align:'center',sortable:true},
				    {field:'ZSBARCODE',title:'商品条码',width:120,align:'center',sortable:true},	
					{field:'GDNAME',title:'商品名称',width:300,align:'left',sortable:true},
					{field:'ZSKCSL',title:'库存数量',width:80,align:'center',sortable:true},
					{field:'ZSKCJE',title:'库存进价金额',width:80,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true	
			});
		});			
		
		//导出excel
		function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L' ){
			supcode = $('#supcode').val();
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<% if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['门店编码','门店名称','销售数量','销售金额','进价金额','供应商编码','供应商名称'],
									<%}else{%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['门店编码','门店名称','销售数量','进价金额'],
									<%}%>
									sheetTitle: '销售汇总查询',
									gssgcode : User.sgcode,
									userType : User.sutype,
									supcode : supcode,       
									gsmfid : $('#gsmfids').attr('value'),                   // 供应商编码
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
		
		function reloadgrid (value)  {  
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			 if(User.sutype == 'L'){
			supcode = $('#supcode').val();
			}else {
			supcode = User.supcode;
			}  
			
	        //查询参数直接添加在queryParams中
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							userType : User.sutype,
							gsmfid : $('#gsmfids').attr('value'),	// 门店
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value') 		// 结束时间
						}]
					}
				)
			};	
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();		
			$("#saledatagrid").show();		
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
			$("#LssSaleSummary").datagrid('reload'); 
			$("#LssSaleSummary").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
    	}
    	    	
    	function reloadShopSalegrid (value,SUPID)  {
        	$('#gsmfid').attr('value',value);	  
	        //查询参数直接添加在queryParams中
	        $('#saleShopDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleShopDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getShopSaleDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'),      // 结束时间
							gsmfid : $('#gsmfid').attr('value')  	    // 门店编码	
						}]
					}
				)
			};     
			$("#saledatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();					
			$("#saleShopdatagrid").show();   
			$("#saleShopDetail").datagrid('reload');	
			$("#saleShopDetail").datagrid('resize');		 
    	}    	
    	
    	function reloadGsrqSalegrid (value,SUPID)  {
    		$('#gsrq').attr('value',value);        
	        //查询参数直接添加在queryParams中
	        $('#saleGsrqDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleGsrqDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGsrqShopSale',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'), 		// 结束时间
							gsmfid : $('#gsmfid').attr('value'),		// 门店编码
							gsrq : $('#gsrq').attr('value')             // 销售日期
						}]
					}
				)
			};   
			$("#saledatagrid").hide();	   
			$("#saleShopdatagrid").hide();			
			$("#stockdatagrid").hide();				
			$("#saleGsrqdatagrid").show(); 
			$("#saleGsrqDetail").datagrid('reload');
			$("#saleGsrqDetail").datagrid('resize');      
    	}
    	
    	function reloadItemStockgrid (value,SUPID)  {
        	$('#zsgdid').attr('value',value);   
	        //查询参数直接添加在queryParams中
	        $('#ItemStock').datagrid('options').url = 'JsonServlet';        
			$('#ItemStock').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'), 		// 结束时间
							zsmfid : $('#gsmfid').attr('value'),		// 门店编码
							gsrq : $('#gsrq').attr('value'), 			// 销售日期
							zsgdid : $('#zsgdid').attr('value')         // 商品编码
						}]
					}
				)
			};      
			
			$("#saledatagrid").hide();			
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();			  
			$("#stockdatagrid").show(); 
			$("#ItemStock").datagrid('reload');      
			$("#ItemStock").datagrid('resize');
    }
    	
   	function backSalegrid ()  {     		
   		$("#saleShopdatagrid").hide(); 
		$("#saledatagrid").show();    	 
   	}
   	
   	function backSaleShopgrid ()  {
   		$("#saleGsrqdatagrid").hide(); 
		$("#saleShopdatagrid").show();   
   	}
   	
   	function backSaleGsrqgrid ()  {
   		$("#stockdatagrid").hide(); 
		$("#saleGsrqdatagrid").show();   
   	}   
    	
$(function(){
	if( !$('#supcode').data('isLoad') ){
		$.post( 'JsonServlet',				
			{
				data : obj2str({		
						ACTION_TYPE : 'getReceivers',
						ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
						ACTION_MANAGER : 'msgManager',
						list:[{
							id : ''
						}]
				})
				
			}, 
			function(data){ 
                   if(data.returnCode == '1' ){ 
                   	 if( data.rows ){
                   	 	$('#supcode').combobox('loadData', data.rows );
                   	 }
                   }else{ 
                       $.messager.alert('提示','获取接收人失败!<br>原因：' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );
	}

});	
</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="850"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售汇总查询</td>
	</tr>
	<tr>
		<td colspan="3">
			<input type="hidden" id="gsmfid" name="gsmfid" value="" />
			<input type="hidden" id="gsrq" name="gsrq" value="" />
			<input type="hidden" id="zsgdid" name="zsgdid" value="" />
		</td>
	</tr>
	<tr>
		<td id="mainTabTd" align="left" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店： 
			<select style="width: 154px;" name='gsmfids' id="gsmfids" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
		<td width="300" style="border: none;">
			起始日期：<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			结束日期：<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
	</tr>
	<tr>
		
		<td colspan="3" style="border: none;">
			<div id="supcodeDiv" style="">供应商编码：&nbsp;&nbsp;<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="3" style="border: none;"><img
			src="images/sure.jpg" border="0" onClick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
				<table id="saleShopSummary" width="586"></table>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleShopdatagrid" style="display: none;">
				<table id="saleShopDetail" ></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSalegrid();">返回</a>-->
					<img src="images/goback.jpg" border="0" onClick="backSalegrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleGsrqdatagrid" style="display: none;">
				<table id="saleGsrqDetail"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleShopgrid();">返回</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleShopgrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="stockdatagrid" style="display: none;">
				<table id="ItemStock"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">返回</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleGsrqgrid();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("gsmfids");
loadAllShop(obj);

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
</html>