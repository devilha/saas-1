<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.SysLogManager"%>
<%@page import="com.bfuture.app.saas.model.SysLogevent"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bfuture.app.saas.service.HomeManager"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.saas.service.MsgMessageManager"%>
<%@page import="java.util.Iterator"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�ҵĹ���</title>	
	<script type="text/javascript">
		$(function(){
			if( bodyLogoMapping[User.sgcode] ){
				$('#bodyLogo').attr('src','images/' + bodyLogoMapping[User.sgcode] );
			}
		});
	</script>
</head>

<%
	AppSpringContext appContext = AppSpringContext.getInstance();
	SysLogManager slm = (SysLogManager)appContext.getAppContext().getBean("sysLogManager");
	
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	
	
	
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode = currUser.getSgcode();//��ǰ��¼���û�ʵ������
	String mmReByC = currUser.getSucode();//��ǰ�û�
	List roles = currUser.getRoles();
	
	String[] notShowRoles = new String[]{"3029_ROLE_L_CW","3029_ROLE_L_CGSH","3029CWSH1","3029CWSH2","3029CGSH1","3029CGSH2"};//��ҳ���ܴ����Ƿ���ʾ

	boolean isNotShowSaleSummary = false;
	for( Iterator itRole = roles.iterator(); itRole.hasNext(); ){
		Object objRole = itRole.next();		
		Object roleCode = ((Map)objRole).get("RLCODE");
		int len = notShowRoles.length;
		for( int i = 0; i < notShowRoles.length; i ++ ){
			String  role  = notShowRoles[i];
			if( role.equals( roleCode ) ){
				isNotShowSaleSummary = true;
				break;
			}
		}
	}
	//out.println(isNotShowSaleSummary);
	Calendar now = Calendar.getInstance();
	now.setTimeInMillis( System.currentTimeMillis() );
	int hour = now.get( Calendar.HOUR_OF_DAY );
	String timeInfo = null;	
	if( hour < 8 )
		timeInfo = "����";
	else if( hour < 12 )
		timeInfo = "����";
	else if( hour < 13 )
		timeInfo = "����";
	else if( hour < 18 )
		timeInfo = "����";
	else
		timeInfo = "����";
	
	SysLogevent log = slm.getLastLog( currUser, "login" );
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String lastLoginTime = null;
	if( log != null && log.getLetime() != null ){
		lastLoginTime = sdf.format( log.getLetime());
	}	
	
	MsgMessageManager mm = (MsgMessageManager)appContext.getAppContext().getBean("msgManager");		
	mm.setUser( currUser );
	ReturnObject ro = mm.ExecOther( "getMessageNum", null );	
	int messageNumber = 0;
	if( ro != null ){
		messageNumber = ro.getTotal();
	}
	appContext = AppSpringContext.getInstance();
	//��Ϣ��ѯ�ǻ������ ���õĶ���д�ķ�����
	MsgMessageManager mymsg=(MsgMessageManager)appContext.getAppContext().getBean("msgMessageManager");
	ReturnObject myMsgList  = mymsg.getMyMsgList(mmReByC);
	List msglist = myMsgList.getRows();	 
	
	    
