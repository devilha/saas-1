package com.bfuture.app.saas.service;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;


public interface YwBorderheadManager extends BaseManager {
	public ReturnObject SearchYwBorderhead(Object[] o);
	public abstract ReturnObject searchIns(String sgcode);
	static String MESSAGE_STATE_DRAFT = "draft";		//�ݸ�
	static String MESSAGE_STATE_OFFICIAL = "official";	//��ʽ
	static String MESSAGE_STATE_SENDED = "sended";		//����
	static String MESSAGE_STATE_READED = "readed";	//��
}
