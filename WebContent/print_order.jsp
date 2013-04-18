<%@ page language="java" contentType="text/html; charset=GBK"pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.service.YwBorderdetManager"%>
<%@page import="com.bfuture.app.saas.model.YwBorderdet"%>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.saas.model.YwBorderhead"%>
<%@page import="com.bfuture.app.saas.service.YwBorderheadManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.basic.util.xml.StringUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>订单查询--单据明细--打印明细</title>
<style type="text/css">
<!--
.STYLE4 {color: #000000; font-weight: bold; }
.STYLE5 {
	color: #000000;
	font-weight: bold;
	font-size: 24px;
}
-->
</style>
</head>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser scmuser = (SysScmuser)obj;
		String sgcode = scmuser.getSgcode();
		AppSpringContext appContext = AppSpringContext.getInstance();
		YwBorderdetManager ybdetManager = (YwBorderdetManager)appContext.getAppContext().getBean("ywBorderdet");
		YwBorderheadManager ybheadManager = (YwBorderheadManager)appContext.getAppContext().getBean("ywBorderhead");
		
		YwBorderdet borderdet = new YwBorderdet();
		
		borderdet.setBodsgcode(request.getParameter("bodsgcode")); // 实例编码
		borderdet.setBodbillno(request.getParameter("bodbillno")); // 订单编号
		borderdet.setBodshmfid(request.getParameter("bodshmfid")); // 门店编号
		
		ReturnObject resultDet = ybdetManager.SearchYwBorderdet(new Object[]{borderdet});
		List borderdetList = resultDet.getRows();     // 列表数据
		List borderdetFooter = resultDet.getFooter(); // 合计数据
		Map borderFooterMap = (Map)borderdetFooter.get(0); // 合计数据
		
		// 下面是订单头部分
		YwBorderhead borderhead = new YwBorderhead();
		
		borderhead.setBohsgcode(request.getParameter("bodsgcode")); // 实例编码
		borderhead.setBohbillno(request.getParameter("bodbillno")); // 订单编号
		borderhead.setBohmfid(request.getParameter("bodshmfid"));   // 门店编号
		ReturnObject resultHead = ybheadManager.SearchYwBorderhead(new Object[]{borderhead});
		List borderheadList = resultHead.getRows();
		Map borderheadMap = (Map)borderheadList.get(0); // 填充非列表部分信息
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		//获取实例中文名
		List insList = null;
		Map lnsMap = null;
		ReturnObject resultIns = ybheadManager.searchIns(sgcode);
		if(resultIns.getRows().size()!= 0){
		  insList = resultIns.getRows();
		  lnsMap = (Map)insList.get(0);
		}
 	%>
<body>
<table width="1000" border="0" align="center" style="font-size: 20px;">
  <tr>
    <td height="90" colspan="7">
    	<div align="center" class="STYLE5">
    		<%if(lnsMap != null){%>
    		<h2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=StringUtil.nullToBlank(lnsMap.get("OI_CN")) %>商品订货单</h2>
    		<%}else{%>
    		<h2>商品订货单</h2>
    		<%}%>
    	</div>
    </td>
  </tr>
  <tr>
    <td colspan="12">&nbsp;</td>      
  </tr>
  <tr>
  	<td colspan="6"><span class="STYLE3"></span></td>
    <td colspan="6" id="ysx" style="display: none;"><span class="STYLE3">已生效</span></td>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">单据编号</span>：<%=borderheadMap.get("BOHBILLNO") %></td>
    <td colspan="6">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">收货门店</span>：<%=borderheadMap.get("BOHMFID") %><%=borderheadMap.get("SHPNAME") %></td>
    <% Object dhrq = borderheadMap.get("BOHDHRQ");%>
    <td colspan="6"><span class="STYLE3">订货日期</span>：<%=dhrq!=null && !"".equals(dhrq) ? dhrq : "" %></td>
  </tr>
  <tr>
    <td colspan="6"><span class="STYLE3">供&nbsp;应&nbsp;商</span>：<%=borderheadMap.get("BOHSUPID") %><%=borderheadMap.get("SUNAME") %></td>
	    <% Object jhrq = borderheadMap.get("BOHJHRQ"); %>
	    <td colspan="3"><span class="STYLE3">送货日期</span>：<%=jhrq!=null && !"".equals(jhrq) ? jhrq : "" %></td>
  </tr>
  <tr>
    <td id="bjlshdz" colspan="6" style="display: none;">
    	<span class="STYLE3">送货地址</span>：<%=borderheadMap.get("ADDRESS")%>
    </td>
    <td id="bjlyydh" style="display: none;"><span class="STYLE3">预约电话</span>：<%=borderheadMap.get("LINKTELE")%></td>
  </tr>
</table>

<table width="1000" border="1" cellpadding="1" cellspacing="0" align="center" style="font-size: 20px;">
  <tr>
    <td bgcolor="#CCCCCC"><span class="STYLE4">序号</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">商品编号</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">商品条码</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">商品名称</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">规格</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">税率</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">单位</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">订货数量</span></td>
	<td bgcolor="#CCCCCC"><span class="STYLE4">含税进价</span></td>
	<td bgcolor="#CCCCCC"><span class="STYLE4">含税进价金额</span></td>
    <td bgcolor="#CCCCCC"><span class="STYLE4">实收</span></td>
	<td bgcolor="#CCCCCC"><span class="STYLE4">备注</span></td>
  </tr>
  
  <!-- 循环列表开始 -->
  <% 
  	if(borderdetList != null && borderdetList.size() > 0){
  		for(int i = 0;i < borderdetList.size();i++){
  			Map bdtmap = (Map)borderdetList.get(i);
  			
  			%>
  			  <tr>
			    <td><%=(i+1) %></td>
			    <td><%=bdtmap.get("BODGDID") %>&nbsp;</td>
			    <td><%=bdtmap.get("GDBARCODE") %>&nbsp;</td>
			    <td><%=bdtmap.get("GDNAME") %>&nbsp;</td>
			    <td><%=bdtmap.get("GDSPEC") %>&nbsp;</td>
			    <td><%=bdtmap.get("BODTAX") %>&nbsp;</td>
			    <td><%=bdtmap.get("GDUNIT") %>&nbsp;</td>
			    <td><%=bdtmap.get("BODSL") %>&nbsp;</td>
				<td><%=bdtmap.get("BODHSJJ") %>&nbsp;</td>
				<td><%=bdtmap.get("BODHSJJJE") %>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			  </tr>
  			<%
  		}
  	}
  %>
  <!-- 循环列表结束 -->
  
  <tr>
         <td colspan="7">合计：</td>
    	 <td><%=borderFooterMap.get("BODSL") %></td>
	    <td>&nbsp;</td>
	    <td><%=borderFooterMap.get("BODHSJJJE") %></td>
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
  </tr>
  
</table>

<table width="1000" border="0" align="center" style="font-size: 20px;">
  <tr>
    <td>采购员：</td>
    <td>收货人：</td>
    <td>供应商：</td>
    <td>核查人：</td>
  </tr>
</table>
</body>
</html>
