<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.basic.dao.UniversalAppDao"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">


<%
	final Log log = LogFactory.getLog(getClass());
	Object objUser = session.getAttribute( "LoginUser" );
	if( objUser == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)objUser;
	
	
	request.setCharacterEncoding("GBK");
	String gyssql = "select sucode,suname,supcode from sys_scmuser where sgcode ='"+currUser.getSgcode()+"' and sutype='S' and suenable='Y'";
	String lsssql = "select sucode,suname from sys_scmuser where sgcode ='"+currUser.getSgcode()+"' and sutype='L' and suenable='Y'";
	AppSpringContext appContext = AppSpringContext.getInstance();
	UniversalAppDao dao = (UniversalAppDao) appContext.getAppContext()
			.getBean("universalAppDao");

	log.debug("DocumentUpload gyssql=" + gyssql);
	log.debug("DocumentUpload lsssql=" + lsssql);

	List revicesList = dao.executeSql(gyssql);
	List lssList = dao.executeSql(lsssql);
%>

<title>文档上传</title>
<script type="text/javascript" src="script/ajaxupload.3.5.js"></script>
<script type="text/javascript">
var  flag=false;
$(function(){
    var button = jQuery('#select'), interval;//绑定事件--------------

    var load = new AjaxUpload(button, {//绑定AjaxUpload
        action: "DocumentUploadServlet.jsp",//文件要上传到的处理页面,语言可以PHP,ASP,JSP等
        type:"POST",//提交方式
        autoSubmit:false,//选择文件后,是否自动提交.这里可以变成true,自己去看看效果吧.
        name:'msUploadFile',//提交的名字
        onChange:function(file,ext){//当选择文件后执行的方法,ext存在文件后续,可以在这里判断文件格式
			$("#filemain").val(file);
					if (/^(rar|zip|txt|ppt|xml|doc|docx|xls|xlsx|pdf)$/.test(ext)) {
						flag=true;
					} else {
						flag=false;
						$.messager.alert('没有通过验证', '文件类型不合法，请重新上传！', 'warning');
						return false;
					}
        },
        onSubmit: function (file, ext) {//提交文件时执行的方法
            //button.text('上传中');
            this.disable();
            interval = window.setInterval(function () {
                var text = button.text();
                if (text.length < 10) {
                    button.text(text + '|');
                } else {
                    button.text('上传中');
                }
            }, 200);
        },
        onComplete: function (file, response) {//文件提交完成后可执行的方法
						var reply = JSON.parse(response);
						if (reply.err != null ) { // 控制附件的大小
							$.messager.alert('没有通过验证', reply.err , 'warning');
							// 重新加载一下本页面
							openUrl('DocumentUpload.jsp', 'Y', false);
							return false;
						}
		                  $.messager.alert('提示','上传成功！','info');
		                  openUrl('DocumentQuery.jsp','Y');
            //window.clearInterval(interval);
            this.enable();
        }
    });
    $("#documentreset").click(function(){
    	openUrl('DocumentUpload.jsp','Y');
    });
	var submit=$('#documentsubmit').click(function(){//触发提交的事件.与autoSubmit的设置有关,是否采用
		if($("#filetitle").val().length<2)
		{
			$.messager.alert('没有通过验证', '文件标题不合法，请认真填写！', 'warning');
			return false;
		}
		if(flag==false)
		{
			$.messager.alert('没有通过验证', '文件类型不合法，请认真填写！', 'warning');
			return false;
		}
		if(submittext())
		load.submit();
		else
		load.submit();
	});

});
function submittext()
{
		$.post( 'JsonServlet',				
		{
			data : obj2str({		
					ACTION_TYPE : 'upfile',
					ACTION_CLASS : 'com.bfuture.app.saas.model.DownlodeCenter',
					ACTION_MANAGER : 'downlodeCenter',	
					list:[{									
						insC : User.sgcode,
						crtByC : User.suname,
						title : $("#filetitle").val(),
						url : $("#filemain").val(),
						memo : $("#filecontent").val(),
						to_id : User.sgcode == '4005' ? $("#revices").val() : ""
					}]
			})
			
		}, 
		function(data){ 
                  if(data.returnCode == '1' ){
                  	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                  	 }	                    	 
                  	 return true;
                  }else{ 
                      $.messager.alert('提示','保存文档信息失败!<br>原因：' + data.returnInfo,'error');
                      return false;
                  } 
          	},
          	'json'
          );	
}
function goback()
{

	openUrl('DocumentQuery.jsp','Y');

}
</script>
</head>
<body>

<center>

<table id="QueryTable" width="960"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	</br>
	<font style="color: #4574a0; font-size: 16px; margin-top: 5px">文档下载中心</font>
	-->
	<font style="font-size: 14px; margin-top: 5px">&nbsp文件上传</font>
	<br>
	<font style="margin-top: 10px">注：上传的文件最大容量为5M。</font>
	<br>
	</br>
	<%if("4005".equals(currUser.getSgcode())){ %>
		接&nbsp;&nbsp;受&nbsp;&nbsp;人：<% currUser.getSutype();%>
		<%if("S".equalsIgnoreCase(currUser.getSutype().toString())) {
		%>
			<select id="revices">
				<%
					if(lssList!=null){
						for(Object obj : lssList){
							Map revicer = (Map)obj;
				%>
					<option value="<%=revicer.get("SUCODE") %>"><%=revicer.get("SUCODE") %>-<%=revicer.get("SUNAME") %></option>
				<%	
						}
					}
				%>
			<!--<option value="40054005">4005-西安唯购商贸</option> -->
			</select>
		<%}else{%>
			<select id="revices">
			<%
				if(revicesList!=null){
					for(Object obj : revicesList){
						Map revicer = (Map)obj;
			%>
							<option value="<%=revicer.get("SUCODE") %>"><%=revicer.get("SUPCODE") %>-<%=revicer.get("SUNAME") %></option>
			<%		
					}
				}
			%>
			</select>
	<%	}
	}%>
	<br/>
	文档标题：
	<input type="text" id="filetitle" name="filetitle"
		class="documentUpload" />
	</br>
	上传文件：
	<input type="text" id="filemain" style="margin-top: 10px"
		name="filemain" />
	<input type="button" id="select" name="select" value="选择文件" />
	</br>
	文档说明：
	<textarea type="text" id="filecontent"
		style="width: 300px; height: 60px; margin-top: 10px"
		name="filecontent" class="documentUpload"></textarea>
	</br>
	<a href="javascript:void(0);"> <img id="documentsubmit"
		style="margin-right: 50px; margin-top: 10px" border="0"
		src="images/tijiao.jpg"> </a>
	<a href="javascript:void(0);"> <img id="documentreset"
		style="margin-right: 50px;" border="0" src="images/back.jpg"> </a>
	<a href="javascript:void(0);" onclick="goback();"> <img
		id="documentreset" style="margin-right: 50px;" border="0"
		src="images/goback.jpg"> </a>
</table>
</center>
</body>
</html>