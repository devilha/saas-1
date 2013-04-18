<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ�����ϸ��ѯ</title>
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}		
	SysScmuser currUser = (SysScmuser)obj;
	String suType = currUser.getSutype() + "" ;
%>
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">
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
  
	$(function(){
		$('#stockDetail').datagrid({
			width: 1000,
			iconCls:'icon-save',
			nowrap: false,
			striped: true,
			collapsible:true,
			url:'',
			sortOrder: 'desc',
			remoteSort: true,	
			singleSelect : true,
			fitColumns:false,
			showFooter:true,	
			loadMsg:'��������...',				
			columns:[[
				{field:'ZSGXTIME',title:'���ͳ������',width:80,align:'center',sortable:true,
					   formatter:function(value,rec){
						if( value != null && value != undefined && value != '�ϼƣ�' )
							return new Date(value.time).format('yyyy-MM-dd');
							else 
							return value;
					}
				},
				{field:'ZSMFID',title:'�ŵ����',width:60,align:'center',sortable:true}, 
				{field:'SHPNAME',title:'�ŵ�����',width:160,align:'left',sortable:true},
				{field:'ZSGDID',title:'��Ʒ����',width:60,align:'center',sortable:true},
				{field:'ZSBARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},
				{field:'GDNAME',title:'��Ʒ����',width:250,align:'left',sortable:true},
				{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
				{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true},
				{field:'GDSPEC',title:'���',width:45,align:'center',sortable:true},
				{field:'GDUNIT',title:'��λ',width:45,align:'center',sortable:true}
				<%if("L".equals(suType)){%>
				,{field:'ZSSUPID',title:'��Ӧ�̱���',width:70,align:'center',sortable:true},	
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
	        $('#stockDetail').datagrid('options').url = 'JsonServlet';        
			$('#stockDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'ywZrstockDetails',		 
						optType : 'query',
						optContent : '���տ����Ʒ��ϸ��ѯ',		 
						list:[{
						 sgcode : User.sgcode,
						 supcode : $('#supcode').val(),
						 zsmfid : $('#zsmfid').attr('value'),
						 zsgdid : $('#zsgdid').attr('value'),
						 zsgdname : $('#zsgdname').attr('value'),
						 gdbarcode :$('#gdbarcode').attr('value')
						}]
					}
				)
			};		
			
			$("#stockDetailList").show();
			$("#stockDetail").datagrid('reload'); 
			$("#stockDetail").datagrid('resize'); 
    	}
    	function exportExcel(){
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
								ACTION_MANAGER : 'ywZrstockDetails',											 
								list:[{
									exportExcel : true,
									<%if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
									enTitle: ['ZSGXTIME','ZSMFID','SHPNAME','ZSGDID','ZSBARCODE','GDNAME','GDSPEC','GDUNIT','ZSSUPID','SUPNAME','ZSKCSL','ZSKCJE' ],
									cnTitle: ['���ͳ������','�ŵ���','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��Ӧ�̱���','��Ӧ������','�������','�����(����˰)'],
									<%}else{%>
									enTitle: ['ZSGXTIME','ZSMFID','SHPNAME','ZSGDID','ZSBARCODE','GDNAME','GDSPEC','GDUNIT','ZSKCSL','ZSKCJE' ],
									cnTitle: ['���ͳ������','�ŵ���','�ŵ�����','��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','�������','�����(����˰)'],
									<%}%>
									sheetTitle: '���տ����Ʒ��ϸ��ѯ',
									sgcode : User.sgcode,
									supcode : $('#supcode').val(),
									zsmfid : $('#zsmfid').attr('value'),
									zsgdid : $('#zsgdid').attr('value'),
									zsgdname : $('#zsgdname').attr('value')
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
 	</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="6" align="left" style="border: none; color: #4574a0;">���տ����Ʒ��ϸ��ѯ</td>
	</tr>
	<tr>
		<td align="right" width="100">�ŵ꣺</td>
		<td align="left" width="230">
			<select style="width: 155px;" name='zsmfid' id="zsmfid" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
		<td align="right" width="100">��Ʒ���ƣ�</td>
		<td align="left" width="230">
			<input type="text" id="zsgdname" name="zsgdname" value="" size="20"/>
		</td>
		<td align="right" width="100">��Ʒ���룺</td>
		<td align="left" width="240"><input type="text" id="zsgdid" name="zsgdid" value="" size="20"/></td>
	</tr>
	<tr>
		<td align="right" width="100">��Ʒ���룺</td>
		<td align="left" width="230"><input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">��Ӧ�̱��룺</td>
		<td align="left" width="230" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="supcode" name="supcode" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>" size="20" />
		</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="240">&nbsp;</td>
	</tr>
	<tr>
	<td colspan="6">
		<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />     
	</tr>
	<tr>
		<td colspan="6" id="stockDetailList" style="display: none;">
			<table id="stockDetail" ></table>
		</td>
	</tr>	
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("zsmfid");
loadAllShop(obj);
</script>
</html>