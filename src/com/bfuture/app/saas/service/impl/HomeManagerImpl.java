package com.bfuture.app.saas.service.impl;


import java.sql.SQLException;
import java.util.List;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.service.HomeManager;
import com.ibm.db2.jcc.a.SqlException;

public class HomeManagerImpl extends BaseManagerImpl implements HomeManager{

	public ReturnObject getMenuList(String sgcode){
	
		ReturnObject result = new ReturnObject();
		String sql = "select meuname,meuhref from sys_menu where meucode in (select meucode from sys_rlmeu where sgcode= '"+sgcode+"' and meucode like '200005005_%')";
		List list=dao.executeSql(sql);
		result.setRows(list);
		return result;
		
	}

}
