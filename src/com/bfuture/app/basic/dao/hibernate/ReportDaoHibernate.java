package com.bfuture.app.basic.dao.hibernate;

import java.sql.SQLException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.bfuture.app.basic.dao.ReportDao;

public class ReportDaoHibernate extends HibernateDaoSupport implements
		ReportDao {
	protected final Log log = LogFactory.getLog(getClass());
	
	
	public List exctueSql(String sql){
		SQLQuery sqlQuery = getSession().createSQLQuery(sql);
		return sqlQuery.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP).list();
}
	public List executeHql(String hql)throws SQLException{
		return getHibernateTemplate().find(hql);
	}
	
	public List executeHql( final String hql, final int firstRow, final int maxRow)throws SQLException{
		
		HibernateCallback callback = new HibernateCallback()
		{
			public Object doInHibernate( Session session ) throws SQLException
			{
				Query query  =  session.createQuery( hql );
				if( firstRow > 0 ){
					query.setFirstResult( firstRow );
				}
				if( maxRow > 0 ){
					query.setMaxResults( maxRow );
				}
				return query.list();
			}
		};
		return (List) getHibernateTemplate().execute( callback );
	}
}
