package com.bfuture.app.basic.clientapp.controller;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ConfigurableApplicationContext;

import com.bfuture.app.basic.AppSpringContext;
import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.BaseObject;

public class BaseClientController {
	public final Log log = LogFactory.getLog(getClass());
	protected static final short insert = 1;
	protected static final short DELETE = 2;
	protected static final short loadall = 3;
	protected static final short UPDATE = 4;
	protected static final short loadByObject = 5;
	protected static final short InsertAndExec = 6;
	protected static final short ExecAndDelete = 7;
	protected static final short UpdateAndExec = 8;
	protected static final short UpdatePartAndExec = 9;
	protected static final short LastAudit = 10;
	protected static final short PsRufuseTobegin = 11;	
	protected static final short PsRufuseToUp = 12;
	protected static final short PsAuditPass = 13;
	protected static final short PsHandle = 14;
	protected static final short PsStop = 15;
	protected static final short TESTCONN = 16;
	protected static final short COPY = 17;
	protected static final short IMPORT = 18;
	
	private ConfigurableApplicationContext appContext;

	/**
	 * 方法描述：根据BaseObject的actionFlag属性，返回不同的short类型。 创建日期：(2002-6-20 9:57:08)
	 * 
	 * @param: <|>
	 * @return:
	 * @return int
	 */
	protected short getACTION_TYPE(BaseObject bean) {
		short i = 0;
		if (bean.getACTION_TYPE() != null) {
			if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.INSERT))
				i = insert;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.DELETE))
				i = DELETE;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.UPDATE))
				i = UPDATE;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.UPDATE_PART))
				i = UPDATE;

			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.LOAD_ALL))
				i = loadall;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.LOAD_BY_OBJECT))
				i = loadByObject;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.INSERTANDEXEC))
				i = InsertAndExec;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.EXECANDDELETE))
				i = ExecAndDelete;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.UPDATEANDEXEC))
				i = UpdateAndExec;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.UPDATEPARTANDEXEC))
				i = UpdatePartAndExec;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.LASTAUDIT))
				i = LastAudit;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.PsAuditPass))
				i = PsAuditPass;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.PsHandle))
				i = PsHandle;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.PsStop))
				i = PsStop;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.PsRufuseToUp))
				i = PsRufuseToUp;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(Constants.PsRufuseTobegin))
				i = PsRufuseTobegin;
			else if( bean.getACTION_TYPE().equalsIgnoreCase( Constants.TESTCONN ) )
				i = TESTCONN;
			else if( bean.getACTION_TYPE().equalsIgnoreCase( Constants.COPY ) )
				i = COPY;
			else if( bean.getACTION_TYPE().equalsIgnoreCase( Constants.IMPORT ) )
				i = IMPORT;


		}
		return i;
	}

	/**
	 * 
	 * 通过spring获得manager
	 */
	public Object getSpringBean(String className) {
		Object o=null;
		AppSpringContext appContext = AppSpringContext.getInstance();
		try {
			o=appContext.getAppContext().getBean(className);
		} catch (Exception e) {

		}
		if (o==null)
			o=getAppContext().getBean(className);
		return o;
	}		

	public ConfigurableApplicationContext getAppContext() {
		return appContext;
	}

	public void setAppContext(ConfigurableApplicationContext appContext) {
		this.appContext = appContext;
	}
}
