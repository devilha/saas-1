<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.SysLogManager"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="com.bfuture.app.saas.model.SysLogevent"%>
<%@page import="com.bfuture.app.saas.model.MsgMessage"%>
<%@page import="com.bfuture.app.saas.model.MsgNotice"%>
<%@page import="com.bfuture.app.saas.service.MsgMessageManager"%>
<%@page import="com.bfuture.app.saas.service.MsgNoticeManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>



<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

	<title>�ҵĹ���</title>
	
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode= currUser.getSgcode();
	String jyfs = currUser.getSuflag() + "";
	
	//�õ���Ŀ��·��
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	//�õ���ͬ·����
	String contractPath = basePath+"WebContent/contract/"+sgcode+"/";
%>	
	<script type="text/javascript">
		$(function(){
			if( bodyLogoMapping[User.sgcode] ){
				$('#bodyLogo').attr('src','images/' + bodyLogoMapping[User.sgcode] );
			}
			
			$('#saleSummary').datagrid({	
				//width: 305,
				width: 382,
				height: 160,
				nowrap: false,
				striped: true,
				url:'',
				sortOrder: 'desc',
				fitColumns:false,
				showFooter:true,				
				loadMsg:'��������...',				
				columns:[[				
					{field:'SHPCODE',title:'�ŵ����',width:64,align:'center'},
					{field:'SHPNAME',title:'�ŵ�����',width:145,align:'center'},				
					{field:'GSXSSL',title:'��������',width:64,align:'center'},	
					{field:'GSHSJJJE',title:'���۳ɱ�',width:100,sortable:true,align:'center'}
				]]
			});
			
			var now = new Date();			
			var startDate = new Date();
			startDate.setDate( now.getDate() - 1 );
			now.setDate( now.getDate() - 1 );	
			
			$('#saleSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : '<%=currUser.getSgcode()%>',
							supcode : '<%=currUser.getSupcode()%>',
							userType : '<%=currUser.getSutype()%>',
							startDate : startDate.format('yyyy-MM-dd'),
							endDate : now.format('yyyy-MM-dd')
						}]
					}
				)
			};					
			$("#saleSummary").datagrid('reload');
			
			var now1 = new Date();			
			var startDate1 = new Date();
			now1.setDate( now1.getDate() - 1 );		
			startDate1.setDate( now1.getDate() - 7 );
			
			var searchData = {
				gssgcode : '<%=currUser.getSgcode()%>',
				gssupid  : '<%=currUser.getSupcode()%>',
				sucode   : '<%=currUser.getSucode()%>',
				saleObject: 'GSXSSL',
				isSup    : 'Y',
				startDate : startDate1.format('yyyy-MM-dd'),
				endDate : now1.format('yyyy-MM-dd')
			};        	
			
			$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getChart',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.YwGoodssale',
								ACTION_MANAGER : 'saleTrendReport',								
								list:[searchData]
						})
						
					}, 
					function(data){ 
	                    if( data.chartData != undefined && data.chartData != null ){	                    	 
	                    	var chartType = "MSLine.swf";
							
							var chart = new FusionCharts("chart/" + chartType, "saleTrendReportSUPChartId", "380", "223", "0", "0");            
							chart.setJSONData( data.chartData );
							chart.render("saleTrendChart");
	                    } 
	            	},
	            	'json'
			);
			
		});
	</script>
</head>

<%
	
	AppSpringContext appContext = AppSpringContext.getInstance();
	SysLogManager slm = (SysLogManager)appContext.getAppContext().getBean("sysLogManager");
	
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
	
	//ȡ�û�������¼ʱ��
	SysLogevent log = slm.getLastLog( currUser, "login" );
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String lastLoginTime = null;
	if( log != null && log.getLetime() != null ){
		lastLoginTime = sdf.format( log.getLetime() );
	}
	
	MsgMessageManager mm = (MsgMessageManager)appContext.getAppContext().getBean("msgManager");		
	mm.setUser( currUser );
	ReturnObject ro = mm.ExecOther( "getMessageNum", null );	
	int messageNumber = 0;
	if( ro != null ){
		messageNumber = ro.getTotal();
	}
	
	MsgNoticeManager mn = (MsgNoticeManager)appContext.getAppContext().getBean("noticeManager");		
	mn.setUser( currUser );
	ro = mn.ExecOther( "getNoticeNum", null );	
	int noticeNumber = 0;
	if( ro != null ){
		noticeNumber = ro.getTotal();
	}
%>

