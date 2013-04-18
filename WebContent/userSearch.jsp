<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>ϵͳ�û�����</title>	

	<script>
			
		$(function(){
			$('#userList').datagrid({
				title:'',
				width: 650,				
				nowrap: false,
				striped: true,
				collapsible:false,
				url:'JsonServlet',
				fitColumns:false,
				queryParams : {
					data :obj2str(
						{		
							ACTION_TYPE : 'datagrid',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'query',
							optContent : '��ѯϵͳ�û�',	 
							list:[{
								sgcode : User.sgcode
							}]
						}
					)
				},   
				loadMsg:'��������,���Ե�...',				
				columns:[[
					{field:'crttime',title:'ע��ʱ��',width:100,
						formatter:function(value,rec){
							if( value != null && value.time != undefined )
								return new Date(value.time).format('yyyy-MM-dd');
						}
					},
					{field:'sumemo',title:'��˾����',width:140},
					{field:'sucode',title:'�û���',width:100,
						formatter:function(value,rec){
							return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=editUser("' + value + '");>' + value + '</a>';
						}
					},
					{field:'sutel',title:'�ƶ��绰',width:130},						
					{field:'email',title:'ע������',width:170}
											
				]],				
				pagination:true				
			});	
			
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
		
			$('#userForm2 input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });

		});	
		
		function editUser( sucode ){
			clearForm('userForm2');
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',		 
							list:[ {sucode: sucode } ]
					})					
				}, 
				function(data){ 
                    if(data.returnCode == '1'  ){
                    	if( data.rows != undefined && data.rows.length > 0 ){ 
                    		var userData = data.rows[0];
                    		fillForm( 'userForm2', userData );
                    		$('#divUserList').hide();
                    		$('#divUserForm').show();	
                    	}
                    	else{
                    		$.messager.alert('��ʾ','û�л�ȡ���κ��û���Ϣ','error');
                    	}
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�û���Ϣ�б�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}	
		
		function saveUser(){
			if( !checkForm( 'userForm2' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			
			var userdata = getFormsData( ['userForm2'] );
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'saveUser',
							ACTION_CLASS : 'com.bfuture.app.saas.model.SysScmuser',
							ACTION_MANAGER : 'userManager',
							optType : 'update',
							optContent : '�޸ĺ�̨�û�',		 
							list:[ userdata ]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	$.messager.alert('��ʾ','�޸��û��ɹ�!','info');
						cancel();
						$('#userList').datagrid('reload');
						$('#userList').datagrid('resize');
                    }else{ 
                        $.messager.alert('��ʾ','�޸��û�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		function cancel(){
			$('#divUserList').show();
            $('#divUserForm').hide();	
		}		
		
	</script>
</head>
<body>		
	<div id="divUserList" style="width: 650px">	
		<table id="userList"></table>
	</div>	 
	
	<div id="divUserForm" title="�û���Ϣά��" style="display: none;"> 
		<table id="userForm2" width="650" style="line-height:20px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td align="left" style="border:none; color:#4574a0;">
					�û���Ϣά��
					<input type="hidden" name="sucode">
					<input type="hidden" name="sgcode">
				</td> 
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
		    <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����<input name="sutel" required="true"  validType="mobile" class="easyui-numberbox" min="0" precision="0" /></td> 
		  </tr> 
		  <tr> 
		    <td style="padding-left:100px;">
		    	<a href="javascript:void(0)" onclick="saveUser();"><img src="images/tj_an.jpg" border="0" /></a>
		    	<a href="javascript:void(0)" onclick="cancel();"><img src="images/goback.jpg" border="0" /></a>
		    </td> 
		  </tr> 
	  		
		</table> 	 
		
	</div>
</body>
</html>