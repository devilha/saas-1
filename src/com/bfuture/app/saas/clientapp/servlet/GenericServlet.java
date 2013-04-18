package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.JSONUtils;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.POJOObject;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.util.Excel;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.SysLogManager;
import com.bfuture.app.saas.service.YwBorderheadManager;
import com.bfuture.app.saas.util.JsonDateValueProcessor;

public class GenericServlet extends BasicServlet {

	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {
		
		SysLogManager logManager = (SysLogManager)getSpringBean("sysLogManager");
		ReturnObject ro = new ReturnObject();
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {			
			e.printStackTrace();
			return;
		}
		
		
		boolean isTree = false;
		try{			
			List<BaseObject> lstObjects = getObjectsFromRequest( request );
			
			
			if( lstObjects != null && lstObjects.size() > 0 ){
				BaseObject bo = lstObjects.get( 0 );
				SysScmuser smUser = getCurrentUser(request);
	        	
				if( smUser == null ){
					ro.setReturnCode( Constants.ERROR_FLAG );
					ro.setReturnInfo( "登录已超时，请重新登录" );								
				}				
				else if( !StringUtil.isBlank( bo.getACTION_MANAGER() ) ){
					Object springBean = getSpringBean( bo.getACTION_MANAGER() );
					if( springBean != null ){
						BaseManager bm = (BaseManager)springBean;
						bm.setUser( smUser );					
						
						Object[] objs = null;
						
						ro.setReturnCode( Constants.SUCCESS_FLAG );
						if( Constants.INSERT.equals( bo.getACTION_TYPE() ) ){
							bm.save( lstObjects.toArray() );
						}
						else if( Constants.UPDATE.equals( bo.getACTION_TYPE() ) ){
							bm.save( lstObjects.toArray() );
						}
						else if( Constants.DELETE.equals( bo.getACTION_TYPE() ) ){							
							bm.remove( lstObjects.toArray() );
						}
						else if( Constants.DATAGRID.equals( bo.getACTION_TYPE() ) ){							
							ro = bm.getResult( bo );							
						}
						else if( Constants.TREEGRID.equals( bo.getACTION_TYPE() ) ){
							isTree = true;
							ro = bm.getResult( bo );
						}
						else if( Constants.COMBOGRID.equals( bo.getACTION_TYPE() ) ){
							isTree = true;
							ro = bm.getResult( bo );
						}
						else if( Constants.COMBOBOX.equals( bo.getACTION_TYPE() ) ){
							isTree = true;
							ro = bm.getResult( bo );
						}
						else if( Constants.TREE.equals( bo.getACTION_TYPE() ) ){
							isTree = true;
							ro = bm.getTreeResult( bo );
						}else{
							ro = bm.ExecOther( bo.getACTION_TYPE(), lstObjects.toArray() );
						}
						
						if( bo.isExportExcel() && ro != null && ro.getRows() != null && ro.getRows().size() > 0 ){
							SimpleDateFormat bartDateFormat =  new SimpleDateFormat("yyyyMMddhhmmss");  
							String strDate = bartDateFormat.format(new Date()); 
							String fileName = bo.getSheetTitle()+ strDate;
							String path =  request.getSession().getServletContext().getRealPath("/temp") + File.separator + smUser.getSucode()+"_"+strDate + ".xls"; 
							//String path =  request.getSession().getServletContext().getRealPath("/temp") + File.separator + fileName + ".xls"; 
							List rows = ro.getRows();
							if( ro.getFooter() != null && ro.getFooter().size() > 0 ){
								rows.addAll( ro.getFooter() );
							}
							boolean exportFlag = false;
							if("3008".equals(smUser.getSgcode())){
								exportFlag = Excel.createExcelQG( rows, path, listToArray( bo.getEnTitle() ), listToArray( bo.getCnTitle() ), bo.getSheetTitle() );
							}else{
								exportFlag = Excel.createExcel( rows, path, listToArray( bo.getEnTitle() ), listToArray( bo.getCnTitle() ), bo.getSheetTitle() );
							}
							if( exportFlag ){
								File tmpDir = new File( request.getContextPath() + "/temp" );
								if( !tmpDir.exists() ){
									tmpDir.mkdir();
								}
								
								ro.setReturnCode( Constants.SUCCESS_FLAG );
								ro.setReturnInfo( request.getContextPath() + "/temp/" + smUser.getSucode()+"_"+strDate + ".xls" );
							}
							else{
								ro.setReturnCode( Constants.ERROR_FLAG );
								ro.setReturnInfo( null );
							}
						}
						
						//记录操作日志
						logManager.log( smUser, bo );
						
						if( objs != null ){
							List<Object> lstObjs = new ArrayList<Object>();
							for( int i = 0; i < objs.length; i ++ ){
								lstObjs.add( objs[i] );
							}
							ro.setRows( lstObjs );
						}
					}
					else{
						ro.setReturnCode( Constants.ERROR_FLAG );
						ro.setReturnInfo( "指定的处理对象没有注册" );
					}
				}
				else{
					ro.setReturnCode( Constants.ERROR_FLAG );
					ro.setReturnInfo( "没有指定处理对象" );
				}
			}
			else{
				ro.setReturnCode( Constants.ERROR_FLAG );
				ro.setReturnInfo( "没有获得任何数据" );
			}
		}
		catch( Exception ex ){
			ex.printStackTrace();
			ro.setReturnCode( Constants.ERROR_FLAG );
			ro.setReturnInfo( ex.getMessage() );
		}
		finally{
			
			if( isTree && ro.getRows() != null ){
				JSONUtils.getMorpherRegistry().registerMorpher( 
				          new DateMorpher(new String[] { "yyyy-MM-dd HH:mm:ss" }));
				out.print( JSONArray.fromObject( ro.getRows() ).toString() );
			}
			else{
				JSONUtils.getMorpherRegistry().registerMorpher( 
				          new DateMorpher(new String[] { "yyyy-MM-dd HH:mm:ss","yyyy-MM-dd" }));
				out.print( JSONObject.fromObject( ro ).toString() );
				System.out.println(JSONObject.fromObject( ro ).toString());
			}
			out.close();
		}

	}
	
	private String[] listToArray( List<String> lstSrc ){
		String[] results = null;
		
		if( lstSrc != null && lstSrc.size() > 0 ){
			results = new String[ lstSrc.size() ];
			int i = 0;
			for( Iterator<String> itLst = lstSrc.iterator(); itLst.hasNext(); i ++ ){
				results[i] = itLst.next();
			}
		}
		
		return results;
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
