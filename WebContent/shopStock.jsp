<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�ŵ����ѯ</title>
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}		
	SysScmuser currUser = (SysScmuser)obj;
%>
	
	
<style>
a:hover {
	text-decoration: underline;
	color: red
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
	$('#shopStock').datagrid({
		width:600,
		iconCls:'icon-save',
		nowrap: false,
		striped: true,
		collapsible:true,
		url:'',
		sortOrder: 'desc',
		remoteSort: true,	
		singleSelect : true,
		fitColumns:false,
		showFooter:true,	
		loadMsg:'��������...',				
		columns:[[
			{field:'ZSGXTIME',title:'���ͳ������',width:150,align:'center',sortable:true,
				formatter:function(value,rec){
			    if(value=='�ϼ�')
			    	return "�ϼ�";
				else
					return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=getShopStockDetail('"+rec.SHPCODE+"');>" + rec.SHPCODE + "</a>";
				}
			},
			{field:'SHPCODE',title:'�ŵ����',width:100,align:'center',sortable:true}, 
			{field:'SHPNAME',title:'�ŵ�����',width:150,align:'center',sortable:true},
			 <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
				{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true,formatter:function(value,rec){
					if(parseFloat(value)>0){
						return value;
					}else{
						return 0;
					}
				}},
				{field:'ZSKCJE',title:'�����',width:150,align:'center',sortable:true,formatter:function(value,rec){
					if( value != null && value != undefined && parseFloat(value)>0){
						return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}else{
						return 0;
					}
				}}
			<%}else{%>
				{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
				{field:'ZSKCJE',title:'�����',width:150,align:'center',sortable:true,formatter:function(value,rec){
					if( value != null && value != undefined )
						return formatNumber(value,{   
						decimalPlaces: 2,thousandsSeparator :','
						});
				}}
			<%}%>	    
		]],
		pagination:true,
		rownumbers:true
	});
	
	$('#shopStockDetail').datagrid({
		width:800,
		iconCls:'icon-save',
		nowrap: false,
		striped: true,
		collapsible:true,
		url:'',
		sortOrder: 'desc',
		remoteSort: true,	
		singleSelect : true,
		fitColumns:false,
		showFooter:true,	
		loadMsg:'��������...',				
		columns:[[
			{field:'ZSSUPID',title:'��Ӧ�̱���',width:150,align:'center',sortable:true},
			{field:'SUPNAME',title:'��Ӧ������',width:100,align:'left',sortable:true}, 
			{field:'ZSGDID',title:'��Ʒ����',width:150,align:'center',sortable:true},
			{field:'GDBARCODE',title:'��Ʒ����',width:150,align:'center',sortable:true},
			{field:'GDNAME',title:'��Ʒ����',width:200,align:'left',sortable:true},
			 <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
				{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true,formatter:function(value,rec){
					if(parseFloat(value)>0){
						return value;
					}else{
						return 0;
					}
				}},
				{field:'ZSKCJE',title:'�����',width:150,align:'center',sortable:true,formatter:function(value,rec){
					if( value != null && value != undefined && parseFloat(value)>0){
						return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
					}else{
						return 0;
					}
				}}
			<%}else{%>
				{field:'ZSKCSL',title:'�������',width:55,align:'center',sortable:true},
				{field:'ZSKCJE',title:'�����',width:150,align:'center',sortable:true,formatter:function(value,rec){
					if( value != null && value != undefined )
						return formatNumber(value,{   
						decimalPlaces: 2,thousandsSeparator :','
						});
				}}
			<%}%>		    
		]],
		pagination:true,
		rownumbers:true
	});   
});
		
function reloadgrid ()  {
  	var supcode = '';
	if(User.sutype == 'L'){
		supcode = $('#zssupid').val();	
	}else {
		supcode = User.supcode;
	}  
    $('#shopStock').datagrid('options').url = 'JsonServlet';        
	$('#shopStock').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getShopStock',
				ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
				ACTION_MANAGER : 'ywZrstockDetails',		 
				list:[{
				 sgcode : User.sgcode,
				 supcode : supcode,
				 zsgdid : $('#zsgdid').attr('value'),
				 gdbarcode : $('#gdbarcode').attr('value'),
				 zsmfid : $('#zsmfid').attr('value')
				}]
			}
		)
	};	
	$("#saledatagrid").show();	
	$("#saledatagridDetail").hide();
	$("#shopStock").datagrid('reload'); 
	$("#shopStock").datagrid('resize'); 
}

function getShopStockDetail(shpcode){  
	var supcode = '';
	if(User.sutype == 'L'){
		supcode = $('#zssupid').val();	
	}else {
		supcode = User.supcode;
	}
    $('#shopStockDetail').datagrid('options').url = 'JsonServlet';        
	$('#shopStockDetail').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getShopStockDetail',
				ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
				ACTION_MANAGER : 'ywZrstockDetails',		 
				list:[{
				 sgcode : User.sgcode,
				 supcode : supcode,
				 gdbarcode : $('#gdbarcode').attr('value'),
				 zsgdid : $('#zsgdid').attr('value'),
				 zsmfid : shpcode
				}]
			}
		)
	};	
	$("#saledatagrid").hide();	
	$("#saledatagridDetail").show();
	$("#shopStockDetail").datagrid('reload'); 
	$("#shopStockDetail").datagrid('resize'); 
}

function goBack(){
	$("#saledatagrid").show();
	$("#saledatagridDetail").hide();
}
</script>
</head>
<body>
<center>
<table width="900" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="4" align="left" style="border: none; color: #4574a0;">�ŵ����ѯ</td>
	</tr>
	<tr>
		<td style="border: none;">
			��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
			<select style="width: 155px;" name='zsmfid' id="zsmfid" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
		<td style="border: none;">
			��Ʒ���룺<input type="text" id="zsgdid" name="zsgdid" value="" size="20"/>
		</td>
		<td style="border: none;">
			��Ʒ���룺<input type="text" id="gdbarcode" name="gdbarcode" value="" size="20"/>
		</td>
		<td style="border: none;">
			��Ӧ�̱��룺<input type="text" id="zssupid" name="zssupid" value="" size="20"/>
		</td>
	</tr>
	<tr>
	<td style="border: none;" colspan="4">
		<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />     
	</tr>
	<tr>
		<td colspan="4">
			<div id="saledatagrid" style="display: none;">
				<table id="shopStock" ></table>
			</div>
			<div id="saledatagridDetail" style="display: none;">
				<table id="shopStockDetail" ></table>
				<div>
					<img src="images/goback.jpg" border="0" onclick="goBack();" />
				</div>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// �����ŵ�
var obj = document.getElementById("zsmfid");
loadAllShop(obj);
</script>
</html>