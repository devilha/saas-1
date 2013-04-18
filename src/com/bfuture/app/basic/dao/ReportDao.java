package com.bfuture.app.basic.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface ReportDao {

	List exctueSql(String sql);
	public List executeHql(String hql)throws SQLException;
	public List executeHql( final String hql, final int firstRow, final int maxRow)throws SQLException;
}
