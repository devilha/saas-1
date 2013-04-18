<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ��Ϣ��ѯ</title>
<%
	Object obj = session.getAttribute("LoginUser");
	if (obj == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	SysScmuser currUser = (SysScmuser) obj;
%>

<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">
	$(function(){
		$('#goodsdetail').datagrid({
			width: 1000,
			nowrap: false,
			striped: true,			
			collapsible:true,
			url:'',	 
			showFooter:true,	
			sortOrder: 'desc',
			singleSelect : true,
			remoteSort: true,
			fitColumns:false,
			loadMsg:'��������...',		
			columns:[[
			    {field:'GDID',title:'��Ʒ����',width:70,align:'left',sortable:true},
				{field:'GDBARCODE',title:'��������',width:120,align:'left',sortable:true},
			    {field:'GDNAME',title:'��Ʒ����',width:250,align:'left',sortable:true},
			    {field:'GDPPNAME',title:'Ʒ������',width:85,align:'left',sortable:true},		    
			    {field:'GDSPEC',title:'���',width:80,align:'left',sortable:true},
			    {field:'GDUNIT',title:'��λ',width:45,align:'left',sortable:true},
			    {field:'GDTAX',title:'˰��',width:45,align:'left',sortable:true},	
			    {field:'GDAREA',title:'����',width:60,align:'left',sortable:true},
			    {field:'GDCATID',title:'������',width:100,align:'left',sortable:true},
			    {field:'GDCATNAME',title:'�������',width:150,align:'left',sortable:true},				    	
			    {field:'TEMP1',title:'����',width:60,align:'left',sortable:true,
			    	formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}
			    }	
			  	<%if ("L".equalsIgnoreCase(currUser.getSutype().toString())) {%>	
			    ,{field:'TEMP2',title:'�ۼ�',width:60,align:'left',sortable:true,
					formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}
				}
				<%}%>
			]],
			toolbar:[{
				text:'����Excel',
				iconCls:'icon-redo',
				handler:function(){
					exportExcel();
				}
			}],
			pagination:true,
			rownumbers:true
		});
		//����������̣�����ʾ��Ӧ�������
		if(User.sutype == 'L'){
			$("#gssupidDiv").show();
			
		}else{
			$("#gssupidDiv").hide();
		}
	});	
		
	function reloadgrid ()  {
   		var supcode = '';
		if(User.sutype == 'L'){
			supcode = $('#supcode').val();
		}else {
			supcode = User.supcode;
		}  
        //��ѯ����ֱ�������queryParams��
        $('#goodsdetail').datagrid('options').url = 'JsonServlet';        
		$('#goodsdetail').datagrid('options').queryParams = {
			data :obj2str(
				{		
					ACTION_TYPE : 'getDetail',
					ACTION_CLASS : 'com.bfuture.app.saas.model.InfGoods',
					ACTION_MANAGER : 'goods',		 
					list:[{
					 gdsgcode : User.sgcode,
					 supcode : supcode,
					 gdcatid : $('#catid').attr('value'),
					 gdcatname : $('#catname').attr('value'),
					 gdid : $('#gdid').attr('value'),
					 gdbarcode : $('#gdbarcode').attr('value'),
					 gdname : $('#gdname').attr('value')
					}]
				}
			)
		};		
		$("#goodsdetail").datagrid('reload'); 
		$("#goodsdetail").datagrid('resize');
		$("#goodsdetailTd").show();
   	}
	
	function exportExcel(){
   		var supcode = '';
		if(User.sutype == 'L'){
			supcode = $('#supcode').val();
		}else {
			supcode = User.supcode;
		}  
		$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'getDetail',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfGoods',
							ACTION_MANAGER : 'goods',											 
							list:[{
								exportExcel : true,
								<%if ("L".equalsIgnoreCase(currUser.getSutype().toString())) {%>
								enTitle: ['GDID','GDBARCODE','GDNAME','GDPPNAME','GDSPEC','GDUNIT','GDTAX','GDAREA','GDCATID','GDCATNAME','TEMP1','TEMP2'],
								cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','Ʒ������','���','��λ','˰��','����','������','�������','����','�ۼ�'],
								<%} else {%>
								enTitle: ['GDID','GDBARCODE','GDNAME','GDPPNAME','GDSPEC','GDUNIT','GDTAX','GDAREA','GDCATID','GDCATNAME','TEMP1','TEMP2'],
								cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','Ʒ������','���','��λ','˰��','����','������','�������','����','�ۼ�'],
								<%}%>
								sheetTitle: '��Ʒ��ϸ��ѯ',
								gdsgcode : User.sgcode,
								supcode : supcode,  
								gdcatid : $('#catid').attr('value'),
								gdcatname : $('#catname').attr('value'),
								gdid : $('#gdid').attr('value'),
					 			gdbarcode : $('#gdbarcode').attr('value'),
					 			gdname : $('#gdname').attr('value')
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
   	
   	function reset(){
   		$("#gdid").val('');
    	$("#gdbarcode").val('');
    	$("#gdname").val('');
    	$("#supcode").val('');
   	}
    	   
 	</script>
</head>
<body>
	<center>
		<!-- ---------- ��ѯ������������ʼ ---------- -->
		<table width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
			<tr>
				<td colspan="4" align="left" style="border: none; color: #4574a0;">��Ʒ��Ϣ��ѯ</td>
			</tr>
			<tr>
				<td width="250" style="border: none;">��Ʒ���룺<input type="text" id="gdid" name="gdid" value="" size="20" /></td>
				<td width="250" style="border: none;">��Ʒ���ƣ�<input type="text" id="gdname" name="gdname" value="" size="20" /></td>
				<td width="250" style="border: none;">�������룺<input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
				<td width="250" style="border: none;">&nbsp;</td>
			</tr>
			<tr>
				<td width="250" style="border: none;">�����룺<input type="text" id="catid" name="catid" value="" size="20" /></td>
				<td width="250" style="border: none;">������ƣ�<input type="text" id="catname" name="catname" value="" size="20" /></td>
				<td width="250" style="border: none;">
					<div id="gssupidDiv" style="">
						��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" />
					</div>
				</td>
				<td width="250" style="border: none;">&nbsp;</td>
			</tr>
			<tr>
				<td style="border: none;" colspan="4">
					<img src="images/sure.jpg" border="0" onclick="reloadgrid();" /> 
					<img src="images/back.jpg" border="0" onclick="reset();" />
				</td>
			</tr>
			<tr>
				<td id="goodsdetailTd" colspan="4" style="display: none;">
					<table id="goodsdetail"></table>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>