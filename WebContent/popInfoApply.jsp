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
		<title>�ύ��������</title>
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
			//�ϴ��ļ�
			var load = new AjaxUpload( "upload", {
				action : "AttachmentUploadServlet.jsp",
				autoSubmit:false,
				onChange : function(file, extension) {
    				$("#ppfile").val(file);
					// �������͵���֤
					if (/^(doc|docx|xls|xlsx|pdf)$/.test(extension)) {
						// ������С����֤
						// ������ʱ�ڷ���������֤
					} else {
						$.messager.alert('û��ͨ����֤', '�ļ����Ͳ��Ϸ����������ϴ���', 'warning');
						return false;
					}
				},
				onComplete : function(file, response) {
					var reply = JSON.parse(response);
					if (reply.err != null ) { // ���Ƹ����Ĵ�С
							$.messager.alert('û��ͨ����֤', reply.err , 'warning');
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
	          return checkIsEmpty('ppgdbarcode','��Ʒ����') &&
	       		    checkIsEmpty('ppgdname','��Ʒ����') &&
	       		 	checkIsEmpty('ppgdid','��Ʒ����') &&
	                checkIsEmpty('ppmarket','�ŵ�����') &&
	                checkIsEmpty('ppbjrq','�������') &&
	                checkIsEmpty('ppbjyy','����ԭ��') &&
	                checkIsEmpty('ppksrq','������ʼ����') &&
	                checkIsEmpty('ppjsrq','������������') &&
	                checkIsEmpty('ppcxsj','�����۸�') &&
	                checkIsNumber('ppcxsj','�����۸�') &&
	                checkIsEmpty('ppgdyj','��Ʒԭ��') &&
	                checkIsNumber('ppgdyj','��Ʒԭ��');
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
							$.messager.alert('��ʾ', '����Ʒ���벻����!', 'warn');
						}
					}else{ 
						$.messager.alert('��ʾ','�Զ���ȡ��Ʒ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
					} 
				},
				'json'
			);
		}
		function save() {
        	var searchData = getFormData( 'popInfo' );
			searchData['ppsupid'] = User.supcode;  		// ��Ӧ�̱���
			searchData['ppsgcode'] = User.sgcode;  // ʵ������
			$.post('JsonServlet', {
				data : obj2str( {
					ACTION_TYPE : 'YwPopInfoApply',
					ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwPopinfoForm',
					ACTION_MANAGER : 'ywPopInfoManager',
					optType : 'add',
					optContent : '�ύ���������',
					list : [ searchData ]
				})
		
			}, function(data) {
				if (data.returnCode == '1') {
					$.messager.alert('��ʾ', '�ύ�ɹ�!', 'info');
					openUrl('popInfoList.jsp','Y');					
					return true;
				} else {
					$.messager.alert('��ʾ', '�ύʧ��!<br>ԭ��' + data.returnInfo, 'error');
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
	          	 $.messager.alert('��ʾ', message+'����Ϊ��', 'warning');
	             //alert(message+"����Ϊ��");
	             document.getElementById(id).style.backgroundColor="yellow";
	             flag = false;
	          }else{
	             document.getElementById(id).style.backgroundColor="white";
	          }
	          return flag;
		}
		function checkIsNumber(id,message)	{
		    //������ʽ
		    var EL = /^\d{0,}$/;
		    var flag = true;
		    if(isNaN(document.getElementById(id).value))
		    {
		    	$.messager.alert('��ʾ', message+'����������', 'warning');
		        //alert(message+"����������");
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
		    <td colspan="4"><span>�۸����</span>-&gt;������������ <span>-&gt;��������</span></td>
		  </tr>
		  <tr>
		    <td class="label_style">��Ʒ���룺</td>
		    <td>
		      <input type="text" onblur="getGoodInfo();" name="ppgdbarcode" id="ppgdbarcode" />
		    <label class="dot">*</label></td>
		    <td class="label_style">��Ʒ���ƣ�</td>
		    <td><input type="text" name="ppgdname" id="ppgdname" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">��Ʒ���룺</td>
		    <td><input type="text" name="ppgdid" id="ppgdid" />
		    <label class="dot">*</label>
		    </td>
		    <td class="label_style">�ŵ����ƣ�</td>
		    <td><select style="width:150px;" name="ppmarket" id="ppmarket" size='1'>
		              			<option value = ''>�����ŵ�</option>
		      				</select>
		      				<label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">������ڣ�</td>
		    <td><input type="text" name="ppbjrq" id="ppbjrq" value="" 
							onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		    <td class="label_style">��������ԭ��</td>
		    <td><input type="text" name="ppbjyy" id="ppbjyy" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">������ʼ���ڣ�</td>
		    <td><input type="text" name="ppksrq" id="ppksrq"
							value="" onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		    <td class="label_style">�����������ڣ�</td>
		    <td><input type="text" name="ppjsrq" id="ppjsrq" value="" id="ppjsrq"
							onClick="WdatePicker({isShowClear:true,readOnly:true});" />
							<label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">ִ�м۸�</td>
		    <td><input type="text" name="ppcxsj" id="ppcxsj" />
		    <label class="dot">*</label></td>
		    <td class="label_style">ԭ�ۣ�</td>
		    <td><input type="text" name="ppgdyj" id="ppgdyj" />
		    <label class="dot">*</label></td>
		  </tr>
		  <tr>
		    <td class="label_style">�ϴ��ļ���</td>
		    <td><input type="text" name="ppfile" id="ppfile" />
		       <input type="button" value="���" style="margin-left:5px; "  id="upload" />
		        </td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="4">ע��������Ʒ�������Զ���ʾ�������Ӧ����Ʒ���Ƽ����룬����ȷ������Ʒ����</td>
		     
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
// �����ŵ�
var obj = document.getElementById("ppmarket");
loadAllShop(obj);
</script>
</html>