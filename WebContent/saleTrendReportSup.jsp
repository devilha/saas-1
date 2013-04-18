<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>	
	<title>�������Ʒ���</title>
	
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
	
	<script>
		var saleTrendReportSUPChart = null;
		
		$(function(){
			$('#saleTrendReportSupList').datagrid({
				width: 800,				
				nowrap: false,
				striped: true,				
				url:'',
				sortOrder: 'desc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'��������...',				
				showFooter:true,												
				columns:[[
				
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						{field:'GSRQ',title:'����',width:80,
							formatter:function(value,rec){
								if( value != null && value != undefined && value != '�ϼ�' )
									return Date.parseString(value).format('yyyy-MM-dd');
								else
									return value;
							}
						},
						{field:'SHPCODE',title:'�ŵ����',width:60},			
						{field:'SHPNAME',title:'�ŵ�����',width:80},
						{field:'GSXSSL',title:'��������',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},{field:'GSXSSR',title:'���۽��',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						<%if(("3009".equals(currUser.getSgcode().toString()))){%>
						{field:'MLL',title:'ë����',width:70,align:'center',sortable:true},
						<%}%>
						/*
						{field:'GSHSJJJE',title:'��˰���۽��',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},					
						{field:'GSXSSR',title:'��������',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},*/
						{field:'INFSUPID',title:'��Ӧ�̱��',width:80,sortable:true},
						{field:'INFSUPNAME',title:'��Ӧ������',width:223,sortable:true}
					<%
					}else {
					%>	
						{field:'GSRQ',title:'����',width:120,
							formatter:function(value,rec){
								if( value != null && value != undefined && value != '�ϼ�' )
									return Date.parseString(value).format('yyyy-MM-dd');
								else
									return value;
							}
						},
						{field:'SHPCODE',title:'�ŵ����',width:120},			
						{field:'SHPNAME',title:'�ŵ�����',width:285},
						{field:'GSXSSL',title:'��������',width:120,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},
						<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
							{field:'GSHSJJJE',title:'���۳ɱ�',width:120,align:'right',
								formatter:function(value,rec){
									return formatNumber(
										value,
										{ decimalPlaces : 2, thousandsSeparator :',' }
									);
								}
							}
						<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
							{field:'GSXSSR',title:'��������',width:120,align:'right',
								formatter:function(value,rec){
									return formatNumber(
										value,
										{ decimalPlaces : 2, thousandsSeparator :',' }
									);
								}
							}
						<%}else if("3034".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'���۽��',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :','}
								);
							}
						}						
						<%}else{%>
						{field:'GSHSJJJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,width:120,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}
						<%}%>
						<%if(currUser.getSgcode().equals("3009")){%>
						,{field:'GSXSSR',title:'���۽��',width:80,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
						<%}%>
						/*{field:'GSHSJJJE',title:'��˰���۽��',width:100,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						},					
						{field:'GSXSSR',title:'��������',width:100,align:'right',
							formatter:function(value,rec){
								return formatNumber(
									value,
									{ decimalPlaces : 2, thousandsSeparator :',' }
								);
							}
						}*/
					<%
					}
					%>
					
				]],				
				rownumbers:true,
				onLoadSuccess:function( data ){
					if( data.chartData ){
						saleTrendReportSUPChart = data.chartData;
						drawChart();
		            }
				}
			});
			
			clear();
			
			//����������̣�����ʾ��Ӧ�������
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
			}else{
				$("#supcodeDiv").hide();
			}			
		});	// load end	
		
		function drawChart(){
			if( saleTrendReportSUPChart != null ){
				var chartType = "MSColumn3D.swf";
				if( $('#chartStyle').val() == 'line' ){
					chartType = "MSLine.swf";
				}
				var chart = new FusionCharts("chart/" + chartType, "saleTrendReportSUPChartId", "800", "400", "0", "0");            
				chart.setJSONData( saleTrendReportSUPChart );
				chart.render("saleTrendReportSUPChart");
			}
		}
		
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
		
		function exportExcel(){
			var searchData = getFormData( 'saleTrendReportSUPSearch' );
        	searchData['gssgcode'] = User.sgcode;    
        	searchData['gssupid'] = User.supcode;    	
        	searchData['sucode'] = User.sucode;
        	searchData['isSup'] = 'Y'; 
        	searchData['exportExcel'] = true;
        	//searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','gshsjjje','gsxssr'];
        	//searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','��˰���۽��','��������'];
        	//����������̣�����ʾ���۽���Ӧ�̱���͹�Ӧ������
			if(User.sutype == 'L'){
				searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE','GSXSJE','INFSUPID','INFSUPNAME'];
	        	searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','���۳ɱ�','���۽��','��Ӧ�̱��','��Ӧ������'];
			}else{
				<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE'];
        			searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','���۳ɱ�'];
				<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSXSJE'];
        			searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','���۽��'];
				<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")) {%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSXSJE'];
        			searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','���۽��'];
				<%}else{%>
					searchData['enTitle'] = ['gsrq','shpcode','shpname','gsxssl','GSHSJJJE'];
        			searchData['cnTitle'] = ['����','�ŵ����','�ŵ�����','��������','���۳ɱ�'];
				<%}%>
			}
        	
        	searchData['sheetTitle'] = '�������Ʒ�����ѯ';
		
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwGoodssale',
								ACTION_MANAGER : 'saleTrendReport',									 
								list:[ searchData ]
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
        	var searchData = getFormData( 'saleTrendReportSUPSearch' );
        	searchData['gssgcode'] = User.sgcode;    
        	searchData['sucode'] = User.sucode;
        	searchData['isSup'] = 'Y';
        	
        	//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#gssupid").val();
			}else{
				supcode = User.supcode;
			}  
        	searchData['gssupid'] = supcode; 
        
	        //��ѯ����ֱ�������queryParams��
	        $('#saleTrendReportSupList').datagrid('options').url = 'JsonServlet';        
			$('#saleTrendReportSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleTrendReport', // getChart datagrid
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwGoodssale',
						ACTION_MANAGER : 'saleTrendReport',
						optType : 'query',
						optContent : '��ѯ�������Ʒ�������',		 
						list:[	searchData	]
					}
				)
			};  
			
			$( '#div2' ).show();			        
			$("#saleTrendReportSupList").datagrid('reload');
			$("#saleTrendReportSupList").datagrid('resize');
    	}
    	
    	// ���ò�ѯ���������
		function searchReset(){
			clear();
			$('#gsmfid').val( '' ); 	// �� ��
			$('#gssupid').val( '' ); 	// ��Ӧ�̱��
		}
	</script>
