package com.bfuture.app.saas.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.model.newProductApplyBean;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;

public interface SysScmuserManager extends BaseManager{
	SysScmuser getSysScmuserBySucode( String usercode ) throws SQLException;
	String encoder(String passWord);
	List getRolesBySucode( String usercode );
	List getSupplierJyfs (String sgcode,String supid);
}
