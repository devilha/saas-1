<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>���ϴ��ĵ���ѯ</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
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
				loadMsg:'��������...',				
				columns:[[
					{field:'aaaa',checkbox:true},
				    {field:'TITLE',title:'�ĵ�����',width:200,align:'center',sortable:true},
				    {field:'MEMO',title:'�ĵ�˵��',width:350,align:'center',sortable:true},
					{field:'CRT_BY_C',title:'�ĵ���Դ',width:150,sortable:true},
					{field:'CRT_BY_TIME',title:'�ϴ�ʱ��',width:100,align:'center',sortable:true},	
					{field:'URL',title:'����',width:100,align:'center',sortable:true,
			    		 formatter:function(value,rec){
							return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "����" + '</a>';
							
					}}
				]],
				<%
					if("L".equals(currUser.getSutype()+"")){
				%>
					toolbar:[{
					id:'btnSearch',
					text:'���',
					iconCls:'icon-add',
					handler:function(){
						newFile();
					}
				},'-',{
					id:'btnAdd',
					text:'ɾ��',
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
        	//��֤�û����������Ƿ�Ϸ���
 			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('��ʾ','�����뿪ʼ��������ڣ�����','info');
				return;
			} 
			var supcode = '';
				supcode = User.supcode;
			//var startDateArr = startDate.split("-");   
			//var endDateArr = endDate.split("-");   
			//startDate = new Date(startDateArr[0],parseInt(startDateArr[1])-1,startDateArr[2]);   
			//endDate = new Date(endDateArr[0],parseInt(endDateArr[1])-1,endDateArr[2]);
			//if(startDate > endDate){
			///	$.messager.alert('����','��ʼ���ڱ���С�ڻ���ڽ������ڣ�����','error');
			//	return;
			//} 
	        //��ѯ����ֱ�������queryParams��
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
									cnTitle: ['��Ʊ����','��Ʊ����','��Ʊ����','��������','��Ʊ���','����˰���','˰��','���㵥��','�ύ����','�ύ״̬'],
									sheetTitle: '��Ʊ¼���ѯ',
									sgcode : User.sgcode,
									venderid : supcode,
									invoiceno : $('#invoiceno').attr('value'),//��Ʊ����
									balanceno : $('#balanceno').attr('value'),//���㵥��
									flag : $('#invoiceflag').attr('value'),// ���״̬
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
	                        $.messager.alert('��ʾ','����Excelʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		} 
		// ɾ������
		function deleteDocument(){
			var row = $('#Document').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;				
			}
			var list = [];
			for( var i = 0; i < row.length; i ++ ){
					list.push(
						{ id : row[i].ID, ins_c: User.sgcode }
					);
			}

			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��[ ' + row[0].URL + ' ]��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'deleteDocument',
									ACTION_CLASS : 'com.bfuture.app.saas.model.DownlodeCenter',
									ACTION_MANAGER : 'downlodeCenter',
									optType : 'delete',
									optContent : 'ɾ���ļ�',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','ɾ���ɹ���','info');
                    			$('#Document').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
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
		<td colspan="2" align="left" style="border: none; color: #4574a0;">���ϴ��ļ���ѯ</td>
	</tr>
	<tr>
		<td  style="border: none;width:250">��ʼ���ڣ� <input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
		<td  style="border: none;width:280"><font style="text-align:center;letter-spacing:3px">�������ڣ�</font> <input type="text"
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
			<!-- table ����ʾ�б����Ϣ -->
			<div id="Documentdatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<!--  <a href="javascript:exportExcel();">>>����Excel���</a>  -->
					</div>
				<table id="Document"></table>
			</div>
		</td>
	</tr>

</table>
</center>
</body>
</html>