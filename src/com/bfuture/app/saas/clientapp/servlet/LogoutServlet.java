package com.bfuture.app.saas.clientapp.servlet;

import java.io.PrintWriter;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.basic.model.POJOObject;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.SysLogManager;





/**
 * 

 * @author 丁元
 * @version 1.0
 */
public class LogoutServlet extends BasicServlet
{

	@Override
	public void performTask( HttpServletRequest request,
			HttpServletResponse response ){
		
		SysLogManager logManager = (SysLogManager)getSpringBean("sysLogManager");
		PrintWriter out = null;

		try
		{

	        
			if (request.getSession(false) != null) {
				
				Set SmUsers = (Set) getServletContext().getAttribute(Constants.SmUserS_KEY);

		        if (SmUsers != null) {
		        	SysScmuser smUser = getCurrentUser(request);
		        	
		        	POJOObject bo = new POJOObject();
					bo.setOptType( "logout" );
					bo.setOptContent( "退出" );
					logManager.log( smUser, bo );
		        	
		            SmUsers.remove( smUser );
		        }

		        getServletContext().setAttribute(Constants.SmUserS_KEY, SmUsers);
		        int counter = Integer.parseInt((String) getServletContext().getAttribute(Constants.COUNT_KEY));
		        counter --;

		        if (counter < 0) {
		            counter = 0;
		        }

		        getServletContext().setAttribute(Constants.COUNT_KEY, Integer.toString(counter));
				request.getSession().invalidate();
			}
			response.sendRedirect("http://www.bfuture.com.cn/");			
		}
		catch( Exception e )
		{
			e.printStackTrace();
		}
		catch( Throwable e )
		{
			e.printStackTrace();
		}finally{
			try{
				if(null!=out){
					out.close();
				}
				
			}catch(Exception e){
				e.printStackTrace();
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
		smUser=(SysScmuser) request.getSession().getAttribute( Constants.LOGIN_USER );
		return smUser;
	}
		
}
