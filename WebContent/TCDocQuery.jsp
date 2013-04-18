<%@ page language="java" contentType="text/html; charset=GBK" import="java.text.SimpleDateFormat,java.util.Date"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�˳�����ѯ</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String suType = currUser.getSutype() + "";
	String sgcode = currUser.getSgcode();
	String supcode = currUser.getSupcode();
	Date date=new Date();
	String startDate_= new SimpleDateFormat("yyyy-MM-dd").format(date);
%>
<script type="text/javascript">
		var now = new Date(); 
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		$(function(){
			$('#TCDoc').datagrid({
				width: 1000,
				nowrap: false,
				striped: true,
				singleSelect: true,
				fitColumns:false,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',	
				columns:[[
				    {field:'BTHBILLNO',title:'�˳�����',width:150,align:'center',sortable:true,
				    formatter:function(value,rec){
						if(value=='�ϼ�')
						return value;
						else
							return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=TCDocDetail('"+rec.BTHBILLNO+"','"+rec.BTHSGCODE+"','"+rec.BTHTHMFID+"');>" + rec.BTHBILLNO + "</a>";
						}
					},
				    {field:'BTHTHMFID',title:'�ŵ���',width:100,align:'center',sortable:true},
					{field:'SHPNAME',title:'�ŵ�����',width:160,sortable:true},
				    {field:'BTHSHTIME',title:'�������',width:100,align:'center',sortable:true},	
					{field:'BTHSL',title:'����',width:80,align:'center',sortable:true},
			        {field:'BTHHSJJJE',title:'���',width:100,align:'center',sortable:true}
					,{field:'BTHSUPID',title:'��Ӧ�̱���',width:80,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:250,align:'center',sortable:true}
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

			$('#TCDocDetail').datagrid({
				width: 1000,
				nowrap: false,
				striped: true,
				singleSelect: true,	
				fitColumns:false,
				remoteSort: true,	
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
					{field:'BTDGDID',title:'��Ʒ����',width:100,sortable:true},
					{field:'BTDBARCODE',title:'��Ʒ����',width:150,sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:250,align:'left',sortable:true},			
				    {field:'GDSPEC',title:'���',width:75,sortable:true},			
				    {field:'GDUNIT',title:'��λ',width:75,align:'center',sortable:true},
				    {field:'BTDSL',title:'�˳�����',width:100,align:'center',sortable:true} ,
					{field:'BTDHSJJ',title:'��˰����',width:100,align:'center',sortable:true} ,
			        {field:'BTDHSJJJE',title:'��˰���۽��',width:150,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true
			});
		});
	
	
		function reloadgrid ()  {
			$('#TCDoc').datagrid('options').url = 'JsonServlet';        
			$('#TCDoc').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getTCDocHead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
						ACTION_MANAGER : 'tcdocQueryManager',	
						list:[{
							sgcode : User.sgcode,
							supcode : $('#supcodequery').val(),
							shopcode : $('#shopcode').attr('value'),// �ŵ����
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#TCDocdatagrid").css("display","");
			$("#QueryTable").css("display","");
			$("#TCDoc").datagrid('reload'); 
			$("#TCDoc").datagrid('resize'); 
    	}
		
    	function TCDocDetail(tcdcode,ssgcode,shopcode){
    		//��ѯ����ֱ�������queryParams��
	        $('#TCDocDetail').datagrid('options').url = 'JsonServlet';        
			$('#TCDocDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
								ACTION_TYPE : 'getTCDocDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
								ACTION_MANAGER : 'tcdocQueryManager',	
								list:[{									
									sgcode : User.sgcode,
									BTLLNO : tcdcode,
									shopcode:shopcode
								}]
					}
				)
			};	
			$("#QueryTable").css("display","none");
			$("#QueryDetailTable").css("display","");
            $("#TCDocDetail").datagrid('reload'); 
			$("#TCDocDetail").datagrid('resize'); 
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getHead',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
							ACTION_MANAGER : 'tcdocQueryManager',	
							list:[{									
								sgcode : User.sgcode,
								BTLLNO:tcdcode,
								shopcode:shopcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	 if( data.rows != undefined && data.rows.length > 0 ){	   
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					           $("#shopname").html(n.BTHTHMFID+'-'+n.SHOPNAME);
					           $("#supname").html(n.BTHSUPID+'-'+n.SUPNAME);
					           $("#memo").html(n.BTHMEMO);
					           $("#shtime").html(n.BTHSHTIME);
					           $("#BTLLNO").html(n.BTHBILLNO);
					           
						        
						       });						        
                    	 }	                    	 
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );

				
    	}
    	
    	function exportExcel(){ 
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getTCDocHead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
								ACTION_MANAGER : 'tcdocQueryManager',										 
								list:[{
									exportExcel : true,
									enTitle: ['BTHBILLNO','BTHTHMFID','BTHSHTIME','SHPNAME','BTHSL','BTHHSJJJE','BTHSUPID','SUPNAME'],
									cnTitle: ['�˳�����','�ŵ����','�������','�ŵ�����','����','���','��Ӧ�̱���','��Ӧ������'],
									sheetTitle: '�˳�����ѯ',
									sgcode : User.sgcode,
									supcode : $('#supcodequery').val(),
									shopcode : $('#shopcode').attr('value'),
									startDate : $('#startDate').attr('value'),	// ��ʼʱ��
									endDate : $('#endDate').attr('value') 		// ����ʱ��
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
    	function backgrid ()  {     		
    		$("#QueryTable").css("display","");
    		$("#QueryDetailTable").css("display","none");
    	}    
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="1000" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="6" align="left" style="border: none; color: #4574a0;">�˳�����ѯ</td>
	</tr>
	<tr>
		<td align="right" width="100">�ŵ꣺</td>
		<td align="left" width="230">
			<select style="width: 155px;" name='shopcode' id="shopcode" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
		<td align="right" width="100">��ʼ���ڣ�</td>
		<td align="left" width="230">
			<input type="text" id="startDate" name="startDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" size="20" />
		</td>
		<td align="right" width="100">�������ڣ�</td>
		<td align="left" width="240">
			<input type="text" id="endDate" name="endDate" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
	</tr>
	<tr>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">��Ӧ�̱��룺</td>
		<td align="left" width="230"  style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="supcodequery" name="supcodequery" size="20" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>"/>
		</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="230">&nbsp;</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="240">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="6" style="border: none;"><img src="images/sure.jpg" border="0" onclick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="6" id="TCDocdatagrid" style="display: none;"><table id="TCDoc"></table></td>
	</tr>
</table>

<table id="QueryDetailTable" width="1000" style="line-height:20px; text-align:left; border:none;font-size: 12px; display: none;">
    <tr>
    	<td height="24" colspan="6" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">�˳�����ϸ</span></td>
    </tr>
	<tr>
		<td align="right" width="100">�˳����� ��</td>
		<td align="left" width="230"><span id="BTLLNO" name="BTLLNO"></span></td>
		<td align="right" width="100">������� ��</td>
		<td align="left" width="230"><span id="shtime" name="shtime"></span></td>
		<td align="right" width="100">�˻��ŵ� ��</td>
		<td align="left" width="240"><span id="shopname" name="shopname"></span> </td>
	</tr>
	<tr>
		<td align="right" width="100">��Ӧ�̣�</td>
		<td align="left" width="230"><span id="supname" name="supname"></span></td>
		<td align="right" width="100">��ע��</td>
		<td align="left" width="570" colspan="3"><span id="memo" name="memo"></span></td>
	</tr>
    <tr>
    	<td colspan="6"><table id="TCDocDetail"></table></td>
    </tr>
    <tr>
   	   <td colspan="6" style="text-align:left">
   	 		<img src="images/goback.jpg" border="0" onclick="backgrid();" />
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