<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="x-ua-compatible" content="ie=7"/ >
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>֤�շ�����ѯ</title>
<!-- ��Ӧ���� -->
<%     
       //���������ȡ����
        String nameURL =request.getParameter("name");
      
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
			$('#LicenceSearchGYSList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect : false,
				remoteSort: true,
				fitColumns:false,
				idField: 'ID',
				loadMsg:'��������...',
				columns:[[
						{field:'select',checkbox:true},
						{field:'CRT_BY_TIME',title:'�ϴ�ʱ��',width:90,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'DEADLINE',title:'��Чʱ��',width:100,sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},
						{field:'LICENCE_NAME',title:'֤������',width:220,sortable:true},
						{field:'MEMO',title:'֤����ע',width:150,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'ID',title:'�Ƿ����',width:100,sortable:true,
							formatter:function(value,rec){
								if( rec.DEADLINE != null && rec.DEADLINE.time != undefined ){
									if(new Date(rec.DEADLINE.time).format('yyyy-MM-dd') >= '<%=new SimpleDateFormat("yyyy-MM-dd").format(new Date())%>')
										return '��';
									else 
										return '��';
								}
							}
						},
						{field:'STATUS',title:'״̬',width:100,sortable:true,
							formatter:function(value,rec){
								if( value == 0 )
									return '���ύ'
								else if( value == 1 )
									return '�����'
								else
									return '�Ѳ���'
							}
						},
						{field:'REFUSE_MEMO',title:'����ԭ��',width:100,sortable:true,
							formatter:function(value,rec){
								if(value != null && value != ""){
										return '<span title="' + value + '">' + value + '</span>';
								}
							}
						},
						{field:'URL',title:'����',width:76,sortable:true,
							formatter:function(value,rec){
								return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPic("' + value + '","'+rec.ID+'");>�鿴</a>';
							}
						}
				]],				
				pagination:true,
				rownumbers:true
				,toolbar:[{
					id:'btnAdd',
					text:'�½�',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},'-',{
					id:'btnDelete',
					text:'ɾ��',					
					iconCls:'icon-remove',
					handler:function(){
						removeCert();
					}
				}
				]
			});
			
			
			$('#certificatesManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });//must����֤��ʼ��
	        
	        // ===============
	        // �ϴ�����
	        uploadIt();
	        deleteFile();
	        var nameURL=$('#nameURL').val();
	        if(nameURL==2 ){	
		    reloadgrid();
		    }
		    $('#nameURL').val('');
	        
		}); // load end   
		
		// ����ģʽ���ڲţ��鿴ͼƬ
		function showPic(picurl,id){

	        // window.showModalDialog("imgpic.jsp?picurl=" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no");
            window.showModalDialog("<%=Constants.HttpImgUrl %>" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // ��������ʹ��
			//window.showModalDialog("<=request.getContextPath() %>"+"/upload/" + picurl,"","dialogWidth:1000px;dialogHeight:700px;status:no"); // ������������ʹ��
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'updateViewStatus',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
						    ACTION_MANAGER : 'InfLicenceManager',	 
							list:[{
								id : id
							}]
					})
				},
            	'json'
            );
		}

		// �����б�
		function reloadgrid()  {  
        	var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // ʵ������
			searchData['supid'] = User.supcode; // ��Ӧ�̱���
				var nameURL=$('#nameURL').val();
			
	     if(nameURL!=''){
		 searchData['status']=nameURL;
		 searchData['view_status']='is null';
		 }else{ 
		 searchData['status']=$('#status').val();
		}
		
	        //��ѯ����ֱ�������queryParams��
	        $('#LicenceSearchGYSList').datagrid('options').url = 'JsonServlet';        
			$('#LicenceSearchGYSList').datagrid('options').queryParams = {
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
			$("#LicenceSearchGYSList").datagrid('reload');
			$("#LicenceSearchGYSList").datagrid('resize'); 
        
    	}
    	
    	// ������ӿ�
		function add(){			
			clearForm('certificatesManager_form'); // ��һ�±���֮ǰ������
				
			// $('#url').val(''); // ������Ҫ������һ�£��ϴ�������
			$('#upload1').attr('disabled' , ''); // ���ϴ���ť����hou add
			
			$(".uploadAndOkImg").hide(); // hou add
			$(".deleteImg").hide(); // hou add
							
			$('#addCertificates').window('open');
		}
		
		// ��ӿ�ͱ༭��Ĺر�
		function cancel(what){
			$(what).window('close');
		}
		
		// ���ò�ѯ���������
		function searchReset(){
			$('#licence_name').val( '' ); 		// ֤������
			$('#starttime_temp').val( '' ); 	// ��ʼ����
			$('#endtime_temp').val( '' ); 		// ��������
			$('#status').val( '' );				// ״̬		
		}
		
		// ����(���)
		function saveCertificates(){
		
			// ������֤
			if( !checkForm( 'certificatesManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
		
			var certificatesData = getFormData( 'certificatesManager_form' );
				certificatesData['ins_c'] = User.sgcode; 	// ʵ������
				certificatesData['supid'] = User.supcode; 	// ��Ӧ�̱���
				certificatesData['supname'] = User.suname; 	// ��Ӧ������
				certificatesData['crt_by_c'] = User.sucode; // �ϴ���
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'AddInfLicence',
							ACTION_CLASS : 'com.bfuture.app.saas.model.InfLicence',
							ACTION_MANAGER : 'InfLicenceManager',
							optType : 'add',
							optContent : '����֤��',		 
							list:[certificatesData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','����֤���ɹ�!','info');
                    	
                    	$('#LicenceSearchGYSList').datagrid('reload');
                    	
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
			var rows = $('#LicenceSearchGYSList').datagrid('getSelections'); // getSelected getSelections 
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
		                    	
		                    	$('#LicenceSearchGYSList').datagrid('reload');	// ���¼����б�
		                    	$('#LicenceSearchGYSList').datagrid('clearSelections'); 		// ���֮ǰѡ��ļ�¼
		                    	
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
		function exportExcelGYS(){
		
			var searchData = getFormData( 'LicenceSearch' );
        	
			searchData['ins_c'] = User.sgcode;  // ʵ������
			searchData['supid'] = User.supcode; // ��Ӧ�̱���
			searchData['exportExcel'] = true; 
			searchData['enTitle'] = ['CRT_BY_TIME','DEADLINE','LICENCE_NAME','MEMO','DEADLINE','STATUS','REFUSE_MEMO' ];
			searchData['cnTitle'] = ['�ϴ�ʱ��','��Чʱ��','֤������','֤����ע','�Ƿ����','״̬','����ԭ��'];
			searchData['sheetTitle'] = '֤�շ���';
		
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
		
		// ͼƬ�ϴ�����===============================================================
		// ����ͼƬ�¼�
		function uploadIt() {
    		//$(".uploadAndNext").click(function() {
    			var uploadId = "#" + $("#upload1").attr("id");
				//var uploadId = "#" + $(this).attr("id");
    			//var btn = $(this);
    			var btn = $("#upload1");
    			new AjaxUpload( uploadId + "" , {
   					 	action : "CertificatesUpl.jsp" , 
	   					onChange: function(file, extension){
	   					
	   						// ͼƬ���͵���֤
	   						if(/^(jpg|png|jpeg|gif|bmp)$/.test(extension)){
	   							// ͼƬ��С����֤
	   							// ������ʱ�ڷ���������֤
	   						}else {
	   							$.messager.alert('û��ͨ����֤','�ļ����Ͳ��Ϸ����������ϴ���','warning');
	   							return false;
	   						}
	   						
   							$(uploadId + "").parent().find("input")[0].value = file;
   					 		$(uploadId + "").parent().find(".uploadAndOkImg").show().attr("src" , "images/spinner.gif");
   					 		btn.attr("disabled" , "disabled");
   					 		$("#url").attr("disabled" , true); // �ϴ�������url�ı����ֹ�༭
   					 	},   					 	
   					 	onComplete: function(file, response) {
							if(response != ''){ // ����ͼƬ�Ĵ�С
								$.messager.alert('û��ͨ����֤','ͼƬ��С���ܳ���3M��','warning');
								
	   							// ���¼���һ�±�ҳ��
	   							openUrl('CertificatesGYS_vigo.jsp','Y',false);
	   							return false;
	   							
							}
							
							$(uploadId + "").parent().find(".uploadAndOkImg").attr("src" , "images/ok.gif");
							$(uploadId + "").parent().find(".deleteImg").attr("src" , "images/delete.gif").show();
							
							//uploadIt();
							// deleteFile();
   					 	}
    			});
    		//});
    	}
    	
    	// ɾ��ͼƬ�¼�
    	function deleteFile() {
    		$("#uploaddiv .deleteImg").click(function() {
	    			var fileName = $(this).parent().find("input").val();
	    			var thisObj = $(this);
	    			$.post("CertificatesDel.jsp" , {
	    				"fileName" : fileName
	    			},
	    				function(data) {
	    					// thisObj.parent().remove(); // �������������أ�����ɾ��
	    					// thisObj.parent().hide();
	    					
	    					$("#url").attr("value" ,''); // ���url�ı���
	    					$("#url").attr("disabled" , true ); // ��url�ı���ɱ༭
	    					$('#upload1').attr('disabled' , ''); // ���ϴ���ť����hou add
							$(".uploadAndOkImg").hide(); // hou add
							$(".deleteImg").hide(); // hou add
	    					
	    					// add();
	    					// ɾ��ͼƬ�������¼���һ�±�ҳ
	    					// openUrl('CertificatesGYS.jsp','Y',false);
	    					// uploadIt();
	    				}
	    			);
	    		});
    	}

</script>

</head>


<body>
<center>
<input type="hidden" name="nameURL" id="nameURL" value="<%=nameURL %>"/>

<!-- ��ѯ��������ʼ -->
  <table width="1000" id="LicenceSearch" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
  <tr>
    <td colspan="3" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">�ҵĹ���</span>-&gt;֤�����</td>
  </tr>
  <tr>
    <td width="333" style="border:none;">֤�����ƣ�
      <input name="licence_name" type="text" id="licence_name" size="20" />
    </td>
    <td width="333" style="border:none;">��ʼ���ڣ�
      <input type="text" name="starttime_temp" id="starttime_temp" value="" size="20" onClick="WdatePicker();"/></td>
    <td width="333" style="border:none;">�������ڣ�
      <input type="text" name="endtime_temp" id="endtime_temp" value="" size="20" onClick="WdatePicker();"/></td>
  </tr>
  <tr>
    <td colspan="3" style="border:none;">״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬��
      <select name="status" id="status" style="width: 155px;">
          <option value="">--��ѡ��--</option>
          <option value="0">���ύ</option>
          <option value="1">�����</option>
          <option value="2">�Ѳ���</option>
      </select></td>
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
   	    <div id="excel" align="right" style="color:#33CCFF;"><a href="javascript:exportExcelGYS();">>>����Excel���</a></div>
	    <table id="LicenceSearchGYSList"></table>
     </div> 
     <!-- ����б���� -->    
    </td>
  </tr>
</table>
<!-- ��ѯ����������� -->
    
    <!-- ��ӿ�start -->
	<div id="addCertificates" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="֤������" style="width:400px;height:400px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="certificatesManager_form" class="tableClass">
				  <tr>
				    <td colspan="2" style="font-size: 12px;"><span class="STYLE6">ע��*Ϊ������Ϣ</span></td>
				  </tr>
				  
				   <tr>
				    <td style="font-size: 12px;">֤�����ƣ�</td>
				    <td><input type="text" name="licence_name" id="licence_name" required="true"/><span class="STYLE6">*</span></td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">��Ч�ڣ�</td>
					<td><input type="text" name="deadline_temp" id="deadline_temp" required="true" onClick="WdatePicker();"/><span class="STYLE6">*</span></td>
				  </tr>
				  
				  <!-- ͼƬ�ϴ�����ʼ -->
				  <tr>
				    <td colspan="2" style="font-size: 12px;">
				    	<!-- �ϴ�������&nbsp;&nbsp;&nbsp;      
				      		<input type="file" name="url" id="url" />
				      		<span class="STYLE6">*</span>&nbsp;&nbsp;&nbsp;&nbsp;
				       -->
				       <div id="uploaddiv">
			  				�ϴ�ͼƬ��&nbsp;&nbsp;<input type="text" id="url" name="url" required="true" /><span style="color:#FF0000">*</span>
			  				<!--<button class="uploadAndNext" id="upload1">� ��</button> -->
			  				<input type="button" id="upload1" value="� ��" />&nbsp;&nbsp; 
			  				<img src="" width="20px" height="20px" class="uploadAndOkImg" style="display: none"/>
			  				<img src="" width="20px" height="20px" class="deleteImg" style="display:none;cursor: pointer;" alt="ɾ��"/><br/>
  					  </div>
				      
				    </td>
				  </tr>
				  <!-- ͼƬ�ϴ������� -->
				  
				  <tr>
				    <td>&nbsp;</td>
				    <td style="font-size: 12px;">ע���ϴ����ļ��������Ϊ5M��</td>
				  </tr>
				  
				  <tr>
					<td style="font-size: 12px;">��ע��</td>
					<td>
					
					<textarea id="memo" name="memo" rows="10" cols="20"></textarea>
					
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
	<!-- ��ӿ�end -->
</center>
</body>
</html>
