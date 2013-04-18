<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>��������</title>
<!-- ��Ӧ���� -->
<%
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
			$('#supinfoSerachList').datagrid({	
			    title: '',	
				width: 1085,
				nowrap: false,
				striped: true,
				url:'',		
				fitColumns:false,
				remoteSort: true,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[
					{field:'select',checkbox:true},				
					{field:'SUPID',title:'��Ӧ�̱���',width:80,align:'center'},
					{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true},
					{field:'SUPCONT',title:'��ϵ��',width:100,align:'center',sortable:true},					
					{field:'SUPCONTPHONE',title:'��ϵ�˵绰',width : 80,sortable:true,align:'center'},
					{field:'SUPCONTEMAIL',title:'��ϵ��Email',width:80,align:'center',sortable:true},
					{field:'SUPDUTYNO',title:'��ҵ˰��',width:100,align:'center',sortable:true},
					{field:'SUPFAX',title:'����',width:80,align:'center',sortable:true},
					{field:'SUPBANK',title:'������',width:100,align:'center',sortable:true},
					{field:'SUPZIP',title:'�ʱ�',width:80,align:'center',sortable:true},
					{field:'SUPADD',title:'��Ӧ�̵�ַ',width:150,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true	
			});
			//���ؽ�ɫ��Ϣ
			$.post('JsonServlet',
				{
					data : obj2str({	
						ACTION_TYPE : 'getRoleInfo',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'query',
						optContent : '��ѯ��ɫ��Ϣ',		 
						list : [{
							supsgcode : User.sgcode
						}]
					})
				},function(data){
					if(data.returnCode == '1' ){
                   	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                   	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
				            var html = "<option value='" + n.RLCODE + "'>" + n.RLNAME + "</option>";  
				            $("#selectionRole").append(html);  
				        });						        
                   	 }	                    	 
                   }else{ 
                   	  $.messager.alert('��ʾ','��ȡ��ɫ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                   } 
				},
				'json'
			); 
			
			// ��ʼ����֤���
			$('#userinfo_form input').each(function () {
	            if ($(this).attr('required') || $(this).attr('validType'))
	                $(this).validatebox();
	        }); 
		});
		 
		// �����б�
		function reloadgrid()  { 
	        //��ѯ����ֱ�������queryParams��
	        $('#supinfoSerachList').datagrid('options').url = 'JsonServlet';        
			$('#supinfoSerachList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.InfSupinfo',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'query',
						optContent : '��ѯδ������Ӧ����Ϣ',			 
						list:[{
							supsgcode : User.sgcode,
							supid : $("#supid").val(),
							supname : $("#supname").val()
						}]
					}
				)
			};        
			$('#showSupinfo').show(); // ��ʾ������ʾ��
			$("#supinfoSerachList").datagrid('reload');
			$("#supinfoSerachList").datagrid('resize'); 
    	}
    	
    	//  �������������ť����������������д��Ϣ��
    	function plkh(){
    		//��ȡѡ�м�¼
    		var rows = $('#supinfoSerachList').datagrid('getSelections');
    		if( rows.length == 0 ){
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
				return;
			}
			// ��������û���Ϣ
			$("#addUser").window('open');
    	}
    	
    	//��������û���Ϣ
		function addUserInfo(){
			//��֤�û������Ƿ�Ϸ�
			if( !checkForm( 'userinfo_form' ) ){
				$.messager.alert('û��ͨ����֤','�����Ƿ��б�����д����û����д��','warning');
				return;
			}
			//��ȡ��������
			var params = getFormData('userinfo_form');
			//��ȡѡ�м�¼
			var rows = $('#supinfoSerachList').datagrid('getSelections');
			var supids = "";
			$.each( rows, function(i, n) {    
				// ѭ��ԭ�б���ѡ�еĹ�Ӧ�̱���
				supids = supids + "'" +n.SUPID + "',";
			});
			supids = supids.substring(0 ,supids.length - 1);
			params['sgcode'] = User.sgcode;
			params['supcodes'] = supids;
			params['rlcode'] = $("#selectionRole").val();
			params['isSetMd'] = getRadioValue('userinfo_form');
			
			//��������
			$.post('JsonServlet',
				{
					data : obj2str({	
						ACTION_TYPE : 'plkh',
						ACTION_CLASS : 'com.bfuture.app.saas.model.Plkh',
						ACTION_MANAGER : 'plkhManagerImpl',
						optType : 'addUserinfo',
						optContent : '��������',		 
						list : [params]
					})
				},function(data){
					if(data.returnCode == '1' ){ 
						//���¼��ػ�δ�����Ĺ�Ӧ����Ϣ
                    	$("#supinfoSerachList").datagrid('reload');
						$("#supinfoSerachList").datagrid('resize');
						// �ر���д��Ϣ��
						cancel();
                    	$.messager.alert('��ʾ','���������ɹ�!','info');
                    }else{ 
                        $.messager.alert('��ʾ','��������ʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
				},
				'json'
			); 	
		}
		
		// �ر���д��Ϣ��
		function cancel(){
			$("#addUser").window('close');
		}
		//����radio��ֵ
		function getRadioValue(formId){
			var radioValue = "";
			if( formId ){
				$( '#' + formId + ' :radio' ).each(function () {
				    if ( $(this).attr('checked') ) {	
				    	radioValue = $(this).val();
				    }
				});
			}
			return radioValue;
		}
		
</script>

</head>

<body>

<!-- ��ѯ��������ʼ -->
	<table width="1085" align="center" style="line-height:20px; text-align:left; border:none; font-size: 12px;">
	  <tr>
	    <td colspan="4" align="left" style="border:none; color:#33CCFF;">���������û�</td>
	  </tr>
	  <tr>
	    <td colspan="4">
	    	��Ӧ�̱��룺<input name="supid" type="text" id="supid" size="20" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	��Ӧ�����ƣ�<input type="text" name="supname" id="supname" size="20"/>
	    </td>
	  </tr>
	  <tr>
	    <td colspan="4" style="border:none;">
	    	<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
	    	&nbsp;
	    	<a href="javascript:void(0);"><img src="images/qx.jpg" border="0" onclick="back();" style="margin-left:40px;" /></a>
	    </td>
	  </tr>
	  <tr>
	  	<td colspan="4" style="border:none;">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="4" style="border:none;">
	  		<!-- ����б�ʼ  -->
			<div id="showSupinfo" style="margin-top:5px; width:1085px;display: none;">
			   	<div align="right" style="color:#33CCFF;">>>����Excel���</div>
				<table id="supinfoSerachList"></table><br/>
				<div align="right">
					<a href="javascript:void(0);"><img src="images/plkh.jpg" border="0" onclick="plkh();" style="margin-left:40px;" /></a>
				</div>
			</div> 
	  	</td>
	  </tr>
	</table>
<!-- ��ѯ����������� -->

    
    <!-- ��ӿ�start -->
	<div id="addUser" class="easyui-window" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="����������ʼ������" style="width:400px;height:300px;font-size: 12px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table id="userinfo_form" class="tableClass">
				  <tr>
				    <td colspan="2" style="font-size: 12px;"><span class="STYLE6">ע��*Ϊ������Ϣ</span></td>
				  </tr>
				   <tr>
				    <td style="font-size: 12px;">��ʼ������&nbsp;��</td>
				    <td>
				    	<input type="password" name="password" id="password" required="true" size="22" />
				    	<span class="STYLE6">*</span>
				    </td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">���뿪ʼʱ�䣺</td>
					<td>
						<input type="text" id="startDate" name="startDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}',minDate:'%y-%M-%d'});"size="20" />
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">�������ʱ�䣺</td>
					<td>
						<input type="text" id="endDate" name="endDate" type="text" required="true" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}'});" size="20" />
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
					<td style="font-size: 12px;">�Ƿ������ŵ꣺</td>
					<td>
						<input type="radio" name="isSetMd" checked="checked" value="Y" />��
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="isSetMd" value="N" />��
						<span class="STYLE6">*</span>
					</td>
				  </tr>
				  <tr>
				  	<td style="font-size: 12px;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ɫ��</td>
					<td>
						<select id="selectionRole" name="selectionRole" style="width:140px;"></select>
						<span class="STYLE6" >*</span>
					</td>
				  </tr>
				</table>
			</div> 
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="addUserInfo();">ȷ��</a> 
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('');">ȡ��</a> 
			</div> 
		</div>
	</div>	
    
</body>
</html>
