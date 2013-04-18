<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʊ¼��</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#Invoicedatagrid").hide();
		
		$(function(){

			$('#Invoice').datagrid({
				width:930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: false,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
					{field:'select',checkbox:true},
				    {field:'INVOICENO',title:'��Ʊ����',width:130,align:'center',sortable:true},
				    {field:'INVOICEDATE',title:'��Ʊ����',width:80,align:'center',sortable:true},
				    {field:'INVOICETYPE',title:'��Ʊ����',width:65,align:'center',sortable:true,
				    formatter:function(value,rec){
							if( value == '1' )
								return '��ֵ';
							else 
								return '��';
						}
					},
				    {field:'GOODSNAME',title:'��������',width:140,sortable:true},				    
				    {field:'PAYAMT',title:'��Ʊ���',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PAYNETAMT',title:'����˰���',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				     {field:'PAYTAXAMT',title:'˰��',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BALANCENO',title:'���˵���',width:120,align:'center',sortable:true},	
						//{field:'INPUTDATE',title:'�ύ����',width:75,align:'center',sortable:true},	
						{field:'FLAG',title:'�ύ״̬',width:90,align:'center',sortable:true,
						    formatter:function(value,rec){
									if( value == '0' )
										return 'δ�ύ';
									else if( value == '1' )
										return 'δ���';
									else if(value=='2')
										return '���ͨ��';
									else if(value=='3')
										return '���δͨ��';
									else
										return '��״̬';
								}
							}

				]],
				pagination:true,
				rownumbers:true,
				
				toolbar:[{
					id:'btnAdd',
					text:'���',
					iconCls:'icon-add',
					handler:function(){
						addInvoice();
					}
				},'-',{
					id:'btnRemove',
					text:'ɾ��',
					iconCls:'icon-remove',
					handler:function(){
						deleteInvoice();
					}
				},'-',{
					id:'btnOk',
					text:'����',
					iconCls:'icon-ok',
					handler:function(){
						if(checkFlag('0')){
							changeState(1);
						}
					}
				}
				]
				
			});
			reloadgrid();
			
			$('#uiform input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });//must����֤��ʼ��
		}

		);
		function reloadgrid ()  {
			var supcode = '';
				supcode = User.supcode;

	        //��ѯ����ֱ�������queryParams��
	        $('#Invoice').datagrid('options').url = 'JsonServlet';        
			$('#Invoice').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getInvoice',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
						ACTION_MANAGER : 'InvoiceDZDXFXManager',	
						list:[{
							sgcode : User.sgcode,
							venderid : supcode,
							flag : 0 // ���״̬
						}]
					}
				)
			};		
			$("#Invoicedatagrid").show();
			$("#Invoice").css("display","");
			$("#Invoice").datagrid('reload'); 
			$("#Invoice").datagrid('resize'); 
    	}
    	function exportExcel(){
			var supcode = '';
				supcode = User.supcode;
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getInvoice',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
								ACTION_MANAGER : 'InvoiceDZDXFXManager',										 
								list:[{
									exportExcel : true,
									enTitle: ['INVOICENO','INVOICEDATE','INVOICETYPE','GOODSNAME','PAYAMT','PAYNETAMT','PAYTAXAMT','BALANCENO','INPUTDATE','FLAG'],
									cnTitle: ['��Ʊ����','��Ʊ����','��Ʊ����','��������','��Ʊ���','����˰���','˰��','���˵���','�ύ����','�ύ״̬'],
									sheetTitle: '��Ʊ¼��',
									sgcode : User.sgcode,
									venderid : supcode,
									flag : 0 // ���״̬
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
	//��֤�Ƿ���ύ
	function checkFlag(id){
	         var rows = $('#Invoice').datagrid('getSelections');   
	         if(rows.length<1)
	         {
	         	$.messager.alert('����','δѡ���¼!');
				return false;
	         }         
	         for(var i=0;i<rows.length;i++){  
	        	 
	        	if(rows[i].FLAG != id){
					$.messager.alert('����','��ѡ��״̬�Ϸ��ķ�Ʊ!');
					return false;
				}          
	         }           
		return true;
	}
	
	/**
	 * �ύ����
	 */
	function changeState(changeflag){
		var rows = $('#Invoice').datagrid('getSelections');   
		if(rows.length < 1){
			$.messager.alert('����','δѡ���¼!');
			return false;
		}
		var list = [];
		for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ invoiceno : rows[i].INVOICENO, flag: changeflag }
				);
			}
		$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ����[ ' + rows[0].INVOICENO + ' ]��Ʊ��?', function(r){
				if (r){
							$.post( 'JsonServlet',				
									{
										data : obj2str({		
												ACTION_TYPE : 'updateInvoice',
												ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
												ACTION_MANAGER : 'InvoiceDZDXFXManager',	
												list: list
										})
									}, 
									function(data){ 
					                    if(data.returnCode == '1' ){
					                    	$.messager.alert('��ʾ','�����ɹ�!');
							    		    //ˢ�½���б�
											reloadgrid();
					                    }else{
					                        $.messager.alert('��ʾ','����ʧ��!<br>ԭ��' + data.returnInfo,'error');
					                    }
					            	},'json'
					            );
					  }
					  });
	}
	function addInvoice(){
		$("#addInvoice").window('open');
		$("div :input[type=text]").val('');
		//$('#hadInvoiceno').show();
		$('#hadINV').val('cannot');
		$('#hadINV2').val('cannot');
		$('#hadINV3').val('cannot');
		$('#hadINV4').val('cannot');
		$('#hadINV5').val('cannot');
		$('#hadINV6').val('cannot');
	    $('#hadaddgoodsname').show();
	    $('#hadaddpayamt').show();
	    $('#hadaddpaynetamt').show();
	    $('#hadaddpaytaxamt').show();
	   // $('#hadaddbalanceno').show();

		
	}
	function checkInvoiceno(){
			if($('#addinvoiceno').val()!='')
			{
				$('#hadInvoiceno').hide();
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'checkInvoiceno',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
								ACTION_MANAGER : 'InvoiceDZDXFXManager',		 
								list:[{								
									invoiceno : $('#addinvoiceno').val()
								}]
						})							
					}, 
					function(data){
			        	if(data.returnCode == '1' ){ 
							if( data.rows != undefined && data.rows.length > 0 ){
			                	$('#hadInvoiceno').show();
			                	$('#hadINV').val('cannot');
							}
							else{
								$('#hadInvoiceno').hide();
								$('#hadINV').val('can');
							} 
						}else{ 
							$.messager.alert('��ʾ','��ȡ��Ʊ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
						} 
					},
					'json'
				);
			}
			else
			{
				$('#hadInvoiceno').show();
				$('#hadINV').val('cannot');
			}
		}
	function checkgoodsname(){
			if($('#addgoodsname').val()==''||$('#addgoodsname').val()=='defined')
			{
				$('#hadaddgoodsname').show();
			    $('#hadINV2').val('cannot');
			}
			else
			{
				$('#hadINV2').val('can');
				$('#hadaddgoodsname').hide();
			}
		}
	function checkpayamt(){
			if($('#addpayamt').val()==''||$('#addpayamt').val()=='defined')
			{
				$('#hadaddpayamt').show();
			    $('#hadINV3').val('cannot');
			}
			else
			{
				$('#hadINV3').val('can');
				$('#hadaddpayamt').hide();
			}
		}
	function checkpaynetamt(){
			if($('#addpaynetamt').val()==''||$('#addpaynetamt').val()=='defined')
			{
				$('#hadaddpaynetamt').show();
			    $('#hadINV4').val('cannot');
			}
			else
			{
				$('#hadINV4').val('can');
				$('#hadaddpaynetamt').hide();
			}
		}
	function checkpaytaxamt(){
			if($('#addpaynetamt').val()==''||$('#addpaynetamt').val()=='defined'||$('#addpayamt').val()==''||$('#addpayamt').val()=='defined')
			{
				$('#hadaddpaytaxamt').show();
			    $('#hadINV5').val('cannot');
			}
			else
			{
			var aaaa=parseFloat(parseFloat($('#addpayamt').val()).toFixed(2)-parseFloat($('#addpaynetamt').val()).toFixed(2)).toFixed(2);
			//alert(aaaa);
				$('#addpaytaxamt').val(aaaa);
				$('#hadINV5').val('can');
				$('#hadaddpaytaxamt').hide();
			}
		}
	function checkbalanceno(){

			if($('#addbalanceno').val()!='')
			{
				$('#hadaddbalanceno').hide();
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'checkBalanceno',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
								ACTION_MANAGER : 'GysJxDocManager',		 
								list:[{								
									billno : $('#addbalanceno').val(),
									sgcode : User.sgcode
								}]
						})							
					}, 
					function(data){
			        	if(data.returnCode == '1' ){ 
							if( data.rows != undefined && data.rows.length > 0 ){//���ڵ���
								$('#hadaddbalanceno').hide();
								$('#hadINV6').val('can');
							}
							else{
								$('#hadaddbalanceno').show();//���Ų�����
			                	$('#hadINV6').val('cannot');
							} 
						}else{ 
							$.messager.alert('��ʾ','��ȡ���˵���ʧ��!<br>ԭ��' + data.returnInfo,'error');
						} 
					},
					'json'
				);
			}
			else
			{
				$('#hadaddbalanceno').show();
				$('#hadINV6').val('cannot');
			}


		}
		// ��ӿ�ͱ༭��Ĺر�
		function cancel(what){
			$(what).window('close');
		}
		
		// ����(��ӻ����)
		function saveInvoice(){
	
			//alert($("#addinvoicedate").val());
			
			
			
			// ������֤
			if( !checkForm( 'uiform' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			
			//return ;
			if( $('#hadINV').val() == 'cannot' ){
				$.messager.alert('û��ͨ����֤','��Ʊ����[' + $('#addinvoiceno').val() + ']�Ѵ��ڣ�','warning');
				return;
			}

			if( $('#hadINV6').val() == 'cannot' ){
				$.messager.alert('û��ͨ����֤','���˵���[' + $('#addbalanceno').val() + ']�����ڣ�','warning');
				return;
			}

			var invoiceData = getFormData( 'uiform' );
        $.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ����[ ' + $('#addinvoiceno').val() + ' ]��Ʊ��?', function(r){
				if (r){
						$.post( 'JsonServlet',				
							{
								data : obj2str({		
										ACTION_TYPE : 'addInvoice',
										ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
										ACTION_MANAGER : 'InvoiceDZDXFXManager',
										optType : 'add',
										optContent : '������Ʊ',		 
										list:[ {
										//invoiceData 
											sgcode : User.sgcode,
											venderid : User.supcode,
											invoiceno : $("#addinvoiceno").val(),
											invoicedate : $("#addinvoicedate").val(),
											endDate  : $("#addinvoicedate").val(),//����invoicedate ��ֵ
											invoicetype : $("#addinvoicetype").val(),
											goodsname : $("#addgoodsname").val(),
											payamt : $("#addpayamt").val(),
											paynetamt : $("#addpaynetamt").val(),
											paytaxamt : $("#addpaytaxamt").val(),
											balanceno : $("#addbalanceno").val()
											
										}]
								})
								
							}, 
							function(data){ 
			                    if(data.returnCode == '1' ){ 
			                    	$.messager.alert('��ʾ','���淢Ʊ�ɹ�!','info');
			                    	$('#Invoice').datagrid('reload');
			                    	cancel('#addInvoice');                    	
			                    }else{ 
			                        $.messager.alert('��ʾ','���淢Ʊʧ��!<br>ԭ��' + data.returnInfo,'error');
			                    } 
			            	},
			            	'json'
			            );
			           }
			          });
		}
		
		// ɾ������
		function deleteInvoice(){
			var row = $('#Invoice').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;				
			}
			var list = [];
			for( var i = 0; i < row.length; i ++ ){
					list.push(
						{ invoiceno : row[i].INVOICENO, sgcode: User.sgcode }
					);
			}

			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��[ ' + row[0].INVOICENO + ' ]��Ʊ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'deleteInvoice',
									ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
									ACTION_MANAGER : 'InvoiceDZDXFXManager',
									optType : 'delete',
									optContent : 'ɾ����Ʊ',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','ɾ���ɹ���','info');
                    			$('#Invoice').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});		
			
						
		}
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">��Ʊ¼��</td>
	</tr>
