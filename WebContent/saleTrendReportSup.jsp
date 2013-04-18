<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>	
	<title>销售趋势分析</title>
	
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
	
	<script>
		var saleTrendReportSUPChart = null;
		
		$(function(){
			$('#saleTrendReportSupList').datagrid({
				width: 800,				
				nowrap: false,
				striped: true,				
				url:'',
				sortOrder: 'desc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'加载数据...',				
				showFooter:true,												
				columns:[[
				
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						{field:'GSRQ',title:'日期',width:80,
							formatter:function(value,rec){
								if( value != null && value != undefined && value != '合计' )
									return Date.parseString(value).format('yyyy-MM-dd');
								else
									return value;
							}
						},
						{field:'SHPCODE',title:'门店编码',width:60},			
						{field:'SHPNAME',title:'门店名称',width:80},
						{field:'GSXSSL',title:'销售数量',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},{field:'GSXSSR',title:'销售金额',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true},
						<%}%>
						/*
						{field:'GSHSJJJE',title:'含税进价金额',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},					
						{field:'GSXSSR',title:'销售收入',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},*/
						{field:'INFSUPID',title:'供应商编号',width:80,sortable:true},
						{field:'INFSUPNAME',title:'供应商名称',width:223,sortable:true}
					<%
					}else {
					%>	
						{field:'GSRQ',title:'日期',width:120,
							formatter:function(value,rec){
								if( value != null && value != undefined && value != '合计' )
									return Date.parseString(value).format('yyyy-MM-dd');
								else
									return value;
							}
						},
						{field:'SHPCODE',title:'门店编码',width:120},			
						{field:'SHPNAME',title:'门店名称',width:285},
						{field:'GSXSSL',title:'销售数量',width:120,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
							{field:'GSHSJJJE',title:'进价成本',width:120,align:'right',
								formatter:function(value,rec){
									return formatNumber(
										value,
										{ decimalPlaces : 2, thousandsSeparator :',' }
									);
								}
							}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
							{field:'GSXSSR',title:'销售收入',width:120,align:'right',
								formatter:function(value,rec){
									return formatNumber(
										value,
										{ decimalPlaces : 2, thousandsSeparator :',' }
									);
								}
							}
						<%}else if("3034".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'销售金额',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :','}
								);
							}
						}						
						<%}else{%>
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,width:120,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}
						<%}%>
						<%if(currUser.getSgcode().equals("3009")){%>
						,{field:'GSXSSR',title:'销售金额',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
						<%}%>
						/*{field:'GSHSJJJE',title:'含税进价金额',width:100,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},					
						{field:'GSXSSR',title:'销售收入',width:100,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}*/
					<%
					}
					%>
					
				]],				
				rownumbers:true,
				onLoadSuccess:function( data ){
					if( data.chartData ){
						saleTrendReportSUPChart = data.chartData;
						drawChart();
		            }
				}
			});
			
			clear();
			
			//如果是零售商，就显示供应商输入框
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
			}else{
				$("#supcodeDiv").hide();
			}			
		});	// load end	
		
		function drawChart(){
			if( saleTrendReportSUPChart != null ){
				var chartType = "MSColumn3D.swf";
				if( $('#chartStyle').val() == 'line' ){
					chartType = "MSLine.swf";
				}
				var chart = new FusionCharts("chart/" + chartType, "saleTrendReportSUPChartId", "800", "400", "0", "0");            
				chart.setJSONData( saleTrendReportSUPChart );
				chart.render("saleTrendReportSUPChart");
			}
		}
		
		function clear(){
			var now = new Date();
			var startDate = new Date();
			startDate.setDate( now.getDate() - 7 );
			$('#startDate').val( startDate.format('yyyy-MM-dd') );
			$('#endDate').val( now.format('yyyy-MM-dd') );
		}
		
		function returnFirst(){
			$( '#div1' ).show();
			$( '#div2' ).hide(); 
		}
		
		function loadAllShop( list ){
			if( $(list).attr('isLoad') == undefined ){
				$(list).attr('isLoad' , true );
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
	                    	 	$.each( data.rows, function(i, n) {      
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 
	                    }else{ 
	                        $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		
		function exportExcel(){
			var searchData = getFormData( 'saleTrendReportSUPSearch' );
        	searchData['gssgcode'] = User.sgcode;    
        	searchData['gssupid'] = User.supcode;    	
        	searchData['sucode'] = User.sucode;
        	searchData['isSup'] = 'Y'; 
        	searchData['exportExcel'] = true;
        	//searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','gshsjjje','gsxssr'];
        	//searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','含税进价金额','销售收入'];
        	//如果是零售商，就显示销售金额、供应商编码和供应商名称
			if(User.sutype == 'L'){
				searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE','GSXSJE','INFSUPID','INFSUPNAME'];
	        	searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','进价成本','销售金额','供应商编号','供应商名称'];
			}else{
				<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE'];
        			searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','进价成本'];
				<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSXSJE'];
        			searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','销售金额'];
				<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")) {%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSXSJE'];
        			searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','销售金额'];
				<%}else{%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE'];
        			searchData['cnTitle'] = ['日期','门店编码','门店名称','销售数量','进价成本'];
				<%}%>
			}
        	
        	searchData['sheetTitle'] = '销售趋势分析查询';
		
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwGoodssale',
								ACTION_MANAGER : 'saleTrendReport',									 
								list:[ searchData ]
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
		
		function reloadgrid ()  {  
        	var searchData = getFormData( 'saleTrendReportSUPSearch' );
        	searchData['gssgcode'] = User.sgcode;    
        	searchData['sucode'] = User.sucode;
        	searchData['isSup'] = 'Y';
        	
        	//根据用户是供应商还是零售商，获取供应商编码
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#gssupid").val();
			}else{
				supcode = User.supcode;
			}  
        	searchData['gssupid'] = supcode; 
        
	        //查询参数直接添加在queryParams中
	        $('#saleTrendReportSupList').datagrid('options').url = 'JsonServlet';        
			$('#saleTrendReportSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleTrendReport', // getChart datagrid
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwGoodssale',
						ACTION_MANAGER : 'saleTrendReport',
						optType : 'query',
						optContent : '查询销售趋势分析报表',		 
						list:[	searchData	]
					}
				)
			};  
			
			$( '#div2' ).show();			        
			$("#saleTrendReportSupList").datagrid('reload');
			$("#saleTrendReportSupList").datagrid('resize');
    	}
    	
    	// 重置查询条件输入框
		function searchReset(){
			clear();
			$('#gsmfid').val( '' ); 	// 门 店
			$('#gssupid').val( '' ); 	// 供应商编号
		}
	</script>
</head>
<body>
	<div id="div1" title="销售趋势分析" style="padding:10px;" align="center" >
		
		<!-- 查询条件区域开始 -->
		<table id="saleTrendReportSUPSearch" style="line-height:20px; text-align:left; border:none; font-size:12px" width="800px"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">销售趋势分析<%if(currUser.getSgcode().equals("3007")){%>( 说明：预估销售成本是以商品的最新进价进行核算,和月结后的成本可能不一样)<%}%></td> 
			</tr> 
			
			<tr> 
				<td width="282" style="border:none;"> 
					门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：
					<select style="width:150px;" name='gsmfid' id="gsmfid" size='1'> 
              			<option value = ''>所有门店</option> 
      				</select>
      			</td>
				 <td width="282" style="border:none;"> 
					起&nbsp;&nbsp;始&nbsp;&nbsp;日&nbsp;&nbsp;期&nbsp;&nbsp;：
					<input type="text" name="startDate" id="startDate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /> 
				</td> 
				<td width="282" style="border:none;"> 
					结&nbsp;束&nbsp;日&nbsp;期&nbsp;：
					<input type="text" name="endDate" id="endDate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /> 
				</td>	
  			</tr> 
  			
			<tr> 
				<td width="282" style="border:none;"> 
					图表格式：
					<select style="width:150px;" id="chartStyle" size='1' onchange="drawChart();" > 
              			<option value = 'line'>曲线图</option>
              			<option value = 'column'>柱状图</option> 
      				</select>
      			</td>
      			<td width="282" style="border:none;"> 
					数据分析对象：
					<select style="width:155px;" id='saleObject' name='saleObject' size='1'>	
					
						<%
							if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
						%>
							<option value='GSXSSL' selected="selected">销售数量</option>	
				       		<option value='GSHSJJJE'>进价成本</option>	
							<option value='GSXSJE'>销售金额</option>
						<%
							}else{
								if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">销售数量</option>	
				       				<option value='GSHSJJJE'>进价成本</option>	
								<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">销售数量</option>	
				       				<option value='GSXSSR'>销售收入</option>
								<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">销售数量</option>	
				       				<option value='GSXSJE'>销售金额</option>
								<%}else{%>
									<option value='GSXSSL' selected="selected">销售数量</option>	
				       				<option value='GSHSJJJE'>进价成本</option>	
								<%}
							} %>
							       		
			       		<!-- <option value='GSXSSL' selected="selected">销售数量</option>	
			       		<option value='GSHSJJJE'>含税进价金额</option>				    	
						<option value='GSXSSR'>销售收入</option>  -->
					</select> 
				</td> 
				<td width="282" style="border:none;"> 
					<div id="supcodeDiv" style="">供应商编码：&nbsp;&nbsp;<input type="text" id="gssupid" name="gssupid" value="" size="20" /></div>
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
  			</tr> 
  			
			<tr> 
				<td width="282" style="border:none;"> 
					<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
					<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onclick="searchReset();"/></a> 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
			</tr> 
		</table>
		<!-- 查询条件区域结束 --> 
		
	</div>	
	<div id="div2" style="padding:10px;display:none;height:400px;overflow-y:auto;" align="center">		
		<div id="saleTrendReportSUPChart">		
		</div>
		<div>	
			<!-- <div align="right" style="color:#336699;width: 800px"><a href="javascript:exportExcel();">&gt;&gt;导出Excel表格</a></div> --> 
			<table id="saleTrendReportSupList"></table>
		</div>
	</div>	
	
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>