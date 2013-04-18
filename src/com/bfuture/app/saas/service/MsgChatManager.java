package com.bfuture.app.saas.service;

import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.MsgChat;
/**
 * 采购洽淡(MSG_CHAT)
 * @author chenjw
 * 2012-02-02
 */
public interface MsgChatManager extends BaseManager {
	public void InsertMsgChat(MsgChat msgChat);
	
}
