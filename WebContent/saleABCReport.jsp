<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.basic.service.BaseManager"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="com.bfuture.app.basic.util.xml.StringUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.basic.util.Excel"%>
<%@page import="java.io.File"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.model.report.YwGoodssale"%>
<html>
<head>	
	<title>����ABC����</title>
	
	<style>
		.underLine{
			border:0px;
			border-bottom:#000 1px solid;
			overflow:hidden;
		}
	</style>
	<script>
		$(function(){
			loadAllShop( document.getElementById('gsmfid') );
			
			if( $('#isLoadData').val() == 'true' ){				
				$('#saleObject').val( $('#so').val() );
				$('#startDate').val( $('#sd').val() );
				$('#endDate').val( $('#ed').val() );
				$('#gssupid').val( $('#gi').val()=='null'?'': $('#gi').val());							
			}
			else{
				clear();
			}
			
			//����������̣�����ʾ��Ӧ�������
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
			}else{
				$("#supcodeDiv").hide();
			}
		});		
		
		function clear(){		
			var now = new Date();
			var startDate = new Date();
			startDate.setDate( now.getDate() - 7 );
			$('#startDate').val( startDate.format('yyyy-MM-dd') );
			$('#endDate').val( now.format('yyyy-MM-dd') );	
		}
		
		function returnFirst(){
			$( '#div1' ).show();
			$( '#div2' ).hide(); 
		}
		
		function loadAllShop( list ){
			if( $(list).attr('isLoad') == undefined ){
				$(list).attr('isLoad' , true );
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Shop',
								ACTION_MANAGER : 'shopManager',	
								list:[{									
									usercode : User.sucode,
									sgcode : User.sgcode,
									supid : User.supcode									
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
						        
						        if( $('#isLoadData').val() == 'true' ){
									$('#gsmfid').val( $('#md').val() );
								}					        
	                    	 }
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		
		function reloadgrid ()  {  
        	var searchData = getFormData( 'saleABCReportSearch' );
        	
        	//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#gssupid").val();
			}else{
				supcode = User.supcode;
			}  
			searchData['gssupid'] = supcode; 
        		        
			var	paraStr = '';
			for( var name in searchData ){
				if( searchData[name] != '' && searchData[name] != undefined ){
					paraStr += '&' + name + '=' + searchData[name];
				}
			}
			paraStr = encodeURI(paraStr);
			paraStr = encodeURI(paraStr);        	
        	var url = 'saleABCReport.jsp?isLoadData=true' + paraStr;
        	
        	openUrl( url, 'Y' );
    	}
    	
    	// ���ò�ѯ���������
		function searchReset(){
			clear();
			$('#gsmfid').val( '' ); 	// �� ��
			$('#gssupid').val( '' );	// ��Ӧ�̱��
		}
	</script>
	
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
		
		AppSpringContext appContext = AppSpringContext.getInstance();
		BaseManager salem = (BaseManager)appContext.getAppContext().getBean("saleABCReport");
		List lstGds = null;		
		String[] enTitle = null, cnTitle = null;
		
		YwGoodssale gd = new YwGoodssale();
		boolean isLoadData = false;
		if( !StringUtil.isBlank( request.getParameter("isLoadData") ) ){
			isLoadData = true;
			gd.setGssgcode( currUser.getSgcode() );
			if('L' == currUser.getSutype()){ // ��¼�û�Ϊ�����̣���Ӧ�̱���Ӳ�ѯ������ȡ
				if( !StringUtil.isBlank( request.getParameter("gssupid") ) ){
					gd.setGssupid( request.getParameter("gssupid") );
				}
			}else{
				gd.setGssupid( currUser.getSupcode() );
			}
			gd.setSucode( currUser.getSucode() );
			if( !StringUtil.isBlank( request.getParameter("gsmfid") ) ){
				gd.setGsmfid( request.getParameter("gsmfid") );
			}
			if( !StringUtil.isBlank( request.getParameter("saleObject") ) ){
				gd.setSaleObject( request.getParameter("saleObject") );
			}
			if( !StringUtil.isBlank( request.getParameter("startDate") ) ){
				gd.setStartDate( request.getParameter("startDate") );
			}
			if( !StringUtil.isBlank( request.getParameter("endDate") ) ){
				gd.setEndDate( request.getParameter("endDate") );
			}
			
			ReturnObject ro = salem.getResult( gd );
			if( ro != null && ro.getRows() != null && ro.getRows().size() > 0 ){
				lstGds = ro.getRows();
			}
		}
		
	%>
	
</head>
<body>
	<div id="div1" title="����ABC����" style="padding:10px;" align="center">
	
		<!-- ��ѯ��������ʼ -->
		<table id="saleABCReportSearch" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">����ABC����</td> 
			</tr> 
			<tr> 
				<td width="242" style="border:none;"> 
					��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
					<select style="width:150px;" name='gsmfid' id="gsmfid" size='1' onclick="loadAllShop(this);"> 
              			<option value = ''>�����ŵ�</option> 
      				</select>
      			</td>
				<td width="242" style="border:none;"> 
					&nbsp;&nbsp;��&nbsp;ʼ&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="startDate" id="startDate" value="" size="20"  onClick="WdatePicker();" /> 
				</td> 
				<td width="242" style="border:none;"> 
					&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="endDate" id="endDate" value="" size="20"  onClick="WdatePicker();" /> 
				</td>
				
  			</tr> 
  			<tr>
  				<td width="242" style="border:none;"> 
					���ݷ�������
					<select style="width:150px;" id='saleObject' name='saleObject' size='1'>	
						<%
							if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
						%>
							<option value='GSXSSL' selected="selected">��������</option>
							<%if("3027".equals(currUser.getSgcode())){%>
								<option value='GSHSJJJE'>��˰�ɱ�</option>
								<option value='GSXSJE'>��˰��������</option>
							<%}else{%>
								<option value='GSHSJJJE'>���۳ɱ�</option>
					       		<%if(currUser.getSgcode().equals("3007")){%>
								<option value='GSXSSR'>��������</option>				       		
					       		<%}else{%>			    	
								<option value='GSXSJE'>���۽��</option>
								<%}%>
							<%}%>
						<%
							}else{
								if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSHSJJJE'>��˰�ɱ�</option>	
								<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSXSJE'>��˰��������</option>	
								<%}else{%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSHSJJJE'>���۳ɱ�</option>
								<%}
						} %>	       		
			       		<!-- <option value='GSXSSL' selected="selected">��������</option> 
			       		<option value='GSHSJJJE'>��˰���۽��</option>					    	
						<option value='GSXSSR'>��������</option>  -->
					</select> 
				</td> 	
  				<td width="242" style="border:none;"> 
					<div id="supcodeDiv" style="">&nbsp;&nbsp;��Ӧ�̱��룺&nbsp;&nbsp;<input type="text" id="gssupid" name="gssupid" value="" size="20" /></div>
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
  			</tr>
			<tr> 
				<td width="242" style="border:none;"> 
					<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onClick="reloadgrid();"/></a>
					<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onClick="searchReset();"/></a> 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
			</tr> 
		</table>
		<!-- ��ѯ����������� -->
		
	</div>
	<%if( isLoadData ){	 %>
	<input id="isLoadData" type="hidden" value="true"></id>
	<input id="md" type="hidden" value="<%=gd.getGsmfid()%>"></id>
	<input id="so" type="hidden" value="<%=gd.getSaleObject()%>"></id>
	<input id="sd" type="hidden" value="<%=gd.getStartDate()%>"></id>
	<input id="ed" type="hidden" value="<%=gd.getEndDate()%>"></id>
	<input id="gi" type="hidden" value="<%=gd.getGssupid()%>"></id>	
	<div id="div2" style="padding:10px;" align="center">		
		<div style="width: 730px">
		<div style="float: left;">
			<strong>
				 <INPUT size="1" style="background-color : #e6eef0;font-weight : lighter;text-decoration : none;" type="text" readonly>A����Ʒ 
				 <INPUT size="1" type="text" style="background-color : #ecefce;" readonly>B����Ʒ 
				 <INPUT size="1" style="background-color : #eee6f1;" type="text" readonly>C����Ʒ			 
	 		</strong>
 		</div>
 		<%if( lstGds != null ){ %>
 		<div style="color:#336699;float: right"><a href="<%=request.getContextPath() + "/temp/" + currUser.getSucode() + ".xls" %>">&gt;&gt;����Excel���</a></div><br>
 		<%} %>
 		</div>
 		<br>
 		<table border="0" width="730" cellpadding="0" cellspacing="0" style="line-height:20px;font-size:12px" align="center"> 
				<tr bgcolor="#8bbedd"> 
				    <td width="100" align="center">��Ʒ����</td> 
				    <td width="200" align="left">��Ʒ����</td> 
				    <td width="100" align="left">���</td> 
				    <td width="70" align="left">��λ</td> 
				    <%
				    if( "GSXSSL".equals( gd.getSaleObject() ) ){
				    	enTitle = new String[]{"GDID","GDNAME","GDSPEC","GDUNIT","GSXSSL","ZB","LJZB"};
				    	cnTitle = new String[]{"��Ʒ����","��Ʒ����","���","��λ","��������","ռ��(%)","�ۼ�ռ��(%)"};
				    %>
				    <td width="100" align="right">��������</td> 
				    <%}else if( "GSXSSR".equals( gd.getSaleObject() ) ){ 
				    	enTitle = new String[]{"GDID","GDNAME","GDSPEC","GDUNIT","GSXSSR","ZB","LJZB"};
				    	cnTitle = new String[]{"��Ʒ����","��Ʒ����","���","��λ","��������","ռ��(%)","�ۼ�ռ��(%)"};
				    %>
				    <td width="100" align="right">��������</td>
				    <%}else if("GSHSJJJE".equals(gd.getSaleObject())){ 
				    	enTitle = new String[]{"GDID","GDNAME","GDSPEC","GDUNIT","GSHSJJJE","ZB","LJZB"};
				    	cnTitle = new String[]{"��Ʒ����","��Ʒ����","���","��λ","���۳ɱ�","ռ��(%)","�ۼ�ռ��(%)"};
				    %>
				    <td width="100" align="right">���۳ɱ�</td>
				    <%}else if("GSXSJE".equals(gd.getSaleObject())){
				    	enTitle = new String[]{"GDID","GDNAME","GDSPEC","GDUNIT","GSXSJE","ZB","LJZB"};
				    	cnTitle = new String[]{"��Ʒ����","��Ʒ����","���","��λ","���۽��","ռ��(%)","�ۼ�ռ��(%)"};
				    %>
				    <td width="100" align="right">���۽��</td>	
				   <% }%>
				    <td width="80" align="right">ռ��(%)</td> 
				    <td width="80" align="right">�ۼ�ռ��(%)</td>
				</tr>
		</table>
		<div style="height:360px;overflow-y:auto;" align="center">
			<table id="salaABCDataTable" width="730" border="0" cellpadding="0" cellspacing="0" style="line-height:20px;font-size:12px;">				
				<%
					if( lstGds != null ){
						
						String path =  request.getSession().getServletContext().getRealPath("/temp") + File.separator + currUser.getSucode() + ".xls"; 
						
						Excel.createExcel( lstGds, path, enTitle, cnTitle, "����ABC����" );
						java.text.NumberFormat df=java.text.NumberFormat.getInstance();
						df.setMaximumFractionDigits(2);
						df.setMinimumFractionDigits(2);
						for( Iterator itGd = lstGds.iterator(); itGd.hasNext(); ){
							Map gds = (Map)itGd.next();
							String gsxssl = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("GSXSSL") ) ) ? "0" : df.format( Double.parseDouble(gds.get("GSXSSL").toString() ) );
							String gsxssr = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("GSXSSR") ) ) ? "0" : df.format( Double.parseDouble(gds.get("GSXSSR").toString() ) );
							String gsjjcb = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("GSHSJJJE") ) ) ? "0" : df.format( Double.parseDouble(gds.get("GSHSJJJE").toString() ) );
							String gsxsje = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("GSXSJE") ) ) ? "0" : df.format( Double.parseDouble(gds.get("GSXSJE").toString() ) );
							String zb = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("ZB") ) ) ? "0" : df.format( Double.parseDouble(gds.get("ZB").toString() ) );
							String ljzb = StringUtil.isBlank( StringUtil.nullToBlank( gds.get("LJZB") ) ) ? "0" : df.format( Double.parseDouble(gds.get("LJZB").toString() ) );
				%>
				<%
					if( "A".equals( StringUtil.nullToBlank( gds.get("FLAG") ) ) ){
				%>
				<tr bgcolor="#e6eef0">
				<%}else if( "B".equals( StringUtil.nullToBlank( gds.get("FLAG") ) ) ){ %>
				<tr bgcolor="#ecefce">
				<%}else if( "C".equals( StringUtil.nullToBlank( gds.get("FLAG") ) ) ){ %>
				<tr bgcolor="#eee6f1">
				<%}else if( "T".equals( StringUtil.nullToBlank( gds.get("FLAG") ) ) ){ %>
				<tr bgcolor="#8bbedd">
				<%}%>
					<td width="100" align="center"><%=StringUtil.nullToBlank( gds.get("GDID") )%></td> 
				    <td width="200" align="left"><%=StringUtil.nullToBlank( gds.get("GDNAME") )%></td> 
				    <td width="100" align="left"><%=StringUtil.nullToBlank( gds.get("GDSPEC") )%></td> 
				    <td width="70" align="left"><%=StringUtil.nullToBlank( gds.get("GDUNIT") )%></td>					 
				    <%if( "GSXSSL".equals( gd.getSaleObject() ) ){ %>
				    <td width="100" align="right"><%=gsxssl%></td>
				    <%}else if( "GSXSSR".equals( gd.getSaleObject() ) ){ %>
				    <td width="100" align="right"><%=gsxssr%></td>
				    <%}else if("GSHSJJJE".equals(gd.getSaleObject())){ %>
				    <td width="100" align="right"><%=gsjjcb%></td>
				    <%}else if("GSXSJE".equals(gd.getSaleObject())){ %>
				    <td width="100" align="right"><%=gsxsje%></td>
				    <%} %>
				    <td width="80" align="right"><%=zb%></td> 
					<td width="80" align="right"><%=ljzb%></td>
				</tr>			
				<%
						}
					}
				%>
			</table>
		</div>		
	</div>	
	<%} %>
</body>
</html>