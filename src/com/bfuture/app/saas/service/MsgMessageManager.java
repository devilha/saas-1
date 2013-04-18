package com.bfuture.app.saas.service;

import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.SysLogevent;
import com.bfuture.app.saas.model.SysScmuser;

public interface MsgMessageManager extends BaseManager{
	static String MESSAGE_STATE_DRAFT = "draft";		//草稿
	static String MESSAGE_STATE_OFFICIAL = "official";	//正式
	static String MESSAGE_STATE_SENDED = "sended";		//已发送
	static String MESSAGE_STATE_READED = "readed";	//已读
	
	public ReturnObject getMyMsgList(String mmReByC);//根据登录的用户查询
}
