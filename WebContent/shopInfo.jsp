<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<title>�ŵ���Ϣ����</title>	
	<script type="text/javascript" src="script/ajaxupload.3.5.js"></script>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	%>
	<script>
		var isNew = false; // ���һ�������Ƿ����µ�
		
		$(function(){
			$('#dept').datagrid({
				width: 900,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:false,
				loadMsg:'��������...',			
				columns:[[					
					{field:'shopid',title:'�ŵ����',width:80,sortable:true},
					{field:'shopname',title:'�ŵ�����',width:80,sortable:true},
					{field:'shopadd',title:'��ַ',width:280,sortable:true},
					{field:'shopcont',title:'��ϵ��',width:60,sortable:true},
					{field:'shoptel',title:'�绰',width:80,sortable:true},
					{field:'shopfax',title:'����',width:80,sortable:true},
					{field:'shopmail',title:'����',width:100,sortable:true},
					{field:'remarks',title:'��ע',width:103,sortable:true}
				]],
				pagination:true,
				rownumbers:true
				
				<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
				,toolbar:[{
					id:'btnSearch',
					text:'��ѯ',
					iconCls:'icon-search',
					handler:function(){
						search();
					}
				},'-',{
					id:'btnAdd',
					text:'�½�',
					iconCls:'icon-add',
					handler:function(){
						add();
					}
				},{
					id:'btnEdit',
					text:'�޸�',
					iconCls:'icon-edit',
					handler:function(){
						edit();
					}
				},{
					id:'btnDelete',
					text:'ɾ��',					
					iconCls:'icon-remove',
					handler:function(){
						remove();
					}
				}
				]
				
				<%
					}
				%>
				
			});
			reloadgrid();
			
			$('#deptManager_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        });//must����֤��ʼ��
	        
	        // ===============
	        // �ϴ�����
	        uploadIt();
	        deleteFile();
	        
		});	// load end	
		
		function reloadgrid ()  {  
        
	        //��ѯ����ֱ�������queryParams��
	        $('#dept').datagrid('options').url = 'JsonServlet';        
			$('#dept').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SeaShopInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
						ACTION_MANAGER : 'ShopInfoManager',		 
						list:[{
							sisgcode : User.sgcode
						}]
					}
				)
			};        
			$("#dept").datagrid('reload'); 
        
    	}
    	
    	function search(){
			$('#searchDept').window('open');
		}
		
		function cancelSearch(){
			$('#searchDept').window('close');
		}
		
		// ��ѯ�ķ���
		function searchDept(){
			var searchData = getFormData( 'searchDept' );
			
			//��ѯ����ֱ�������queryParams��
		    $('#dept').datagrid('options').url = 'JsonServlet';        
			$('#dept').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SeaShopInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
						ACTION_MANAGER : 'ShopInfoManager',		 
						list:[{
							 shopcode : $('#queryid').attr('value'),
							 shopname : $('#queryname').attr('value')
						}]
					}
				)
			};        
			$("#dept").datagrid('reload');				 
			
			cancelSearch();
		}
		
		// ������ӿ�
		function add(){			
			
			clearForm('deptManager_form');			
			$('#id').attr('disabled', '');// ���ò��ű�������
			isNew = true;
			$('#addDept').window('open');
		}
		
		// ��ӿ�ͱ༭��Ĺر�
		function cancel(what){
			$(what).window('close');
		}
		
		// ����(��ӻ����)
		function saveDept(){
		
			// ������֤
			if( !checkForm( 'deptManager_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
		
			var deptData = getFormData( 'deptManager_form' );
			deptData['sisgcode'] = User.sgcode;
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : isNew ? 'AddShopInfo' : 'UpShopInfo',
							ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
							ACTION_MANAGER : 'ShopInfoManager',
							optType : isNew ? 'add':'update',
							optContent : isNew ? '�����ŵ�':'�޸��ŵ�',		 
							list:[deptData]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	$.messager.alert('��ʾ','�����ŵ�ɹ�!','info');
                    	
                    	$('#dept').datagrid('reload');
                    	
                    	cancel('#addDept');                    	
                    }else{ 
                        $.messager.alert('��ʾ','�����ŵ�ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		}
		
		// ɾ������
		function remove(){
			var row = $('#dept').datagrid('getSelections'); // getSelected 
			
			if( row.length == 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;				
			}
			
			if( row.length > 1 ){
				$.messager.alert('����','ֻ��ѡ��һ�м�¼����ɾ����','warning');
				return;
			}
			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��[ ' + row[0].shopname + ' ]������?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'DelShopInfo',
									ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
									ACTION_MANAGER : 'ShopInfoManager',
									optType : 'delete',
									optContent : 'ɾ���ŵ�',		 
									list: [
										{
											sisgcode : User.sgcode,
											shopcode : row[0].shopid
										}
									]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	$.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	$('#dept').datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});		
			
						
		}
		
		// �����޸Ŀ� �����޸�����
		function edit(){			
			var row = $('#dept').datagrid('getSelections'); // getSelected
			clearForm('deptManager_form');
			
			if( row.length == 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
				return;				
			}
			
			if( row.length > 1 ){
				$.messager.alert('����','ֻ��ѡ��һ�м�¼���б༭��','warning');
				return;
			}
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'SeaShopInfo',  //  deptload
							ACTION_CLASS : 'com.bfuture.app.saas.model.ShopInfo',
							ACTION_MANAGER : 'ShopInfoManager',		 
							list:[{
								sisgcode : User.sgcode,
								shopcode : row[0].shopid
							}]
					})
					
				}, 
				function(data){
				
					// alert('data.rows.length : ' + data.rows.length)					
                
                    if( data.rows.length != undefined && data.rows.length > 0 ){
                    	var sm = data.rows[0];                    	
                    	fillForm('deptManager_form', sm);
                    	isNew = false;
                    	
                    	$('#shopcode').attr('value', sm['shopid']);
                    	$('#shopcode').attr('disabled', 'disabled');		// ���ò��ű��벻�ɱ༭
                    					
						$('#addDept').window('open');						
                    	 
                    }else{
                        $.messager.alert('��ʾ','û�л�ȡ�����ŵ����Ϣ!','error');
                    }
                    
            	},
            	'json'
            );			
		}
		
		// ͼƬ�ϴ�����===============================================================
		// ����ͼƬ�¼�
		function uploadIt() {
    		$(".uploadAndNext").click(function() {
				var uploadId = "#" + $(this).attr("id");
    			var btn = $(this);
    			new AjaxUpload( uploadId + "" , {
   					 	action : "UploadServletList.jsp" , 
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
   					 		
   					 		$("#pic").attr("disabled" , true); // �ϴ�������url�ı����ֹ�༭
   					 	},
   					 	
   					 	onComplete: function(file, response) {
							if(response != ''){ // ����ͼƬ�Ĵ�С
								$.messager.alert('û��ͨ����֤','ͼƬ��С���ܳ���3M��','warning');
								
	   							// ���¼���һ�±�ҳ��
	   							openUrl('shopInfo.jsp','Y',false);
	   							return false;
	   							
							}
							
							$(uploadId + "").parent().find(".uploadAndOkImg").attr("src" , "images/ok.gif");
							$(uploadId + "").parent().find(".deleteImg").attr("src" , "images/delete.gif").show();
							
							uploadIt();
							// deleteFile();
   					 	}
    			});
    		});
    	}
    	
    	// ɾ��ͼƬ�¼�
    	function deleteFile() {
    		$("#uploaddiv .deleteImg").click(function() {
	    			var fileName = $(this).parent().find("input").val();
	    			var thisObj = $(this);
	    			$.post("DeleteServletList.jsp" , {
	    				"fileName" : fileName
	    			},
	    				function(data) {
	    					thisObj.parent().remove();
	    					
	    					// ɾ��ͼƬ�������¼���һ�±�ҳ
	    					openUrl('shopInfo.jsp','Y',false);
	    					// uploadIt();
	    				}
	    			);
	    		});
    	}
		
	</script>
