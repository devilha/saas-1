<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>已上传文档查询</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		$("#Documentdatagrid").hide();
		
		$(function(){
			$('#Document').datagrid({
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
				    {field:'TITLE',title:'文档名称',width:200,align:'center',sortable:true},
				    {field:'MEMO',title:'文档说明',width:350,align:'center',sortable:true},
					{field:'CRT_BY_C',title:'文档来源',width:150,sortable:true},
					{field:'CRT_BY_TIME',title:'上传时间',width:100,align:'center',sortable:true},	
					{field:'URL',title:'下载',width:100,align:'center',sortable:true,
			    		 formatter:function(value,rec){
							return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "下载" + '</a>';
							
					}}
				]],
				<%
					if("L".equals(currUser.getSutype()+"")){
				%>
					toolbar:[{
					id:'btnSearch',
					text:'添加',
					iconCls:'icon-add',
					handler:function(){
						newFile();
					}
				},'-',{
					id:'btnAdd',
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						deleteDocument();
					}
				}
				],
				<%		
					}
				%>
				pagination:true,
				rownumbers:true
				
			});
			reloadgrid ();
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
			//var startDateArr = startDate.split("-");   
			//var endDateArr = endDate.split("-");   
			//startDate = new Date(startDateArr[0],parseInt(startDateArr[1])-1,startDateArr[2]);   
			//endDate = new Date(endDateArr[0],parseInt(endDateArr[1])-1,endDateArr[2]);
			//if(startDate > endDate){
			///	$.messager.alert('错误','开始日期必须小于或等于结束日期！！！','error');
			//	return;
			//} 
	        //查询参数直接添加在queryParams中
	        $('#Document').datagrid('options').url = 'JsonServlet';        
			$('#Document').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getDocument',
						ACTION_CLASS : 'com.bfuture.app.saas.model.DownlodeCenter',
						ACTION_MANAGER : 'downlodeCenter',	
						list:[{
							insC : User.sgcode,
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#Documentdatagrid").show();
			$("#Document").css("display","");
			$("#Document").datagrid('reload'); 
			$("#Document").datagrid('resize'); 
    	}
    	function exportExcel(){
			var supcode = '';
				supcode = User.supcode;
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getInvoice',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
								ACTION_MANAGER : 'InvoiceDZDXFXManager',										 
								list:[{
									exportExcel : true,
									enTitle: ['INVOICENO','INVOICEDATE','INVOICETYPE','GOODSNAME','PAYAMT','PAYNETAMT','PAYTAXAMT','BALANCENO','INPUTDATE','FLAG'],
									cnTitle: ['发票单号','发票日期','发票类型','货物名称','开票金额','不含税金额','税额','结算单号','提交日期','提交状态'],
									sheetTitle: '发票录入查询',
									sgcode : User.sgcode,
									venderid : supcode,
									invoiceno : $('#invoiceno').attr('value'),//发票单号
									balanceno : $('#balanceno').attr('value'),//结算单号
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
		// 删除操作
		function deleteDocument(){
			var row = $('#Document').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			var list = [];
			for( var i = 0; i < row.length; i ++ ){
					list.push(
						{ id : row[i].ID, ins_c: User.sgcode }
					);
			}

			$.messager.confirm('确认操作', '确认要删除[ ' + row[0].URL + ' ]吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'deleteDocument',
									ACTION_CLASS : 'com.bfuture.app.saas.model.DownlodeCenter',
									ACTION_MANAGER : 'downlodeCenter',
									optType : 'delete',
									optContent : '删除文件',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('提示','删除成功！','info');
                    			$('#Document').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});		
						
		}
		
		function downAttachment(filename){
			filename = encodeURI(filename);
			window.location = "${pageContext.request.contextPath }/CenterDownServlet?filename="+filename;
		}
		
		function redate()
		{
				$("#startDate").val( now.format('yyyy-MM-dd') );
				$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		}
		function newFile()
		{
				openUrl('DocumentUpload.jsp','Y');
		}
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="2" align="left" style="border: none; color: #4574a0;">已上传文件查询</td>
	</tr>
	<tr>
		<td  style="border: none;width:250">起始日期： <input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
		<td  style="border: none;width:280"><font style="text-align:center;letter-spacing:3px">结束日期：</font> <input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>

	<tr>
		<td style="border: none;">

				<a href="javascript:void(0);" onclick="reloadgrid();">
					<img style="margin-right:50px;"  border="0" src="images/sure.jpg">
				</a>
				<!--  
				<a href="javascript:void(0);" onclick="redate();">
					<img style="margin-right:50px;"  border="0" src="images/cz.jpg">
				</a>
				-->
		</td>
				
				
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="2">
			<!-- table 中显示列表的信息 -->
			<div id="Documentdatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<!--  <a href="javascript:exportExcel();">>>导出Excel表格</a>  -->
					</div>
				<table id="Document"></table>
			</div>
		</td>
	</tr>

</table>
</center>
</body>
</html>