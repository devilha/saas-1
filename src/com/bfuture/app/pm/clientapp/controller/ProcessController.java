package com.bfuture.app.pm.clientapp.controller;

import com.bfuture.app.basic.clientapp.controller.BaseClientController;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.pm.service.PmProcessManager;


public class ProcessController extends BaseClientController {
	protected static final short PROCESS_MANAGER_NEW = 1;
	protected static final short PROCESS_MANAGER_EDIT = 2;
	protected static final short PROCESS_MANAGER_DELETE = 3;
	protected static final short PROCESS_OPERATION_START = 4;
	protected static final short PROCESS_WORKITEM_PASS = 5;
	protected static final short PROCESS_WORKITEM_BACKTOUP = 6;
	protected static final short PROCESS_OPERATION_STOP = 7;
	protected static final short PROCESS_OPERATION_SUSPEND = 8;
	protected static final short PROCESS_DISPATCHER_START = 9;
	
	private PmProcessManager processManager;	
	
	public void setProcessManager(PmProcessManager processManager) {
		this.processManager = processManager;
	}



	

	/**
	 * 方法描述：根据BaseObject的actionFlag属性，返回不同的short类型。
	 * 
	 * @param: <|>
	 * @return:
	 * @return int
	 */

	protected short getActionFlag(BaseObject bean) {
		short i = 0;
		if (bean.getACTION_TYPE() != null) {
			if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_MANAGER_NEW))
				i = PROCESS_MANAGER_NEW;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_MANAGER_EDIT))
				i = PROCESS_MANAGER_EDIT;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_MANAGER_DELETE))
				i = PROCESS_MANAGER_DELETE;
			
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_OPERATION_START))
				i = PROCESS_OPERATION_START;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_WORKITEM_PASS))
				i = PROCESS_WORKITEM_PASS;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_WORKITEM_BACKTOUP))
				i = PROCESS_WORKITEM_BACKTOUP;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_OPERATION_SUSPEND))
				i = PROCESS_OPERATION_SUSPEND;
			else if (bean.getACTION_TYPE().equalsIgnoreCase(PmProcessManager.PROCESS_OPERATION_STOP))
				i = PROCESS_OPERATION_STOP;			


		}
		return i;
	}


}
