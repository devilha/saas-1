package com.bfuture.app.basic.service.impl;

import java.io.IOException;
import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.AppSpringContext;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.SysMenu;
import com.bfuture.app.saas.model.SysScmuser;

/**
 * Base class for Business Services - use this class for utility methods and
 * generic CRUD methods.
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 */
public class BaseManagerImpl implements BaseManager {
	/**
	 * Log instance for all child classes. Uses LogFactory.getLog(getClass()) from Commons Logging
	 */
	public final Log log = LogFactory.getLog(getClass());
	/**
	 * UniversalDao instance, ready to charge forward and persist to the database
	 */
	protected UniversalAppDao dao;
	protected SysScmuser user;

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public UniversalAppDao getDao() {
		return dao;
	}

	/**
	 * {@inheritDoc}
	 */
	public Object get(Class clazz, Serializable id) {
		return dao.get(clazz, id);
	}

	/**
	 * {@inheritDoc}
	 */
	public List getAll(Class clazz) {
		return dao.getAll(clazz);
	}

	/**
	 * {@inheritDoc}
	 */
	public void remove(Class clazz, Serializable id) {
		dao.remove(clazz, id);
	}

	/**
	 * {@inheritDoc}
	 */
	public void remove(Object o){
		dao.remove(o);
	}

	/**
	 * {@inheritDoc}
	 */
	public void remove(Object[] o){
		for (Object s : o) {
			Object id=null;
			try {
				Method getMethod = s.getClass().getMethod("getId",
						null);
				 id=getMethod.invoke(s, null);

			} catch (Exception e) {
				
			}
			if (id!=null)
			remove(s.getClass(),(Serializable)id);
			else
				dao.remove(s);
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public Object save(Object o){
		
		return dao.save(o);
	}

	/**
	 * {@inheritDoc}
	 */
	public Object[] save(Object[] o) throws Exception{
		
		Object[] updateObject = new Object[o.length];
		for (int i = 0; i < o.length; i++) {

			updateObject[i] = dao.save(o[i]);
		}
		return updateObject;
	}
	

	public List getByObject(Object o) {
		return dao.getByObject(o);
	}
	
	public ReturnObject getResult(Object o) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public ReturnObject getTreeResult(Object o) {
		// TODO Auto-generated method stub
		return null;
	}

	public Object[] InsertAndExec(Object[] o) {
		
		Object[] updateObject = new Object[o.length];
		for (int i = 0; i < o.length; i++) {

			updateObject[i] = dao.InsertAndExec(o[i]);
		}
		return updateObject;
	}
	
	public Object InsertAndExec(Object o) {
		
		Object updateObject = dao.InsertAndExec(o);
		return updateObject;
	}

	public void ExecAndDelete(Object[] o) {
		for (Object s : o) {
			Object id=null;
			try {
				Method getMethod = s.getClass().getMethod("getId",
						null);
				 id=getMethod.invoke(s, null);

			} catch (Exception e) {
				
			}
			if (id!=null)
				dao.ExecAndDelete(s.getClass(),(Long)id);

		}
	}
	
	public void ExecAndDelete(Object o) {
		
			Object id=null;
			try {
				Method getMethod = o.getClass().getMethod("getId",
						null);
				 id=getMethod.invoke(o, null);

			} catch (Exception e) {
				
			}
			if (id!=null)
				dao.ExecAndDelete(o.getClass(),(Long)id);

		
	}

	public void ExecOther(Object o) {
		// TODO Auto-generated method stub
		
	}

	public ReturnObject ExecOther(String actionType, Object[] o) {
		return null;		
	}
	public void flush(){
		dao.flush();
	}
	
	/**
	 * 
	 * 通过spring获得manager
	 */
	public Object getSpringBean(String className) {
		AppSpringContext appContext = AppSpringContext.getInstance();
		return appContext.getAppContext().getBean(className);
	}
	
	protected String getWebPath(){
		String webPath = null;
		AppSpringContext appContext = AppSpringContext.getInstance();
		try {
			webPath = appContext.getAppContext().getResource("").getFile().getAbsolutePath();
		} catch (IOException e) {}
		return webPath;
	}

	public List<SysMenu> getTreeByRlcode(Object o) throws Exception{
		return null;
		
	}

	public void setUser( SysScmuser user ) {
		this.user = user;
	}

	public ReturnObject findNewPrds(Object o,String sgcode,String supid, String applyStatus,
			String startDate, String endDate, String applyname,
			String gdbarcode, String gdname,String custType,String gysbm,String supname,String printstatus) {
		// TODO Auto-generated method stub
		return null;
	}


}
