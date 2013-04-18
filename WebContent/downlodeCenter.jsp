<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�ĵ���������</title>
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
				loadMsg:'��������...',		
				columns:[[
					{field:'TITLE',title:'�ĵ�����',width:140,align:'center',sortable:true},
				    {field:'MEMO',title:'�ĵ�˵��',width:200,align:'center',sortable:true,
				     formatter:function(value,rec){
							if( value != null && value != undefined  )
								return value;
								else 
								return '��';
						}
				    },
				    
				    {field:'CRT_BY_C',title:'�ϴ���',width:100,align:'center',sortable:true},
				    {field:'CRT_BY_TIME',title:'�ϴ�ʱ��',width:100,align:'center',sortable:true,
				      formatter:function(value,rec){
							if( value != null && value != undefined )
								return new Date(value.time).format('yyyy-MM-dd');
								else 
								return value;
						}
				    },
				 	{field:'URL',title:'���ظ���',width:100,align:'center',sortable:true,
				     formatter:function(value,rec){
							
								return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "����" + '</a>';
								
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
	        //��ѯ����ֱ�������queryParams��
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
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="880"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">�ĵ���������</td>
	</tr>
	<tr>
		<td width="300" style="border: none;">
			��ʼ���ڣ�<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			�������ڣ�<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
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
		<!-- table ����ʾ�б����Ϣ -->
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