</head>
<body>
	
	<!-- �ϴ����ֿ�ʼ -->
	<table width="900" style="line-height:20px; text-align:left; border:none;font-size: 12px;" align="center">
	  
	  <%
		 if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
	  %>
	  <tr>
	    <td colspan="3" align="left" style="border:none; color:#33CCFF;">�ŵ�ֲ�����</td>
	  </tr>
	  <tr>
	    <td width="333" style="border:none;"><span class="STYLE3">�ϴ��ļ�</span></td>
	    <td width="333" style="border:none;">&nbsp;</td>
	    <td width="333" style="border:none;">&nbsp;</td>
	  </tr>
  		<tr>
		   <td style="border:none;"><span class="STYLE4">ע���ϴ��ļ��������Ϊ5M��</span></td>
		   <td style="border:none;">&nbsp;</td>
	    <td style="border:none;">&nbsp;</td>
	  </tr>
	  
	  <tr>
	    <td colspan="3" style="border:none;">    
	      	<div id="pictureManager_Form">
  				
  				<div id="uploaddiv">
	  				�ϴ�ͼƬ��<input type="text" id="pic" name="pic" required="true" /><span style="color:#FF0000">*</span>
	  				<button class="uploadAndNext" id="upload1">� ��</button>
	  				<img src="" width="20px" height="20px" class="uploadAndOkImg" style="display: none"/>
	  				<img src="" width="20px" height="20px" class="deleteImg" style="display:none;cursor: pointer;" alt="ɾ��"/><br/>
  				</div>
  				
  			</div>
	      </td>
	  </tr>
	  
	  <tr>
	    <td colspan="3" style="border:none;">&nbsp;</td>
	  </tr>
	  <% 
		 }else{
	  %>
	  <tr>
	    <td colspan="3" align="left" style="border:none; color:#33CCFF;">�ŵ�ֲ��鿴</td>
	  </tr>
	  <% 
		 }
	  %>
	  
	</table>
	<!-- �ϴ����ֽ��� -->
	
	<!-- �б���ʾstart -->
	<div align="center">
		<table id="dept"></table>
	</div>
	<!-- �б���ʾend -->
	
	<!-- ��ѯ������start -->
	<div id="searchDept" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="��ѯ�ŵ�" style="width:270px;height:160px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table class="tableClass">
					<tr>
						<td style="font-size: 12px;">�ŵ���룺</td>
						<td><input id="queryid" name="queryid" type="text" /></td>						
					</tr>					
					<tr>
						<td style="font-size: 12px;">�ŵ����ƣ�</td>
						<td><input id="queryname" name="queryname" type="text"/></td>
					</tr>
				</table>
			</div> 
			
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="searchDept();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelSearch();">ȡ��</a> 
			</div>
			 
		</div>
	</div>
	<!-- ��ѯ������end -->
	
	<!-- ��ӿ�start -->
	<div id="addDept" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�ŵ���Ϣ" style="width:300px;height:340px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="deptManager_form" class="tableClass">
					<tr>
						<td style="font-size: 12px;">�ŵ��ţ�</td>
						<td><input id="shopcode" name="shopcode" type="text" required="true"/></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">�ŵ����ƣ�</td>
						<td><input id="shopname" name="shopname" type="text" required="true"/></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">��ַ��</td>
						<td><input id="shopadd" name="shopadd" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">��ϵ�ˣ�</td>
						<td><input id="shopcont" name="shopcont" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">�绰��</td>
						<td><input id="shoptel" name="shoptel" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">���棺</td>
						<td><input id="shopfax" name="shopfax" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">���䣺</td>
						<td><input id="shopmail" name="shopmail" type="text" /></td>
					</tr>
					<tr>
						<td style="font-size: 12px;">��ע��</td>
						<td><input id="remarks" name="remarks" type="text" /></td>
					</tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveDept();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('#addDept');">ȡ��</a> 
			</div> 
		</div>
	</div>	
	<!-- ��ӿ�end -->
	
</body>
</html>