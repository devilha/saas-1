package com.bfuture.app.basic.service;

import java.io.Serializable;
import java.util.List;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.saas.model.SysMenu;
import com.bfuture.app.saas.model.SysScmuser;


/**
 * Business Facade interface. 
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 *
 * Modifications and comments by <a href="mailto:bwnoll@gmail.com">Bryan Noll</a>
 * This thing used to be named simply 'GenericManager' in versions of AppFuse prior to 2.0.
 * It was renamed in an attempt to distinguish and describe it as something
 * different than GenericManager.  GenericManager is intended for subclassing, and was
 * named Generic because 1) it has very general functionality and 2) is
 * 'generic' in the Java 5 sense of the word... aka... it uses Generics.
 *
 * Implementations of this class are not intended for subclassing. You most
 * likely would want to subclass GenericManager.  The only real difference is that
 * instances of java.lang.Class are passed into the methods in this class, and
 * they are part of the constructor in the GenericManager, hence you'll have to do
 * some casting if you use this one.
 *
 * @see com.einvite.service.GenericManager
 */
public interface BaseManager {
	
    /**
     * Generic method used to get a all objects of a particular type. 
     * @param clazz the type of objects 
     * @return List of populated objects
     */
    List getAll(Class clazz);

    /**
     * Generic method to get an object based on class and identifier. 
     * 
     * @param clazz model class to lookup
     * @param id the identifier (primary key) of the class
     * @return a populated object 
     * @see org.springframework.orm.ObjectRetrievalFailureException
     */
    Object get(Class clazz, Serializable id);

    /**
     * Generic method to save an object.
     * @param o the object to save
     * @return a populated object
     * @throws Exception 
     */
    Object save(Object o) throws Exception;

    /**
     * Generic method to save an object.
     * @param o the object to save
     * @return a populated object
     * @throws Exception 
     */
    Object[] save(Object[] o) throws Exception;
    /**
     * Generic method to save an object.
     * @param o the object to save
     * @return a populated object
     */
    Object[] InsertAndExec(Object[] o);
    Object InsertAndExec(Object o);
    /**
     * Generic method to delete an object based on class and id
     * @param clazz model class to lookup
     * @param id the identifier of the class
     */
    void remove(Class clazz, Serializable id);
    /**
     * Generic method to delete an object based on class and id
     * @param clazz model class to lookup
     * @param id the identifier of the class
     * @throws Exception 
     */
    void remove(Object o) throws Exception;
    /**
     * Generic method to delete an object based on class and id
     * @param clazz model class to lookup
     * @param id the identifier of the class
     * @throws Exception 
     */
    void remove(Object[] o) throws Exception;
    
    List getByObject(Object o) throws Exception ;
    ReturnObject getResult(Object o);
    ReturnObject getTreeResult(Object o);
	void ExecAndDelete(Object[] o);
	void ExecAndDelete(Object o);
	void ExecOther(Object o);
    void flush();
    ReturnObject ExecOther( String actionType, Object[] o);
    List<SysMenu> getTreeByRlcode(Object o) throws Exception;
    void setUser( SysScmuser user );

	ReturnObject findNewPrds(Object o,String sgcode,String supid, String applyStatus,
			String startDate, String endDate, String applyname,
			String gdbarcode, String gdname,String custType,String gysbm,String supname,String printstatus);
	}