%>
<!-- ---------------------------------------�����̲鿴���ۻ���--------------------------------------- -->
	<script type="text/javascript">
		$(function(){
				$('#LssSaleSummary').datagrid({	
				width: 360,
				height:160,
				nowrap: false,
				striped: true,
				url:'',
				sortOrder: 'desc',
				fitColumns:false,
				showFooter:true,				
				loadMsg:'��������...',	
							
				columns:[[				
					{field:'SHPCODE',title:'�ŵ����',width:64,align:'center'},
					{field:'SHPNAME',title:'�ŵ�����',width:120,align:'left'},				
					{field:'GSXSJE',title:'���۽��',width:75,sortable:true,align:'center',formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
						});
					}}
					,
					{field:'MAOLE',title:'ë����',width:75,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					]]
			});
			
			$('#LssSaleSummary').datagrid('options').url = 'JsonServlet';  

			$('#LssSaleSummary').datagrid('options').queryParams = {
				data :obj2str(
					{	
						ACTION_TYPE : <%if("S".equals(currUser.getSutype()+"")){%>'datagrid'<%}else{%>'getLssSaleSum'<%}%>,
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : '<%=isNotShowSaleSummary ? "0000" :currUser.getSgcode()%>',
							supcode : '<%=currUser.getSupcode()%>',							
							sutype : '<%=currUser.getSutype() %>',							
							yesterdayFlag: 'Y'
						}]
					}
				)
			};	
							
			$("#LssSaleSummary").datagrid('reload'); 
			$("#LssSaleSummary").datagrid('resize'); 
			
		});
	</script>	
	
	<!-- �й���ҳ��Ϣ���ڵĲ��� -->
	<script type="text/javascript">
		//���֪ͨ��������鿴����Ϣ����
		function showMsg( id, viewflag,msgWindow){		
			$('#msgId').val(id );
			$('#msgWindow').val( msgWindow );
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'editMsg',
							ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
							ACTION_MANAGER : 'msgManager',
							list:[{
								id : id,
								viewFlag : viewflag
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){ 
                    	 if( data.rows.length >0){
                    	 	var msg = data.rows[0];    
                    	 	$('#mmTitleView').text( msg['mmTitle'] );
                    	 	$('#mmContentView').html( msg['mmContent'] );
                    	 	
							$('#msgWindow').window('open');
                    	 }
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ��Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		//�ر�����ҳ�򿪵���Ϣ����
		function cancel(windowId){
			$('#'+windowId).window('close');
		}
		//����ҳ����Ϣ�Ķ����ɾ����Ϣ
		function removeMessage(){
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫɾ������Ϣ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'removeMsg',
									ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
									ACTION_MANAGER : 'msgManager',
									list: [{id:$('#msgId').val()}]
							})							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){ 
		                    	 $.messager.alert('��ʾ','ɾ���ɹ���','info');
		                    	 $( $('#gridId').val() ).datagrid('reload');
		                    	 
		                    	 cancel('msgWindow');
		                    }else{ 
		                        $.messager.alert('��ʾ','ɾ��ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                    } 
		            	},
		            	'json'
		            );
				}
			});			
		}
	</script>
