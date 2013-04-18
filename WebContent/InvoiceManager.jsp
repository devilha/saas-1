<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>发票管理</title>

<%
//传入参数
String  invo=request.getParameter("name");
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
		return;
	}
	//SysScmuser currUser = (SysScmuser)obj;
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		$("#Invoicedatagrid").hide();
		$(function(){
			$('#Invoice').datagrid({
				width:930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: false,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',	
		
				columns:[[
					{field:'aaaa',checkbox:true},
					{field:'VENDERID',title:'供应商编码',width:74,align:'center',sortable:true},
					{field:'SUNAME',title:'供应商名称',width:110,align:'center',sortable:true},
				    {field:'INVOICENO',title:'发票单号',width:110,align:'center',sortable:true},
				    {field:'INVOICEDATE',title:'发票日期',width:80,align:'center',sortable:true},
				    {field:'INVOICETYPE',title:'发票类型',width:60,align:'center',sortable:true,
				    formatter:function(value,rec){
							if( value == '1' )
								return '增值';
							else 
								return '无';
						}
					},
				    {field:'GOODSNAME',title:'货物名称',width:130,sortable:true},				    
				    {field:'PAYAMT',title:'开票金额',width:75,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PAYNETAMT',title:'不含税金额',width:74,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				     {field:'PAYTAXAMT',title:'税额',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BALANCENO',title:'对账单号',width:100,align:'center',sortable:true},	
						{field:'INPUTDATE',title:'提交日期',width:80,align:'center',sortable:true},	
						{field:'FLAG',title:'提交状态',width:95,align:'center',sortable:true,
						    formatter:function(value,rec){
									if( value == '0' )
										return '未提交';
									else if( value == '1' )
										return '未审核';
									else if(value=='2')
										return '审核通过';
									else if(value=='3')
										return '审核未通过';
									else
										return '无状态';
								}
							}

				]],
				pagination:true,
				rownumbers:true,
				
				toolbar:[{
					id:'btnSearch',
					text:'审核通过',
					iconCls:'icon-ok',
					handler:function(){
						//search();
						if(checkFlag('1')){
							changeState(2);
						}
					}
				},'-',{
					id:'btnAdd',
					text:'驳回',
					iconCls:'icon-no',
					handler:function(){
						//add();
						if(checkFlag('1')){
							changeState(3);
						}
					}
				}
				]
				
				
			});
			//获得参数,判断
			var invo=$('#invo').val();
			if(invo==1){
			
			reloadgrid();
			}
			$('#invo').val('');
		}
		);

		function reloadgrid ()  {
        	//验证用户输入日期是否合法？
 			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('提示','请输入开始或结束日期！！！','info');
				return;
			} 
			var supcode = '';
				supcode = User.supcode;
			var startDateArr = startDate.split("-");   
			var endDateArr = endDate.split("-");   
			
			//获得参数值
			var invo=$('#invo').val();
			
		        //查询参数直接添加在queryParams中
	        $('#Invoice').datagrid('options').url = 'JsonServlet';        
			$('#Invoice').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getInvoiceManager',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
						ACTION_MANAGER : 'InvoiceDZDXFXManager',	
						list:[{
							sgcode : User.sgcode,
							//venderid : supcode,
							invoiceno : $('#invoiceno').attr('value'),//发票单号
							balanceno : $('#balanceno').attr('value'),//对账单号
							flag : invo==1?invo:$('#invoiceflag').attr('value'),// 审核状态
							startDate :invo==1?'' :$('#startDate').attr('value'),
							endDate :invo==1?'' :$('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#Invoicedatagrid").show();
			$("#Invoice").css("display","");
			$("#Invoice").datagrid('reload'); 
			$("#Invoice").datagrid('resize'); 
    	}

    	function exportExcel(){
			var supcode = '';
				supcode = User.supcode;
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getInvoiceManager',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
								ACTION_MANAGER : 'InvoiceDZDXFXManager',										 
								list:[{
									exportExcel : true,
									enTitle: ['VENDERID','SUNAME','INVOICENO','INVOICEDATE','INVOICETYPE','GOODSNAME','PAYAMT','PAYNETAMT','PAYTAXAMT','INPUTDATE','BALANCENO','FLAG'],
									cnTitle: ['供应商编码','供应商名称','发票单号','发票日期','发票类型','货物名称','开票金额','不含税金额','税额','对账单号','提交日期','提交状态'],
									sheetTitle: '发票管理',
									sgcode : User.sgcode,
									venderid : supcode,
									invoiceno : $('#invoiceno').attr('value'),//发票单号
									balanceno : $('#balanceno').attr('value'),//对账单号
									flag : $('#invoiceflag').attr('value'),// 审核状态
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
	//验证是否可审核
	function checkFlag(id){
	
      //选择正确
	         var ids = [];            
	         var rows = $('#Invoice').datagrid('getSelections');   
	         if(rows.length<1)
	         {
	         	$.messager.alert('错误','未选择记录!');
				return false;
	         }         
	         for(var i=0;i<rows.length;i++){  
	        	 
	        	if(rows[i].FLAG != id){
					$.messager.alert('错误','请选择状态合法的发票!');
					return false;
				}          
	         }           
		return true;
	}
	
	/**
	 * 审核操作[审核通过、审核不通过]
	 */
	function changeState(changeflag){

		var rows = $('#Invoice').datagrid('getSelections');   
		if(rows.length < 1){
			$.messager.alert('错误','未选择记录!');
			return false;
		}
		var list = [];
		var len="";
		for( var i = 0; i < rows.length; i ++ ){

				list.push(
					{ invoiceno : rows[i].INVOICENO, flag: changeflag }
				);
				len+=(rows[i].INVOICENO+',');
			}
		
		
		$.messager.confirm('确认操作', '确认要对[ ' + len+ ' ]发票</br>&nbsp&nbsp执行'+(changeflag==2?'[审核通过]"':'[审核不通过]')+'操作吗？', function(r){
		if (r){
					$.post( 'JsonServlet',				
							{
								data : obj2str({		
										ACTION_TYPE : 'updateInvoice',
										ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
										ACTION_MANAGER : 'InvoiceDZDXFXManager',	
										list: list
								})
							}, 
							function(data){ 
			                    if(data.returnCode == '1' ){
			                    	$.messager.alert('提示','操作成功!');
					    		    //刷新结果列表
									reloadgrid();
			                    }else{
			                        $.messager.alert('提示','操作失败!<br>原因：' + data.returnInfo,'error');
			                    }
			            	},'json'
			            );
			    }
			    });
	}
 	</script>
</head>
<body>
<input type="hidden" id="invo" value="<%=invo %>">
<center>

<table id="QueryTable" width="950" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">发票管理</td>
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">发票单号：
			<input type="text" id="invoiceno" name="invoiceno" size="20"/>
        	</td>
        	<td  style="border:none;width: 250px;">供应商编码：
			<input type="text" id="venderid" name="venderid" size="20"/>
        	</td>
			<td  style="border: none;width:250">开票开始时间：<input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
			
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">对账单号：
			<input type="text" id="balanceno" name="balanceno" size="20"/>
        	</td>
		<td  style="border: none;width:250"><font style="text-align:center;letter-spacing:4px">提交状态</font>： <select
			style="width: 154px;" name='invoiceflag' id="invoiceflag" size='1'>
			<option value='4'>全部</option>
			<option value='1'>未审核</option>
			<option value='2'>审核通过</option>
			<option value='3'>审核未通过</option>
		</select></td>
			<td  style="border: none;width:280">开票结束时间：<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
		<td style="border: none;"><img src="images/sure.jpg" border="0"
			onclick="reloadgrid();" /></td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="Invoicedatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a></div>
				
				<table id="Invoice">
		    	</table>

			</div>
		</td>
	</tr>

</table>
</center>
</body>
</html>