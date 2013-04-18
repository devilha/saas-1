package com.bfuture.app.basic.dao.hibernate;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.net.URL;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Table;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.mapping.PersistentClass;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.BaseInterface;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.util.xml.ConversionUtils;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.SysCodeseq;

/**
 * This class serves as the a class that can CRUD any object witout any
 * Spring configuration. The only downside is it does require casting
 * from Object to the object class.
 *
 * @author Bryan Noll
 */
public class UniversalAppDaoHibernate extends HibernateDaoSupport implements UniversalAppDao {
    /**
     * Log variable for all child classes. Uses LogFactory.getLog(getClass()) from Commons Logging
     */
    protected final Log log = LogFactory.getLog(getClass());

    /**
     * {@inheritDoc}
     */
    public Object save(Object o) {
        return getHibernateTemplate().merge(o);
    }
    
    public Object saveEntity(Object o) {
        return getHibernateTemplate().save(o);  // 这里方法是后添加的，用于主键不是自增的情况
    }
    
    public void updateEntity(Object o) {
        getHibernateTemplate().update(o);  // 这里方法是后添加的，用于更改操作
    }
    
    public void saveBySQL(String sql){
    	try {
    		getSession().createSQLQuery(sql).executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
		}	 
    }
    
    public void deleteBySQL(String sql){
    	try {
    		getSession().beginTransaction().begin();
    		getSession().delete(sql);
    		getSession().beginTransaction().commit();
		}catch (Exception e) {
			getSession().beginTransaction().rollback();
			e.printStackTrace();
		}finally{
			getSession().close();
		}		 
    }

    /**
     * {@inheritDoc}
     */
    public Object get(Class clazz, Serializable id) {
        Object o = getHibernateTemplate().get(clazz, id);

        if (o == null) {
           // throw new ObjectRetrievalFailureException(clazz, id);
        }

        return o;
    }

    /**
     * {@inheritDoc}
     */
    public List getAll(Class clazz) {
        return getHibernateTemplate().loadAll(clazz);
    }
    /**
     * {@inheritDoc}
     */
    public List getByObject(Object o) {
        return getHibernateTemplate().findByExample(o);
    }

    /**
     * {@inheritDoc}
     */
    public void remove(Class clazz, Serializable id) {
        getHibernateTemplate().delete(get(clazz, id));
    }
    /**
     * {@inheritDoc}
     */
    public void remove(Object o) {
        getHibernateTemplate().delete(o);
    }
   public void flush(){
    	getSession().flush();
    }
	public Object InsertAndExec(final Object o) {

		HibernateCallback callback = new HibernateCallback()
		{
			public Object doInHibernate( Session session ) throws SQLException
			{

				String procedures="";
				 Table table = AnnotationUtils.findAnnotation(o.getClass(), Table.class);
				 procedures="SP_"+table.name()+"_AFTER_INSERT";
				 
				 
				Object ro=session.merge(o);
				session.flush();

				Object id=null;
				try {
					Method getMethod = ro.getClass().getMethod("getId",
							null);
					 id=getMethod.invoke(ro, null);

				} catch (Exception e) {
					throw new SQLException("取不到ID");
					
				}				 

				Map<String, Object> map = new HashMap();
				String sp = "{CALL "+procedures.toUpperCase()+"(?)}";
				CallableStatement callableStatement = session.connection()
						.prepareCall( sp );
				callableStatement.setLong( 1, (Long)id );

				try {
					callableStatement.execute();
				} catch (SQLException e) {
                        throw e;
				}
				finally
				{
					callableStatement.close();
				}



				return ro;
			}
		};
		return getHibernateTemplate().execute( callback );
	
       
	}

	public void ExecAndDelete(final Class clazz, final Serializable id) {


		HibernateCallback callback = new HibernateCallback()
		{
			public Object doInHibernate( Session session ) throws SQLException
			{
			

				String procedures="";
				 Table table = AnnotationUtils.findAnnotation(clazz, Table.class);
				 procedures="SP_"+table.name()+"_BEFORE_DELETE";
				 
				 
			

				 

				Map<String, Object> map = new HashMap();
				String sp = "{CALL "+procedures.toUpperCase()+"(?)}";
				CallableStatement callableStatement = session.connection()
						.prepareCall( sp );
				callableStatement.setLong( 1, (Long)id );

				try {
					callableStatement.execute();
				} catch (SQLException e) {
                        throw e;
				}
				finally
				{
					callableStatement.close();
				}
				
				session.delete(get(clazz, id));
				return null;



			}
			 
		};
		
	
		getHibernateTemplate().execute( callback );
	
		
	}
	
