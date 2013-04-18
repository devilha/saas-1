package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.MsgMessage;
import com.bfuture.app.saas.service.MsgMessageManager;
import com.bfuture.app.saas.util.StringUtil;
import com.bfuture.app.saas.util.Tools;

public class MyMsgMessageManagerImpl extends BaseManagerImpl implements	MsgMessageManager {

	//动态显示消息有就显示没有就不显示
	public ReturnObject getMyMsgList(String mmReByC) {
	ReturnObject result = new ReturnObject();
		
		//String sql ="select mm_title,mm_content from msg_message where mm_re_by_c in (select sucode from sys_scmuser where suname like '+suname+%') and MM_STATUS ='official'";
		String sql ="select id, mm_title from msg_message where mm_re_by_c in (select sucode from sys_scmuser where suname like '"+mmReByC+"')";
		List list=dao.executeSql(sql);
		
		result.setRows(list);
		
		System.out.println(list);
		
		return result;	
	}
}