<body>	
	<center>
	<div style="margin:0px auto; padding:0px; text-align:center; width:990px; margin-top:10px;">
	   <div align="left" style="text-align:left; float:left; width:990px;"><%= timeInfo%>�ã�<%= currUser.getSuname()%>������һ�εĵ�½ʱ���ǣ�<%= lastLoginTime != null ? lastLoginTime : "��"%>
	      <div style="float:left; text-align:left; width:360px; ">
		     <div style="color:#33CCFF; margin-bottom:10px; margin-top:10px;" id='tip'>���ۻ��ܲ�ѯ
		     </div>
		     
		     <table id="saleSummary"></table>
		     <div style="margin-top:10px;">��Ҫ�鿴&nbsp;&nbsp;<a href="javascript:void(0)" onclick="openUrl( 'saleSummaryReport.jsp', 'Y' );"><img style="cursor:hand;" src="images/sure.jpg" border="0" /></a></div>
			
		  </div>
		    
			
		   <div style="float:left; text-align:left;width:263px; height:223px; margin-top:10px; background:url(images/imp_bg.jpg) no-repeat; margin-left:40px; _margin-left:35px; padding-top:3px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">��Ҫ֪ͨ</div>
		      
		      <% if( noticeNumber > 0 ){ %>				
				<div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />����<span style="color:#FF0000"><%=noticeNumber%></span>�������̳�����Ҫ֪ͨ��</span><a href="javascript:void(0)" onclick="openUrl( 'noticeManager.jsp', 'Y' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">�����鿴</span></a></div>
				<div style="clear:both"></div>			  
			  <%
			  	}
		      	if( messageNumber > 0 ){
			  %>
				<div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;"><img src="images/tanhao.jpg" />����<span style="color:#FF0000"><%=messageNumber%></span>������Ϣ��</span><a href="javascript:void(0)" onclick="openUrl( 'messageManager.jsp', 'Y' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">�����鿴</span></a></div>
				<div style="clear:both"></div>	
			  <%
		      	}
			  %>
		   </div>
		   
		     
		   
		   
		   <div style="margin-top:10px; width:300px; float:right; text-align:right;"><img id="bodyLogo" src="images/pic_ylb2.jpg"/></div>
	</div>
	
	<div style="margin:0px auto; padding:0px; text-align:center; width:990px;">
	   <div style="float:left; text-align:left; margin-top:20px;">
	   <div style="color:#33CCFF;">�������Ʒ���</div>
		<div id="saleTrendChart" style="width:380px;height:223px"></div>
	   <div>��Ҫ�鿴&nbsp;&nbsp;<a href="javascript:void(0)" onclick="openUrl( 'saleTrendReportSup.jsp', 'Y' );"><img style="cursor:hand;" src="images/sure.jpg" border="0" /></a></div>
	   
	   </div>
		  <div style="float:left; text-align:left; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px; margin-left:40px; margin-top:20px; padding-top:2px; line-height:20px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">һ��ͨ</div> 
		  </div>
		  <div style="float:right; text-align:right; background:url(images/imp_bg.jpg) no-repeat; width:263px; height:223px;  margin-top:20px; padding-top:2px; line-height:20px;">
		    <div style="float:left; text-align:left; width:263px;">
		      <div style="font-size:14px; font-weight:bold; padding-left:5px; color:#33CCFF">��ܰС��ʿ</div>
				  		  
				  <!--<div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">���������</span><a href="javascript:void(0)" onclick="openUrl( 'yjfk.jsp', 'W' );"><span style="float:right; text-align:right; padding-right:5px; color:#FF0000;cursor:hand;">��������</span></a></div> 
				  <div style="clear:both"></div>	-->			 				 
		          <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">�ۿ�������ʾ</span><a href="http://www.bfuture.com.cn/ptys_saas.html"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px; cursor:hand;">�����鿴</span></a></div>
				  <div style="clear:both"></div>
		          <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">����ϵͳʹ���ֲ�</span><a href="downloadfile?filename=bfutureSaasOper.pdf"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px; cursor:hand;">��������</span></a></div>
				  <div style="clear:both"></div>
				  <%if("3040".equals(currUser.getSgcode())){%>
				  <div style="margin-top:5px;"><span style="float:left; text-align:left; padding-left:5px;">��Ӧ�̺�ͬ</span><a href="downloadfile?filename=HSC_hetong.zip"><span style="float:right; text-align:right; color:#FF0000; padding-right:5px; cursor:hand;">��������</span></a></div>
				  <%}%>
		  </div>
	</div>
	</center>
</body>
</html>