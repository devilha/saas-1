<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="x-ua-compatible" content="ie=7"/ >
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>֤�շ���</title>
<!-- �������� -->
<%
        //���������ȡ����
        String nameLSS =request.getParameter("name");
		Object obj = session.getAttribute( "LoginUser" );		
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	%>
<style type="text/css">

.STYLE2 {color: #FFFFFF}
.STYLE3 {
	font-size: 18px;
	font-weight: bold;
}
.STYLE6 {color: #FF0000}
.STYLE4 {color: #3399FF}
.STYLE7 {color: #00FFFF}
</style>

<script>
		$(function(){
			// ����б�
			$('#LicenceSearchLSSList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect :false,
				remoteSort: true,
				fitColumns:false,
				idField: 'ID',
				loadMsg:'��������...',
				columns:[[
						{field:'select',checkbox:true},
						{field:'CRT_BY_TIME',title:'�ϴ�ʱ��',width:70,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'DEADLINE',title:'��Чʱ��',width:70,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},
						{field:'SUPID',title:'��Ӧ�̱��',width:70,sortable:true},
						{field:'SUPNAME',title:'��Ӧ������',width:100,sortable:true},
						{field:'LICENCE_NAME',title:'֤������',width:193,sortable:true},
						{field:'MEMO',title:'֤����ע',width:110,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'INS_C',title:'�Ƿ����',width:60,sortable:true,
							formatter:function(value,rec){
								if( rec.DEADLINE != null && rec.DEADLINE.time != undefined ){
									if(new Date(rec.DEADLINE.time).format('yyyy-MM-dd') >= '<%=new SimpleDateFormat("yyyy-MM-dd").format(new Date())%>')
										return '��';
									else 
										return '��';
								}
							}
						},
						{field:'STATUS',title:'״̬',width:50,sortable:true,
							formatter:function(value,rec){
								if( value == 0 )
									return '���ύ'
								else if( value == 1)
									return '�����'
								else 
									return '�Ѳ���'
							}
						},
						{field:'REFUSE_MEMO',title:'����ԭ��',width:90,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'ID',title:'����',width:120,sortable:true,
							formatter:function(value,rec){
								if(rec.STATUS == '0'){
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + rec.URL + '");>�鿴</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=audit_cert("' + value + '","1");>���</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=reject_cert("' + value + '");>����</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=window.location.href="CertDownServlet?picname='+ rec.URL +'">����</a>';
								}else {
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + rec.URL + '");>�鿴</a>'
									+ '|<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=window.location.href="CertDownServlet?picname='+ rec.URL +'&sgocde=4005">����</a>';
								}
								
							}
						}
				]],				
				pagination:true,
				rownumbers:true
				,toolbar:[{
					id:'btnDelete',
					text:'ɾ��',					
					iconCls:'icon-remove',
					handler:function(){
						removeCert();
					}
				}
				]
			});
		  var nameLSS=$('#nameLSS').val();
		if(nameLSS==0){
		   reloadgrid();
		   }
		   $('#nameLSS').val('');
		}); // load end
		
		// ����ģʽ���ڣ��鿴ͼƬ
		function showPic(picurl){
	        //window.showModalDialog("imgpic.jsp?picurl=" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no");
			//window.showModalDialog("<=request.getContextPath() %>"+"/upload/" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // ���ػ�������ʹ��
			window.showModalDialog("<%=Constants.HttpImgUrl %>" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // ��������ʹ��
		}
		
		// ��˲���
		function audit_cert(id_temp,states_temp){
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ���ͨ����?', function(r){
				if (r){ 
			
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'UpdInfLicence',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
								ACTION_MANAGER : 'InfLicenceManager',
								optType : 'update',
								optContent : '����֤��',		 
								list:[{
									id :id_temp, // ����id
									status :states_temp, // ״̬
									opt_by_c : User.sucode // �����
								}]
						})
						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){ 
	                    	$.messager.alert('��ʾ','���֤���ɹ�!','info');
	                    	
	                    	$('#LicenceSearchLSSList').datagrid('reload');
	                    	
	                    }else{ 
	                        $.messager.alert('��ʾ','���֤��ʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
            
            } });
		}
		
		// �������ؿ�
		function reject_cert(id_temp){
			clearForm('certificatesManager_form'); // ��һ�±���֮ǰ������
			
			$('#id').attr('value',id_temp);
				
			$('#addCertificates').window('open');
		}
		
		// ��ӿ�ͱ༭��Ĺر�
		function cancel(what){
			$(what).window('close');
		}
		 
		// �����б�
		function reloadgrid()  {  
        	var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // ʵ������
			
			  var nameLSS=$('#nameLSS').val();
			  if(nameLSS!='')
		      searchData['status']=nameLSS;
		      else 
		      searchData['status']=$('#status').val();
        	
	        //��ѯ����ֱ�������queryParams��
	        $('#LicenceSearchLSSList').datagrid('options').url = 'JsonServlet';        
			$('#LicenceSearchLSSList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchInfLicence',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
						ACTION_MANAGER : 'InfLicenceManager',
						optType : 'query',
						optContent : '��ѯ֤��',			 
						list:[searchData]
					}
				)
			};        
			$('#showLicence').show(); // ��ʾ������ʾ��
			$("#LicenceSearchLSSList").datagrid('reload');
			$("#LicenceSearchLSSList").datagrid('resize'); 
        
    	}
    	
		// ���ò�ѯ���������
		function searchReset(){
			$('#licence_name').val( '' ); 		// ֤������
			$('#starttime_temp').val( '' ); 	// ��ʼ����
			$('#endtime_temp').val( '' ); 		// ��������
			$('#status').val( '' );				// ״̬		
		}
		
		// ���ز���
		function saveCertificates(){
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'UpdInfLicence',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
							ACTION_MANAGER : 'InfLicenceManager',
							optType : 'update',
							optContent : '����֤��',		 
							list:[{
								id :$('#id').val(), // ����id
								status :'2', // ״̬
								opt_by_c : User.sucode, // �����
								refuse_memo :$('#refuse_memo').val() // ����ԭ��
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','����֤���ɹ�!','info');
                    	
                    	$('#LicenceSearchLSSList').datagrid('reload');
                    	
                    	cancel('#addCertificates');  
                    	
                    }else{ 
                        $.messager.alert('��ʾ','����֤��ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		// ɾ������
		function removeCert(){
			var rows = $('#LicenceSearchLSSList').datagrid('getSelections'); // getSelected getSelections 
			if( rows.length == 0 ){
				$.messager.alert('����','��������ѡ��һ�м�¼��','warning');
				return;				
			}
			
			// ������һ��ѭ����������
			var certlist = [];
			for(var i = 0;i < rows.length;i++){
				certlist.push({ id : rows[i].ID });
				
				if( rows[i].STATUS == '1'){ // 1=�����
					$.messager.alert('����','[' + rows[i].LICENCE_NAME + ']����˲���ɾ����','warning');
					return;
				}
				if( rows[i].STATUS == '2'){ // 2=�Ѳ���
					$.messager.alert('����','[' + rows[i].LICENCE_NAME + ']�Ѳ��ز���ɾ����','warning');
					return;
				}
			}
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ����' + rows.length + '��������?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'DelInfLicence',
									ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
									ACTION_MANAGER : 'InfLicenceManager',
									optType : 'delete',
									optContent : 'ɾ��֤��',		 
									list: certlist
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	
		                    	$('#LicenceSearchLSSList').datagrid('reload');					// ���¼����б�
		                    	$('#LicenceSearchLSSList').datagrid('clearSelections'); 		// ���֮ǰѡ��ļ�¼
		                    	
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});	
		}
		
		// excel����
		function exportExcelLSS(){
		
			var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // ʵ������
			searchData['exportExcel'] = true; 
			searchData['enTitle'] = ['CRT_BY_TIME','DEADLINE','SUPID','SUPNAME','LICENCE_NAME','MEMO','DEADLINE','STATUS','REFUSE_MEMO' ];
			searchData['cnTitle'] = ['�ϴ�ʱ��','��Чʱ��','��Ӧ�̱��','��Ӧ������','֤������','֤����ע','�Ƿ����','״̬','����ԭ��'];
			searchData['sheetTitle'] = '֤�չ���';
		
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'SearchInfLicence',
								ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
								ACTION_MANAGER : 'InfLicenceManager',											 
								list:[searchData]
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
		
</script>

</head>


<body>
<center>
<input type="hidden" name="nameLSS" id="nameLSS" value="<%=nameLSS %>"/>

<!-- ��ѯ��������ʼ -->
  <table width="1000" id="LicenceSearch" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
  <tr>
    <td colspan="3" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">�ҵĹ���</span>-&gt;֤�չ���</td>
  </tr>
  <tr>
    <td width="333" style="border:none;">֤�����ƣ�
      <input name="licence_name" type="text" id="licence_name" size="20" />
    </td>
    <td width="333" style="border:none;">��&nbsp;ʼ&nbsp;��&nbsp;��&nbsp;��
      <input type="text" name="starttime_temp" id="starttime_temp" value="" size="20" onClick="WdatePicker();"/></td>
    <td width="333" style="border:none;">�������ڣ�
      <input type="text" name="endtime_temp" id="endtime_temp" value="" size="20" onClick="WdatePicker();"/></td>
  </tr>
  <tr>
    <td style="border:none;">״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬��
      <select name="status" id="status" style="width:155px;">
          <option value="">--��ѡ��--</option>
          <option value="0">���ύ</option>
          <option value="1">�����</option>
          <option value="2">�Ѳ���</option>
      </select>
    </td>
    <td width="333" style="border:none;">��Ӧ�̱�ţ�
      <input type="text" name="supid" id="supid" value="" size="20" />
    </td>
    <td width="333" style="border:none;">��Ʒ���룺
    	<input type="text" name="gdbarcode" id="gdbarcode" value="" size="20" />
    </td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">
    	<div align="left">
    		<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
    		<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onclick="searchReset();" style="margin-left:40px;" /></a>
    	</div>
    </td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">
      <!-- ����б�ʼ -->
      <div id="showLicence" style="display: none;">
   	  <div align="right" style="color:#33CCFF;"><a href="javascript:exportExcelLSS();">>>����Excel���</a></div>
	  <table id="LicenceSearchLSSList"></table>
      </div> 
      <!-- ����б���� -->    
    </td>
  </tr>
</table>
<!-- ��ѯ����������� -->

<!-- ����ԭ���start -->
	<div id="addCertificates" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="���ز���" style="width:400px;height:300px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="certificatesManager_form" class="tableClass">
				  
				   <tr>
				    <td style="font-size: 12px;"></td>
				    <td><input type="hidden" name="id" id="id" /></td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">����ԭ��</td>
					<td>
					
					<textarea id="refuse_memo" name="refuse_memo" rows="11" cols="30"></textarea>
					
					</td>
				  </tr>
				  
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveCertificates();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addCertificates');">ȡ��</a> 
			</div> 
		</div>
	</div>	
	<!-- ����ԭ���end -->
    
</center>
</body>
</html>
