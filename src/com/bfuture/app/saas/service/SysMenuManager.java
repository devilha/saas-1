package com.bfuture.app.saas.service;

import java.util.List;

import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.SysMenu;

public interface SysMenuManager extends BaseManager{
	List<SysMenu> getMenusByUsercode( String sucode ) throws Exception;
}
