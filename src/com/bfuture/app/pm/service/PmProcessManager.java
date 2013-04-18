package com.bfuture.app.pm.service;

import java.util.List;

import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.pm.exception.ProcessException;
import com.bfuture.app.pm.model.PmActIns;
import com.bfuture.app.pm.model.PmProIns;
import com.bfuture.app.pm.model.PmTemplate;
import com.bfuture.pm.userInterface.UserInterface;

/**
 * 
 * b-future�������ӿ�
 * 
 * @version 0.1.0
 * @author ��Ԫ
 *
 */
public interface PmProcessManager extends BaseManager{	
	
	final static String START_NODE  = "START_NODE";

	final static String END_NODE  = "END_NODE";
	
	final static String NODE_TYPE_HUMAN  = "HUMAN";
	
	final static String NODE_TYPE_RULE = "RULE";

	final static String NODE_TYPE_LOGIC  = "LOGIC";

	final static String PROCESS_MANAGER_NEW = "NEW";

	final static String PROCESS_MANAGER_EDIT = "EDIT";

	final static String PROCESS_MANAGER_DELETE = "DELETE";

	final static String PROCESS_OPERATION_START = "START";	

	final static String PROCESS_OPERATION_SUSPEND = "SUSPEND";

	final static String PROCESS_OPERATION_STOP = "STOP";
	
	final static String PROCESS_WORKITEM_PASS = "PASS";

	final static String PROCESS_WORKITEM_BACKTOUP = "BACK";	

	final static String PROCESS_WORKITEM_TRANSFER = "TRANSFER";

	final static String PROCESS_WORKITEM_TIMEOUT = "TIMEOUT";

	final static String PROCESS_STATE_NORUN = "NORUN";

	final static String PROCESS_STATE_FINISHED = "FINISHED";

	final static String PROCESS_STATE_READY = "READY";

	final static String PROCESS_STATE_RUNNING = "RUNNING";

	final static String PROCESS_STATE_SUSPENDED = "SUSPENDED";

	final static String PROCESS_STATE_CANCELED = "CANCELED";

	final static String PROCESS_STATE_BACKED = "BACKED";

	final static String PROCESS_STATE_TIMEOUT = "TIMEOUTED";
	
	final static String PROCESS_OWNERTYPE_PERSON = "PERSON";

	final static String PROCESS_OWNERTYPE_ROLE = "ROLE";
	
	public String createProcess( PmTemplate pt ) throws ProcessException;

	public String updateProcess( PmTemplate pt ) throws ProcessException;

	public String deleteProcess( String ptC ) throws ProcessException;
		
	public String  startProcess( String ptC, String billC, UserInterface user ) throws ProcessException;
		
	public void stopProcess( String paiId, UserInterface user ) throws ProcessException;
	
	public void stopProcessByBill( String billC , UserInterface user ) throws ProcessException;
	
	public String backWorkItemByBill( String billC, UserInterface user )throws ProcessException;
	
	public String passWorkItem( String paiId, UserInterface user ) throws ProcessException;
	
	public String passWorkItemByBill( String billC , UserInterface user ) throws ProcessException;

	public String backWorkItem( String paiId, UserInterface user ) throws ProcessException;
	
	public String suspendWorkItem( String paiId, UserInterface user ) throws ProcessException;
	
	public List<PmTemplate> getTemplates( PmTemplate pt, UserInterface user ) throws ProcessException;
	
	public PmTemplate getTemplateByCode( String ptC, UserInterface user ) throws ProcessException;			
	
	public List<PmActIns> getWorkItems( PmActIns pai, UserInterface user ) throws ProcessException;
	
	
}
