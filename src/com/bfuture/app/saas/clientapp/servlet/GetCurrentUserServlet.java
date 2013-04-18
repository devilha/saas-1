package com.bfuture.app.saas.clientapp.servlet;

import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.saas.model.SysScmuser;




/**
 * 

 * @author 丁元
 * @version 1.0
 */
public class GetCurrentUserServlet extends BasicServlet
{


	@Override
	public void performTask( HttpServletRequest request,
			HttpServletResponse response ){
	PrintWriter out=null;	

	String resultStr ="";

		try
		{
			
			out =  response.getWriter();
			if (noLogin(request))
			{
				this.sendError(response, Constants.NO_LOGIN);
				return;
			}
			resultStr= JSONObject.fromObject( getCurrentUser(request) ).toString();
//			resultStr = URLEncoder.encode( resultStr, "utf-8");
			out.println(resultStr);
			out.close();	
			
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
				//e.printStackTrace();
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
