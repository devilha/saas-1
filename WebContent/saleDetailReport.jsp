<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ������ϸ��ѯ</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		String sucode= currUser.getSucode();
		//��þ�Ӫ��ʽ
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script><!--
	    var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
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
				$('#saleDetail').datagrid({
				width:1000,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
				    {field:'GSGDID',title:'��Ʒ����',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if(value == '�ϼ�'){
			        			return value;
			        		}else{
			        			var gdid = "'" + rec.GSGDID + "'";
			        			var gdbarcode = "'" + rec.GSBARCODE + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+gdbarcode+','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
			        {field:'GSBARCODE',title:'��Ʒ����',width:160,align:'center',sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:300,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'���',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},		
				    {field:'GSXSSL',title:'��������',width:90,align:'center',sortable:true},   
				    {field:'GDPPNAME',title:'Ʒ������',width:92,align:'center',sortable:true},
					{field:'GSHSJJJE',title:'��˰���۳ɱ�',width:100,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSSR',title:'��������',width:100,align:'center',sortable:true},
					{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:250,align:'left',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			}); 
			
			
			//
			$('#itemStock').datagrid({
				width:1000,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'KCRQ',title:'�������',width:100,align:'center',sortable:true},
					{field:'ZSMFID',title:'�ŵ����',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'�ŵ�����',width:160,align:'left',sortable:true},
				    {field:'ZSGDID',title:'��Ʒ����',width:100,align:'center',sortable:true},
					{field:'ZSBARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:300,align:'left',sortable:true},
					{field:'ZSKCSL',title:'�������',width:80,align:'center',sortable:true},
					{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:250,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			//����ǹ�Ӧ���û������ع�Ӧ�̱�������򣬷�����ʾ
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(1110);
				$("#mainTab").width(1110);
				$("#mainTabTd").width(380);
				$("#mainTabStartDateTd").width(450);
			}else{
				$("#supcodeDiv").hide();
			}
		});		
		
		function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
		  var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getSaleDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3006".equals(currUser.getSgcode())){
									%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3026".equals(currUser.getSgcode())){%>
									enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
									cnTitle: ['��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','��λ','��������','��������','���۳ɱ�'],
									<%}else if("3027".equals(currUser.getSgcode())){%>
									enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSXSJE','GSVENDREBATE' ],
									cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��˰��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
									<%
									}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','�ۼ�','��������'],
									<%
									}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','����С��','���С��'],
									<%}else{%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','��Ӧ�̱���','��Ӧ������','���','��λ','��������','��������'],
									<%
									}
									}else{
										if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['��Ʒ����','��Ʒ����','���','��λ','��������','���۳ɱ�'],
									<%}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE','GSVENDREBATE'],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSVENDREBATE'],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','��˰��������','��Ӧ�̳е��ۿ�'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������','�ۼ�','��������'],
									<%}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','����С��','���С��'],
									<%}else{%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
											cnTitle: ['��������','��Ʒ����','��Ʒ����','���','��λ','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>],
										<%}
									}
									}%>
									sheetTitle: '��Ʒ������ϸ��ѯ',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// �ŵ����
									supcode : supcode,					// ��Ӧ�̱���						
									gsgdid : $('#gsgdid').attr('value'), // ��Ʒ����
									gdppname : $('#gdppname').attr('value'), //Ʒ������
									gsgdname : $('#gsgdname').attr('value'), // ��Ʒ����
									gdbarcode : $('#gdbarcode').attr('value'), // ��Ʒ����
									startDate : $('#startDate').attr('value'),//��ʼ����
									endDate : $('#endDate').attr('value')     //��������
									//,
									//category : $("#category").val() //Ʒ������
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
		
		function reloadgrid ()  {
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���  
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),// �ŵ����
							gdppname : $('#gdppname').attr('value'), //Ʒ������
							gsgdid : $('#gsgdid').attr('value'), // ��Ʒ����
							gdbarcode : $('#gdbarcode').attr('value'), // ��Ʒ����
							gsgdname : $('#gsgdname').attr('value'), // ��Ʒ����
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#itemStockdatagrid").hide();
			$("#saledatagrid").show();
			$("#saleDetail").datagrid('reload'); 
			$("#saleDetail").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
			
    	}
    	
    	function reloadItemStockgrid (gdid,barcode,SUPID)  { 
	        $('#itemStock').datagrid('options').url = 'JsonServlet';        
			$('#itemStock').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'), 		// ����ʱ��
							zsmfid : $('#gsmfid').attr('value'),	
							zsgdid : gdid,
							gdbarcode : barcode
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#itemStockdatagrid").show();
			$("#itemStock").datagrid('reload');
			$("#itemStock").datagrid('resize');  
    	}
    	
    	function backgrid ()  {     		
    		$("#itemStockdatagrid").hide(); 
			$("#saledatagrid").show();    	 
    	}   

    	   
 	--></script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ��ϸ��ѯ<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">��ʼ���ڣ�<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;�������ڣ�<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺<select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>
	</tr>
	<tr>
		<td style="border: none;">��Ʒ���룺<input type="text" id="gsgdid" name="gsgdid"/></td>
		<td style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;��Ʒ���ƣ�<input type="text" id="gsgdname" name="gsgdname"/></td>
		<td style="border: none;">��Ʒ���룺<input type="text" id="gdbarcode" name="gdbarcode"/></td>
	</tr>
	<tr>
		<td style="border: none;">Ʒ�����ƣ�<input type="text" id="gdppname" name="gdppname"/></td>
		<td style="border: none;" id="supcodeDiv">
			��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" />
		</td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onClick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	
	<tr>
		<td colspan="3" id="saledatagrid" style="display: none;">
			<table id="saleDetail"></table>
		</td>
	</tr>
	
	<tr>
		<td colspan="3" id="itemStockdatagrid" style="display: none;">
			<table id="itemStock"></table>
			<br>
			<img src="images/goback.jpg" border="0" onClick="backgrid();" />
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>