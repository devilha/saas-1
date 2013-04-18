<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%      //从浏览器得到一个 参数
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
<title>促商品调价申请查询</title>
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
	$(function(){
			//var id;
			// 填充促商品调价申请列表
			$('#popInfoList').datagrid({
				nowrap: false,
				striped: true,
				url:'JsonServlet',		
				remoteSort: true,
				showFooter:true,
				width: 932,
				loadMsg:'加载数据...',
				columns:[[
						/*
						{field:'POPSEQUECE',align:'center',title:'序&nbsp;&nbsp;&nbsp;&nbsp;号',width:80,sortable:true,
							formatter:function(value,rec){
								id = value;
								return value;
							}
						},*/
						{field:'select',checkbox:true},
						{field:'POPSEQUECE',title:'查&nbsp;&nbsp;看',width:75,align:'center',
							formatter:function(value,rec){
									return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showPopInfoDet("' + value + '");>' + "查看" + '</a>';
							}
						},	
						{field:'PPSUPNAME',title:'供&nbsp;应&nbsp;商&nbsp;',width:140,align:'center'},	
						{field:'PPGDNAME',title:'商&nbsp;品&nbsp;名&nbsp;称',width:150,align:'center'},	
						{field:'PPGDBARCODE',title:'商&nbsp;品&nbsp;条&nbsp;码',width:100,align:'center'},	
						{field:'SHPNAME',title:'门&nbsp;&nbsp;&nbsp;&nbsp;店',width:80,align:'center'},	
						{field:'PPGXTIME',title:'发&nbsp;送&nbsp;时&nbsp;间',width:80,align:'center',sortable:true,
							formatter:function(value,rec){
								if( value != null && value.time != undefined )
									return new Date(value.time).format('yyyy-MM-dd');
							}
						},	
						{field:'PPHFYJ',title:'回&nbsp;&nbsp;&nbsp;&nbsp;复',width:80,align:'center',
							  formatter:function(value,rec){
									if( value == '0' )
										return '未审核';
									else if( value == '2' )
										return '未通过';
									else if(value=='1')
										return '通过';
								}
						},	
						{field:'PPCGYJ',title:'采&nbsp;购&nbsp;意&nbsp;见',width:80,align:'center'},
						{field:'PPFILE',title:'下&nbsp;载&nbsp;附&nbsp;件',width:80,align:'center',
							formatter:function(value,rec){
								return value == null ? "" :'<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=downAttachment("' + value + '");>' + "下载附件" + '</a>';
							}
						}
					
				]],				
				pagination:true,
				rownumbers:true,
				toolbar:[{
					id:'btnDelete',
					text:'删除',					
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
		
		// 加载促销表
		function reloadgrid(){
			//$("#div3").show();	
			//验证用户输入日期是否合法？
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			var startDateArr = startDate.split("-");   
			var endDateArr = endDate.split("-");   
			startDate = new Date(startDateArr[0],parseInt(startDateArr[1])-1,startDateArr[2]);   
			endDate = new Date(endDateArr[0],parseInt(endDateArr[1])-1,endDateArr[2]);
			if(startDate > endDate){
				$.messager.alert('错误','开始日期必须小于或等于结束日期！！！','error');
				return;
			} 
			
        	var searchData = getFormData( 'popInfoSearch' );
			searchData['ppsupid'] = User.supcode;  		// 供应商编码
			searchData['sgcode'] = User.sgcode;  // 实例编码
			//查看状态
			var popPama =$('#popPama').val();
			if(popPama=='lsh'){
			searchData['pphfyj'] ='0';
			}
			
	        //查询参数直接添加在queryParams中
	        $('#popInfoList').datagrid('options').url = 'JsonServlet';        
			$('#popInfoList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'YwPopInfoListLSS',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
						ACTION_MANAGER : 'ywPopInfoManager',
						optType : 'query',
						optContent : '查询促销表信息',			 
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
             				 $("#ppsupname_").html(data.rows[0].PPSUPNAME == null || data.rows[0].PPSUPNAME == undefined ? "供&nbsp;应&nbsp;&nbsp;商：" : "供&nbsp;应&nbsp;&nbsp;商："+ data.rows[0].PPSUPNAME);
							 $("#ppgdname_").html(data.rows[0].PPGDNAME == null && data.rows[0].PPGDNAME != undefined ? "商&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;品：" : "商&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;品："+ data.rows[0].PPGDNAME);
	                    	 $("#ppksrq_").html(data.rows[0].PPBJRQ == null || data.rows[0].PPBJRQ == undefined ? "变价日期：" : "变价日期：" + new Date(parseInt(data.rows[0].PPBJRQ.time)).format("yyyy-MM-dd"));
	                    	 $("#ppksrq_").html(data.rows[0].PPKSRQ == null || data.rows[0].PPKSRQ == undefined ? "促销开始日期&nbsp;&nbsp;&nbsp;：" : "促销开始日期&nbsp;&nbsp;&nbsp;：" + new Date(parseInt(data.rows[0].PPKSRQ.time)).format("yyyy-MM-dd"));
	                    	 $("#ppgdid_").html(data.rows[0].PPGDID == null || data.rows[0].PPGDID == undefined ? "商品编码：" : "商品编码："+ data.rows[0].PPGDID);
	                    	 $("#ppjsrq_").html(data.rows[0].PPJSRQ == null || data.rows[0].PPJSRQ == undefined ? "促销结束日期&nbsp;&nbsp;&nbsp;：" : "促销结束日期&nbsp;&nbsp;&nbsp;："+ new Date(parseInt(data.rows[0].PPJSRQ.time)).format("yyyy-MM-dd")); 
	                    	 $("#ppgdbarcode_").html(data.rows[0].PPGDBARCODE == null || data.rows[0].PPGDBARCODE == undefined ? "商品条码：" :"商品条码："+data.rows[0].PPGDBARCODE);
	                    	 $("#ppbjyy_").html(data.rows[0].PPBJYY == null || data.rows[0].PPBJYY == undefined ? "促销或变价原因：" : "促销或变价原因："+data.rows[0].PPBJYY);
	                    	 $("#shpname_").html(data.rows[0].SHPNAME == null || data.rows[0].SHPNAME == undefined ? "门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：" : "门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店："+data.rows[0].SHPNAME); 
	                    	 $("#ppcxsj_").html(data.rows[0].PPCXSJ == null || data.rows[0].PPCXSJ == undefined ? "执&nbsp;行&nbsp;价&nbsp;格：" : "执&nbsp;&nbsp;行&nbsp;&nbsp;价&nbsp;&nbsp;格&nbsp;&nbsp;："+data.rows[0].PPCXSJ + "元");
	                    	 $("#ppgxtime_").html(data.rows[0].PPGXTIME == null || data.rows[0].PPGXTIME == undefined ? "发送时间：" : "发送时间："+ new Date(parseInt(data.rows[0].PPGXTIME.time)).format("yyyy-MM-dd"));
	                    	 $("#ppgdyj_").html(data.rows[0].PPGDYJ == null || data.rows[0].PPGDYJ == undefined ? "原&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价&nbsp;&nbsp;：" : "原&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价&nbsp;&nbsp;："+data.rows[0].PPGDYJ + "元");
	                    	 $("#ppfile_").html(data.rows[0].PPFILE == null || data.rows[0].PPFILE == undefined ? "附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件：" : "附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件：<a href='${pageContext.request.contextPath }/DownServlet?filename="+ encodeURI(data.rows[0].PPFILE)+"'>"+data.rows[0].PPFILE+"</a>");
	                    	 $("#popsequece").val(data.rows[0].POPSEQUECE);
	                    	 if(data.rows[0].PPHFYJ != "0"){
	                    	 	$("#pphfyj1_").html(data.rows[0].PPHFYJ == null || data.rows[0].PPHFYJ == undefined ? "回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复：" : data.rows[0].PPHFYJ == "0"? "回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复：未审核":data.rows[0].PPHFYJ == "1"?"回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复：通过":data.rows[0].PPHFYJ == "2"?"回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复：未通过":"");
	                    	 	$("#ppcgyj1_").html(data.rows[0].PPCGYJ == null || data.rows[0].PPCGYJ == undefined ? "采购意见：" : "采购意见："+data.rows[0].PPCGYJ );
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
	                        $.messager.alert('提示','获取信息失败!<br>原因：' + data.returnInfo,'error');
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
			// 重置查询条件输入框
	function searchReset(){
			clear();
			$('#startDate').val( '' ); 	// 查询起始时间
			$('#endDate').val( '' ); 	// 查询结束时间
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
			searchData['cnTitle'] = ['供应商','商品名称','商品条码','门店','发送时间','回复意见','采购意见'];
			searchData['sgcode'] = User.sgcode;  // 实例编码
			searchData['exportExcel'] = true;
			searchData['sheetTitle'] = '查询促销表信息';
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
	                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		}
		function remove(){
			var filePath = "<%=Constants.PromotionApplUrl.replace("\\","\\\\\\\\")%>";
			var rows = $("#popInfoList").datagrid('getSelections');
			if( rows.length == 0 ){
				$.messager.alert('警告','请至少选择一行记录！','warning');
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
			$.messager.confirm('确认操作', '确认要删除选中的信息吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'remove',
									ACTION_CLASS : 'com.bfuture.app.saas.model.YwPopinfoNew',
									ACTION_MANAGER : 'ywPopInfoManager',
									optType : 'remove',
									optContent : '删除促销条目',
									list: list
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('提示','删除成功！','info');
		                    	 $("#popInfoList").datagrid('reload');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
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
				optContent : '零售商审批促销申请',
				list : [ {
							popsequece : $("#popsequece").val(),
							pphfyj : pphfyj,
							ppcgyj : $("#ppcgyj_").val()
						} ]
			})
		}, function(data) {
			if (data.returnCode == '1') {
				//$.messager.alert('提示', '提交成功!', 'info');
			    $("#popInfoDet").hide();
			    $("#popInfoSearch").show();
			    $("#div3").show();
				openUrl('popInfoListLSS.jsp', 'Y', true);				
			} else {
				$.messager.alert('提示', '提交失败!<br>原因：' + data.returnInfo, 'error');
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
    <td colspan="6"><span style="color:#33CCFF; margin:0;">商品变价申请查询</span></td> 
  </tr>
  <tr>
    <td align="left" class="label_style">商品条码：</td>
    <td><input name="popgdbarcode" type="text" id="popgdbarcode" class="input_style"/>
   </td>
    <td align="left" class="label_style">门店：</td>
    <td><select name="popmarket" id="ppmarket" class="input_style">
        <option  value="" selected="selected">所有门店</option>
      </select></td>
    <td align="left" class="label_style">回复意见：</td>
    <td><select name="pphfyj" id="pphfyj" class="input_style">
        <option value="" selected="selected">全部</option>
        <option value="1">通过</option>
        <option value="2">未通过</option>
        <option value="0">未审核</option>
      </select></td> 
  </tr>
  <tr>
    <td align="left" class="label_style">供应商：</td>
    <td><input name="ppsupname" type="text" id="ppsupname" class="input_style"/></td>
    <td align="left" class="label_style">起始日期：</td>
    <td><input type="text" class="input_style" onClick="WdatePicker({isShowClear:true,readOnly:true,dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'endDate\')}'})"   value="" id="startDate" name="startDate" /></td>
    <td align="left" class="label_style">结束日期：</td>
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
	<div style="color:#336699;width: 932px;" align="right"><a href="javascript:exportExcel();">&gt;&gt;导出Excel表格</a></div>
	<table id="popInfoList" style="clear:both;"></table>
</div>
<div id="popInfoDet" style="width:800px;height:450px;display:none;">
<table width="800px" style="margin:40px auto;line-height:20px; text-align:left; border:0;font-size:14px;">
  <tr>
    <td align="left"><input type="hidden" id="popsequece" name="popsequece"/></td>
    <td align="left"></td>
  </tr>
  <tr>
    <td align="left" style="color:#33CCFF;">商品变价申请查看</td>
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
    <td colspan="2" style="border:none;">回&nbsp;&nbsp;&nbsp;&nbsp;复：      
      <input type="radio" name="pphfyj_" id="pphfyjpass" value="1" checked="checked"/>
      通过 
      <input type="radio" name="pphfyj_" id="pphfyjreject" value="2" />
      不通过</td>
  </tr>
  <tr id="cgyj1">
    <td>采购意见：</td>
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
// 加载门店
var obj = document.getElementById("ppmarket");
loadAllShop(obj);
</script>
</html>