<!--  
	<tr>
		<td style="border: none;">
		<img src="images/tianjia.jpg" border="0" onclick="addInvoice();" />&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="images/delete.jpg" border="0" onclick="deleteInvoice();" />
		
		</td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>

-->
	<tr>
		<td colspan="3">
			<!-- table ����ʾ�б����Ϣ -->
			<div id="Invoicedatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<a href="javascript:exportExcel();">>>����Excel���</a></div>
				<table id="Invoice"></table>
			<!--  
			<a href="javascript:void(0);" onclick="if(checkFlag('0')){changeState(1);}">
			<img style="margin-right:50px;"  border="0" src="images/songshen.jpg">
			</a>
			-->
			</div>
		</td>
	</tr>
</table>
	<!-- ��ӿ�start -->
	<div id="addInvoice" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="��Ʊ��Ϣ" style="width:450px;height:350px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="uiform" class="tableClass">
					<tr>
						<td>��Ʊ���ţ�</td> 
						<td><input id="addinvoiceno" name="addinvoiceno" type="text" onblur="checkInvoiceno();" required="true" /></td> <!-- ��ⷢƱ�����Ƿ��ظ� -->
						<td><div id="hadInvoiceno" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">�����Ѵ��ڣ�</font></div></td>
						<input id="hadINV" type="hidden" />
					</tr>
					<tr>
					<td>��Ʊ���ڣ�</td>
					<td ><input
						type="text" id="addinvoicedate" name="addinvoicedate"  size="20"
						onClick="WdatePicker({isShowClear:false,readOnly:true});"  required="true" /></td>
					</tr>
					<tr>
						<td>��Ʊ���ͣ�</td>
						<td>
						<select id="addinvoicetype" name="addinvoicetype">
							    <option value="1">��ֵ</option>
							    <option value="0">--��ѡ��--</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>�������ƣ�</td>
						<td><input id="addgoodsname" name="addgoodsname" type="text" onblur="checkgoodsname();" required="true"/></td>
						<!-- �����������Ƿ�Ϊ�� -->
						<!--  <td><div id="hadaddgoodsname" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">����Ϊ�գ�</font></div></td>
						 -->
						<input id="hadINV2" type="hidden" />
					</tr>
					<tr>
						<td>��Ʊ��</td>
						<td><input id="addpayamt" name="addpayamt" type="text" onblur="checkpayamt();" required="true"/></td>
						<!-- ��⿪Ʊ����Ƿ�Ϊ�� -->
						<!-- <td><div id="hadaddpayamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">����Ϊ�գ�</font></div></td>
						-->
						<input id="hadINV3" type="hidden" />
					</tr>
					<tr>
						<td>����˰��</td>
						<td><input id="addpaynetamt" name="addpaynetamt" type="text" onblur="checkpaynetamt();" required="true" /></td> 
						<!-- ��ⲻ��˰����Ƿ�Ϊ�� -->
						<!--  <td><div id="hadaddpaynetamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">����Ϊ�գ�</font></div></td>
						-->
						<input id="hadINV4" type="hidden" />
					</tr>
					<tr>
						<td>˰�</td>
						<td><input id="addpaytaxamt" name="addpaytaxamt" type="text" onblur="checkpaytaxamt();" required="true" /></td>
						<!-- ����˰�� -->
						<!--  <td><div id="hadaddpaytaxamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">����Ϊ�գ�</font></div></td>
						-->
						<input id="hadINV5" type="hidden" /> 
					</tr>
					<tr>
						<td>���˵��ţ�</td>
						<td><input id="addbalanceno" name="addbalanceno" type="text" onblur="checkbalanceno();" required="true" /></td> 
						<!-- ����Ƿ���ڴ˶��˵��� -->
						<td><div id="hadaddbalanceno" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">���Ų����ڣ�</font></div></td>
						<input id="hadINV6" type="hidden" /> 
					</tr>

				</table>
			</div> 
			
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveInvoice();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addInvoice');">ȡ��</a> 
			</div> 
		</div>
	</div>	
	<!-- ��ӿ�end -->
</center>
</body>
</html>