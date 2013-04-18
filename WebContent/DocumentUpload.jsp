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

<title>�ĵ��ϴ�</title>
<script type="text/javascript" src="script/ajaxupload.3.5.js"></script>
<script type="text/javascript">
var  flag=false;
$(function(){
    var button = jQuery('#select'), interval;//���¼�--------------

    var load = new AjaxUpload(button, {//��AjaxUpload
        action: "DocumentUploadServlet.jsp",//�ļ�Ҫ�ϴ����Ĵ���ҳ��,���Կ���PHP,ASP,JSP��
        type:"POST",//�ύ��ʽ
        autoSubmit:false,//ѡ���ļ���,�Ƿ��Զ��ύ.������Ա��true,�Լ�ȥ����Ч����.
        name:'msUploadFile',//�ύ������
        onChange:function(file,ext){//��ѡ���ļ���ִ�еķ���,ext�����ļ�����,�����������ж��ļ���ʽ
			$("#filemain").val(file);
					if (/^(rar|zip|txt|ppt|xml|doc|docx|xls|xlsx|pdf)$/.test(ext)) {
						flag=true;
					} else {
						flag=false;
						$.messager.alert('û��ͨ����֤', '�ļ����Ͳ��Ϸ����������ϴ���', 'warning');
						return false;
					}
        },
        onSubmit: function (file, ext) {//�ύ�ļ�ʱִ�еķ���
            //button.text('�ϴ���');
            this.disable();
            interval = window.setInterval(function () {
                var text = button.text();
                if (text.length < 10) {
                    button.text(text + '|');
                } else {
                    button.text('�ϴ���');
                }
            }, 200);
        },
        onComplete: function (file, response) {//�ļ��ύ��ɺ��ִ�еķ���
						var reply = JSON.parse(response);
						if (reply.err != null ) { // ���Ƹ����Ĵ�С
							$.messager.alert('û��ͨ����֤', reply.err , 'warning');
							// ���¼���һ�±�ҳ��
							openUrl('DocumentUpload.jsp', 'Y', false);
							return false;
						}
		                  $.messager.alert('��ʾ','�ϴ��ɹ���','info');
		                  openUrl('DocumentQuery.jsp','Y');
            //window.clearInterval(interval);
            this.enable();
        }
    });
    $("#documentreset").click(function(){
    	openUrl('DocumentUpload.jsp','Y');
    });
	var submit=$('#documentsubmit').click(function(){//�����ύ���¼�.��autoSubmit�������й�,�Ƿ����
		if($("#filetitle").val().length<2)
		{
			$.messager.alert('û��ͨ����֤', '�ļ����ⲻ�Ϸ�����������д��', 'warning');
			return false;
		}
		if(flag==false)
		{
			$.messager.alert('û��ͨ����֤', '�ļ����Ͳ��Ϸ�����������д��', 'warning');
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
                      $.messager.alert('��ʾ','�����ĵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
	<font style="color: #4574a0; font-size: 16px; margin-top: 5px">�ĵ���������</font>
	-->
	<font style="font-size: 14px; margin-top: 5px">&nbsp�ļ��ϴ�</font>
	<br>
	<font style="margin-top: 10px">ע���ϴ����ļ��������Ϊ5M��</font>
	<br>
	</br>
	<%if("4005".equals(currUser.getSgcode())){ %>
		��&nbsp;&nbsp;��&nbsp;&nbsp;�ˣ�<% currUser.getSutype();%>
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
			<!--<option value="40054005">4005-����Ψ����ó</option> -->
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
	�ĵ����⣺
	<input type="text" id="filetitle" name="filetitle"
		class="documentUpload" />
	</br>
	�ϴ��ļ���
	<input type="text" id="filemain" style="margin-top: 10px"
		name="filemain" />
	<input type="button" id="select" name="select" value="ѡ���ļ�" />
	</br>
	�ĵ�˵����
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