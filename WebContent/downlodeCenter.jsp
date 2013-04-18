<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>文档下载中心</title>
<%
	Object objUser = session.getAttribute( "LoginUser" );
	if( objUser == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
%>
<style>

</style>
<script type="text/javascript">
        var now = new Date();
		now.setDate( now.getDate() - 7 );
	    $("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		
		
		$(function(){
			$('#downlodeDetail').datagrid({
				width:  673,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',		
				columns:[[
					{field:'TITLE',title:'文档名称',width:140,align:'center',sortable:true},
				    {field:'MEMO',title:'文档说明',width:200,align:'center',sortable:true,
				     formatter:function(value,rec){
							if( value != null && value != undefined  )
								return value;
								else 
								return '无';
						}
				    },
				    
				    {field:'CRT_BY_C',title:'上传人',width:100,align:'center',sortable:true},
				    {field:'CRT_BY_TIME',title:'上传时间',width:100,align:'center',sortable:true,
				      formatter:function(value,rec){
							if( value != null && value != undefined )
								return new Date(value.time).format('yyyy-MM-dd');
								else 
								return value;
						}
				    },
				 	{field:'URL',title:'下载附件',width:100,align:'center',sortable:true,
				     formatter:function(value,rec){
							
								return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "下载" + '</a>';
								
						}}
		
				]],
				pagination:true,
				rownumbers:true
			});
			
			reloadgrid ();
			
		});	
		function downAttachment(filename){
		filename = encodeURI(filename);
		window.location = "${pageContext.request.contextPath }/CenterDownServlet?filename="+filename;
	}
		
		function reloadgrid ()  {
	        //查询参数直接添加在queryParams中
	       $('#downlodeDetail').datagrid('options').url = 'JsonServlet';        
			$('#downlodeDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Downlode',
						ACTION_MANAGER : 'downlodeCenter',		 
						list:[{
						 insC : User.sgcode,
						 startDate : $('#startDate').attr('value'),
						 endDate : $('#endDate').attr('value'),
						 //sucode : User.sucode
						 sucode : User.sgcode == '4005' ? User.sucode : ""
						}]
					}
				)
			};		
			
			document.getElementById("saledatagrid").style.display="";
			$("#downlodeDetail").datagrid('reload'); 
			$("#downlodeDetail").datagrid('resize'); 
			
    	}
    	

    	   
 	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="880"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">文档下载中心</td>
	</tr>
	<tr>
		<td width="300" style="border: none;">
			起始日期：<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			结束日期：<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td width="250" style="border: none;"></td>
		
	</tr>

	
	<tr>
	<td style="border: none;"><img src="images/sure.jpg" border="0"
			onclick="reloadgrid();" />     </td>
			<td style="border: none;"></td>
			<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
		<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
				<div id="goodsExcel" align="right" style="color: #336699; width: 673px">
					</div>
				<table id="downlodeDetail"></table>
			</div>
		</td>
		</tr>
	
</table>

</center>
</body>
</html>