package com.bfuture.app.saas.service;

import com.bfuture.app.basic.service.BaseManager;

public interface MsgNoticeManager extends BaseManager{
	static String NOTICE_STATE_DRAFT = "draft";		//草稿
	static String NOTICE_STATE_OFFICIAL = "official";	//正式
	static String NOTICE_STATE_READED = "readed";	//
}
