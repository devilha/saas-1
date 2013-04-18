package com.bfuture.app.job.service.impl;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.job.dao.SmsJobDao;
import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobManagerImpl extends BaseManagerImpl implements SmsJobManager {
    
	protected SmsJobDao smsJobDao;
	
	public SmsJobDao getSmsJobDao() {
		return smsJobDao;
	}

	public void setSmsJobDao(SmsJobDao smsJobDao) {
		this.smsJobDao = smsJobDao;
	}

	public void insupsql(String sql) {
		// TODO Auto-generated method stub
		smsJobDao.insupsql(sql);
	}

	public List executeSql(final String sql) {
		// TODO Auto-generated method stub
		return smsJobDao.executeSql(sql);
	}

	public void execessql(final String[] exesql) {
		// TODO Auto-generated method stub
		smsJobDao.execessql(exesql);
	}

}
