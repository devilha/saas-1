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
		String suType = currUser.getSutype() + "";
	%>

<title>���ۻ��ܲ�ѯ</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">	 
		var now = new Date(); 
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
	    
		$(function(){
			$('#saleShopSummary').datagrid({	
				width: 836 ,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[				
					{field:'SHPCODE',title:'�ŵ����',width:150,align:'center',
						formatter:function(value,rec){
								if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
								var shopCode = "'" + value + "'";
								var supid = "'" + rec.GSSUPID + "'";
								return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadShopSalegrid(' +  shopCode + ','+ supid +');">' + value + '</a>';											
						}
					},
					{field:'SHPNAME',title:'�ŵ�����',width:"<%if("S".equals(suType)){%>300<%}else{%>200<%}%>",align:'left',sortable:true},
					{field:'GSXSSL',title:'��������',width:"<%if("S".equals(suType)){%>170<%}else{%>120<%}%>",align:'center',sortable:true},				
					{field:'GSHSJJJE',title:'���۳ɱ�', width:"<%if("S".equals(suType)){%>183<%}else{%>120<%}%>",sortable:true,align:'center'}
					<% if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){ %>
					,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true},
					{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:200,align:'left',sortable:true}
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
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(836);
			}else{
				$("#supcodeDiv").hide();
			}
			
			//
			$('#saleShopDetail').datagrid({		
				title: '',	
				width: 836,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				singleSelect: true,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[
			        {field:'GSRQ',title:'��������',width:"<%if("S".equals(suType)){%>200<%}else{%>100<%}%>",align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}	
			        		var gsrq = "'" + value + "'";
			        		var supid = "'" + rec.GSSUPID + "'";
			        		return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadGsrqSalegrid(' +  gsrq + ','+supid+');">' + value + '</a>';	       		        	 	        		
						
						}
			        },
					{field:'GSXSSL',title:'��������',width:"<%if("S".equals(suType)){%>300<%}else{%>120<%}%>",sortable:true,align:'center'},
					{field:'GSHSJJJE',title:'���۳ɱ�',width:"<%if("S".equals(suType)){%>305<%}else{%>120<%}%>",sortable:true,align:'center'} 
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSJE',title:'���۽��',width:100,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'GSSUPID',title:'��Ӧ�̱���',width:111,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:250,align:'left',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true			
			});
			
			$('#saleGsrqDetail').datagrid({
				width: 836,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				fitColumns:false,			
				remoteSort: true,	
				singleSelect: true,	
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[	
						{field:'GSGDID',title:'��Ʒ����',width:80,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}			  
			        		else
			        		{
			        			if(value == '�ϼ�'){
									return "<span style='color:#4574a0; font-weight:bold;'>"+value+"</span>";
								}
			        			var gdid = "'" + value + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        				return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' +  gdid + ','+supid+');">' + value + '</a>';	
			        		} 							
						}
			        },
			        {field:'GSBARCODE',title:'��Ʒ����',width:120,align:'left',sortable:true},	
				    {field:'GDNAME',title:'��Ʒ����',width:297,align:'left',sortable:true},	
				    {field:'GDSPEC',title:'���',width:80,align:'center',sortable:true},
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},
					{field:'GSXSSL',title:'��������',width:80,align:'center',sortable:true}			
					,{field:'GSHSJJJE',title:'���۳ɱ�',width:90,align:'center',sortable:true}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSJE',title:'���۽��',width:100,align:'center',sortable:true}
					,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:250,align:'center',sortable:true}
					<%}%>	
				]],
				pagination:true,
				rownumbers:true
			});

			$('#ItemStock').datagrid({
				width:836,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				showFooter:true,
				fitColumns:false,				
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'ZSMFID',title:'�ŵ����',width:80,align:'center',sortable:true},
				    {field:'SHPNAME',title:'�ŵ�����',width:120,align:'left',sortable:true},	
					{field:'ZSGDID',title:'��Ʒ����',width:100,align:'center',sortable:true},
				    {field:'ZSBARCODE',title:'��Ʒ����',width:120,align:'center',sortable:true},	
					{field:'GDNAME',title:'��Ʒ����',width:300,align:'left',sortable:true},
					{field:'ZSKCSL',title:'�������',width:80,align:'center',sortable:true},
					{field:'ZSKCJE',title:'�����۽��',width:80,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:200,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true	
			});
		});			
		
		//����excel
		function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			if(User.sutype == 'L' ){
			supcode = $('#supcode').val();
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<% if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSXSJE','GSHSJJJE','GSSUPID','SUPNAME' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۽��','���۽��','��Ӧ�̱���','��Ӧ������'],
									<%}else{%>
										enTitle: ['SHPCODE','SHPNAME','GSXSSL','GSHSJJJE' ],
										cnTitle: ['�ŵ����','�ŵ�����','��������','���۽��'],
									<%}%>
									sheetTitle: '���ۻ��ܲ�ѯ',
									gssgcode : User.sgcode,
									userType : User.sutype,
									supcode : supcode,       
									gsmfid : $('#gsmfids').attr('value'),                   // ��Ӧ�̱���
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
		
		function reloadgrid (value)  {  
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
			var supcode = '';
			 if(User.sutype == 'L'){
			supcode = $('#supcode').val();
			}else {
			supcode = User.supcode;
			}  
			
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							userType : User.sutype,
							gsmfid : $('#gsmfids').attr('value'),	// �ŵ�
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value') 		// ����ʱ��
						}]
					}
				)
			};	
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();		
			$("#saledatagrid").show();		
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
			$("#LssSaleSummary").datagrid('reload'); 
			$("#LssSaleSummary").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
    	}
    	    	
    	function reloadShopSalegrid (value,SUPID)  {
        	$('#gsmfid').attr('value',value);	  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleShopDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleShopDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getShopSaleDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'),      // ����ʱ��
							gsmfid : $('#gsmfid').attr('value')  	    // �ŵ����	
						}]
					}
				)
			};     
			$("#saledatagrid").hide();
			$("#saleGsrqdatagrid").hide();
			$("#stockdatagrid").hide();					
			$("#saleShopdatagrid").show();   
			$("#saleShopDetail").datagrid('reload');	
			$("#saleShopDetail").datagrid('resize');		 
    	}    	
    	
    	function reloadGsrqSalegrid (value,SUPID)  {
    		$('#gsrq').attr('value',value);        
	        //��ѯ����ֱ�������queryParams��
	        $('#saleGsrqDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleGsrqDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGsrqShopSale',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : SUPID,
							userType : User.sutype,
							startDate : $('#startDate').attr('value'),	// ��ʼʱ��
							endDate : $('#endDate').attr('value'), 		// ����ʱ��
							gsmfid : $('#gsmfid').attr('value'),		// �ŵ����
							gsrq : $('#gsrq').attr('value')             // ��������
						}]
					}
				)
			};   
			$("#saledatagrid").hide();	   
			$("#saleShopdatagrid").hide();			
			$("#stockdatagrid").hide();				
			$("#saleGsrqdatagrid").show(); 
			$("#saleGsrqDetail").datagrid('reload');
			$("#saleGsrqDetail").datagrid('resize');      
    	}
    	
    	function reloadItemStockgrid (value,SUPID)  {
        	$('#zsgdid').attr('value',value);   
	        //��ѯ����ֱ�������queryParams��
	        $('#ItemStock').datagrid('options').url = 'JsonServlet';        
			$('#ItemStock').datagrid('options').queryParams = {
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
							zsmfid : $('#gsmfid').attr('value'),		// �ŵ����
							gsrq : $('#gsrq').attr('value'), 			// ��������
							zsgdid : $('#zsgdid').attr('value')         // ��Ʒ����
						}]
					}
				)
			};      
			
			$("#saledatagrid").hide();			
			$("#saleShopdatagrid").hide();
			$("#saleGsrqdatagrid").hide();			  
			$("#stockdatagrid").show(); 
			$("#ItemStock").datagrid('reload');      
			$("#ItemStock").datagrid('resize');
    }
    	
   	function backSalegrid ()  {     		
   		$("#saleShopdatagrid").hide(); 
		$("#saledatagrid").show();    	 
   	}
   	
   	function backSaleShopgrid ()  {
   		$("#saleGsrqdatagrid").hide(); 
		$("#saleShopdatagrid").show();   
   	}
   	
   	function backSaleGsrqgrid ()  {
   		$("#stockdatagrid").hide(); 
		$("#saleGsrqdatagrid").show();   
   	}   
    	
