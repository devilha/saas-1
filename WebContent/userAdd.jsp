<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�������û�</title>	

	<script>	
		
		$(function(){
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'roles',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[ {sucode:''} ]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
							var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
							$('#role').append(html);  
						});	
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ��ɫ�б�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );		
		
			$('#userForm1 input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });	        
		});	
		
		function clear(){
			clearForm('userForm1');
		}		
		
		function saveNewUser(){
			if( !checkForm( 'userForm1' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			
			var userdata = getFormsData( ['userForm1'] );
			userdata['suenable'] = 'Y';			
			userdata['sgcode'] = User.sgcode;
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'add',
							optContent : '������̨�û�',		 
							list:[ userdata ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	if( data.rows != undefined && data.rows.length > 0 ){
                    		var usr = data.rows[0]; 
	                    	$.messager.alert('��ʾ','�����û��ɹ�!<BR>�û�������' + usr.sucode + '��<BR>��ʼ���룺��' + usr.sucode + '��','info');
	                    	clearForm('userForm1');
                    	}
                    	else{
                    		$.messager.alert('��ʾ','�����û�ʧ��!���Ժ������³���','error');
                    	}
                    }else{ 
                        $.messager.alert('��ʾ','�����û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
	</script>
</head>
<body>
	<div title="�������û�"> 
		<table id="userForm1" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td align="left" style="border:none; color:#4574a0;">������û�</td> 
	    	</tr> 
	  		<tr> 
			    <td>�û���ɫ��
			    	<select style="width:150px;" id='role' name='role' size='1'>			         
			    	</select>
				</td> 
		  </tr> 
		  <tr> 
		  	<td>��˾���ƣ�<input name="sumemo" required="true" type="text" value="" /></td> 
		  </tr> 
		  <tr> 
		    <td>��&nbsp;&nbsp;ϵ&nbsp;&nbsp;�ˣ�<input name="suname" required="true" type="text" /></td> 
		  </tr> 
		  <tr> 
		    <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�䣺<input name="email" required="true"  validType="email" /><span style="color:#FF0000; margin-left:5px;">˵��������д��ȷ�Ĺ�˾���䣬�Է���Ϣ��ʧ��</span></td> 
		  </tr> 
		  <tr> 
		    <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����<input name="sutel" required="true"  validType="mobile" class="easyui-numberbox" min="0" precision="0" maxlength="11" /></td> 
		  </tr> 
		  <tr> 
		    <td style="padding-left:170px;"><a href="javascript:void(0)" onclick="saveNewUser();"><img src="images/tj_an.jpg" border="0" /></a></td> 
		  </tr> 
	  		
		</table> 	 
		
	</div>
</body>
</html>