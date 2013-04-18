<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>发票录入</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
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
				loadMsg:'加载数据...',				
				columns:[[
					{field:'select',checkbox:true},
				    {field:'INVOICENO',title:'发票单号',width:130,align:'center',sortable:true},
				    {field:'INVOICEDATE',title:'发票日期',width:80,align:'center',sortable:true},
				    {field:'INVOICETYPE',title:'发票类型',width:65,align:'center',sortable:true,
				    formatter:function(value,rec){
							if( value == '1' )
								return '增值';
							else 
								return '无';
						}
					},
				    {field:'GOODSNAME',title:'货物名称',width:140,sortable:true},				    
				    {field:'PAYAMT',title:'开票金额',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PAYNETAMT',title:'不含税金额',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				     {field:'PAYTAXAMT',title:'税额',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BALANCENO',title:'对账单号',width:120,align:'center',sortable:true},	
						//{field:'INPUTDATE',title:'提交日期',width:75,align:'center',sortable:true},	
						{field:'FLAG',title:'提交状态',width:90,align:'center',sortable:true,
						    formatter:function(value,rec){
									if( value == '0' )
										return '未提交';
									else if( value == '1' )
										return '未审核';
									else if(value=='2')
										return '审核通过';
									else if(value=='3')
										return '审核未通过';
									else
										return '无状态';
								}
							}

				]],
				pagination:true,
				rownumbers:true,
				
				toolbar:[{
					id:'btnAdd',
					text:'添加',
					iconCls:'icon-add',
					handler:function(){
						addInvoice();
					}
				},'-',{
					id:'btnRemove',
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						deleteInvoice();
					}
				},'-',{
					id:'btnOk',
					text:'送审',
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
	        });//must表单验证初始化
		}

		);
		function reloadgrid ()  {
			var supcode = '';
				supcode = User.supcode;

	        //查询参数直接添加在queryParams中
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
							flag : 0 // 审核状态
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
									cnTitle: ['发票单号','发票日期','发票类型','货物名称','开票金额','不含税金额','税额','对账单号','提交日期','提交状态'],
									sheetTitle: '发票录入',
									sgcode : User.sgcode,
									venderid : supcode,
									flag : 0 // 审核状态
								}]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	location.href = data.returnInfo;	                    	 
	                    }else{ 
	                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		} 
	//验证是否可提交
	function checkFlag(id){
	         var rows = $('#Invoice').datagrid('getSelections');   
	         if(rows.length<1)
	         {
	         	$.messager.alert('错误','未选择记录!');
				return false;
	         }         
	         for(var i=0;i<rows.length;i++){  
	        	 
	        	if(rows[i].FLAG != id){
					$.messager.alert('错误','请选择状态合法的发票!');
					return false;
				}          
	         }           
		return true;
	}
	
	/**
	 * 提交操作
	 */
	function changeState(changeflag){
		var rows = $('#Invoice').datagrid('getSelections');   
		if(rows.length < 1){
			$.messager.alert('错误','未选择记录!');
			return false;
		}
		var list = [];
		for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ invoiceno : rows[i].INVOICENO, flag: changeflag }
				);
			}
		$.messager.confirm('确认操作', '确认要送审[ ' + rows[0].INVOICENO + ' ]发票吗?', function(r){
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
					                    	$.messager.alert('提示','操作成功!');
							    		    //刷新结果列表
											reloadgrid();
					                    }else{
					                        $.messager.alert('提示','操作失败!<br>原因：' + data.returnInfo,'error');
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
							$.messager.alert('提示','获取发票信息失败!<br>原因：' + data.returnInfo,'error');
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
							if( data.rows != undefined && data.rows.length > 0 ){//存在单号
								$('#hadaddbalanceno').hide();
								$('#hadINV6').val('can');
							}
							else{
								$('#hadaddbalanceno').show();//单号不存在
			                	$('#hadINV6').val('cannot');
							} 
						}else{ 
							$.messager.alert('提示','获取对账单号失败!<br>原因：' + data.returnInfo,'error');
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
		// 添加框和编辑框的关闭
		function cancel(what){
			$(what).window('close');
		}
		
		// 保存(添加或更改)
		function saveInvoice(){
	
			//alert($("#addinvoicedate").val());
			
			
			
			// 表单的验证
			if( !checkForm( 'uiform' ) ){
				$.messager.alert('没有通过验证','请检查是否有必须填写的项没有填写！','warning');
				return;
			}
			
			//return ;
			if( $('#hadINV').val() == 'cannot' ){
				$.messager.alert('没有通过验证','发票单号[' + $('#addinvoiceno').val() + ']已存在！','warning');
				return;
			}

			if( $('#hadINV6').val() == 'cannot' ){
				$.messager.alert('没有通过验证','对账单号[' + $('#addbalanceno').val() + ']不存在！','warning');
				return;
			}

			var invoiceData = getFormData( 'uiform' );
        $.messager.confirm('确认操作', '确认要保存[ ' + $('#addinvoiceno').val() + ' ]发票吗?', function(r){
				if (r){
						$.post( 'JsonServlet',				
							{
								data : obj2str({		
										ACTION_TYPE : 'addInvoice',
										ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
										ACTION_MANAGER : 'InvoiceDZDXFXManager',
										optType : 'add',
										optContent : '新增发票',		 
										list:[ {
										//invoiceData 
											sgcode : User.sgcode,
											venderid : User.supcode,
											invoiceno : $("#addinvoiceno").val(),
											invoicedate : $("#addinvoicedate").val(),
											endDate  : $("#addinvoicedate").val(),//代替invoicedate 传值
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
			                    	$.messager.alert('提示','保存发票成功!','info');
			                    	$('#Invoice').datagrid('reload');
			                    	cancel('#addInvoice');                    	
			                    }else{ 
			                        $.messager.alert('提示','保存发票失败!<br>原因：' + data.returnInfo,'error');
			                    } 
			            	},
			            	'json'
			            );
			           }
			          });
		}
		
		// 删除操作
		function deleteInvoice(){
			var row = $('#Invoice').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;				
			}
			var list = [];
			for( var i = 0; i < row.length; i ++ ){
					list.push(
						{ invoiceno : row[i].INVOICENO, sgcode: User.sgcode }
					);
			}

			$.messager.confirm('确认操作', '确认要删除[ ' + row[0].INVOICENO + ' ]发票吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'deleteInvoice',
									ACTION_CLASS : 'com.bfuture.app.saas.model.InvoiceDZDXFX',
									ACTION_MANAGER : 'InvoiceDZDXFXManager',
									optType : 'delete',
									optContent : '删除发票',		 
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('提示','删除成功！','info');
                    			$('#Invoice').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
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
		<td colspan="3" align="left" style="border: none; color: #4574a0;">发票录入</td>
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
			<!-- table 中显示列表的信息 -->
			<div id="Invoicedatagrid" >
				<div  align="right" style="color: #336699; width: 930px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a></div>
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
	<!-- 添加框start -->
	<div id="addInvoice" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="发票信息" style="width:450px;height:350px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="uiform" class="tableClass">
					<tr>
						<td>发票单号：</td> 
						<td><input id="addinvoiceno" name="addinvoiceno" type="text" onblur="checkInvoiceno();" required="true" /></td> <!-- 检测发票单号是否重复 -->
						<td><div id="hadInvoiceno" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">单号已存在！</font></div></td>
						<input id="hadINV" type="hidden" />
					</tr>
					<tr>
					<td>发票日期：</td>
					<td ><input
						type="text" id="addinvoicedate" name="addinvoicedate"  size="20"
						onClick="WdatePicker({isShowClear:false,readOnly:true});"  required="true" /></td>
					</tr>
					<tr>
						<td>发票类型：</td>
						<td>
						<select id="addinvoicetype" name="addinvoicetype">
							    <option value="1">增值</option>
							    <option value="0">--请选择--</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>货物名称：</td>
						<td><input id="addgoodsname" name="addgoodsname" type="text" onblur="checkgoodsname();" required="true"/></td>
						<!-- 检测货物名称是否为空 -->
						<!--  <td><div id="hadaddgoodsname" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">不可为空！</font></div></td>
						 -->
						<input id="hadINV2" type="hidden" />
					</tr>
					<tr>
						<td>开票金额：</td>
						<td><input id="addpayamt" name="addpayamt" type="text" onblur="checkpayamt();" required="true"/></td>
						<!-- 检测开票金额是否为空 -->
						<!-- <td><div id="hadaddpayamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">不可为空！</font></div></td>
						-->
						<input id="hadINV3" type="hidden" />
					</tr>
					<tr>
						<td>不含税金额：</td>
						<td><input id="addpaynetamt" name="addpaynetamt" type="text" onblur="checkpaynetamt();" required="true" /></td> 
						<!-- 检测不含税金额是否为空 -->
						<!--  <td><div id="hadaddpaynetamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">不可为空！</font></div></td>
						-->
						<input id="hadINV4" type="hidden" />
					</tr>
					<tr>
						<td>税额：</td>
						<td><input id="addpaytaxamt" name="addpaytaxamt" type="text" onblur="checkpaytaxamt();" required="true" /></td>
						<!-- 计算税额 -->
						<!--  <td><div id="hadaddpaytaxamt" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">不可为空！</font></div></td>
						-->
						<input id="hadINV5" type="hidden" /> 
					</tr>
					<tr>
						<td>对账单号：</td>
						<td><input id="addbalanceno" name="addbalanceno" type="text" onblur="checkbalanceno();" required="true" /></td> 
						<!-- 检测是否存在此对账单号 -->
						<td><div id="hadaddbalanceno" style="float:left;display:none;"><img src="themes/icons/no.png">&nbsp;<font style="font-size:10px">单号不存在！</font></div></td>
						<input id="hadINV6" type="hidden" /> 
					</tr>

				</table>
			</div> 
			
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveInvoice();">确定</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addInvoice');">取消</a> 
			</div> 
		</div>
	</div>	
	<!-- 添加框end -->
</center>
</body>
</html>