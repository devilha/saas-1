<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%      //��������õ�һ�� ����
		String popPama=request.getParameter("name");
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>����Ʒ���������ѯ</title>
<style type="text/css"> 
	.label_style{
		width:60px;
		height:30px;
		line-height:30px;
	}
	.input_style{
		width:140px;
		height:25px;
		line-height:20px;
	}
</style>
	<script type="text/javascript">
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
	$(function(){
			//var id;
			// ������Ʒ���������б�
			$('#popInfoList').datagrid({
				nowrap: false,
				striped: true,
				url:'JsonServlet',		
				remoteSort: true,
				showFooter:true,
				width: 932,
				loadMsg:'��������...',
				columns:[[
						/*
						{field:'POPSEQUECE',align:'center',title:'��&nbsp;&nbsp;&nbsp;&nbsp;��',width:80,sortable:true,
							formatter:function(value,rec){
								id = value;
								return value;
							}
						},*/
						{field:'select',checkbox:true},
						{field:'POPSEQUECE',title:'��&nbsp;&nbsp;��',width:75,align:'center',
							formatter:function(value,rec){
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPopInfoDet("' + value + '");>' + "�鿴" + '</a>';
							}
						},	
						{field:'PPSUPNAME',title:'��&nbsp;Ӧ&nbsp;��&nbsp;',width:140,align:'center'},	
						{field:'PPGDNAME',title:'��&nbsp;Ʒ&nbsp;��&nbsp;��',width:150,align:'center'},	
						{field:'PPGDBARCODE',title:'��&nbsp;Ʒ&nbsp;��&nbsp;��',width:100,align:'center'},	
						{field:'SHPNAME',title:'��&nbsp;&nbsp;&nbsp;&nbsp;��',width:80,align:'center'},	
						{field:'PPGXTIME',title:'��&nbsp;��&nbsp;ʱ&nbsp;��',width:80,align:'center',sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'PPHFYJ',title:'��&nbsp;&nbsp;&nbsp;&nbsp;��',width:80,align:'center',
							  formatter:function(value,rec){
									if( value == '0' )
										return 'δ���';
									else if( value == '2' )
										return 'δͨ��';
									else if(value=='1')
										return 'ͨ��';
								}
						},	
						{field:'PPCGYJ',title:'��&nbsp;��&nbsp;��&nbsp;��',width:80,align:'center'},
						{field:'PPFILE',title:'��&nbsp;��&nbsp;��&nbsp;��',width:80,align:'center',
							formatter:function(value,rec){
								return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "���ظ���" + '</a>';
							}
						}
					
				]],				
				pagination:true,
				rownumbers:true,
				toolbar:[{
					id:'btnDelete',
					text:'ɾ��',					
					iconCls:'icon-remove',
					handler:function(){
						remove();
					}
				}]
				
			});

	          reloadgrid();
	       $('#popPama').val('');
			clear();
		
			
		});
		
		// ���ش�����
		function reloadgrid(){
			//$("#div3").show();	
			//��֤�û����������Ƿ�Ϸ���
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			var startDateArr = startDate.split("-");   
			var endDateArr = endDate.split("-");   
			startDate = new Date(startDateArr[0],parseInt(startDateArr[1])-1,startDateArr[2]);   
			endDate = new Date(endDateArr[0],parseInt(endDateArr[1])-1,endDateArr[2]);
			if(startDate > endDate){
				$.messager.alert('����','��ʼ���ڱ���С�ڻ���ڽ������ڣ�����','error');
				return;
			} 
			
        	var searchData = getFormData( 'popInfoSearch' );
			searchData['ppsupid'] = User.supcode;  		// ��Ӧ�̱���
			searchData['sgcode'] = User.sgcode;  // ʵ������
			//�鿴״̬
			var popPama =$('#popPama').val();
			if(popPama=='lsh'){
			searchData['pphfyj'] ='0';
			}
			
	        //��ѯ����ֱ�������queryParams��
	        $('#popInfoList').datagrid('options').url = 'JsonServlet';        
			$('#popInfoList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'YwPopInfoListLSS',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
						ACTION_MANAGER : 'ywPopInfoManager',
						optType : 'query',
						optContent : '��ѯ��������Ϣ',			 
						list:[	searchData	]
					}
				)
			};        
			$("#popInfoList").datagrid('reload');
			$("#popInfoList").datagrid('resize'); 
        
    	}
   	function showPopInfoDet(num){
		$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'YwPopInfoDet',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwPopinfoForm',
								ACTION_MANAGER : 'ywPopInfoManager',
								list:[{
										id : num
									}
								]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
             				 $("#ppsupname_").html(data.rows[0].PPSUPNAME == null || data.rows[0].PPSUPNAME == undefined ? "��&nbsp;Ӧ&nbsp;&nbsp;�̣�" : "��&nbsp;Ӧ&nbsp;&nbsp;�̣�"+ data.rows[0].PPSUPNAME);
							 $("#ppgdname_").html(data.rows[0].PPGDNAME == null && data.rows[0].PPGDNAME != undefined ? "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ʒ��" : "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ʒ��"+ data.rows[0].PPGDNAME);
	                    	 $("#ppksrq_").html(data.rows[0].PPBJRQ == null || data.rows[0].PPBJRQ == undefined ? "������ڣ�" : "������ڣ�" + new Date(parseInt(data.rows[0].PPBJRQ.time)).format("yyyy-MM-dd"));
	                    	 $("#ppksrq_").html(data.rows[0].PPKSRQ == null || data.rows[0].PPKSRQ == undefined ? "������ʼ����&nbsp;&nbsp;&nbsp;��" : "������ʼ����&nbsp;&nbsp;&nbsp;��" + new Date(parseInt(data.rows[0].PPKSRQ.time)).format("yyyy-MM-dd"));
	                    	 $("#ppgdid_").html(data.rows[0].PPGDID == null || data.rows[0].PPGDID == undefined ? "��Ʒ���룺" : "��Ʒ���룺"+ data.rows[0].PPGDID);
	                    	 $("#ppjsrq_").html(data.rows[0].PPJSRQ == null || data.rows[0].PPJSRQ == undefined ? "������������&nbsp;&nbsp;&nbsp;��" : "������������&nbsp;&nbsp;&nbsp;��"+ new Date(parseInt(data.rows[0].PPJSRQ.time)).format("yyyy-MM-dd")); 
	                    	 $("#ppgdbarcode_").html(data.rows[0].PPGDBARCODE == null || data.rows[0].PPGDBARCODE == undefined ? "��Ʒ���룺" :"��Ʒ���룺"+data.rows[0].PPGDBARCODE);
	                    	 $("#ppbjyy_").html(data.rows[0].PPBJYY == null || data.rows[0].PPBJYY == undefined ? "��������ԭ��" : "��������ԭ��"+data.rows[0].PPBJYY);
	                    	 $("#shpname_").html(data.rows[0].SHPNAME == null || data.rows[0].SHPNAME == undefined ? "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺" : "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺"+data.rows[0].SHPNAME); 
	                    	 $("#ppcxsj_").html(data.rows[0].PPCXSJ == null || data.rows[0].PPCXSJ == undefined ? "ִ&nbsp;��&nbsp;��&nbsp;��" : "ִ&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��"+data.rows[0].PPCXSJ + "Ԫ");
	                    	 $("#ppgxtime_").html(data.rows[0].PPGXTIME == null || data.rows[0].PPGXTIME == undefined ? "����ʱ�䣺" : "����ʱ�䣺"+ new Date(parseInt(data.rows[0].PPGXTIME.time)).format("yyyy-MM-dd"));
	                    	 $("#ppgdyj_").html(data.rows[0].PPGDYJ == null || data.rows[0].PPGDYJ == undefined ? "ԭ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��" : "ԭ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��"+data.rows[0].PPGDYJ + "Ԫ");
	                    	 $("#ppfile_").html(data.rows[0].PPFILE == null || data.rows[0].PPFILE == undefined ? "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����" : "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����<a href='${pageContext.request.contextPath }/DownServlet?filename="+ encodeURI(data.rows[0].PPFILE)+"'>"+data.rows[0].PPFILE+"</a>");
	                    	 $("#popsequece").val(data.rows[0].POPSEQUECE);
	                    	 if(data.rows[0].PPHFYJ != "0"){
	                    	 	$("#pphfyj1_").html(data.rows[0].PPHFYJ == null || data.rows[0].PPHFYJ == undefined ? "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����" : data.rows[0].PPHFYJ == "0"? "��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����δ���":data.rows[0].PPHFYJ == "1"?"��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ͨ��":data.rows[0].PPHFYJ == "2"?"��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����δͨ��":"");
	                    	 	$("#ppcgyj1_").html(data.rows[0].PPCGYJ == null || data.rows[0].PPCGYJ == undefined ? "�ɹ������" : "�ɹ������"+data.rows[0].PPCGYJ );
	                    	 	$("#hfyj").show();
	                    	 	$("#cgyj").show();
	                    	 	$("#hfyj1").hide();
	                    	 	$("#cgyj1").hide();
	                    	 	$("#cgyj1_1").hide();
							 }else{
							 	$("#hfyj").hide();
	                    	 	$("#cgyj").hide();
	                    	 	$("#hfyj1").show();
	                    	 	$("#cgyj1").show();
	                    	 	$("#cgyj1_1").show();
							 }
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
	      $("#popInfoDet").show();
	      $("#popInfoSearch").hide();
	      $("#div3").hide();
	}
	function downAttachment(filename){
		filename = encodeURI(encodeURI(filename));
		window.location = "${pageContext.request.contextPath }/DownServlet?filename="+filename;
	}
			// ���ò�ѯ���������
	function searchReset(){
			clear();
			$('#startDate').val( '' ); 	// ��ѯ��ʼʱ��
			$('#endDate').val( '' ); 	// ��ѯ����ʱ��
	}
	function clear(){
			var now = new Date();
			var startDate = new Date();
			startDate.setDate( now.getDate() - 7 );
			$('#startDate').val( startDate.format('yyyy-MM-dd') );
			$('#endDate').val( now.format('yyyy-MM-dd') );
	}
	function exportExcel(){
			var searchData = getFormData( 'popInfoSearch' );
			searchData['enTitle'] = ['PPSUPNAME','PPGDNAME','PPGDBARCODE','SHPNAME','PPGXTIME','PPHFYJ','PPCGYJ'];
			searchData['cnTitle'] = ['��Ӧ��','��Ʒ����','��Ʒ����','�ŵ�','����ʱ��','�ظ����','�ɹ����'];
			searchData['sgcode'] = User.sgcode;  // ʵ������
			searchData['exportExcel'] = true;
			searchData['sheetTitle'] = '��ѯ��������Ϣ';
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'YwPopInfoListLSS',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
								ACTION_MANAGER : 'ywPopInfoManager',
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
		function remove(){
			var filePath = "<%=Constants.PromotionApplUrl.replace("\\","\\\\\\\\")%>";
			var rows = $("#popInfoList").datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('����','������ѡ��һ�м�¼��','warning');
				return;
			}
			var list = [];
			for( var i = 0; i < rows.length; i ++ ){
				list.push(
					{ 
						popsequece : rows[i].POPSEQUECE,
						ppfile : filePath
					}
				);
			}			
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ��ѡ�е���Ϣ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.YwPopinfoNew',
									ACTION_MANAGER : 'ywPopInfoManager',
									optType : 'remove',
									optContent : 'ɾ��������Ŀ',
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $("#popInfoList").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );	
				}
			});
						
		}
		
	function save() {
		var pphfyj;
		$("input[name='pphfyj_']:radio").each(function(){ 
			if($(this).attr("checked")) {  
				pphfyj = $(this).val();
			} 
		}) 
		$.post('JsonServlet', {
			data : obj2str( {
				ACTION_TYPE : 'YwPopInfoApplyLSS',
				ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwPopinfoForm',
				ACTION_MANAGER : 'ywPopInfoManager',
				optType : 'update',
				optContent : '������������������',
				list : [ {
							popsequece : $("#popsequece").val(),
							pphfyj : pphfyj,
							ppcgyj : $("#ppcgyj_").val()
						} ]
			})
		}, function(data) {
			if (data.returnCode == '1') {
				//$.messager.alert('��ʾ', '�ύ�ɹ�!', 'info');
			    $("#popInfoDet").hide();
			    $("#popInfoSearch").show();
			    $("#div3").show();
				openUrl('popInfoListLSS.jsp', 'Y', true);				
			} else {
				$.messager.alert('��ʾ', '�ύʧ��!<br>ԭ��' + data.returnInfo, 'error');
			}
		}, 'json');
	
	}
	function goback(){
	      $("#popInfoDet").hide();
	      $("#popInfoSearch").show();
	      $("#div3").show();
	}
	</script>
