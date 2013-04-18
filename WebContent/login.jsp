<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>登录</title>
<link href="css/main.css" rel="stylesheet" type="text/css" />

<style type="text/css">.imcm ul,.imcm li,.imcm div,.imcm span,.imcm a{text-align:left;vertical-align:top;padding:0px;margin:0;list-style:none outside none;border-style:none;background-image:none;clear:none;float:none;display:block;position:static;overflow:visible;line-height:normal;}.imcm li a img{display:inline;border-width:0px;}.imcm span{display:inline;}.imcm .imclear,.imclear{clear:both;height:0px;visibility:hidden;line-height:0px;font-size:1px;}.imcm .imsc{position:relative;}.imcm .imsubc{position:absolute;visibility:hidden;}.imcm li{list-style:none;font-size:1px;float:left;}.imcm ul ul li{width:100%;float:none !important;}.imcm a{display:block;position:relative;}.imcm ul .imsc,.imcm ul .imsubc {z-index:10;}.imcm ul ul .imsc,.imcm ul ul .imsubc{z-index:20;}.imcm ul ul ul .imsc,.imcm ul ul ul .imsubc{z-index:30;}.imde ul li:hover .imsubc{visibility:visible;}.imde ul ul li:hover  .imsubc{visibility:visible;}.imde ul ul ul li:hover  .imsubc{visibility:visible;}.imde li:hover ul  .imsubc{visibility:hidden;}.imde li:hover ul ul .imsubc{visibility:hidden;}.imde li:hover ul ul ul  .imsubc{visibility:hidden;}.imcm .imea{display:block;position:relative;left:0px;font-size:1px;line-height:1px;height:0px;width:1px;float:right;}.imcm .imea span{display:block;position:relative;font-size:1px;line-height:0px;}.dvs,.dvm{border-width:0px}/*\*//*/.imcm .imea{visibility:hidden;}/**/</style><!--[if IE]><style type="text/css">.imcm .imea span{position:absolute;}.imcm .imclear,.imclear{display:none;}.imcm{zoom:1;} .imcm li{curosr:hand;} .imcm ul{zoom:1}.imcm a{zoom:1;}</style><![endif]--><!--[if gte IE 7]><style type="text/css">.imcm .imsubc{background-image:url(images/ie_css_fix);}</style><![endif]--><!--end-->

<!--[imstyles] *** Infinite Menu Styles: Keep this section in the document head for full validation. -->
<style type="text/css">


	/* --[[ Main Expand Icons ]]-- */
	#imenus0 .imeam span,#imenus0 .imeamj span {background-image:url(images/sample3_main_arrow.gif); width:7px; height:5px; left:-7px; top:5px; background-repeat:no-repeat;background-position:top left;}
	#imenus0 li:hover .imeam span,#imenus0 li a.iactive .imeamj span {background-image:url(images/sample3_main_arrow.gif); background-repeat:no-repeat;background-position:top left;}


	/* --[[ Sub Expand Icons ]]-- */
	#imenus0 ul .imeas span,#imenus0 ul .imeasj span {background-image:url(images/sample3_sub_arrow.gif); width:5px; height:7px; left:-5px; top:3px; background-repeat:no-repeat;background-position:top left;}
	#imenus0 ul li:hover .imeas span,#imenus0 ul li a.iactive .imeasj span {background-image:url(images/sample3_sub_arrow.gif); background-repeat:no-repeat;background-position:top left;}


	/* --[[ Main Container ]]-- */
	#imouter0 {background:url(images/nav_bg1.jpg) repeat-x; border-style:none; border-color:#0099ff; border-width:1px; padding:0px; margin:0px; }


	/* --[[ Sub Container ]]-- */
	#imenus0 li ul {background-color:#efefef; border-style:solid; border-color:#0099ff; border-width:1px; padding:5px; margin:4px 0px 0px; }


	/* --[[ Main Items ]]-- */
	#imenus0 li a, #imenus0 .imctitle {color:#185c81; text-align:left; font-family:Arial; font-size:12px; font-weight:normal; border-style:solid; border-color:#fff; border-width:1px; padding:2px 8px; }

		/* [hover] - These settings must be duplicated for IE compatibility.*/
		#imenus0 li:hover>a {background-color:#efefef; text-decoration:underline; }
		#imenus0 li a.ihover, .imde imenus0 a:hover {background-color:#efefef; text-decoration:underline; }

		/* [active] */
		#imenus0 li a.iactive {}


	/* --[[ Sub Items ]]-- */
	#imenus0 ul a, #imenus0 .imsubc li .imctitle  {color:#185c81; text-align:left; font-size:11px; font-weight:normal; text-decoration:none; border-style:none; border-color:#000000; border-width:1px; padding:2px 5px; }

		/* [hover] - These settings must be duplicated for IE comptatibility.*/
		#imenus0 ul li:hover>a {color:#185c81; text-decoration:underline; }
		#imenus0 ul li a.ihover {color:#185c81; text-decoration:underline; }

		/* [active] */
		#imenus0 ul li a.iactive {background-color:#ffffff; }