$(function(){
	if( !$('#supcode').data('isLoad') ){
		$.post( 'JsonServlet',				
			{
				data : obj2str({		
						ACTION_TYPE : 'getReceivers',
						ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
						ACTION_MANAGER : 'msgManager',
						list:[{
							id : ''
						}]
				})
				
			}, 
			function(data){ 
                   if(data.returnCode == '1' ){ 
                   	 if( data.rows ){
                   	 	$('#supcode').combobox('loadData', data.rows );
                   	 }
                   }else{ 
                       $.messager.alert('��ʾ','��ȡ������ʧ��!<br>ԭ��' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );
	}

});	
</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="850"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">���ۻ��ܲ�ѯ</td>
	</tr>
	<tr>
		<td colspan="3">
			<input type="hidden" id="gsmfid" name="gsmfid" value="" />
			<input type="hidden" id="gsrq" name="gsrq" value="" />
			<input type="hidden" id="zsgdid" name="zsgdid" value="" />
		</td>
	</tr>
	<tr>
		<td id="mainTabTd" align="left" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺ 
			<select style="width: 154px;" name='gsmfids' id="gsmfids" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
		<td width="300" style="border: none;">
			��ʼ���ڣ�<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" />
		</td>
		<td width="300" style="border: none;">
			�������ڣ�<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
	</tr>
	<tr>
		
		<td colspan="3" style="border: none;">
			<div id="supcodeDiv" style="">��Ӧ�̱��룺&nbsp;&nbsp;<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="3" style="border: none;"><img
			src="images/sure.jpg" border="0" onClick="reloadgrid();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;">
				<table id="saleShopSummary" width="586"></table>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleShopdatagrid" style="display: none;">
				<table id="saleShopDetail" ></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSalegrid();">����</a>-->
					<img src="images/goback.jpg" border="0" onClick="backSalegrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saleGsrqdatagrid" style="display: none;">
				<table id="saleGsrqDetail"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleShopgrid();">����</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleShopgrid();" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="stockdatagrid" style="display: none;">
				<table id="ItemStock"></table>
				<div style="text-align: left; float: left;  margin-top: 10px">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backSaleGsrqgrid();">����</a> -->
					<img src="images/goback.jpg" border="0" onClick="backSaleGsrqgrid();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("gsmfids");
loadAllShop(obj);

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
</html>