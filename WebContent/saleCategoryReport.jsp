<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品销售类别明细查询</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		//获得经营方式
		String jyfs = currUser.getSuflag() + "";
		String suType = currUser.getSutype() + "";
	%>
<style>
a:hover { 
	text-decoration: underline;
	color: red
}
body{
	font-size: 9px;
}
</style>
<script>
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
		$(function(){
			$('#saleCategory').datagrid({
				width:836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'GDCATID',title:'类别编号',width:"<%if("S".equals(suType)){%>150<%}else{%>130<%}%>",align:'center',sortable:true,formatter:function(value,rec){
					if(rec.GDCATID == null || rec.GDCATID == 'null'){
						return '';
					}else if(rec.GDCATID!='合计'){
						var gcid = "'" + rec.GDCATID + "'";
						var supid = "'" + rec.GSSUPID + "'";
						return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="showDetail(' + gcid + ','+supid+');">' + value + '</a>';
					}else{
						return value;
					}
					}},
					{field:'GCNAME',title:'类别名称',width:"<%if("S".equals(suType)){%>300<%}else{%>200<%}%>",align:'left',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:"<%if("S".equals(suType)){%>190<%}else{%>100<%}%>",align:'center',sortable:true},
					{field:'GSHSJJJE',title:'含税进价成本',width:"<%if("S".equals(suType)){%>190<%}else{%>150<%}%>",sortable:true,align:'center'}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSSR',title:'售价金额',width:150,sortable:true,align:'center'},
					{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:250,align:'left',sortable:true}
					<%
					}
					%>
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
			
			$('#saleCategoryDetail').datagrid({
				width: 836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'GCID',title:'类别编码',width:100,align:'center',sortable:true},
					{field:'GCNAME',title:'类别名称',width:100,align:'center',sortable:true},
				    {field:'GSGDID',title:'商品编码',width:100,align:'center',sortable:true},	
				    {field:'GSBARCODE',title:'商品条码',width:160,align:'center',sortable:true},	
					{field:'GDNAME',title:'商品名称',width:300,align:'left',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:100,align:'center',sortable:true},					
					{field:'GSHSJJJE',title:'进价成本',width:60,sortable:true,align:'center'}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSSR',title:'销售金额',width:80,sortable:true,align:'center'},
					{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:250,align:'center',sortable:true}
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
				$("#mainTabTd").width(318);
				$("#mainTabTdStartDate").width(250);
				$("#mainTabTd").attr("align","right");
				$("#mainTabTd2").attr("align","right");
				$("#saledatagrid").attr("style","margin-left: 0px;display: none;");
			}else{
				$("#supcodeDiv").hide();
			}
			
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
		});
		
		function padLeft(str, lenght) {
            if (str.length >= lenght)
                return str;
            else
                return padLeft("0" + str, lenght);
        }
		
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
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getSaleCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价','售价金额','进价成本','供应商编码','供应商名称'],
										<%}else if("3027".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
											cnTitle: ['类别编号','类别名称','销售数量','含税销售收入','含税成本','供应商编码','供应商名称','供应商承担折扣'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价金额',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,'供应商编码','供应商名称'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['类别编号','类别名称','销售数量','含税成本','供应商承担折扣'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSVENDREBATE'],
											cnTitle: ['类别编号','类别名称','销售数量','含税销售收入','供应商承担折扣'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价','销售金额'],
										<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR' ],
											cnTitle: ['类别编号','类别名称','销售数量','销售金额'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE' ],
											cnTitle: ['类别编号','类别名称','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价金额'<%}%>],
										<%}
									}%>
									sheetTitle: '商品销售类别明细查询',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// 门店编码
									supcode : supcode,					// 供应商编码
									userType : User.sutype,				// 用户类型
									gsgcid : $('#gsgcid').attr('value'), // 类别编码
									gsgcname : $('#gsgcname').attr('value'), // 类别名称						
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
		
		function reloadgrid ()  {  
			//根据用户是供应商还是零售商，获取供应商编码  
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //查询参数直接添加在queryParams中
	        $('#saleCategory').datagrid('options').url = 'JsonServlet';        
			$('#saleCategory').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategory',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#gsmfid').attr('value'),// 门店编码
							supcode : supcode,					// 供应商编码
							gsgcid : $('#gsgcid').attr('value'), // 类别编码
							userType : User.sutype,				// 用户类型
							gsgcname : $('#gsgcname').attr('value'), // 类别名称							
							startDate : $('#startDate').attr('value'), // 开始日期
							endDate : $('#endDate').attr('value')      // 结束日期
						}]
					}
				)
			};
			$("#saledatagrid").show();         
			$("#saleCategory").datagrid('reload');        
			$("#saleCategory").datagrid('resize');
			$('#shopid_').val('').val($('#gsmfid').val());
			$('#startdate_').val('').val($('#startDate').val());
			$('#enddate_').val('').val($('#endDate').val());
			$('#supcode').combobox('setValue','');  
			
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

		//获取所有类别信息(编码)
		function loadAllCategoryID( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.CODE + "'>" + n.CODE + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取类别信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		} 		
		
		//获取所有类别信息(名字)
		function loadAllCategory( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategoryname',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.NAME + "'>" + n.NAME + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取类别信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		}   
  	
		
		  function backgrid ()  {     		
    		$("#saledatagrid").show(); 
    		$("#sure_button").show();
			$("#saleCategoryDetail2").hide();    	 
    	}  
    	function showDetail(gcid,supid){
    	
    	  $('#saleCategoryDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleCategoryDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategoryDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#shopid_').val(),// 门店编码
							supcode : supid,					// 供应商编码
							gsgcid :gcid, // 类别编码
							startDate : $('#startdate_').val(), // 开始日期
							endDate : $('#enddate_').val()      // 结束日期
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#sure_button").hide();
			$("#saleCategoryDetail2").show();                  
			$("#saleCategoryDetail").datagrid('reload');        
			$("#saleCategoryDetail").datagrid('resize');
    	} 
	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="740" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售商品类别查询</td>
	</tr>
	<tr>
		<td width="230" id="mainTabTdStartDate" style="border: none;">
			起始日期：<input type="text" id="startDate" name="startDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" />
		</td>
		<td width="230" style="border: none;">
			结束日期：<input type="text" id="endDate" name="endDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td id="mainTabTd" width="280" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：
			<select style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
	</tr>
	<tr>
		<td style="border: none;" id="gsgcid11">
			类别编码：<input type="text" id="gsgcid" name="gsgcid" width="110" value="" />		
		</td>
		  <td id='gsgcname11' style="border: none;" style="border: none;">
		         类别名称：<input type="text" name='gsgcname' id='gsgcname' />
		</td>
		<td style="border: none;" id="mainTabTd2">
			<div id="supcodeDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
	</tr>
	<tr>
		<td colspan="3" style="border: none;" align="left">
		    <img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
	</tr>
	<tr>
		<td colspan="3" id="saledatagrid" style="display: none;">
			<table id="saleCategory"></table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
		    <div id="shopid_" style="display: none"></div>
			<div id="startdate_" style="display: none"></div>
			<div id="enddate_" style="display: none"></div>
			<div id="saleCategoryDetail2" style="display: none;">
				<table id="saleCategoryDetail"></table>
				<div style="text-align: left; margin-top: 10px;">
					<img src="images/goback.jpg" border="0" onclick="backgrid();" />
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