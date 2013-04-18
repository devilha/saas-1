<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
	<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;	
		String sgcode = currUser.getSgcode();
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>提交促销申请</title>
		<style type="text/css"> 
			.label_style{
				width:100px;
				height:30px;
				line-height:30px;
			}
			.dot{
				color:#F00;
			}
				
		</style>
		<script type="text/javascript">
		$().ready(function(){
			//上传文件
			var load = new AjaxUpload( "upload", {
				action : "AttachmentUploadServlet.jsp",
				autoSubmit:false,
				onChange : function(file, extension) {
    				$("#ppfile").val(file);
					// 附件类型的验证
					if (/^(doc|docx|xls|xlsx|pdf)$/.test(extension)) {
						// 附件大小的验证
						// 这里暂时在服务器端验证
					} else {
						$.messager.alert('没有通过验证', '文件类型不合法，请重新上传！', 'warning');
						return false;
					}
				},
				onComplete : function(file, response) {
					var reply = JSON.parse(response);
					if (reply.err != null ) { // 控制附件的大小
							$.messager.alert('没有通过验证', reply.err , 'warning');
							return false;
					}else{
						save();
					}
				}
			});
		var submit=$('#tijiao').click(function(){
				if(!checkAll()){
					return false;
				}
				save();
			});
		})	
		//获取所有门店信息
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
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		function reset1() {
			$("#ppgdbarcode").val("");		   
			$("#ppgdname").val("");		   
			$("#ppgdid").val("");		   
			$("#ppmarket").val("");		   
			$("#ppbjrq").val("");		   
			$("#ppbjyy").val("");		   
			$("#ppksrq").val("");		   
			$("#ppjsrq").val("");		   
			$("#ppcxsj").val("");		   
			$("#ppgdyj").val("");		   
		}
        function checkAll(){
	          return checkIsEmpty('ppgdbarcode','商品条码') &&
	       		    checkIsEmpty('ppgdname','商品名称') &&
	       		 	checkIsEmpty('ppgdid','商品编码') &&
	                checkIsEmpty('ppmarket','门店名称') &&
	                checkIsEmpty('ppbjrq','变价日期') &&
	                checkIsEmpty('ppbjyy','促销原因') &&
	                checkIsEmpty('ppksrq','促销开始日期') &&
	                checkIsEmpty('ppjsrq','促销结束日期') &&
	                checkIsEmpty('ppcxsj','促销价格') &&
	                checkIsNumber('ppcxsj','促销价格') &&
	                checkIsEmpty('ppgdyj','商品原价') &&
	                checkIsNumber('ppgdyj','商品原价');
 	    }
 	    function getGoodInfo(){
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getGoodInfo',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfGoods',
							ACTION_MANAGER : 'ywPopInfoManager',		 
							list:[{								
								gdbarcode : $('#ppgdbarcode').val(),
								sgcode : "<%=sgcode%>"
								
							}]
					})							
				}, 
				function(data){ 
		        	if(data.returnCode == '1' ){ 
						if( data.rows != undefined && data.rows.length > 0 ){
			                $("#ppgdname").val(data.rows[0].GDNAME);
			                $("#ppgdid").val(data.rows[0].GDID);
						}else{
							$.messager.alert('提示', '此商品条码不存在!', 'warn');
						}
					}else{ 
						$.messager.alert('提示','自动获取商品信息失败!<br>原因：' + data.returnInfo,'error');
					} 
				},
				'json'
			);
		}
		function save() {
        	var searchData = getFormData( 'popInfo' );
			searchData['ppsupid'] = User.supcode;  		// 供应商编码
			searchData['ppsgcode'] = User.sgcode;  // 实例编码
			$.post('JsonServlet', {
				data : obj2str( {
					ACTION_TYPE : 'YwPopInfoApply',
					ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwPopinfoForm',
					ACTION_MANAGER : 'ywPopInfoManager',
					optType : 'add',
					optContent : '提交促销申请表',
					list : [ searchData ]
				})
		
			}, function(data) {
				if (data.returnCode == '1') {
					$.messager.alert('提示', '提交成功!', 'info');
					openUrl('popInfoList.jsp','Y');					
					return true;
				} else {
					$.messager.alert('提示', '提交失败!<br>原因：' + data.returnInfo, 'error');
					return false;
				}
			}, 'json');
		
		}
		function sendRedictToList(){
			openUrl('popInfoList.jsp','Y');	
		}
		function checkIsEmpty(id,message){
	          var flag = true;
	          if(document.getElementById(id).value=="")
	          {
	          	 $.messager.alert('提示', message+'不能为空', 'warning');
	             //alert(message+"不能为空");
	             document.getElementById(id).style.backgroundColor="yellow";
	             flag = false;
	          }else{
	             document.getElementById(id).style.backgroundColor="white";
	          }
	          return flag;
		}
		function checkIsNumber(id,message)	{
		    //正则表达式
		    var EL = /^\d{0,}$/;
		    var flag = true;
		    if(isNaN(document.getElementById(id).value))
		    {
		    	$.messager.alert('提示', message+'必须是数字', 'warning');
		        //alert(message+"必须是数字");
		        flag = false;
		        document.getElementById(id).style.backgroundColor="yellow";
		    }else{
		        document.getElementById(id).style.backgroundColor="white";
		    }
		    return flag;
		}
		</script>