</head>
<body>
<input type="hidden" id="popPama" value="<%=popPama %>">

<center>
<div id="div1" style="margin:0; width:800px; height:400px; padding:0; border:0;">
<table id="popInfoSearch" width="800px" border="0" cellspacing="0" cellpadding="0" style="margin-left:0; font-size:12px;line-height:30px;">
  <tr>
    <td colspan="6"><span style="color:#33CCFF; margin:0;">��Ʒ��������ѯ</span></td> 
  </tr>
  <tr>
    <td align="left" class="label_style">��Ʒ���룺</td>
    <td><input name="popgdbarcode" type="text" id="popgdbarcode" class="input_style"/>
   </td>
    <td align="left" class="label_style">�ŵ꣺</td>
    <td><select name="popmarket" id="ppmarket" class="input_style">
        <option  value="" selected="selected">�����ŵ�</option>
      </select></td>
    <td align="left" class="label_style">�ظ������</td>
    <td><select name="pphfyj" id="pphfyj" class="input_style">
        <option value="" selected="selected">ȫ��</option>
        <option value="1">ͨ��</option>
        <option value="2">δͨ��</option>
        <option value="0">δ���</option>
      </select></td> 
  </tr>
  <tr>
    <td align="left" class="label_style">��Ӧ�̣�</td>
    <td><input name="ppsupname" type="text" id="ppsupname" class="input_style"/></td>
    <td align="left" class="label_style">��ʼ���ڣ�</td>
    <td><input type="text" class="input_style" onClick="WdatePicker({isShowClear:true,readOnly:true,dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'endDate\')}'})"   value="" id="startDate" name="startDate" /></td>
    <td align="left" class="label_style">�������ڣ�</td>
    <td><input type="text" class="input_style" onClick="WdatePicker({isShowClear:true,readOnly:true,dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'})"   value="" id="endDate" name="endDate" /></td> 
  </tr>
  <tr>
    <td align="left" style="padding-right:5px;"><a href="javascript:void(0);"><img src="images/sure.jpg" border="0"  onClick="reloadgrid();"/></a></td>
    <td align="left"><a href="javascript:void(0);"><img src="images/back.jpg" border="0" onClick="searchReset();"/></a></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>  
    <td>&nbsp;</td> 
  </tr>