<!-- --------------------------------------------------------------------------------------------------------------------- -->
<body>	
	<center>
	<div style="margin:0px auto; padding:0px; text-align:center; width:970px; margin-top:20px;">
	   <div style="text-align:left; float:left; width:970px;"><%= timeInfo%>�ã�<%= currUser.getSuname()%>������һ�εĵ�½ʱ���ǣ�<%= lastLoginTime != null ? lastLoginTime : "��"%></div>
			 <div style="float:left; text-align:left; width:360px; margin-top:5px; line-height:20px;">
		     <div style="float:left; text-align:left; width:360px; ">
		     <div style="color:#33CCFF; margin-bottom:10px; margin-top:10px;">���ۻ��ܲ�ѯ</div>
		     <table id="LssSaleSummary"></table>
		     <div style="margin-top:10px;">��Ҫ�鿴&nbsp;&nbsp;<a href="javascript:void(0)" onclick="openUrl( 'saleSummaryReport.jsp', 'Y' );"><img style="cursor:hand;" src="images/sure.jpg" border="0" /></a></div>
			 </div>	
	  </div>	
	  	    			
		   <div style="float:left; text-align:left;width:263px; height:223px; margin-top:27px; background:url(images/imp_bg.jpg) no-repeat; margin-left:40px; _margin-left:35px; padding-top:3px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">��Ҫ֪ͨ</div>
			  	 <% if( messageNumber > 0 ) {%>
			      <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />����<span style="color:#FF0000;"><%=messageNumber %></span>�����Թ�Ӧ�̵�δ���ʼ���</span><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp', 'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">�����鿴</span></a></div>
				  <div style="clear:both"></div>
			  	 <% } %>
			  	 <% if( messageNumber == 0 ) {%>
			      <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />����ǰû�����Թ�Ӧ�̵�δ����Ϣ��</span><br><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp', 'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">��Ϣ����</span></a></div>
				  <div style="clear:both"></div>
			  	 <% } %>
			  	 			  	 
				 <% if( currUser.getSupwda() == null || currUser.getSupwdq() == null ){ %>
					  <div style="margin-top:2px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />����������д���������벹����д�������Ա����պ��һ����롣</span><a href="javascript:void(0)" onclick="openUrl( 'userSafeEdit.jsp',  'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">��������</span></a></div>
					  <div style="clear:both"></div>
				 <% } %> 			 
		   </div>	
		   <div style="margin-top:27px; width:300px; float:right; text-align:right;"><img id="bodyLogo" src="images/pic_ylb1.jpg"/></div>
	 </div>
	
		  <div style="margin:0px auto; padding:0px; text-align:center; width:970px;">
		   <div style="float:left; text-align:left; margin-top:20px; background:url(images/mail_bg.jpg) no-repeat; width:358px; height:223px;">
		       <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">���յ���֪ͨ</div>
		         <!-- ����¼���û�û����Ӧ����Ϣʱ��ʾ -->
				<%if(msglist.size()==0){%>
				  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">�������û���յ���Ϣ��</span></div>
				  <div style="clear:both"></div>
				<%}%>
		   <!-- ����¼���û�����Ӧ����Ϣʱ��ʾ ѭ��  -->			
				<% 
				if(msglist !=null && msglist.size()>0){	%>
					<div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">��������յ�����Ϣ����:</span></div>	<br/>			
				<!--��Ϣ������8��-->
						<% if(msglist.size()<8){
							for(int i=0;i<msglist.size();i++){
								Map msgMap = (Map)msglist.get(i);
							%>					 
							  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">��<%=msgMap.get("MM_TITLE")%></span><a href="javascript:void(0)" onclick='showMsg("<%=msgMap.get("ID")%>","Y","#msgWindow")'><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">�����鿴</span></a></div> 
								 <div style="clear:both"></div>	
							<%}%>
							<div style="margin-top:5px;"><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp');"><span style="float:right; text-align:right; padding-right:5px; color:#33CCFF; cursor:hand;">�鿴������Ϣ...</span></a></div>
						<%}%>
				<!--��Ϣ������8��-->
						<% if(msglist.size()>=8){
							for(int i=0;i<8;i++){
								Map msgMap = (Map)msglist.get(i);
							%>					 
							  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">��<%=msgMap.get("MM_TITLE")%></span><a href="javascript:void(0)" onclick='showMsg("<%=msgMap.get("ID")%>","Y","#msgWindow")'><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">�����鿴</span></a></div> 
								 <div style="clear:both"></div>		
							<%} %>
							<div style="margin-top:5px;"><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp');"><span style="float:right; text-align:right; padding-right:5px; color:#33CCFF; cursor:hand;">�鿴������Ϣ...</span></a></div>
							<%}%>
					<%}%>
		  </div>
		 
		  <div style="float:left; text-align:left; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px; margin-left:40px; margin-top:20px; padding-top:2px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">һ��ͨ</div>
			  
		  </div>
		  
		  <div style="float:right; text-align:right; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px;  margin-top:20px; padding-top:2px; line-height:20px;">
		    <div style="float:left; text-align:left; width:263px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">��ܰС��ʿ</div>
			  
			  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">���Թ���ϵͳʹ��˵��</span><a href="http://www.bfuture.com.cn/ptys-mis.html"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px;">�����鿴</span></a></div>
			  <div style="clear:both"></div>
			  
			   <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">���������</span><a href="http://www.bfuture.com.cn/yhgs.html"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px;">�������</span></a></div>
			  <div style="clear:both"></div>
		    </div>
		  </div>
	</div>	
	</center>
	
	<!--��ʾ��Ϣ�Ĵ���	-->
		<div id="msgWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="�鿴��Ϣ" style="width:720px;height:500px;">
		<div class="easyui-layout" fit="true"> 
			<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;"> 
				<table style="font-size: 12px" width="100%">					
					<tr>						
						<td align="center">
							<input type="hidden" id="msgId" name="id"/>
							<input type="hidden" id="msgWindow" />
							<span id="mmTitleView" style="font-size: large; vertical-align: middle;"></span>
						</td>						
					</tr>					
					<tr>						
						<td>						
							<div style="width:645px;height:405px;" id="mmContentView" ></div>	
						</td>
					</tr>										
				</table>
			</div>
			<div region="south" border="false" style="text-align:right;height:30px;line-height:30px;"> 
				<a id="btnSave" class="easyui-linkbutton" iconCls="icon-remove" href="javascript:void(0)" onclick="removeMessage();">ɾ��</a>				
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('msgWindow');">�ر�</a> 
			</div>
		</div>
	</div>		
 </body>
</html>