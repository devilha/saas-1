<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysMenu"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.SysMenuManager"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%@page import="com.bfuture.app.basic.util.xml.StringUtil"%>
<%@page import="com.bfuture.app.saas.service.SysScmuserManager"%>
<%@page import="com.bfuture.app.saas.service.impl.SysScmuserManagerImpl"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>供应链管理系统</title>
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css">
	<script type="text/javascript" src="script/jquery-1.5.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/jquery.easyui.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/easyui-lang-zh_CN.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/common-util.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/WdatePicker.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/FusionCharts.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/xheditor-1.1.12-zh-cn.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/ajaxupload.3.5.js" charset="utf-8"></script>
	<script type="text/javascript" src="script/jquery.autocomplete.js" charset="utf-8"></script>
	
	<script>
		var isExpanded = true;
		var isLoadData = false;
		
		var mainLogoMapping = {
			'3001' : '3001logo.jpg',
			'3008' : '3008logo.jpg',
			'3029' : 'hcyg_logo_1.jpg',
			'3020' : 'bb_logo_2.jpg',
			'3019' : '3019logo.jpg',
			'3022' : '3022logo.jpg',
			'3023' : '3023logo.jpg'
			
		};
		
		var bodyLogoMapping = {
			'3001' : '3001main.jpg',
			'3008' : '3008main.jpg',
			'3009' : 'jm_logo.png',
			'3029' : 'hcyg_logo.jpg',
			'3020' : 'bb_logo_1.jpg',
			'3019' : '3019main.jpg',
			'3022' : '3022main.jpg',
			'3023' : '3023main.jpg',
			'3024' : 'pic_ylb2.jpg'
		};
		//存放一品多码实例
		var ypdmobj=['3021'];	
				
		$(function(){
			
			$.ajax( {
				url : 'GetCurrentUser',
				type: 'POST',
				dataType: 'json',
				error: function(){
			        alert('Error loading JSON document');
			        location.href = 'login.jsp';
			    },
			    success: function(data){
			        if( data.error ){				    	    
				    }
				    else{
				    	window.User = data;
				    	
				    	if( mainLogoMapping[User.sgcode] ){
				    		$('#mainlogo').attr('src','images/' + mainLogoMapping[User.sgcode] );
				    	}
				    	
				    	if( User.sutype == 'L' || User.sutype == 'M' || User.sutype == 'Z' ){	/*零售商首页*/
				    		if(User.sgcode=='3008'||User.sgcode=='3029' || User.sgcode=='3024'){
				    		openUrl( 'managerWork.jsp', 'Y',false );
				    		}else{
				    		openUrl( 'messageManager.jsp', 'Y',false );
				    		}	
				    		
				    	}
				    	else{	
				    	     if(existIns(ypdmobj,User.sgcode)){
				    		openUrl( 'supplyWork_YPDM.jsp', 'Y', false );				    	     
				    	     }else{
				    		openUrl( 'supplyWork.jsp', 'Y', false );
				    	     }
				    	}	
					} 
			    }
			});
			
			if( window.DictMapping == undefined ){
				$.post( 'script/dictConfig.json',				
					{}, 
					function(data){			
						window.DictMapping = data;
					},
					'json'
				);
			}						
		});
		
		function existIns(objs,sgcode)
			{
			for(var i=0;i<objs.length;i++){
			  if(objs[i]==sgcode){
			  return true;
			  }
			}
			return false;
			}
		
		function openUrl( url, fullscreen, loadFlag ){
			if( url ){			
				if( url.indexOf('http://') > -1 || fullscreen == 'W'){
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');
					return;
				}
			
				if( loadFlag != undefined ){
					isLoadData = loadFlag;
				}
				else{
					isLoadData  = false;
				}
				
				$('#main').html( '<div align=center><img id="loading" src="images/loading.gif"></div>' );				
				$.get( url, {},
					function(data){
									
						$('#main').html( data );
						$.parser.parse($('#main'));
						
						if( fullscreen == 'Y' ){
							if( isExpanded ){
								isExpanded = false;
								$('#west').panel(
									{
										width:0
									}
								);
								$('#west').hide();
								setTimeout( function(){
									$('body').layout('resize');
								});	
							}
						}
						else{
							if( !isExpanded ){
								isExpanded = true;
								$('#west').panel(
									{
										width:330
									}
								);
								$('#west').show();
								setTimeout( function(){
									$('body').layout('resize');
								});	
							}
						}
					} 
				);
			} 
		}
		
		function backMain(){
			location.href = 'index.jsp';
		}
		
		function logout(){
			$.messager.confirm('确认操作', '确认要退出系统吗?', function(r){
				if (r){
					// location.href = 'Logout';
					window.open('','_parent','');
    				window.close();	
				}
			});
		}	
	</script>

</head>

