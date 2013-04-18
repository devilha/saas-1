<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>	
	<title>������Ϣ��ѯ</title>
	
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode = currUser.getSgcode();
	String suType = currUser.getSutype() + "";
%>
<style>
	.underLine{
		border:0px;
		border-bottom:#000 1px solid;
		overflow:hidden;
	}
</style>
	<script type="text/javascript">
		$(function(){
			// ��䶩��ͷ�б�
			$('#orderSearchSupList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect : true,
				showFooter:true,
				remoteSort: true,
				fitColumns:false,
				idField: 'BOHBILLNO',
				loadMsg:'��������...',
				columns:[[
						{field:'BOHBILLNO',title:'�������',width:150,sortable:true,
							formatter:function(value,rec){
							var supname3=(rec.SUNAME+'').replace(/\ /g,'');
								return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showOrderDet("'+ rec.BOHBILLNO +'","'+rec.BOHMFID+'","'+rec.BOHSUPID+'","'+rec.SHPNAME+'","'+supname3+'","'+rec.BOHDHRQ+'","'+rec.BOHJHRQ+'","'+rec.BOHQXTIME+'");>' + value + '</a>';
							}
						},	
						{field:'BOHMFID',title:'�ŵ���',width:100,sortable:true},
						{field:'SHPNAME',title:'�ŵ�����',width:200,sortable:true},
						{field:'BOHDHRQ',title:'��������',width:150,sortable:true},
						{field:'BOHJHRQ',title:'�ͻ�����',width:150,sortable:true},
						{field:'SL',title:'��������',width:100,sortable:true},
						{field:'JE',title:'��˰���۽��',width:150,sortable:true}
						<%if("L".equals(suType)){%>
						,{field:'BOHSUPID',title:'��Ӧ�̱��',width:100,sortable:true},
						{field:'SUNAME',title:'��Ӧ������',width:250,sortable:true}
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
			
			// ��䶩����ϸ�б�
			$('#orderDetSupList').datagrid({
				width: 1000,
				nowrap: false,
				striped: true,	
				url:'',			
				sortOrder: 'asc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'��������...',				
				showFooter:true,
				rownumbers:true,				
				columns:[[	
					{field:'BODGDID',title:'��Ʒ����',width:100,align:'left'},
					{field:'GDNAME',title:'��Ʒ����',width:300,align:'left'},
					{field:'GDBARCODE',title:'��Ʒ����',width:100,align:'left'},
					{field:'GDSPEC',title:'��Ʒ���',width:70,align:'left'},
					{field:'GDUNIT',title:'��λ',width:70,align:'left'},
					{field:'BODSL',title:'��������',width:60,align:'left'}, 
					{field:'BODTAX',title:'˰��',width:50,align:'left'},
					{field:'BODHSJJ',title:'��˰����',width:100,align:'left'},
					{field:'BODHSJJJE',title:'��˰���۽��',width:150,align:'left'}		
				]]
			});
		});
		
		
		function exportExcel(){
			var searchData = getFormData( 'orderSearchHTSearch' ); 
			if(User.sutype == 'L'){
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ','SL','JE','BOHSUPID','SUNAME'];
			    searchData['cnTitle'] = ['�������','�ŵ���','�ŵ�����','��������','�ͻ�����','��������','��˰���۽��','��Ӧ�̱��','��Ӧ������'];
			}else{
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ','SL','JE'];
				searchData['cnTitle'] = ['�������','�ŵ���','�ŵ�����','��������','�ͻ�����','��������','��˰���۽��'];
			} 
			searchData['bohsupid'] = $('#bohsupid').val();  		// ��Ӧ�̱���
			searchData['bohsgcode'] = User.sgcode;  // ʵ������
			searchData['exportExcel'] = true;
			searchData['sheetTitle'] = '������Ϣ��ѯ';
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'SearchYwBorderhead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderhead',
								ACTION_MANAGER : 'ywBorderhead',											 
								list:[searchData]
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

		// ���ض���ͷ�б�
		function reloadgrid()  { 
        	var searchData = getFormData( 'orderSearchHTSearch' ); 
			searchData['bohsupid'] = $('#bohsupid').val();  		// ��Ӧ�̱���
			searchData['bohsgcode'] = User.sgcode;  // ʵ������
	        //��ѯ����ֱ�������queryParams��
	        $('#orderSearchSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderSearchSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchYwBorderhead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderhead',
						ACTION_MANAGER : 'ywBorderhead',
						optType : 'query',
						optContent : '��ѯ����',			 
						list:[	searchData	]
					}
				)
			};        
			$("#orderSearchSupListTD").show();			
			$("#orderSearchSupList").datagrid('reload');
			$("#orderSearchSupList").datagrid('resize');   
    	}
    	
    	// ��ȥ������ϸ�ķ���
		function showOrderDet( bohbillc,shopid ,BOHSUPID,SHPNAME,SUNAME,dhrq,jhrq,qxrq){
			if(jhrq=="null"){
				jhrq="";
			}
			var data;
			$('#bohbillno_').empty().append(bohbillc); // �������
			$('#bohsupid_').empty().append(BOHSUPID);	// ��Ӧ�̱��
			$('#bohsupid_').append(SUNAME);				// ��Ӧ������
			$('#bohdhrq_').empty().append(dhrq); // ��������
			$('#bohjhrq_').empty().append(jhrq);	// �ͻ�����
			$('#bohqxrq_').empty().append(qxrq );	// ��Ч����
			$('#bohmfid_').empty().append(shopid);		// �ջ��ŵ���
			$('#bohmfid_').append(SHPNAME);				// �ջ��ŵ�����
			
			// ���������(��ӡ��)
			$('#bohbillno_hidden').val(bohbillc);
			$('#bohmfid_hidden').val(shopid);
					
	        //��ѯ����ֱ�������queryParams��
	        $('#orderDetSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderDetSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchYwBorderdet',
						ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderdet',
						ACTION_MANAGER : 'ywBorderdet',		 
						list:[{
							bodbillno : bohbillc,
							bodsgcode : User.sgcode,
							bodshmfid :shopid
						}]
					}
				)
			};
			
			$( '#orderSearchHTSearch' ).hide();
			$( '#orderDetHT' ).show();			        
			$("#orderDetSupList").datagrid('reload');
			$("#orderDetSupList").datagrid('resize'); 
		}
		
		// ���ض���ͷҳ
		function returnFirst(){
			$( '#orderSearchHTSearch' ).show();
			$( '#orderDetHT' ).hide(); 
			reloadgrid();
		}
		
		// ��ϸҳ��[��ӡ]��ť�¼�
		function printOrder(){
			var mfid = $('#bohmfid_hidden').val();
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ��ӡ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'addYwBorderstatus',
									ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderstatus',
									ACTION_MANAGER : 'ywBorderstatus',
									optType : 'update',
									optContent : '��ӡ����',	
									list:[{
										bohsgcode : User.sgcode,    			  // ʵ������
										bohbillno : $('#bohbillno_hidden').val(), // �������
										bohshmfid : mfid,   // �ŵ���
										bohstatus : ''      					  // ����״̬
									}]
							})
							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){	                    	 
		                    	
		                    }else{ 
		                        $.messager.alert('��ʾ','��ӡ����ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                        return;
		                    } 
		            	},
		            	'json'
					);
				
				
	                var bodsgcode = User.sgcode; 					 // ʵ������
					var bodbillno = $('#bohbillno_hidden').val(); 	 // �������
					var bodshmfid = $('#bohmfid_hidden').val(); 	 // �ŵ���
	                //��url��ָ����ӡִ��ҳ��
	                var url = "print_order.jsp?bodsgcode=" + bodsgcode + "&bodbillno=" + bodbillno + "&bodshmfid=" + bodshmfid;					
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
				}
			});
		}		
		// �����ŵ�����������
		function loadSupShop( list ){ 
			if( $(list).attr('isLoad') == undefined ){
				$(list).attr('isLoad' , true );
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
	                    	 	$.each( data.rows, function(i, n) { 
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 
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
<table id="orderSearchHTSearch" style="line-height:20px;border:none; font-size:12px;margin:auto;width:1000px;" align="center"> 
	<tr> 
		<td colspan="6" align="left" style="border:none; color:#4574a0;">������Ϣ��ѯ</td> 
	</tr>
	<tr>
		<td align="right" width="100">������ţ�</td>
		<td align="left" width="230"><input type="text" name="bohbillno" id="bohbillno" value="" width="110" /> </td>
		<td align="right" width="100">��ʼ���ڣ�</td>
		<td align="left" width="230"><input type="text" name="startDate" id="startDate" value="" size="20"  onClick="WdatePicker();" /> </td>
		<td align="right" width="100">�������ڣ�</td>
		<td align="left" width="240"><input type="text" name="endDate" id="endDate" value="" size="20"  onClick="WdatePicker();" /> </td>
	</tr> 
	<tr>
		<td align="right" width="100">�ŵ����ƣ�</td>
		<td align="left" width="230">
			<select style="width:155px;" name='bohmfid' id="bohmfid" size='1' onclick="loadSupShop(this);">
            			<option value = ''>�����ŵ�</option>
    				</select>
		</td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">��Ӧ�̱��룺</td>
		<td align="left" width="230" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="bohsupid" name="bohsupid" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>"  size="20" />
		</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="240">&nbsp;</td>
	</tr>

	<tr> 
		<td colspan="6" style="border:none;"> 
			<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
		</td> 
	</tr>
	<tr>
		<td id="orderSearchSupListTD" colspan="6" style="border: none; display: none;">
			<table id="orderSearchSupList"></table>
		</td>
	</tr> 
</table>
<!-- ��ѯ�����������  -->
		
	
<!-- ��һ��ҳ�� �б�ҳ ����  -->
	
<!-- �ڶ���ҳ�� ��ϸҳ ��ʼ display:none;-->		
<!-- (2)��ϸ����ʼ -->
<table id="orderDetHT" width="100" style="line-height:20px;border:none;font-size: 12;display: none" align="center">
   <tr><th colspan="6" style="align:center;font-size:24px;">������ϸ</th></tr>
   <tr>
     <td width="100" align="right">������ţ�</td>
     <td width="230" align="left"><span id="bohbillno_"></span></td>
     <td width="100" align="right">�������ڣ�</td> 
     <td width="230" align="left"><span id="bohdhrq_"></span></td>
     <td width="100" align="right">�ͻ����ڣ�</td>
     <td width="230" align="left"><span id="bohjhrq_"></span></td>
   </tr>
   <tr>
     <td width="100" align="right">�ջ��ŵ꣺</td>
     <td width="230" align="left"><span id="bohmfid_"></span></td>
     <td width="100" align="right">��Ӧ�̣�</td>
     <td width="570" align="left" colspan="3"><span id="bohsupid_"></span></td>
   </tr>
   <tr><td colspan="6"><table id="orderDetSupList"></table></td></tr>
   <tr>
      <td colspan="3" style="border:none;">	
		<a href="javascript:void(0);"><img src="images/goback.jpg" border="0" onclick="returnFirst();"/></a>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0);"><img src="images/print.jpg" border="0" onclick="printOrder();"/></a>			
      </td>
   </tr>
</table>
        <!-- (2)��ϸ������ -->
<!-- (1)���⿪ʼ -->
<span id="detTitle" style="color:008CFF;font-size:20px"></span>
<input type="hidden" id="bohbillno_hidden">
<input type="hidden" id="bohmfid_hidden"><br>
<!-- (1)������� -->
<!-- �ڶ���ҳ�� ��ϸҳ ���� -->
</center>	
</body>
</html>