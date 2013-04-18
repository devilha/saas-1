package com.bfuture.app.basic.clientapp.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import java.util.zip.Adler32;
import java.util.zip.CheckedInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.JSONUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;

import com.bfuture.app.basic.AppSpringContext;
import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.util.JsonDateValueProcessor;




/**
 * 
 * <p>
 * Title: BasicServlet基类
 * </p>
 * <p>
 * Description: 所有的Servlet都继承自此类
 * </p>
 */
public abstract class BasicServlet extends HttpServlet {
	public final Log log = LogFactory.getLog(getClass());


	
	public void sendError(HttpServletResponse response,String msg)
	{
		
		
		PrintWriter out = null;
		try {			
			out =  response.getWriter();
			out.print( "{ \"error\":\"" + msg + "\" }");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			out.close();
		}
		 
		//response.flushBuffer();

	}
	
	/**
	 * 
	 * 
	 */
	public Object getSpringBean(String className) {
		AppSpringContext appContext = AppSpringContext.getInstance();
		return appContext.getAppContext().getBean(className);
	}
	/**
	 * 
	 * 
	 */
	public ApplicationContext getSpringContext() {
		AppSpringContext appContext = AppSpringContext.getInstance();
		return appContext.getAppContext();
	}
	/**
	 * 
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param index
	 *            String
	 * @param obj
	 *            Object
	 * @return void
	 */
	protected void addObjectToSession(HttpServletRequest request, String index,
			Object obj) {
		HttpSession session = request.getSession(true);
		String sessionid = session.getId();
		boolean b = session.isNew();
		long l = session.getCreationTime();
		if (obj == null) {
			session.removeAttribute(index);
		} else {
			session.setAttribute(index, obj);
		}
	}

	/**
	 * 
	 * 
	 * @return java.lang.String
	 * @param s
	 *            java.lang.String
	 * @exception java.io.UnsupportedEncodingException
	 *               
	 */
	protected String changToChinese(String s)
			throws UnsupportedEncodingException {
		if (s == null)
			return null;

		byte[] aa = s.getBytes("8859_1");
		String ss = new String(aa, "GBK");
		return ss;
	}

	/**
	 *
	 * 
	 * @return java.lang.String
	 * @param s
	 *            java.lang.String
	 * @exception java.io.UnsupportedEncodingException
	 *                
	 */
	protected String changToEnglish(String s)
			throws UnsupportedEncodingException {
		if (s == null)
			return null;

		byte[] aa = s.getBytes("GBK");
		String ss = new String(aa, "8859_1");
		return ss;
	}

	/**
	 * 
	 * 
	 */

	protected void convertToZipXML(String xml,
			javax.servlet.http.HttpServletResponse response) throws Exception {
		try {
			xml = changToChinese(xml);
			ZipOutputStream zipOutputstream = null;
			OutputStream outstream = response.getOutputStream();
			zipOutputstream = new ZipOutputStream(new BufferedOutputStream(
					outstream));
			zipOutputstream.putNextEntry(new ZipEntry("packedVdrp.xml"));
			zipOutputstream.setLevel(9);
			zipOutputstream.write(xml.getBytes());
			zipOutputstream.close();
		} catch (Exception ex) {
			throw ex;
		}
	}

	/**
	 *
	 * 
	 */

	protected void convertToZipXMLs(String[] xmls,
			javax.servlet.http.HttpServletResponse response) throws Exception {
		try {
			String xml = null;

			ZipOutputStream zipOutputstream = null;
			OutputStream outstream = response.getOutputStream();
			zipOutputstream = new ZipOutputStream(new BufferedOutputStream(
					outstream));
			for (int i = 0; i < xmls.length; i++) {
				zipOutputstream.putNextEntry(new ZipEntry("packedvdrp" + i
						+ ".xml"));
				zipOutputstream.setLevel(9);

				xml = xmls[i];
				zipOutputstream.write(xml.getBytes());
			}
			zipOutputstream.close();
		} catch (Exception ex) {
			throw ex;
		}
	}

