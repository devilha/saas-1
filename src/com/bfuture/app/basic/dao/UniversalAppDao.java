package com.bfuture.app.basic.dao;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.springframework.orm.hibernate3.HibernateCallback;


/**
 * Data Access Object (DAO) interface. 
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 * 
 * Modifications and comments by <a href="mailto:bwnoll@gmail.com">Bryan Noll</a>
 * This thing used to be named simply 'GenericDao' in versions of appfuse prior to 2.0.
 * It was renamed in an attempt to distinguish and describe it as something 
 * different than GenericDao.  GenericDao is intended for subclassing, and was
 * named Generic because 1) it has very general functionality and 2) is 
 * 'generic' in the Java 5 sense of the word... aka... it uses Generics.
 * 
 * Implementations of this class are not intended for subclassing. You most
 * likely would want to subclass GenericDao.  The only real difference is that 
 * instances of java.lang.Class are passed into the methods in this class, and 
 * they are part of the constructor in the GenericDao, hence you'll have to do 
 * some casting if you use this one.
 * 
 * @see com.bfuture.app.basic.dao.GenericDao
 */
public interface UniversalAppDao {

    /**
     * Generic method used to get all objects of a particular type. This
     * is the same as lookup up all rows in a table.
     * @param clazz the type of objects (a.k.a. while table) to get data from
     * @return List of populated objects
     */
    List getAll(Class clazz);

    /**
     * Generic method to get an object based on class and identifier. An 
     * ObjectRetrievalFailureException Runtime Exception is thrown if 
     * nothing is found.
     * 
     * @param clazz model class to lookup
     * @param id the identifier (primary key) of the class
     * @return a populated object
     * @see org.springframework.orm.ObjectRetrievalFailureException
     */
    Object get(Class clazz, Serializable id);

    /**
     * Generic method to save an object - handles both update and insert.
     * @param o the object to save
     * @return a populated object
     */
    Object save(Object o);
    Object saveEntity(Object o);  // 这个方法是后加的，用于表的主键不是自增的情况
    void updateEntity(Object o);  // 这个方法是后加的，用于更改的操作
    void saveBySQL(String sql);
    List<Object> getObject(String sql,Object o);
    /**
     * Generic method to save an object - handles both update and insert.
     * @param o the object to save
     * @return a populated object
     */
    Object InsertAndExec(Object o);
    /**
     * Generic method to delete an object based on class and id
     * @param clazz model class to lookup
     * @param id the identifier (primary key) of the class
     */
    void remove(Class clazz, Serializable id);
    /**
     * Generic method to delete an object based on class and id
     * @param clazz model class to lookup
     * @param id the identifier (primary key) of the class
     */
    void remove(Object o);
    
    List getByObject(Object o) ;

    void ExecAndDelete(Class clazz, Serializable id);
    
    /**
     * 获取指定类的最大ID值
     * @param clazz		类名
     * @param id		ID字段名
     * @param bid		数据库连接编码
     * @return			最大ID值
     */
//    public Integer getMaxId( Class clazz, String id, String bid );
//    
   
    
    /**
     * 保存商业对象
     * @param o		商业对象数组
     * @param session	数据库连接
     * @return		保存后的商业对象数组
     * @throws Exception	保存异常操作
     */
    public Object[] save( Object[] o, Session session ) throws Exception;
    
    /**
     * 保存商业对象并执行存储过程
     * @param o		商业对象数组
     * @param session	数据库连接
     * @param bid		数据库连接编码
     * @return			被保存的商业对象数组
     * @throws Exception	保存操作异常
     */
    public Object[] saveAndExec( Object[] o, Session session, String bid ) throws Exception;
    
    /**
     * 删除商业对象
     * @param o		商业对象数组
     * @param session	数据库连接
     * @throws Exception	删除操作异常
     */
    public void remove( Object[] o, Session session ) throws Exception;
    
    /**
     * 执行存储过程删除商业对象
     * @param o		商业对象数组
     * @param session	数据库连接\
     * @param bid		数据库连接编码
     * @throws Exception	删除操作异常
     */
    public void execAndDelete( Object[] o, Session session, String bid ) throws Exception;
    
    /**
     * 批量保存商业对象（其中包括增删改功能）实例
	 * @param o		商业对象实例数组
	 * @param session	商业对象数据库连接池
	 * @param bid	数据库连接编码
	 * @return	被操作的商业对象实例
	 * @throws Exception	数据操作异常
     */
    public Object[] merge( Object[] o, Session session, String bid ) throws Exception;
    public void flush();
    
    public List executeSql(String sql);
    
    public List<Object> executeSql(String sql,Class<Object> cls );
    
    public void updateSql(String sql);
    
	// 前台调用
	public List executeSqlCount(String sql);
	
	// 前台调用
	public List executeSqlToMap(final String sql);
    
	// 前台调用 
	public List executeSqlToMap(final String sql, final int firstRow, final int maxRow);
	
    public List executeSql(final String sql, final int firstRow, final int maxRow);
    
    public List executeSql(final String sql, final int firstRow, final int maxRow, Class cls);

	public List executeHql(String hql) throws SQLException;	

	public List executeHql(final String hql, final int firstRow,
			final int maxRow) throws SQLException;
	
	public String getBillCode(final String type) throws SQLException;
}