<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�Żݵ���ѯ</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sucode= currUser.getSucode();
	String suType = currUser.getSutype()+"";
%>
<script type="text/javascript">
	var now = new Date();
	now.setDate( now.getDate() - 7 );
	$("#startDate").val( now.format('yyyy-MM-dd') );
	$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
	
	$(function(){
		$('#POP').datagrid({
			width:1000,
			nowrap: false,
			striped: true,
			collapsible:true,
			url:'',		
			singleSelect: true,
			remoteSort: true,
			loadMsg:'��������...',				
			columns:[[
			    {field:'POPSEQUECE',title:'�Żݵ���',width:150,align:'center',sortable:true},
				{field:'PPLB',title:'��������',width:100,align:'center',sortable:true},
				{field:'PPMARKET',title:'�ŵ���',width:60,align:'center',sortable:true},
		    	{field:'SHPNAME',title:'�ŵ�����',width:150,align:'center',sortable:true},
			    {field:'PPGDID',title:'��Ʒ����',width:100,align:'center',sortable:true},				
			    {field:'PPBARCODE',title:'��Ʒ����',width:150,sortable:true},
			    {field:'GDNAME',title:'��Ʒ����',width:250,sortable:true},
			    {field:'PPSHRQ',title:'�������',width:100,sortable:true},
			    {field:'PPKSRQ',title:'��ʼ����',width:65,align:'center',sortable:true},
			    {field:'PPJSRQ',title:'��������',width:65,align:'center',sortable:true},
			    {field:'PPCXSJ',title:'�����ۼ�',width:80,align:'center',sortable:true},
			    {field:'PPYSSJ',title:'ԭ���۵���',width:80,align:'center',sortable:true}
				<%
				if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
					,{field:'PPSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:250,align:'center',sortable:true}
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
	});
        
	function reloadgrid ()  {
        $('#POP').datagrid('options').url = 'JsonServlet';        
		$('#POP').datagrid('options').queryParams = {
			data :obj2str(
				{		
					ACTION_TYPE : 'getPOP',
					ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
					ACTION_MANAGER : 'popQueryManager',	
					list:[{
						sgcode : User.sgcode,
						popsupcode : $('#supcodequery').val(),
						popgdid : $('#gdid').attr('value'),//��Ʒ����
						popgdname : $('#gdname').attr('value'),//��Ʒ����
						popmarket : $('#shopcode').attr('value'),// �ŵ����
						startDate : $('#startDate').attr('value'),
						endDate : $('#endDate').attr('value')
					}]
				}
			)
		};		
		$("#POPdatagrid").show();
		$("#POP").datagrid('reload'); 
		$("#POP").datagrid('resize'); 
   	}   
 
   	function exportExcel(){ 
		$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'getPOP',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
							ACTION_MANAGER : 'popQueryManager',										 
							list:[{
								exportExcel : true,
								<%
								if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
								%>
								enTitle: ['POPSEQUECE','PPLB','PPMARKET','PPGDID','PPBARCODE','GDNAME','PPSHRQ','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ','PPSUPID','SUPNAME'],
								cnTitle: ['�Żݵ���','��������','�ŵ����','��Ʒ����','��Ʒ����','��Ʒ����','�������','��ʼ����','���������','�����ۼ�','ԭ���۵���','��Ӧ�̱���','��Ӧ������'],
								<%}else{%>
								enTitle: ['POPSEQUECE','PPLB','PPMARKET','PPGDID','PPBARCODE','GDNAME','PPSHRQ','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ' ],
								cnTitle: ['�Żݵ���','��������','�ŵ����','��Ʒ����','��Ʒ����','��Ʒ����','�������','��ʼ����','���������','�����ۼ�','ԭ���۵���'],
								<%}%>
								sheetTitle: '��Ʒ�Żݵ���ѯ',
								sgcode : User.sgcode,
								popsupcode : $('#supcodequery').val(),
								popgdid : $('#gdid').attr('value'),//��Ʒ����
								popgdname : $('#gdname').attr('value'),//��Ʒ����
								popmarket : $('#shopcode').attr('value'),// �ŵ���� 
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
   //��ȡ�����ŵ���Ϣ
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
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
					            $(list).append(html);  
					        });						        
                    	 }	                    	 
                    	 $(list).attr('isLoad' , true );
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );				
		}
	}

</script>
</head>
<body>
<center>
<table id="QueryTable" width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="6" align="left" style="border: none; color: #4574a0;">��Ʒ�Żݵ���ѯ</td>
	</tr>
	<tr>
		<td align="right" width="100">�ŵ꣺</td>
		<td align="left" width="230">
			<select style="width: 154px;" name='shopcode' id="shopcode" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
		<td align="right" width="100">��ʼ���ڣ�</td>
		<td align="left" width="230">
			<input type="text" id="startDate" name="startDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td align="right" width="100">�������ڣ�</td>
		<td align="left" width="240">
			<input type="text" id="endDate" name="endDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
	</tr>
	<tr>
		<td align="right" width="100">��Ʒ���룺</td>
		<td align="left" width="230"><input type="text" id="gdid" name="gdid" size="20"/></td>
		<td align="right" width="100">��Ʒ���ƣ�</td>
		<td align="left" width="230"><input type="text" id="gdname" name="gdname" size="20"/></td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">��Ӧ�̱��룺</td>
		<td align="left" width="240" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="supcodequery" name="supcodequery" size="20" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>"/>
		</td>
	</tr>
	<tr>
	</tr>
	<tr>
		<td colspan="6"><img src="images/sure.jpg" border="0" onclick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="6" id="POPdatagrid"  style="display: none">
			<table id="POP"></table>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>