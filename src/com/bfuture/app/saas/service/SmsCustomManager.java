package com.bfuture.app.saas.service;

import java.util.List;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.saas.model.SmsSend;
/**
 * 短信定制(SMS_CUSTOM)
 * @author chenjw
 * 2012-02-16
 */
public interface SmsCustomManager extends BaseManager {
	public ReturnObject AddSmsSend(Object[] o);
	
	public List<SmsSend> getXSRYB();
	public List<SmsSend> getXSPH();
	public List<SmsSend> getXHZB();
	public List<SmsSend> getCGDD();
	public List<SmsSend> getZRKC();
	
	public void sendXSRYB();
	public void sendXSPH();
	public void sendXHZB();
	public void sendCGDD();
	public void sendZRKC();
}
