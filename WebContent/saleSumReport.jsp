<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
		//��þ�Ӫ��ʽ
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>

<title>���ۻ��ܲ�ѯ</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script>	 
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'))
	    
	    function reloadItemStockgrid (zsgdid,SUPID)  {
    		//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱��� 
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
	        //��ѯ����ֱ�������queryParams��
	        $('#itemStockList').datagrid('options').url = 'JsonServlet';   
			$('#itemStockList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsDetailStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').val(),	// ��ʼʱ��
							endDate : $('#endDate').val(), 		// ����ʱ��
							zsmfid : $('#gsmfid').val(),	
							zsgdid : zsgdid					
						}]
					}
				)
			}; 
			$("#saledatagrid").hide();		
			$("#stockdatagrid").show();		
			$("#itemStockList").datagrid('reload');  
			$("#itemStockList").datagrid('resize');   
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
		
		$(function(){
			$('#saleShopSummary').datagrid({	
			    title: '',	
				width: User.sutype == 'L' ? 836 : 836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',			
				columns:[[
					{field:'GDBARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '�ϼ�'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
				    },
				    {field:'GDID',title:'��Ʒ����',width:100,align:'center',sortable:true},	
				    {field:'GDNAME',title:'��Ʒ����',width:150,align:'left',sortable:true},
				    {field:'GDSPEC',title:'���',width:100,align:'center',sortable:true},
					{field:'GDUNIT',title:'��λ',width:100,align:'center',sortable:true},
					{field:'GSXSSL',title:'��������',width:100,align:'center',sortable:true},
					<%if("3011".equals(currUser.getSgcode())){%>
					{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSHSJJJE',title:'���۳ɱ�',width:100,align:'center',sortable:true},
						{field:'TEMP5',title:'��ͬ����',width:100,align:'center',sortable:true}
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true},
						{field:'TEMP5',title:'��ͬ����',width:100,align:'center',sortable:true}
					<%}else{%>
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,width:100,align:'center',sortable:true},
						{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true}
						<%if("3007".equals(currUser.getSgcode().toString())){%>,{field:'TEMP5',title:'��ͬ����',width:100,align:'center',sortable:true}<%}%>
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},
					{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
				    <%
					}
					%>	
					<%if("L".equalsIgnoreCase( currUser.getSutype().toString())  && "3027".equals(currUser.getSgcode())){%>
					,{field:'TEMP5',title:'��ͬ����',width:100,align:'center',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true	
			});
			
			//����������̣�����ʾ��Ӧ�������
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#temp5sDiv").show();
			    $("#temp5Div").hide();
				$("#saleExportExcel").width(836);
			}else{
				$("#temp5Div").show();
				$("#temp5sDiv").hide();
				$("#supcodeDiv").hide();
			}
			//
			
			//
			$('#itemStockList').datagrid({
				width:  User.sutype == 'L' ? 935 : 685,
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
					{field:'SHPCODE',title:'�ŵ����',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'�ŵ�����',width:300,align:'center',sortable:true},	
				     <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true,formatter:function(value,rec){
							if(parseFloat(value)>0){
								return value;
							}else{
								return 0;
							}
						}},
						{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined && parseFloat(value)>0){
								return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
							}else{
								return 0;
							}
						}}
					<%}else{%>
						{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
						{field:'ZSKCJE',title:'�����۽��',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
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
				$("#temp5sDiv").show();
			    $("#temp5Div").hide();
				$("#saleExportExcel").width(1110);
				$("#mainTab").width(1110);
				$("#mainTabTd").width(380);
				$("#mainTabStartDateTd").width(450);
			}else{
				$("#temp5sDiv").hide();
			    $("#temp5Div").show();
				$("#supcodeDiv").hide();
			}
		});		
		
		
		//��ѯ
		function reloadgrid (value)  {  
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			var temp5 = '';
			if(User.sutype == 'L'){
			    temp5 = $("#temp5s").val();
				supcode = $("#supcode").val();
			}else{
			    temp5 = $("#temp5").val();
				supcode = User.supcode;
			}  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleSum',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
						    temp5 : temp5,
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),        //�ŵ�
							gdbarcode : $('#gdbarcode').attr('value'),        //��Ʒ����
							gsgdname : $('#gsgdname').attr('value'),        //��Ʒ����
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value') 		// ����ʱ��
						}]
					}
				)
			};	
			/*
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();		
			$("#saledatagrid").hide();	
			*/	
			$("#saledatagrid").show();
			$("#stockdatagrid").hide();
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
    	}  	     	

		function backSaleGsrqgrid ()  {
    		$("#stockdatagrid").hide(); 
			$("#saledatagrid").show();   
    	}  
    	
    	//����excel
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
		var temp5 = '';
	    if(User.sgcode=='3007'){
			if(User.sutype == 'L'){
			    temp5 = $("#temp5s").val();
				supcode = $("#supcode").val();
			}else{
			    temp5 = $("#temp5").val();
				supcode = User.supcode;
			}
		 }
 
			if(User.sgcode=='3007'){
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		

								ACTION_TYPE : 'getSaleSum',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
										enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','TEMP5','GSSUPID','SUPNAME' ],
										cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,'���۽��','��ͬ����','��Ӧ�̱���','��Ӧ������'],
									<%
									}else{
									%>
										enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','TEMP5' ],
										cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,'���۽��','��ͬ����'],
									<%}%>
									sheetTitle: '���ۻ��ܲ�ѯ',
									temp5 : temp5,
									gssgcode : User.sgcode,
									supcode : supcode,                          // ��Ӧ�̱���
									startDate : $('#startDate').attr('value'),	// ��ʼʱ��
									endDate : $('#endDate').attr('value'), 		// ����ʱ��
									gsmfid : $('#gsmfid').attr('value'),        //�ŵ�
									gdbarcode : $('#gdbarcode').attr('value'),        //��Ʒ����
									gsgdname : $('#gsgdname').attr('value')        //��Ʒ����
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
			}else{
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',

								ACTION_TYPE : 'getSaleSum',

								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString())){
										if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','GSHSJJJE','GSXSJE','GSSUPID','SUPNAME' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','�ۼ�','���۳ɱ�','���۽��','��Ӧ�̱���','��Ӧ������'],
										<%}else{%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE','GSSUPID','SUPNAME' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','���۳ɱ�','���۽��','��Ӧ�̱���','��Ӧ������'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','���۳ɱ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','���۽��'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','GSHSJJJE','GSXSJE' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','�ۼ�','���۳ɱ�','���۽��'],
										<%}else{%>
											enTitle: ['GDBARCODE','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSHSJJJE','GSXSJE' ],
											cnTitle: ['��Ʒ����','��Ʒ����','��Ʒ����','���','��λ','��������','���۳ɱ�','���۽��'],
										<%}
									}%>
									sheetTitle: '���ۻ��ܲ�ѯ',
									gssgcode : User.sgcode,
									supcode : supcode,                          // ��Ӧ�̱���
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
			
		}
	</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ���ܲ�ѯ<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">��ʼ���ڣ�<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">�������ڣ�<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" align="right" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺ <select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>
	</tr>
	<tr>
		<!-- <td colspan="1" style="border: none;">Ʒ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ƣ� <select
			style="width: 150px;" name='category' id="category" size='1'
			onclick="loadAllBrand(this);">
			<option value=''>����Ʒ��</option>
		</select></td> -->

		<td width="250" style="border: none;">��Ʒ���룺<input type="text"
			id="gdbarcode" name="gdbarcode" width="110" value="" /></td>

		<td style="border: none;">��Ʒ���ƣ�<input type="text" id="gsgdname"
			name="gsgdname" width="110" /></td>
		<td style="border: none;" align="right" >
			
	        <%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else{%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
			
			<%if("3007".equals(currUser.getSgcode())&&!("L".equalsIgnoreCase( currUser.getSutype().toString()))){%>
			<div id="temp5Div" style="">��ͬ���룺<input type="text" id="temp5" name="temp5" value="" size="20" /></div>
			<%} %>
			
		</td>
	</tr>
	<tr>
	
		<td width="250"  style="border: none;">
			<%if("3007".equals(currUser.getSgcode())&&"L".equalsIgnoreCase( currUser.getSutype().toString())){%>
			<div id="temp5sDiv" style="">��ͬ���룺<input type="text" id="temp5s" name="temp5s" value="" size="20" /></div>
			<%} %>		
			
		</td>
		
			<td style="border: none;"><input type="hidden" id="gdbarcode"
			name="gdbarcode" value="" /></td>

		<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 786px">
					<a href="javascript:exportExcel();">>>����Excel���</a>
				</div>
				<table id="saleShopSummary" width="786" ></table>
			</div>
		</td>
	</tr>
	
	<tr>
		<td colspan="3">
			<div id="stockdatagrid" style="display: none;">
				<table id="itemStockList"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">����</a> -->
					<img src="images/goback.jpg" border="0" onclick="backSaleGsrqgrid();" />
				</div>
			</div>
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





