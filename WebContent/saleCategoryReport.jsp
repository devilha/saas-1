<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ���������ϸ��ѯ</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		//��þ�Ӫ��ʽ
		String jyfs = currUser.getSuflag() + "";
		String suType = currUser.getSutype() + "";
	%>
<style>
a:hover { 
	text-decoration: underline;
	color: red
}
body{
	font-size: 9px;
}
</style>
<script>
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
		$(function(){
			$('#saleCategory').datagrid({
				width:836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'GDCATID',title:'�����',width:"<%if("S".equals(suType)){%>150<%}else{%>130<%}%>",align:'center',sortable:true,formatter:function(value,rec){
					if(rec.GDCATID == null || rec.GDCATID == 'null'){
						return '';
					}else if(rec.GDCATID!='�ϼ�'){
						var gcid = "'" + rec.GDCATID + "'";
						var supid = "'" + rec.GSSUPID + "'";
						return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="showDetail(' + gcid + ','+supid+');">' + value + '</a>';
					}else{
						return value;
					}
					}},
					{field:'GCNAME',title:'�������',width:"<%if("S".equals(suType)){%>300<%}else{%>200<%}%>",align:'left',sortable:true},
					{field:'GSXSSL',title:'��������',width:"<%if("S".equals(suType)){%>190<%}else{%>100<%}%>",align:'center',sortable:true},
					{field:'GSHSJJJE',title:'��˰���۳ɱ�',width:"<%if("S".equals(suType)){%>190<%}else{%>150<%}%>",sortable:true,align:'center'}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSSR',title:'�ۼ۽��',width:150,sortable:true,align:'center'},
					{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:250,align:'left',sortable:true}
					<%
					}
					%>
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
			
			$('#saleCategoryDetail').datagrid({
				width: 836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'��������...',				
				columns:[[
					{field:'GCID',title:'������',width:100,align:'center',sortable:true},
					{field:'GCNAME',title:'�������',width:100,align:'center',sortable:true},
				    {field:'GSGDID',title:'��Ʒ����',width:100,align:'center',sortable:true},	
				    {field:'GSBARCODE',title:'��Ʒ����',width:160,align:'center',sortable:true},	
					{field:'GDNAME',title:'��Ʒ����',width:300,align:'left',sortable:true},
					{field:'GSXSSL',title:'��������',width:100,align:'center',sortable:true},					
					{field:'GSHSJJJE',title:'���۳ɱ�',width:60,sortable:true,align:'center'}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					,{field:'GSXSSR',title:'���۽��',width:80,sortable:true,align:'center'},
					{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
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
				$("#mainTabTd").width(318);
				$("#mainTabTdStartDate").width(250);
				$("#mainTabTd").attr("align","right");
				$("#mainTabTd2").attr("align","right");
				$("#saledatagrid").attr("style","margin-left: 0px;display: none;");
			}else{
				$("#supcodeDiv").hide();
			}
			
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
		});
		
		function padLeft(str, lenght) {
            if (str.length >= lenght)
                return str;
            else
                return padLeft("0" + str, lenght);
        }
		
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
								ACTION_TYPE : 'getSaleCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['�����','�������','��������','�ۼ�','�ۼ۽��','���۳ɱ�','��Ӧ�̱���','��Ӧ������'],
										<%}else if("3027".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
											cnTitle: ['�����','�������','��������','��˰��������','��˰�ɱ�','��Ӧ�̱���','��Ӧ������','��Ӧ�̳е��ۿ�'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['�����','�������','��������','�ۼ۽��',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,'��Ӧ�̱���','��Ӧ������'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['�����','�������','��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSVENDREBATE'],
											cnTitle: ['�����','�������','��������','��˰��������','��Ӧ�̳е��ۿ�'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR' ],
											cnTitle: ['�����','�������','��������','�ۼ�','���۽��'],
										<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR' ],
											cnTitle: ['�����','�������','��������','���۽��'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE' ],
											cnTitle: ['�����','�������','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۽��'<%}%>],
										<%}
									}%>
									sheetTitle: '��Ʒ���������ϸ��ѯ',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// �ŵ����
									supcode : supcode,					// ��Ӧ�̱���
									userType : User.sutype,				// �û�����
									gsgcid : $('#gsgcid').attr('value'), // ������
									gsgcname : $('#gsgcname').attr('value'), // �������						
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
	        $('#saleCategory').datagrid('options').url = 'JsonServlet';        
			$('#saleCategory').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategory',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#gsmfid').attr('value'),// �ŵ����
							supcode : supcode,					// ��Ӧ�̱���
							gsgcid : $('#gsgcid').attr('value'), // ������
							userType : User.sutype,				// �û�����
							gsgcname : $('#gsgcname').attr('value'), // �������							
							startDate : $('#startDate').attr('value'), // ��ʼ����
							endDate : $('#endDate').attr('value')      // ��������
						}]
					}
				)
			};
			$("#saledatagrid").show();         
			$("#saleCategory").datagrid('reload');        
			$("#saleCategory").datagrid('resize');
			$('#shopid_').val('').val($('#gsmfid').val());
			$('#startdate_').val('').val($('#startDate').val());
			$('#enddate_').val('').val($('#endDate').val());
			$('#supcode').combobox('setValue','');  
			
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

		//��ȡ���������Ϣ(����)
		function loadAllCategoryID( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.CODE + "'>" + n.CODE + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		} 		
		
		//��ȡ���������Ϣ(����)
		function loadAllCategory( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategoryname',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.NAME + "'>" + n.NAME + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		}   
  	
		
		  function backgrid ()  {     		
    		$("#saledatagrid").show(); 
    		$("#sure_button").show();
			$("#saleCategoryDetail2").hide();    	 
    	}  
    	function showDetail(gcid,supid){
    	
    	  $('#saleCategoryDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleCategoryDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategoryDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#shopid_').val(),// �ŵ����
							supcode : supid,					// ��Ӧ�̱���
							gsgcid :gcid, // ������
							startDate : $('#startdate_').val(), // ��ʼ����
							endDate : $('#enddate_').val()      // ��������
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#sure_button").hide();
			$("#saleCategoryDetail2").show();                  
			$("#saleCategoryDetail").datagrid('reload');        
			$("#saleCategoryDetail").datagrid('resize');
    	} 
	</script>
</head>
<body>
<center>
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="740" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ����ѯ</td>
	</tr>
	<tr>
		<td width="230" id="mainTabTdStartDate" style="border: none;">
			��ʼ���ڣ�<input type="text" id="startDate" name="startDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" />
		</td>
		<td width="230" style="border: none;">
			�������ڣ�<input type="text" id="endDate" name="endDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td id="mainTabTd" width="280" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
			<select style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
	</tr>
	<tr>
		<td style="border: none;" id="gsgcid11">
			�����룺<input type="text" id="gsgcid" name="gsgcid" width="110" value="" />		
		</td>
		  <td id='gsgcname11' style="border: none;" style="border: none;">
		         ������ƣ�<input type="text" name='gsgcname' id='gsgcname' />
		</td>
		<td style="border: none;" id="mainTabTd2">
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
	</tr>
	<tr>
		<td colspan="3" style="border: none;" align="left">
		    <img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
	</tr>
	<tr>
		<td colspan="3" id="saledatagrid" style="display: none;">
			<table id="saleCategory"></table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
		    <div id="shopid_" style="display: none"></div>
			<div id="startdate_" style="display: none"></div>
			<div id="enddate_" style="display: none"></div>
			<div id="saleCategoryDetail2" style="display: none;">
				<table id="saleCategoryDetail"></table>
				<div style="text-align: left; margin-top: 10px;">
					<img src="images/goback.jpg" border="0" onclick="backgrid();" />
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