</table>
<div id="div3" style="width:800px;height:450px;">
	<div style="color:#336699;width: 932px;" align="right"><a href="javascript:exportExcel();">&gt;&gt;����Excel���</a></div>
	<table id="popInfoList" style="clear:both;"></table>
</div>
<div id="popInfoDet" style="width:800px;height:450px;display:none;">
<table width="800px" style="margin:40px auto;line-height:20px; text-align:left; border:0;font-size:14px;">
  <tr>
    <td align="left"><input type="hidden" id="popsequece" name="popsequece"/></td>
    <td align="left"></td>
  </tr>
  <tr>
    <td align="left" style="color:#33CCFF;">��Ʒ�������鿴</td>
    <td align="left">&nbsp;</td>
  </tr>
  <tr>
    <td  id="ppsupname_"></td>
    <td  id="ppbjrq_"></td>
  </tr>
  <tr>
    <td  id="ppgdname_"></td>
    <td  id="ppksrq_"></td>
  </tr>
  <tr>
    <td  id="ppgdid_"></td>
    <td  id="ppjsrq_"></td>
  </tr>
  <tr>
    <td  id="ppgdbarcode_"></td>
    <td  id="ppbjyy_"></td>
  </tr>
  <tr>
    <td  id="shpname_"></td>
    <td  id="ppcxsj_"></td>
  </tr>
  <tr>
    <td  id="ppgxtime_"></td>
    <td  id="ppgdyj_"></td>
  </tr>
  <tr>
    <td  id="ppfile_"></td>
    <td ></td>
  </tr>
  <tr id="hfyj1">
    <td colspan="2" style="border:none;">��&nbsp;&nbsp;&nbsp;&nbsp;����      
      <input type="radio" name="pphfyj_" id="pphfyjpass" value="1" checked="checked"/>
      ͨ�� 
      <input type="radio" name="pphfyj_" id="pphfyjreject" value="2" />
      ��ͨ��</td>
  </tr>
  <tr id="cgyj1">
    <td>�ɹ������</td>
  </tr>
  <tr id="cgyj1_1">
    <td><textarea name="ppcgyj_" cols="50" rows="5" id="ppcgyj_"></textarea></td>
  </tr>
  <tr style="display: none;" id="hfyj">
    <td  id="pphfyj1_"></td>
    <td ></td>
  </tr>
  <tr style="display: none;" id="cgyj">
    <td  id="ppcgyj1_"></td>
    <td ></td>
  </tr>
 
  <tr>
    <td width="40%"><img onclick="save();" src="images/sms_sell.jpg" width="55" height="19" border="0" />&nbsp;&nbsp;&nbsp;<img onclick="goback();" src="images/goback.jpg" width="55" height="19" border="0" /></td>
    <td width="39%" ></td>
  </tr>
</table>
</div>
</div> 
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("ppmarket");
loadAllShop(obj);
</script>
</html>