</head>
	<body>
	
		<center>
		<form id="popInfoForm">
		<div style="margin:0 auto; width:800px; height:400px; padding:0; border:0;">
			<table id="popInfo" width="100%" border="0" style="line-height:30px; font-size:12px; padding:0; margin:0">
		  <tr>
		    <td colspan="4"><span>价格管理</span>-&gt;促销或变价申请 <span>-&gt;发送申请</span></td>
		  </tr>
		  <tr>
		    <td class="label_style">商品条码：</td>
		    <td>
		      <input type="text" onblur="getGoodInfo();" name="ppgdbarcode" id="ppgdbarcode" />
		    <label class="dot">*</label></td>
		    <td class="label_style">商品名称：</td>
		    <td><input type="text" name="ppgdname" id="ppgdname" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">商品编码：</td>
		    <td><input type="text" name="ppgdid" id="ppgdid" />
		    <label class="dot">*</label>
		    </td>
		    <td class="label_style">门店名称：</td>
		    <td><select style="width:150px;" name="ppmarket" id="ppmarket" size='1'>
		              			<option value = ''>所有门店</option>
		      				</select>
		      				<label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">变价日期：</td>
		    <td><input type="text" name="ppbjrq" id="ppbjrq" value="" 
							onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		    <td class="label_style">促销或变价原因：</td>
		    <td><input type="text" name="ppbjyy" id="ppbjyy" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">促销开始日期：</td>
		    <td><input type="text" name="ppksrq" id="ppksrq"
							value="" onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		    <td class="label_style">促销结束日期：</td>
		    <td><input type="text" name="ppjsrq" id="ppjsrq" value="" id="ppjsrq"
							onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">执行价格：</td>
		    <td><input type="text" name="ppcxsj" id="ppcxsj" />
		    <label class="dot">*</label></td>
		    <td class="label_style">原价：</td>
		    <td><input type="text" name="ppgdyj" id="ppgdyj" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">上传文件：</td>
		    <td><input type="text" name="ppfile" id="ppfile" />
		       <input type="button" value="浏览" style="margin-left:5px; "  id="upload" />
		        </td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="4">注：输入商品条码后会自动显示此条码对应的商品名称及编码，请正确输入商品条码</td>
		     
		  </tr>
		</table>
		<div align="left">
			<img src="images/tijiao.jpg" width="56" height="20" border="0" id="tijiao"/>
	        <img src="images/cz.jpg" width="56" height="20" border="0" onClick="reset1();"/>
	        <img src="images/goback.jpg" width="56" height="20" border="0" onClick="sendRedictToList();"/>
		</div>
		</div>
		</form>
		</center>
	</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("ppmarket");
loadAllShop(obj);
</script>
</html>