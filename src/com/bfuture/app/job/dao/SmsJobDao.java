package com.bfuture.app.job.dao;

import java.util.List;

public interface SmsJobDao {
	public void insupsql(final String sql);
	public List executeSql(final String sql);
	public void execessql(final String [] exesql);
}
