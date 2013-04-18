package com.bfuture.app.saas.clientapp.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import net.sf.json.JSONObject;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.POJOObject;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.SysLogManager;
import com.bfuture.app.saas.service.SysScmuserManager;

/**
 * 
 * 
 * @author 丁元
 * @version 1.0
 */
public class LoginServlet extends BasicServlet {

	Logger log = Logger.getLogger( LoginServlet.class );
	
	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {
		PrintWriter out = null;

		String passwordErrorPage = getServletContext().getInitParameter( Constants.PAGE_PASSWORD_ERROR );
		String systemErrorPage = getServletContext().getInitParameter( Constants.PAGE_SYSTEM_ERROR );
		try {
//			response.setCharacterEncoding("GBK");
			out = response.getWriter();

//			if (getCurrentUser(request) != null) {
//				out.println( JSONObject.fromObject( getCurrentUser(request) ).toString() );
//				out.close();
//				return;
//			}
			
			SysLogManager logManager = (SysLogManager)getSpringBean("sysLogManager");
			SysScmuserManager userManger = (SysScmuserManager) getSpringBean("userManager");
			String usercode = request.getParameter("j_username");
			String password = request.getParameter("j_password");
			if (password != null) {
				password = userManger.encoder(password);
			}
			
			SysScmuser smUser = null;
			
			if (("").equals(usercode) || (usercode == null)
					|| ("").equals(password) || (password == null)) {
//				this.sendError(response, "用户名或密码为空" );
				response.sendRedirect( passwordErrorPage );
				return;
			}
			try {
				smUser = userManger.getSysScmuserBySucode(usercode);
				if ((smUser == null) || (!password.equals( smUser.getSupwd() ) ) ) {
//					this.sendError(response, "用户不存在或密码不正确" );
					response.sendRedirect( passwordErrorPage );
					return;
				}
				else if( Character.valueOf('Y').compareTo( smUser.getSuenable() ) != 0  ) {
//					this.sendError(response, "用户已禁用" );
					response.sendRedirect( passwordErrorPage );
					return;
				}
			} catch (Exception e) {
//				this.sendError(response, "登录时产生错误：" + e.getMessage() );
				response.sendRedirect( passwordErrorPage );
				return;
			}
			
			smUser.setRoles( userManger.getRolesBySucode( usercode ) );
			if("3027".equals(smUser.getSgcode()) && "S".equals(smUser.getSutype()+"")){
				List list = userManger.getSupplierJyfs(smUser.getSgcode(), smUser.getSupcode());
				Map map = (Map)list.get(0);
				smUser.setSuflag(map.get("JYFS").toString().charAt(0));
			}
			smUser.setRemoteIP( request.getRemoteAddr() );
			smUser.setSupwd( null );			
			request.getSession(true).setAttribute( Constants.LOGIN_USER, smUser );
			
			POJOObject bo = new POJOObject();
			bo.setOptType( "login" );
			bo.setOptContent( "登录" );
			logManager.log( smUser, bo );
			
			String userjson = JSONObject.fromObject( smUser ).toString();
			out.print( userjson );
			
			request.getRequestDispatcher( "index.jsp" ).forward( request, response );

		} catch (Exception e) {
//			this.sendError(response, "登录时产生错误：" + e.getMessage() );
			try {
				response.sendRedirect( systemErrorPage );
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (Throwable e) {
//			this.sendError(response, "登录时产生错误：" + e.getMessage() );
			try {
				response.sendRedirect( systemErrorPage );
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				if (null != out) {
					out.close();
				}

			} catch (Exception e) {
				// e.printStackTrace();
			}
		}

	}
	
	/**
	 * 获取系统当前用户
	 * 
	 * @return 系统当前用户HttpServletRequest request
	 */
	public SysScmuser getCurrentUser(HttpServletRequest request)
	{
		SysScmuser smUser=null;
		smUser=(SysScmuser) request.getSession().getAttribute(Constants.LOGIN_USER);
		return smUser;
	}
	
	public boolean noLogin(HttpServletRequest request)
	{
		return getCurrentUser(request) == null; 
	}

}
