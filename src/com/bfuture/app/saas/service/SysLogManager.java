package com.bfuture.app.saas.service;

import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.SysLogevent;
import com.bfuture.app.saas.model.SysScmuser;

public interface SysLogManager extends BaseManager{
	void log( SysScmuser smUser, BaseObject bo )  throws Exception;
	SysLogevent getLastLog( SysScmuser smUser, String optType ) throws Exception;
}