.STYLE1 {color: #FF0000}
</style><!--end-->
<script type="text/javascript" src="script/jquery-1.5.min.js"></script>
<script type="text/javascript">
	function login()
	{
		var v_name = document.getElementById("j_username").value;
	  	var v_pwd = document.getElementById("j_password").value;
	  	if ( v_name ==''){
			alert("用户名不能为空");
	  		return false;
	  	}
	  	else if( v_pwd =='' ){
	  		alert("密码不能为空");
	  		return false;
	 	 }
	  	
	  	document.getElementById('form1').submit();
	}
</script>
</head>
<body>
<div id="top_main">

<div class="top_con">
      <div class="top_left";>
         <a href="http://www.bfuture.com.cn/index.html" target="_blank"><img src="images/logo.jpg" border="0" /></a> </div>
	    <div class="top_right">
		  <table width="500" border="0">  
  <tr>
    <td align="right" style="padding-top:10px;"> 客服电话：(010)5128-3636(北京)/4006-242628(北京以外)&nbsp;&nbsp;
			 →在线客服</td>
  </tr>
</table>
		 
	    </div>
	      
		   
  </div>
</div>

<div style="margin:0px auto; padding:0px; text-align:center; width:970px;">
<!--|**START IMENUS**|imenus0,inline-->

<!--  ****** Infinite Menus Structure & Links ***** -->
<div class="imrcmain0 imgl" style="width:970px;z-index:999999; position:relative;"><div class="imcm imde" id="imouter0"><ul id="imenus0">
<li class="imatm"  style="width:154px;"><a href="http://www.bfuture.com.cn/index.html" target="_blank" class="">首页</a></li>

<li class="imatm"  style="width:155px;"><a href="http://www.bfuture.com.cn/news.html"  target="_blank"><span class="imea imeam"><span></span></span>新闻</a>
   <div class="imsc"><div class="imsubc" style="width:181px;top:0px;left:-1px;"><ul style="">
	<li><a href="http://www.bfuture.com.cn/newslist.html" target="_blank">平台消息</a></li>
	<li><a href="http://www.bfuture.com.cn/companyevertslist.html" target="_blank">公司动态</a></li>
	<li><a href="http://www.bfuture.com.cn/industryinformation.html" target="_blank">行业资讯</a></li>
	<li><a href="http://www.bfuture.com.cn/companyfantasy.html" target="_blank">公司印象</a></li>
	</ul></div></div></li>

 
<li class="imatm"  style="width:160px;"><a href="http://www.bfuture.com.cn/production_service.html" target="_blank"><span class="imea imeam"><span></span></span>产品及服务</a>
    <div class="imsc"><div class="imsubc" style="width:181px;top:0px;left:-1px;"><ul style="">
	<li><a href="http://www.bfuture.com.cn/scm.html" target="_blank">供应链平台</a></li>
	<li><a href="http://www.bfuture.com.cn/t1.html" target="_blank">供应链金融平台</a></li>
	<li><a href="http://www.bfuture.com.cn/mis.html" target="_blank">MIS自管理平台</a></li>
	<li><a href="http://www.bfuture.com.cn/sms.html" target="_blank">在线短信平台</a></li>
	<li><a href="http://www.bfuture.com.cn/csae.html" target="_blank">经典案例</a></li>
	</ul></div></div></li>
	
<li class="imatm"  style="width:160px;"><a href="http://www.bfuture.com.cn/ptys.html" target="_blank"><span class="imea imeam"><span></span></span>在线演示</a>
     <div class="imsc"><div class="imsubc" style="width:181px;top:0px;left:-1px;"><ul style="">
	<li><a href="http://www.bfuture.com.cn/ptys.html" target="_blank">SCM平台演示</a></li>
	<li><a href="http://www.bfuture.com.cn/ptys_saas.html" target="_blank">SaaS平台演示</a></li>
	<li><a href="#" target="_blank">供应链金融演示</a></li>
	<li><a href="http://www.bfuture.com.cn/ptys-mis.html" target="_blank">MIS自管理演示</a></li>
	<li><a href="#" target="_blank">在线短信平台演示</a></li>
	</ul></div></div></li>

<li class="imatm"  style="width:171px;"><a href="http://www.bfuture.com.cn/jianjie.html" target="_blank"><span class="imea imeam"><span></span></span>关于我们</a>
     <div class="imsc"><div class="imsubc" style="width:181px;top:0px;left:-1px;"><ul style="">
	<li><a href="http://www.bfuture.com.cn/jianjie.html" target="_blank">公司简介</a></li>
	<li><a href="http://www.bfuture.com.cn/lianxiwomen.html" target="_blank">联系我们</a></li>
	<li><a href="http://www.bfuture.com.cn/friends.html" target="_blank">合作伙伴</a></li>
	<li><a href="http://www.bfuture.com.cn/partner.html" target="_blank">渠道伙伴</a></li>
	<li><a href="http://www.bfuture.com.cn/jiameng.html" target="_blank">诚征加盟</a></li>
	<li><a href="http://www.bfuture.com.cn/zmhb.html" target="_blank">招募代理</a></li>
	<li><a href="http://www.bfuture.com.cn/credit.html" target="_blank">公司荣誉</a></li>
	<li><a href="http://www.bfuture.com.cn/bangzhu.html" target="_blank">帮助中心</a></li>
	</ul></div></div></li>

<li class="imatm"  style="width:170px;"><a href="http://www.bfuture.com.cn/jiameng.html" target="_blank">合作加盟</a></li>

</ul><div class="imclear">&nbsp;</div></div></div>



<!--|**END IMENUS**|-->

<!--[imcode]*** Infinite Menus Settings / Code - This script reference must appear last. ***

      *Note: This script is required for scripted add on support and IE 6 sub menu functionality.
      *Note: This menu will fully function in all CSS2 browsers with the script removed.-->



<div id="wfi_main">

	<div style="float:left; text-align:left; width:550px;">	
	  <img src="images/index_top.jpg" />
	  <div style="margin-top:13px; margin-left:9px;"><img src="images/ad_con.jpg" border="0" style="border:#CCCCCC 1px solid;" /></div>
</div>	
<form name="form1" id="form1" method="post"  action="Login">	
		<div class="login_in2">
		    <div class="login_content">
			    <div style="padding-bottom:20px;">用&nbsp;户&nbsp;名：<input name="j_username" id="j_username" type="text" value=""  style="margin-left:20px; width:200px;"/></div>
				<div style="padding-bottom:20px;">密&nbsp;&nbsp;&nbsp;&nbsp;码：<input name="j_password" id ="j_password" type="password"  style="margin-left:20px; width:200px;"/></div>				
				<div style="padding-bottom:20px;">
				    <span style="float:left;"><input name="" type="radio" value=""  style="margin-right:5px;"/>记住用户名</span>
					<span class="forgotten">忘记密码？</span>
				  <div style="clear:both"></div>	
				</div>
				<div class="log_in_con">
					  <span style="float:left; text-align:left;"> <a href="javascript:void(0);" onclick="login();" ><img src="images/log_in_bg.jpg" border="0" /></a></span><a href="new_user.jsp"><span style="float:right; text-align:right;">新用户注册</span></a>
					<div style="clear:both"></div>
			  </div>
				   <div style="padding-bottom:20px;"><img src="images/log_heng.jpg" /></div>
				 <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/" target="_blank" title="走进富基标商">走进富基标商...</a></div>
				  <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/jiameng.html" target="_blank" title="合作加盟">合作加盟...</a></div>
				 <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/production_service.html" target="_blank" title="了解我们的产品和服务">了解我们的产品和服务...</a></div>
				 <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/t1.html" target="_blank" title="小企业贷款-信任富基标商供应链金融服务">小企业贷款-信任富基标商供应链金融服务...</a></div>
				  <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/companyevertscontent65.html" target="_blank" title="富基标商荣获“2010北京信息网络产业最具创新力企业”">富基标商荣获“2010北京信息网络产业最具创新力...</a></div>
				 <div style="padding-bottom:20px;"><img src="images/point.jpg" />&nbsp;&nbsp;<a href="http://www.bfuture.com.cn/companyevertscontent64.html" target="_blank" title="富基标商荣获“2010年度SaaS增值服务模式创新奖”">富基标商荣获“2010年度SaaS增值服务模式创新奖”</a></div>
				 
			</div>
		</div>
</form>
</div>

<div style="clear:both"></div>

<div class="main_bottom">

  <table width="900" border="0">
    <tr>
      <td align="right">Copyrights 2001-2010 <a href="http://www.bfuture.com.cn"><span>北京富基标商流通信息科技有限公司版权所有</span></a></td>
      <td align="right"><a href="http://www.bfuture.com.cn">www.bfuture.com.cn</a></td>
    </tr>
  </table>

</div>
</body>
</html>