	/**
	 * 获取指定类的最大ID值
	 */
//	public Integer getMaxId( Class clazz, String id, String bid )
//	{
//		Integer maxid = new Integer( 0 );
//		SessionFactory sessionFactory = ( SessionFactory )AppSpringContext.getInstance().getAppContext().getBean( "sessionFactory_" + bid  );
//		Session session = sessionFactory.openSession();
//		
//		try {
//			maxid = ( Integer )session.createCriteria( clazz ).setProjection( Projections.projectionList().add( Projections.max( id ) ) ).uniqueResult();
//			if( maxid == null )
//			{
//				maxid = new Integer( 0 );
//			}
//		} catch (HibernateException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		finally
//		{
//			session.close();
//		}
//		return maxid;
//	}
	
	
	
	
	
	
	/**
	 * 获取顺序号
	 * @param order	顺序号
	 * @return
	 */
	private String getOrderString( int order )
    {
    	StringBuffer stringBuffer = new StringBuffer();
		
		String strOrder = order + "";
		int length = strOrder.length();
		
		for( int i = 4 - length; i > 0; i--  )
		{
			stringBuffer.append( "0" );
		}
		stringBuffer.append( strOrder );
		
		return stringBuffer.toString();
    }
	
	
	
	/**
	 * 保存商业对象
	 */
	public Object[] save( Object[] o, Session session ) throws Exception
	{
		Object[] s = new Object[ o.length ];
		
		for( int i = 0; i < o.length; i++ )
		{
			Object obj = o[i];
			BaseObject baseObject = ( BaseObject )obj;
			if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.INSERT ) )
			{
				session.save( obj );
				s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.UPDATE ) )
			{
				 session.update( obj );
				 s[ i ] = obj;
			}
		}		
		return s;
	}
	
	/**
	 * 保存商业对象并执行存储过程
	 */
	public Object[] saveAndExec( Object[] o, Session session, String bid ) throws Exception
	{
		String filepath = "/hibernate_" + bid + ".cfg.xml";
		Object[] s = new Object[ o.length ];
		
		for( int i = 0; i < o.length; i++ )
		{
			Object obj = o[i];
			BaseInterface baseInterface = ( BaseInterface )obj;
			BaseObject baseObject = ( BaseObject )obj;
			
			//1，保存商业对象
			if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().indexOf( Constants.INSERT ) != -1 )
			{
				session.merge( obj );
				s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().indexOf( Constants.UPDATE ) != -1  )
			{
				session.update( obj );
				s[ i ] = obj;
			}
			
			//2，执行存储过程
			Connection connection = session.connection();
			URL url = Thread.currentThread().getContextClassLoader().getResource( filepath );
			Class clazz = obj.getClass();
			Configuration configuration = new Configuration().configure( url );
			PersistentClass model = configuration.getClassMapping( clazz.getName() );
			org.hibernate.mapping.Table table = model.getTable();
			String procedures = "";
			String sp = "";
			if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().indexOf( Constants.INSERT ) != -1 )
			{
				procedures = "SP_" + table.getName() + "_AFTER_INSERT";
				sp = "{CALL " + procedures.toUpperCase() + "()}";
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().indexOf( Constants.UPDATE ) != -1  )
			{
				procedures = "SP_" + table.getName() + "_AFTER_UPDATE";
				sp = "{CALL " + procedures.toUpperCase() + "(?)}";
			}
			CallableStatement callableStatement = connection.prepareCall( sp );
			if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().indexOf( Constants.UPDATE ) != -1  )
			{
				Object id = baseInterface.getObjectId();
				callableStatement.setObject( 1, id );
			}
			callableStatement.executeUpdate();
		}
		
		return s;
	}
	
	/**
	 * 删除商业对象
	 */
	public void remove( Object[] o, Session session ) throws Exception
	{
		for( int i = 0; i < o.length; i++ )
		{
			Object obj = o[i];
			session.delete( obj );
		}
	}
	
	/**
	 * 执行存储过程删除商业对象
	 */
	public void execAndDelete( Object[] o, Session session, String bid ) throws Exception
	{
		String filepath = "/hibernate_" + bid + ".cfg.xml";
		for( int i = 0; i < o.length; i++ )
		{
			Object obj = o[i];
			BaseInterface baseInterface = ( BaseInterface )obj;
			
			//1，执行存储过程
			URL url = Thread.currentThread().getContextClassLoader().getResource( filepath );
			Class clazz = obj.getClass();
			Configuration configuration = new Configuration().configure( url );
			PersistentClass model = configuration.getClassMapping( clazz.getName() );
			org.hibernate.mapping.Table table = model.getTable();
			String procedures = "SP_" + table.getName() + "_BEFORE_DELETE";
			Connection connection = session.connection();
			String sp = "{CALL " + procedures.toUpperCase() + "(?)}";
			CallableStatement callableStatement = connection.prepareCall( sp );
			Object id = baseInterface.getObjectId();
			callableStatement.setObject( 1, id );
			callableStatement.executeUpdate();
			
			//2，执行删除操作
			session.delete( obj );
		}
	}
	
	/**
	 * 批量保存商业对象（其中包括增删改功能）实例
	 */
	public Object[] merge( Object[] o, Session session, String bid ) throws Exception
	{
		String filepath = "/hibernate_" + bid + ".cfg.xml";
		Object[] s = new Object[ o.length ];
		
		for( int i = 0; i < o.length; i++ )
		{
			Object obj = o[i];
			BaseObject baseObject = ( BaseObject )obj;
			if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.INSERT ) )
			{
				session.save( obj );
				s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.UPDATE ) )
			{
				 session.update( obj );
				 s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.UPDATE_PART ) )
			{
				BaseInterface baseInterface = ( BaseInterface )obj;
				Object id = baseInterface.getObjectId();
				Serializable sid=(Serializable)id;
				Class cls=obj.getClass();
				Object uo=null;
				try {
					uo = session.get(cls, sid);
				} catch (RuntimeException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					throw e1;
				}
				 try {
						ConversionUtils.convertAttribute(uo, obj, ConversionUtils.GOAL);
						
					} catch (Exception e) {
						e.printStackTrace();
						throw e;
					}
				session.update( uo );
				 s[ i ] = uo;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.DELETE ) )
			{
				session.delete( obj );
				s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.EXECANDDELETE ) )
			{
				BaseInterface baseInterface = ( BaseInterface )obj;
				Object id = baseInterface.getObjectId();
				
				//1，执行存储过程
				URL url = Thread.currentThread().getContextClassLoader().getResource( filepath );
				Class clazz = obj.getClass();
				Configuration configuration = new Configuration().configure( url );
				PersistentClass model = configuration.getClassMapping( clazz.getName() );
				org.hibernate.mapping.Table table = model.getTable();
				String procedures = "SP_" + table.getName() + "_BEFORE_DELETE";
				Connection connection = session.connection();
				String sp = "{CALL " + procedures.toUpperCase() + "(?)}";
				CallableStatement callableStatement = connection.prepareCall( sp );
				callableStatement.setObject( 1, id );
				callableStatement.executeUpdate();
				
				//2，执行删除操作
				session.delete( obj );
				s[ i ] = obj;
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.INSERTANDEXEC ) )
			{
				//1，保存商业对象
				session.save( obj );
				s[ i ] = obj;
				
				//2，执行存储过程
				URL url = Thread.currentThread().getContextClassLoader().getResource( filepath );
				Class clazz = obj.getClass();
				Configuration configuration = new Configuration().configure( url );
				PersistentClass model = configuration.getClassMapping( clazz.getName() );
				org.hibernate.mapping.Table table = model.getTable();
				String procedures = "SP_" + table.getName() + "_AFTER_INSERT";
				Connection connection = session.connection();
				String sp = "{CALL " + procedures.toUpperCase() + "()}";
				CallableStatement callableStatement = connection.prepareCall( sp );
				callableStatement.executeUpdate();
			}
			else if( baseObject.getACTION_TYPE() != null && baseObject.getACTION_TYPE().trim().equals( Constants.UPDATEANDEXEC ) )
			{
				BaseInterface baseInterface = ( BaseInterface )obj;
				Object id = baseInterface.getObjectId();
				
				//1，保存商业对象
				session.update( obj );
				s[ i ] = obj;
				
				//2，执行存储过程
				URL url = Thread.currentThread().getContextClassLoader().getResource( filepath );
				Class clazz = obj.getClass();
				Configuration configuration = new Configuration().configure( url );
				PersistentClass model = configuration.getClassMapping( clazz.getName() );
				org.hibernate.mapping.Table table = model.getTable();
				String procedures = "SP_" + table.getName() + "_AFTER_UPDATE";
				Connection connection = session.connection();
				String sp = "{CALL " + procedures.toUpperCase() + "(?)}";
				CallableStatement callableStatement = connection.prepareCall( sp );
				callableStatement.setObject( 1, id );
				callableStatement.executeUpdate();
			}
		}		
		return s;
	}

	public List executeSql(String sql) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);
		List lstResults = sqlQuery.setResultTransformer(
				CriteriaSpecification.ALIAS_TO_ENTITY_MAP).list();
		releaseSession( session );
		return lstResults;
	}
	
	//得到POJO对象的集合
	public List<Object> getObject(String sql,Object o){
		List<Object> list = null;
		try {
			Query query = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
			list = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List executeSql(String sql, Class<Object> cls) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);
		List lstResults = sqlQuery.addEntity( cls ).list();
		releaseSession( session );
		return lstResults; 
	}

	// 前台调用
	public List executeSqlCount(String sql) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);
		List lstResults = sqlQuery.list();
		releaseSession( session );
		return lstResults;
	}
	
	// 前台调用 
	public List executeSqlToMap(final String sql, final int firstRow, final int maxRow) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);	
		if (firstRow > 0) {
			sqlQuery.setFirstResult(firstRow);
		}
		if (maxRow > 0) {
			sqlQuery.setMaxResults(maxRow);
		}		
		List lstResults = sqlQuery.setResultTransformer(
				CriteriaSpecification.ALIAS_TO_ENTITY_MAP).list();
		releaseSession( session );
		return lstResults;		
	}
	
	public List executeSql(final String sql, final int firstRow, final int maxRow) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);	
		if (firstRow > 0) {
			sqlQuery.setFirstResult(firstRow);
		}
		if (maxRow > 0) {
			sqlQuery.setMaxResults(maxRow);
		}
		List lstResults = sqlQuery.setResultTransformer(
				CriteriaSpecification.ALIAS_TO_ENTITY_MAP).list();
		releaseSession( session );
		return lstResults;		
	}
	
	public List executeSql(final String sql, final int firstRow, final int maxRow, Class cls) {
		Session session = getSession();
		SQLQuery sqlQuery = session.createSQLQuery(sql);	
		if (firstRow > 0) {
			sqlQuery.setFirstResult(firstRow);
		}
		if (maxRow > 0) {
			sqlQuery.setMaxResults(maxRow);
		}		
		List lstResults = sqlQuery.addEntity( cls ).list();
		releaseSession( session );
		return lstResults;		
	}
	
	public void updateSql(final String sql) {
		this.getHibernateTemplate().execute(  
                new HibernateCallback(){  
                    public Object doInHibernate(Session session)  
                    throws HibernateException, SQLException {  
	                    Connection con = session.connection();  
	                    PreparedStatement ps = con.prepareStatement(sql);  
	                    try{
	                    	ps.executeUpdate();
	                    	session.flush();
	                    }
	                    finally{
	                    	ps.close();
	                    	con.close();
	                    }
	                    return null;
                      
                    }  
                }  
        );  
		
	}

	public List executeHql(String hql) throws SQLException {
		return getHibernateTemplate().find(hql);
	}

	public List executeHql(final String hql, final int firstRow,
			final int maxRow) throws SQLException {
		HibernateCallback callback = new HibernateCallback() {
			public Object doInHibernate(Session session) throws SQLException {
				Query query = session.createQuery(hql);
				if (firstRow > 0) {
					query.setFirstResult(firstRow);
				}
				if (maxRow > 0) {
					query.setMaxResults(maxRow);
				}
				return query.list();
			}
		};
		return (List) getHibernateTemplate().execute(callback);
	}

	public List executeSqlToMap(String sql) {
		// TODO Auto-generated method stub
		return null;
	}

	public String getBillCode(String type) throws SQLException {	
		String billCode = null;
		
		if( !StringUtil.isBlank(type) ){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			SysCodeseq sc = null;
			Date now = new Date();
			String nowStr = sdf.format( now );
			
			StringBuffer sb = new StringBuffer( "from SysCodeseq sc where sc.type = '" ).append(type).append("'");
			List lstCs = executeHql( sb.toString() );			
			if( lstCs != null && lstCs.size() > 0 ){
				sc = (SysCodeseq)lstCs.get( 0 );
				String lastUpdateTime = sdf.format( sc.getLastUpdateTime() );				
				
				if( "sucode".equals( type ) ){
					sc.setSeq( sc.getSeq() + 1 );
				}
				else if( nowStr.equals( lastUpdateTime ) ){
					sc.setSeq( sc.getSeq() + 1 );
				}
				else{
					sc.setSeq( 1 );
					sc.setLastUpdateTime( now );
				}
			}
			else{
				sc = new SysCodeseq();
				sc.setType( type );
				sc.setSeq( 1 );
				sc.setLastUpdateTime( now );
			}
			
			if( "sucode".equals( type ) ){
				java.text.DecimalFormat df = new java.text.DecimalFormat("000000");
								
				billCode = Constants.SGCODE + df.format( sc.getSeq() );
			}
			else{
				java.text.DecimalFormat df = new java.text.DecimalFormat("0000");
				billCode = nowStr + type + df.format( sc.getSeq() );
			}
			
			save( sc );
		}
		
		return billCode;
	}	
	
}