	/**
	 * Process incoming HTTP GET requests
	 * 
	 * @param request
	 *            Object that encapsulates the request to the servlet
	 * @param response
	 *            Object that encapsulates the response from the servlet
	 */
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) {

		performTask(request, response);
	}

	/**
	 * Process incoming HTTP POST requests
	 * 
	 * @param request
	 *            Object that encapsulates the request to the servlet
	 * @param response
	 *            Object that encapsulates the response from the servlet
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) {

		performTask(request, response);
	}

	/**
	 * 
	 * 
	 */
	protected String getZipString(javax.servlet.http.HttpServletRequest request)
			throws Exception {
		ZipInputStream in = null;
		String xml = null;
		try {
			InputStream instream = request.getInputStream();
			CheckedInputStream cinstream = new CheckedInputStream(instream,
					new Adler32());
			in = new ZipInputStream(new BufferedInputStream(cinstream));
			ZipEntry ze;
			StringBuffer xmlbuffer = new StringBuffer();
			while ((ze = in.getNextEntry()) != null) {
				int x;
				while ((x = in.read()) != -1) {
					xmlbuffer.append(((char) x));
				}
			}
			xml = xmlbuffer.toString();
			xml = changToChinese(xml).trim();
			in.close();
		} catch (Exception ex) {
			throw ex;
		} finally {
			try {
				if (in != null)
					in.close();
			} catch (IOException e) {
			}
		}
		return xml;
	}

	/**
	 * 
	 */
	protected String getPostString(javax.servlet.http.HttpServletRequest request)
			throws Exception {
		InputStream instream = null;
		String xml = null;
		try {
			instream = request.getInputStream();

			StringBuffer xmlbuffer = new StringBuffer();

			int x;
			while ((x = instream.read()) != -1) {
				xmlbuffer.append(((char) x));
			}

			xml = xmlbuffer.toString();

			instream.close();
		} catch (Exception ex) {
			throw ex;
		} finally {
			try {
				if (instream != null)
					instream.close();
			} catch (IOException e) {
			}
		}
		return xml;
	}

	/**
	 * 
	 */
	protected Object getObjectFromSession(HttpServletRequest request,
			String index) {

		HttpSession session = request.getSession(false);
		if (session != null)
			return session.getAttribute(index);
		else
			return null;
	}
	
	protected List<BaseObject> getObjectsFromRequest( HttpServletRequest request ) throws Exception{
		
		List<BaseObject> lstBaseObjects = null;
		
		int pageRows = 0;
		int page = 0;
		String order = null;
		String sort = null;
		if(null != request.getParameter("rows")) {
			pageRows = Integer.parseInt( request.getParameter("rows").toString() );  
		}  
		if(null!=request.getParameter("page")) {  
			page = Integer.parseInt(request.getParameter("page").toString());  
		} 
		if(null!=request.getParameter("order")) {  
			order = request.getParameter("order").toString();  
		}
		if(null!=request.getParameter("sort")) {  
			sort = request.getParameter("sort").toString();  
		}
		String data = request.getParameter( Constants.JSON_DATA );
		if( !StringUtil.isBlank( data ) ){
			JSONUtils.getMorpherRegistry().registerMorpher( 
			          new DateMorpher(new String[] { "yyyy-MM-dd HH:mm:ss" })); 

			String decodeData = URLDecoder.decode( data, "utf-8");
			JSONObject jo = JSONObject.fromObject( decodeData );
			if( jo != null ){
				JsonConfig jsonConfig = new JsonConfig(); 
				jsonConfig.registerJsonValueProcessor( Date.class,new JsonDateValueProcessor() );
				
				JSONArray jsonList = jo.getJSONArray( Constants.JSON_LIST );
				if( jsonList != null ){					
					if( !StringUtil.isBlank( jo.getString( Constants.ACTION_CLASS ) ) && !StringUtil.isBlank( jo.getString( Constants.ACTION_TYPE ) ) ){
						Class boClass = Class.forName( jo.getString( Constants.ACTION_CLASS ) );
						JSONUtils.getMorpherRegistry().registerMorpher( 
						          new DateMorpher(new String[] { "yyyy-MM-dd HH:mm:ss" })); 
						Collection<BaseObject> list = JSONArray.toCollection( jsonList, boClass );
						 
						if( list != null ){
							lstBaseObjects = new ArrayList<BaseObject>();
							for( BaseObject baseobject : list ){
								baseobject.setACTION_CLASS( jo.getString( Constants.ACTION_CLASS ) );
								baseobject.setACTION_TYPE( jo.getString( Constants.ACTION_TYPE ) );
								baseobject.setACTION_MANAGER( jo.getString( Constants.ACTION_MANAGER ) );
								if( jo.containsKey( Constants.OPT_TYPE ) ){
									baseobject.setOptType( jo.getString( Constants.OPT_TYPE ) );
								}
								if( jo.containsKey( Constants.OPT_CONTENT ) ){
									baseobject.setOptContent( jo.getString( Constants.OPT_CONTENT ) );
								}
								baseobject.setRows( pageRows );
								baseobject.setPage( page );
								baseobject.setOrder( order );
								baseobject.setSort( sort );
								lstBaseObjects.add( baseobject );								
							}
						}
					}
				}
			}
		}
		
		return lstBaseObjects;
	}

	/**
	 * 
	 * 
	 * @param: <|>
	 * @return:
	 * @param objectName
	 *            java.lang.String
	 */
	public Object getObjectFromVector(Vector vec, String objectName) {

		Object obj = null;
		for (int i = 0; i < vec.size(); i++) {
			obj = vec.elementAt(i);
			if (obj.getClass().getName().indexOf(objectName) != -1)
				break;
		}
		return obj;
	}

	/**
	 * Returns the servlet info string.
	 */
	@Override
	public String getServletInfo() {

		return super.getServletInfo();

	}

	/**
	 * Initializes the servlet.
	 */
	@Override
	public void init() {
		// insert code to initialize the servlet here

	}	

	/**
	 * 
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 */
	public abstract void performTask(HttpServletRequest request,
			HttpServletResponse response);

}