</head>
<body>
	<div id="div1" title="�������Ʒ���" style="padding:10px;" align="center" >
		
		<!-- ��ѯ��������ʼ -->
		<table id="saleTrendReportSUPSearch" style="line-height:20px; text-align:left; border:none; font-size:12px" width="800px"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">�������Ʒ���<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td> 
			</tr> 
			
			<tr> 
				<td width="282" style="border:none;"> 
					��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
					<select style="width:150px;" name='gsmfid' id="gsmfid" size='1'> 
              			<option value = ''>�����ŵ�</option> 
      				</select>
      			</td>
				 <td width="282" style="border:none;"> 
					��&nbsp;&nbsp;ʼ&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��
					<input type="text" name="startDate" id="startDate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /> 
				</td> 
				<td width="282" style="border:none;"> 
					��&nbsp;��&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="endDate" id="endDate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /> 
				</td>	
  			</tr> 
  			
			<tr> 
				<td width="282" style="border:none;"> 
					ͼ���ʽ��
					<select style="width:150px;" id="chartStyle" size='1' onchange="drawChart();" > 
              			<option value = 'line'>����ͼ</option>
              			<option value = 'column'>��״ͼ</option> 
      				</select>
      			</td>
      			<td width="282" style="border:none;"> 
					���ݷ�������
					<select style="width:155px;" id='saleObject' name='saleObject' size='1'>	
					
						<%
							if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
						%>
							<option value='GSXSSL' selected="selected">��������</option>	
				       		<option value='GSHSJJJE'>���۳ɱ�</option>	
							<option value='GSXSJE'>���۽��</option>
						<%
							}else{
								if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSHSJJJE'>���۳ɱ�</option>	
								<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSXSSR'>��������</option>
								<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
									<option value='GSXSSL' selected="selected">��������</option>	
				       				<option value='GSXSJE'>���۽��</option>
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
				<td width="282" style="border:none;"> 
					<div id="supcodeDiv" style="">��Ӧ�̱��룺&nbsp;&nbsp;<input type="text" id="gssupid" name="gssupid" value="" size="20" /></div>
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
  			</tr> 
  			
			<tr> 
				<td width="282" style="border:none;"> 
					<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
					<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onclick="searchReset();"/></a> 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
				<td style="border:none;"> 
	  				 
				</td> 
			</tr> 
		</table>
		<!-- ��ѯ����������� --> 
		
	</div>	
	<div id="div2" style="padding:10px;display:none;height:400px;overflow-y:auto;" align="center">		
		<div id="saleTrendReportSUPChart">		
		</div>
		<div>	
			<!-- <div align="right" style="color:#336699;width: 800px"><a href="javascript:exportExcel();">&gt;&gt;����Excel���</a></div> --> 
			<table id="saleTrendReportSupList"></table>
		</div>
	</div>	
	
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>