<%!
	public void createSubMenu(JspWriter out, SysMenu sm ) throws IOException{	
		
		if( sm.getChildren() != null && sm.getChildren().size() > 0 ){
			if( sm.getMeulevel().intValue() > 2 )
				out.print( "<div>" );
			for( Iterator<SysMenu> itMenu = sm.getChildren().iterator(); itMenu.hasNext(); ){
				SysMenu menu = itMenu.next();
				
				out.println();				
				
				out.print( "<div id=\"");
				out.print( menu.getMeucode() );
				out.print( "\"");
				
				if( menu.getIconCls() != null ){
					out.print( " iconCls=\"" );
					out.print( menu.getIconCls() );
					out.print( "\"" );
				}
				
				if( !StringUtil.isBlank( menu.getMeuhref() ) ){
					out.print( " onClick=\"openUrl('" );
					out.print( menu.getMeuhref() );
					out.print( "','");
					out.print( menu.getFullscreen() );
					out.print( "');\"" );
				}
				
				out.print( " align=\"left\" style=\"width:150px;\">" );

				out.print( "<span>" );
				out.print( menu.getMeuname() );
				out.print( "</span>" );
				
				createSubMenu( out, menu );
				out.println( "</div>" );
				

			
			}
			if( sm.getMeulevel().intValue() > 2 )
				out.print( "</div>" );
		}
	}
%>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	
	SysScmuser currUser = (SysScmuser)obj;
	String sutype = StringUtil.nullToBlank( currUser.getSutype() );
	
	AppSpringContext appContext = AppSpringContext.getInstance();
	SysMenuManager smm = (SysMenuManager)appContext.getAppContext().getBean("sysMenuManager");
	List<SysMenu> lstMenus = smm.getMenusByUsercode( currUser.getSucode() ); 
	
%>

<body class="easyui-layout">
		
	<div region="north" border="false" style="margin:0px auto; padding:0px; text-align:center; background:#FFFFFF;">
		<div id="top_main">
			<div class="top_left";>
	        	<img id="mainlogo" src="images/logo.jpg"/>
			</div>
			<div class="top_right">
				<table style="border:none">
		  			<tr>
		    			<td align="right" style="border:none">
				        	<a href="index.jsp"><span class="top_pro">SCM平台</span></a>
							<span class="top_pro STYLE2">SCF平台</span>
							<span class="top_pro STYLE2">MIS平台</span>
							<span class="top_pro STYLE2">SMS平台</span>
							<span class="top_pro1 STYLE2">库存销售系统</span>
						</td>
		  			</tr>
		  			<tr>
		    			<td align="right" style="padding-top:10px; border:none;"> 
		    				<span class="top_pro1 STYLE2">客服电话：(010)5128-3636(北京)/4006-242628(北京以外)&nbsp;&nbsp;	<a href="#" class="STYLE2" style="clear: both" onCLICK="window.open('http://chat.53kf.com/webCompany.php?arg=bfuture1&style=1&charset=utf-8', 'Sample', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=580,height=400,left=100,top=150')" title="在线咨询我的问题">→在线客服</a></span>
		    			</td>
					</tr>
				</table>
			</div>
		</div>
		<div align="left" style="background:#badff1;padding:1px;">
			<% 
				if( lstMenus != null && lstMenus.size() > 0 ){
					for( Iterator<SysMenu> itMenu = lstMenus.iterator(); itMenu.hasNext(); ){
						SysMenu menu = itMenu.next();
			%>
						<a href="javascript:void(0)" id="<%= menu.getMeucode()%>_top" class="easyui-menubutton" menu="#<%= menu.getMeucode()%>" <%= menu.getMeuhref() != null && menu.getMeuhref().trim().length() > 0 ? "onClick=\"openUrl('" + menu.getMeuhref() + "','" + menu.getFullscreen() + "');\"" : "" %> iconCls="<%= menu.getIconCls()%>"><%= menu.getMeuname()%></a>
			<%
					}
				}
			%>
			<a href="javascript:void(0)" id="menuExit" class="easyui-menubutton" onClick="logout();" iconCls="icon-back">退&nbsp;&nbsp;出</a>
			<br>
			<span><%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 当前登录用户："+currUser.getSucode()%>&nbsp;-&nbsp;<%=currUser.getSuname()%></span>
		</div>
		</div>
		
		<% 
			if( lstMenus != null && lstMenus.size() > 0 ){
				for( Iterator<SysMenu> itMenu = lstMenus.iterator(); itMenu.hasNext(); ){
					SysMenu menu = itMenu.next();
					
					if( menu.getChildren() != null && menu.getChildren().size() > 0 ){
						out.println();
						out.print( "<div id=\"");
						out.print( menu.getMeucode() );
						out.print( "\"");
						
						if( menu.getIconCls() != null ){
							out.print( " iconCls=\"" );
							out.print( menu.getIconCls() );
							out.print( "\"" );
						}
						
						if( !StringUtil.isBlank( menu.getMeuhref() ) ){
							out.print( " onClick=\"openUrl('" );
							out.print( menu.getMeuhref() );
							out.print( "','");
							out.print( menu.getFullscreen() );
							out.print( "');\"" );
						}
						
						out.print( " align=left>" );
					
						createSubMenu( out, menu );
						out.print( "</div>" );
					}
				}
			}
		%>
		
		
	<div region="south" border="true" align="center">
		<table style="border:none">
			<tr>
				<td align="right" style="border:none;font-size:12px;">Copyrights 2001-2010 <a href="http://www.bfuture.com.cn" style="color:#000;">北京富基标商流通信息科技有限公司版权所有</a></td>
				<td align="right" style="border:none"><a href="http://www.bfuture.com.cn" style="color:#000;">www.bfuture.com.cn</a></td>
			</tr>
		</table>
	</div>
	<div region="center" border="false" title="" style="margin-left:20px;" align="left" id="main">
	</div>
	
	<div id="background" class="background" style="display: none; "></div> 
	<div id="progressBar" class="progressBar" style="display: none; ">数据处理中，请稍等...</div>
</body>
</html>