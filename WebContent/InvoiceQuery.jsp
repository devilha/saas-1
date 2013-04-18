<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʊ¼���ѯ</title>

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
		$("#Invoicedatagrid").hide();
		
		$(function(){
			$('#Invoice').datagrid({
				width:930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'INVOICENO',title:'��Ʊ����',width:110,align:'center',sortable:true},
				    {field:'INVOICEDATE',title:'��Ʊ����',width:85,align:'center',sortable:true},
				    {field:'INVOICETYPE',title:'��Ʊ����',width:60,align:'center',sortable:true,
				    formatter:function(value,rec){
							if( value == '1' )
								return '��ֵ';
							else 
								return '��';
						}
					},
				    {field:'GOODSNAME',title:'��������',width:132,sortable:true},				    
				    {field:'PAYAMT',title:'��Ʊ���',width:75,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PAYNETAMT',title:'����˰���',width:75,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				     {field:'PAYTAXAMT',title:'˰��',width:75,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BALANCENO',title:'���˵���',width:100,align:'center',sortable:true},	
						{field:'INPUTDATE',title:'�ύ����',width:85,align:'center',sortable:true,
							formatter:function(value,rec){
								if(rec.FLAG=='0')
									return '';
								else
									return value;
							}
						
						},	
						{field:'FLAG',title:'�ύ״̬',width:95,align:'center',sortable:true,
						    formatter:function(value,rec){
									if( value == '0' )
										return 'δ�ύ';
									else if( value == '1' )
										return 'δ���';
									else if(value=='2')
										return '���ͨ��';
									else if(value=='3')
										return '���δͨ��';
									else
										return '��״̬';
								}
							}

				]],
				pagination:true,
				rownumbers:true
			});
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
			var startDateArr = startDate.split("-");   
			var endDateArr = endDate.split("-");   
			
	        //��ѯ����ֱ�������queryParams��
	        $('#Invoice').datagrid('options').url = 'JsonServlet';        
			$('#Invoice').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getInvoice',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
						ACTION_MANAGER : 'InvoiceDZDXFXManager',	
						list:[{
							sgcode : User.sgcode,
							venderid : supcode,
							invoiceno : $('#invoiceno').attr('value'),//��Ʊ����
							balanceno : $('#balanceno').attr('value'),//���˵���
							flag : $('#invoiceflag').attr('value'),// ���״̬
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
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
								ACTION_TYPE : 'getInvoice',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
								ACTION_MANAGER : 'InvoiceDZDXFXManager',										 
								list:[{
									exportExcel : true,
									enTitle: ['INVOICENO','INVOICEDATE','INVOICETYPE','GOODSNAME','PAYAMT','PAYNETAMT','PAYTAXAMT','BALANCENO','INPUTDATE','FLAG'],
									cnTitle: ['��Ʊ����','��Ʊ����','��Ʊ����','��������','��Ʊ���','����˰���','˰��','���˵���','�ύ����','�ύ״̬'],
									sheetTitle: '��Ʊ¼���ѯ',
									sgcode : User.sgcode,
									venderid : supcode,
									invoiceno : $('#invoiceno').attr('value'),//��Ʊ����
									balanceno : $('#balanceno').attr('value'),//���˵���
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
		function openQuery()
		{
				openUrl('InvoiceInput.jsp','Y');
		}
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">��Ʊ¼���ѯ</td>
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">��Ʊ���ţ�
			<input type="text" id="invoiceno" name="invoiceno" size="20"/>
        	</td>
		<td  style="border: none;width:250">��Ʊ��ʼʱ�䣺 <input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
		<td  style="border: none;width:280"><font style="text-align:center;letter-spacing:3px">��Ʊ����ʱ�䣺</font> <input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">���˵��ţ�
			<input type="text" id="balanceno" name="balanceno" size="20"/>
        	</td>
		<td  style="border: none;width:250"><font style="text-align:center;letter-spacing:8.5px">�ύ״̬</font>�� <select
			style="width: 154px;" name='invoiceflag' id="invoiceflag" size='1'>
			<option value='4'>ȫ��</option>
			<option value='0'>δ�ύ</option>
			<option value='1'>δ���</option>
			<option value='2'>���ͨ��</option>
			<option value='3'>���δͨ��</option>


		</select></td>
			<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;"><img src="images/sure.jpg" border="0"
			onclick="reloadgrid();" /></td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="Invoicedatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<a href="javascript:exportExcel();">>>����Excel���</a></div>
				<table id="Invoice"></table>
				¼���·�Ʊ������		
				<a href="javascript:void(0);" onclick="openQuery();">
					<img style="margin-right:50px;"  border="0" src="images/luru.jpg">
				</a> 
			</div>
		</td>
	</tr>

</table>
</center>
</body>
</html>