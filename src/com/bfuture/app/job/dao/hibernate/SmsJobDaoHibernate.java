package com.bfuture.app.job.dao.hibernate;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.bfuture.app.job.dao.SmsJobDao;

public class SmsJobDaoHibernate extends HibernateDaoSupport implements
		SmsJobDao {
	
	public void insupsql(final String sql) {
		//System.err.println("SmsJobDaoHibernate.java insupsql():"+sql);
		this.getHibernateTemplate().execute(  
                new HibernateCallback(){  
                    public Object doInHibernate(Session session)  
                    throws HibernateException, SQLException { 
                    	Connection con = session.connection();
                    	con.setAutoCommit(false);
                    	PreparedStatement ps = con.prepareStatement(sql);  
	                    try{
	                    	ps.executeUpdate();
	                    	con.commit();
	                    	session.flush();
	                    }catch(Exception ex){
	                    	con.rollback();
	                    	System.out.println(ex.getMessage());
	                    }
	                    finally{
	                    	ps.close();
	                    	con.close();
	                    	releaseSession(session);
	                    }
	                    return null;
                    }  
                }  
        );		
	}
	
	public void execessql(final String [] exesql) {
		// TODO Auto-generated method stub
		this.getHibernateTemplate().execute(  
                new HibernateCallback(){  
                    public Object doInHibernate(Session session)  
                    throws HibernateException, SQLException {  
                    	Connection con = session.connection();
	                    con.setAutoCommit(false);
	                    Statement stm = con.createStatement();
	                    try{
		                    for(int i=0;i<exesql.length;i++){
		                    	//System.err.println("SmsJobDaoHibernate.java execessql() exesql["+i+"]:"+exesql[i]);
		                    	stm.executeUpdate(exesql[i]);
		                    }
	                    	   con.commit();
	                    	   session.flush();
	                    }catch(Exception ex){
	                    	con.rollback();
	                    	ex.printStackTrace();
	                    }
	                    finally{
	                    	stm.close();
	                    	con.close();
	                    }
	                    return null;
                    }  
                }  
        );
	}

	public List executeSql(final String sql) {
		//System.err.println("SmsJobDaoHibernate.java executeSql():"+sql);
		Session session = getSession();
		List lstResults = new ArrayList();
		Connection con = null;
		PreparedStatement ptmt = null;
		ResultSet rs = null;
		try{
			con = session.connection();
			ptmt = con.prepareStatement(sql);
			rs = ptmt.executeQuery();
			ResultSetMetaData rsmt = rs.getMetaData();
			int cc = rsmt.getColumnCount();
			while (rs.next()) {
				Map map = new HashMap();
				for (int n = 1; n <= cc; n++) {
					String colName = rsmt.getColumnName(n);
					map.put(colName, rs.getObject(n));
				}
				lstResults.add(map);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(rs != null){
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
					rs = null;
				}
			}
			if(ptmt != null){
				try {
					ptmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
					ptmt = null;
				}
			}
		}
		releaseSession(session);
		return lstResults;
	}

	
}
