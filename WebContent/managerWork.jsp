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

	<title>我的工作</title>	
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
	String sgcode = currUser.getSgcode();//当前登录的用户实例编码
	String mmReByC = currUser.getSucode();//当前用户
	List roles = currUser.getRoles();
	
	String[] notShowRoles = new String[]{"3029_ROLE_L_CW","3029_ROLE_L_CGSH","3029CWSH1","3029CWSH2","3029CGSH1","3029CGSH2"};//首页汇总窗口是否显示

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
		timeInfo = "早上";
	else if( hour < 12 )
		timeInfo = "上午";
	else if( hour < 13 )
		timeInfo = "中午";
	else if( hour < 18 )
		timeInfo = "下午";
	else
		timeInfo = "晚上";
	
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
	//消息查询是活动的连接 调用的额外写的方法。
	MsgMessageManager mymsg=(MsgMessageManager)appContext.getAppContext().getBean("msgMessageManager");
	ReturnObject myMsgList  = mymsg.getMyMsgList(mmReByC);
	List msglist = myMsgList.getRows();	 
	
	    
%>
<!-- ---------------------------------------零售商查看销售汇总--------------------------------------- -->
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
				loadMsg:'加载数据...',	
							
				columns:[[				
					{field:'SHPCODE',title:'门店编码',width:64,align:'center'},
					{field:'SHPNAME',title:'门店名称',width:120,align:'left'},				
					{field:'GSXSJE',title:'销售金额',width:75,sortable:true,align:'center',formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
						});
					}}
					,
					{field:'MAOLE',title:'毛利额',width:75,sortable:true,align:'center',formatter:function(value,rec){
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
	
	<!-- 有关主页消息窗口的操作 -->
	<script type="text/javascript">
		//点击通知里的立即查看打开消息窗口
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
                        $.messager.alert('提示','获取消息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );			
		}
		//关闭在主页打开的消息窗口
		function cancel(windowId){
			$('#'+windowId).window('close');
		}
		//在主页打开信息阅读后可删除消息
		function removeMessage(){
			$.messager.confirm('确认操作', '确认要删除此消息吗?', function(r){
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
		                    	 $.messager.alert('提示','删除成功！','info');
		                    	 $( $('#gridId').val() ).datagrid('reload');
		                    	 
		                    	 cancel('msgWindow');
		                    }else{ 
		                        $.messager.alert('提示','删除失败!<br>原因：' + data.returnInfo,'error');
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
	   <div style="text-align:left; float:left; width:970px;"><%= timeInfo%>好，<%= currUser.getSuname()%>，您上一次的登陆时间是：<%= lastLoginTime != null ? lastLoginTime : "无"%></div>
			 <div style="float:left; text-align:left; width:360px; margin-top:5px; line-height:20px;">
		     <div style="float:left; text-align:left; width:360px; ">
		     <div style="color:#33CCFF; margin-bottom:10px; margin-top:10px;">销售汇总查询</div>
		     <table id="LssSaleSummary"></table>
		     <div style="margin-top:10px;">我要查看&nbsp;&nbsp;<a href="javascript:void(0)" onclick="openUrl( 'saleSummaryReport.jsp', 'Y' );"><img style="cursor:hand;" src="images/sure.jpg" border="0" /></a></div>
			 </div>	
	  </div>	
	  	    			
		   <div style="float:left; text-align:left;width:263px; height:223px; margin-top:27px; background:url(images/imp_bg.jpg) no-repeat; margin-left:40px; _margin-left:35px; padding-top:3px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">重要通知</div>
			  	 <% if( messageNumber > 0 ) {%>
			      <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />您有<span style="color:#FF0000;"><%=messageNumber %></span>封来自供应商的未读邮件。</span><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp', 'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">立即查看</span></a></div>
				  <div style="clear:both"></div>
			  	 <% } %>
			  	 <% if( messageNumber == 0 ) {%>
			      <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />您当前没有来自供应商的未读消息。</span><br><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp', 'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">消息管理</span></a></div>
				  <div style="clear:both"></div>
			  	 <% } %>
			  	 			  	 
				 <% if( currUser.getSupwda() == null || currUser.getSupwdq() == null ){ %>
					  <div style="margin-top:2px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />您的资料填写不完整，请补充填写完整，以便您日后找回密码。</span><a href="javascript:void(0)" onclick="openUrl( 'userSafeEdit.jsp',  'N' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">立即处理</span></a></div>
					  <div style="clear:both"></div>
				 <% } %> 			 
		   </div>	
		   <div style="margin-top:27px; width:300px; float:right; text-align:right;"><img id="bodyLogo" src="images/pic_ylb1.jpg"/></div>
	 </div>
	
		  <div style="margin:0px auto; padding:0px; text-align:center; width:970px;">
		   <div style="float:left; text-align:left; margin-top:20px; background:url(images/mail_bg.jpg) no-repeat; width:358px; height:223px;">
		       <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">您收到的通知</div>
		         <!-- 当登录的用户没有相应的消息时显示 -->
				<%if(msglist.size()==0){%>
				  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·您最近没有收到消息。</span></div>
				  <div style="clear:both"></div>
				<%}%>
		   <!-- 当登录的用户有相应的消息时显示 循环  -->			
				<% 
				if(msglist !=null && msglist.size()>0){	%>
					<div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·您最近收到的消息如下:</span></div>	<br/>			
				<!--信息数不到8条-->
						<% if(msglist.size()<8){
							for(int i=0;i<msglist.size();i++){
								Map msgMap = (Map)msglist.get(i);
							%>					 
							  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·<%=msgMap.get("MM_TITLE")%></span><a href="javascript:void(0)" onclick='showMsg("<%=msgMap.get("ID")%>","Y","#msgWindow")'><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">立即查看</span></a></div> 
								 <div style="clear:both"></div>	
							<%}%>
							<div style="margin-top:5px;"><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp');"><span style="float:right; text-align:right; padding-right:5px; color:#33CCFF; cursor:hand;">查看更多消息...</span></a></div>
						<%}%>
				<!--信息数超过8条-->
						<% if(msglist.size()>=8){
							for(int i=0;i<8;i++){
								Map msgMap = (Map)msglist.get(i);
							%>					 
							  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·<%=msgMap.get("MM_TITLE")%></span><a href="javascript:void(0)" onclick='showMsg("<%=msgMap.get("ID")%>","Y","#msgWindow")'><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">立即查看</span></a></div> 
								 <div style="clear:both"></div>		
							<%} %>
							<div style="margin-top:5px;"><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp');"><span style="float:right; text-align:right; padding-right:5px; color:#33CCFF; cursor:hand;">查看更多消息...</span></a></div>
							<%}%>
					<%}%>
		  </div>
		 
		  <div style="float:left; text-align:left; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px; margin-left:40px; margin-top:20px; padding-top:2px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">一点通</div>
			  
		  </div>
		  
		  <div style="float:right; text-align:right; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px;  margin-top:20px; padding-top:2px; line-height:20px;">
		    <div style="float:left; text-align:left; width:263px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">温馨小贴士</div>
			  
			  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·自管理系统使用说明</span><a href="http://www.bfuture.com.cn/ptys-mis.html"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px;">立即查看</span></a></div>
			  <div style="clear:both"></div>
			  
			   <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">·意见反馈</span><a href="http://www.bfuture.com.cn/yhgs.html"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px;">意见反馈</span></a></div>
			  <div style="clear:both"></div>
		    </div>
		  </div>
	</div>	
	</center>
	
	<!--显示消息的窗口	-->
		<div id="msgWindow" class="easyui-window" resizable="false" iconCls="icon-save" minimizable="false" maximizable="false" collapsible="false" shadow="true" closed="true" modal="true" title="查看消息" style="width:720px;height:500px;">
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
				<a id="btnSave" class="easyui-linkbutton" iconCls="icon-remove" href="javascript:void(0)" onclick="removeMessage();">删除</a>				
				<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancel('msgWindow');">关闭</a> 
			</div>
		</div>
	</div>		
 </body>
</html>