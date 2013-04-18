package com.bfuture.app.saas.service;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;


public interface HomeManager extends BaseManager{
	public ReturnObject getMenuList(String sgcode);
}
