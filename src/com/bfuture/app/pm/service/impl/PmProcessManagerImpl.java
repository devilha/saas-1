package com.bfuture.app.pm.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.BeanUtils;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.ReportDao;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.service.impl.UniversalAppManagerImpl;
import com.bfuture.app.basic.util.RandomGUID;
import com.bfuture.app.pm.exception.ProcessException;
import com.bfuture.app.pm.model.PmActIns;
import com.bfuture.app.pm.model.PmActInsHis;
import com.bfuture.app.pm.model.PmActive;
import com.bfuture.app.pm.model.PmLog;
import com.bfuture.app.pm.model.PmProIns;
import com.bfuture.app.pm.model.PmProInsHis;
import com.bfuture.app.pm.model.PmRule;
import com.bfuture.app.pm.model.PmTemplate;
import com.bfuture.app.pm.service.PmProcessManager;
import com.bfuture.app.pm.service.PmRuleInterface;
import com.bfuture.pm.userInterface.UserInterface;

public class PmProcessManagerImpl extends UniversalAppManagerImpl implements
		PmProcessManager {
	protected ReportDao reportDao;

	public void setReportDao(ReportDao reportDao) {
		this.reportDao = reportDao;
	}

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public PmProcessManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	//创建新流程
	public String createProcess(PmTemplate pt) throws ProcessException {
		String result = null;

		return result;
	}

	//修改更新流程
	public String updateProcess(PmTemplate pt) throws ProcessException {
		String result = null;

		return result;
	}

	//删除流程
	public String deleteProcess(String ptC) throws ProcessException {
		String result = null;

		//得到流程模板编码
		if (ptC != null) {
			//得到已经存在的流程模板后删除
			PmTemplate pt = new PmTemplate();
			pt.setPtC(ptC);
			List lstPts = getByObject(pt);
			if (lstPts != null && lstPts.size() > 0) {
				pt = (PmTemplate) lstPts.get(0);

				//得到已经存在的流程节点模板后删除
				PmActive pa = new PmActive();
				pa.setPtC(pt.getPtC());
				List lstPas = getByObject(pa);
				for (Iterator<PmActive> it = lstPas.iterator(); it.hasNext();) {
					remove(it.next());
				}

				remove(pt);

			}
		} else {
			throw new ProcessException("没有找到指定的流程模板");
		}

		return result;
	}

	//启动流程
	public String startProcess(String ptC, String billC, UserInterface user)
			throws ProcessException {
		String result = null;

		if (ptC == null) {
			throw new ProcessException("流程模板编码不能为空");
		}

		if (billC == null) {
			throw new ProcessException("单据编码不能为空");
		}

		if (user == null) {
			throw new ProcessException("当前用户为空，请检查用户是否登陆");
		}

		try {
			PmTemplate ptT = new PmTemplate();
			ptT.setPtC(ptC);
			ptT.setPtEnable("Y");
			List<PmTemplate> lstPts = getByObject(ptT);
			if (lstPts != null && lstPts.size() > 0) {
				PmTemplate pt = lstPts.get(0);

				//产生流程实例
				PmProIns pmProIns = new PmProIns();
				String id = new RandomGUID().toString();
				pmProIns.setId(id);
				pmProIns.setACTION_TYPE(Constants.INSERT);
				pmProIns.setPpiC(id);
				pmProIns.setBillC(billC);
				pmProIns.setState(PROCESS_STATE_RUNNING);
				pmProIns.setPtC(pt.getPtC());
				pmProIns.setDeptC(" ");
				pmProIns.setDiscription(pt.getDiscription());
				pmProIns.setNameCn(pt.getNameCn());
				pmProIns.setCrtByC(user.getCode());
				pmProIns.setCrtByDate(new Date());

				save(pmProIns);

				List<PmActive> lstPas = getActives(ptC);

				//产生工作项
				PmActIns pai = buildWorkItem(lstPas, pmProIns, user);

				result = id;
			} else {
				throw new ProcessException("没有找到对应的流程模板");
			}
		} catch (Exception ex) {
			throw new ProcessException("启动流程时产生异常：" + ex.getMessage());
		}

		return result;
	}

	//通过工作项
	public String passWorkItem(String paiId, UserInterface user)
			throws ProcessException {
		String result = null;

		if (paiId == null) {
			throw new ProcessException("工作项ID不能为空");
		}

		PmActIns paiEx = new PmActIns();
		paiEx.setPaiC(paiId);
		List<PmActIns> lstActIns = getByObject(paiEx);
		if (lstActIns == null || lstActIns.size() == 0) {
			throw new ProcessException("没有找到对应的流程节点实例");
		}

		PmActIns currPai = lstActIns.get(0);

		//得到流程节点列表
		List<PmActive> lstPas = getActives(currPai.getPtC());

		//判断用户权限		
		if (!checkUser(currPai, user)) {
			throw new ProcessException("当前用户没有处理此流程的权限");
		}

		if (user == null) {
			throw new ProcessException("当前用户为空，请检查用户是否登陆");
		}

		try {
			//修改当前处理过的工作项的状态
			currPai.setACTION_TYPE(Constants.DELETE);
			currPai.setState(PROCESS_STATE_FINISHED);
			currPai.setExeByC(user.getCode());
			currPai.setExeRes(PROCESS_WORKITEM_PASS);
			currPai.setEndTime(new Date());

			//记录历史工作
			saveLog(currPai, user);

			//保存完成的当前工作项
			save(currPai);

			//产生下一个工作项
			PmActive pa = getNextNode(lstPas, currPai);

			if (pa != null && !END_NODE.equals(pa.getType())) {
				PmActIns pai = new PmActIns();
				String id = new RandomGUID().toString();
				pai.setId(id);
				pai.setACTION_TYPE(Constants.INSERT);
				pai.setBillC(currPai.getBillC());
				pai.setBillType(currPai.getBillType());
				pai.setDeptC(currPai.getDeptC());
				pai.setDiscription(pa.getDiscription());
				pai.setNameCn(pa.getNameCn());
				pai.setPaC(pa.getPaC());
				pai.setPaiC(id);
				pai.setPpiC(currPai.getPpiC());
				pai.setPtC(currPai.getPtC());
				pai.setSupC(currPai.getPaC());
				pai.setBackC(pa.getBackC());
				pai.setUrl(pa.getUrl());
				pai.setCrtByC(currPai.getExeByC());
				pai.setCrtByTime(new Date());
				pai.setState(PROCESS_STATE_READY);
				pai.setOwnerC(pa.getExeByCode());
				pai.setOwnerType(pa.getExeByType());
				save(pai);

				result = id;
			} else {

				//				if( pa.getLogicC() != null && pa.getLogicC().trim().length() > 0 ){
				//					PmRule pr = getRuleByC( pa.getLogicC() );
				//					executeRule( pr, getHashMapByBean( currPai ) );
				//				}

				PmProIns ppi = new PmProIns();
				ppi.setPtC(currPai.getPtC());
				ppi.setPpiC(currPai.getPpiC());
				List<PmProIns> lstPpis = getByObject(ppi);
				if (lstPpis.size() > 0) {
					ppi = lstPpis.get(0);
					ppi.setComDate(new Date());
					ppi.setState(PROCESS_STATE_FINISHED);
					ppi.setACTION_TYPE(Constants.INSERT);

					PmActIns paiInstance = new PmActIns();
					paiInstance.setPtC(ppi.getPtC());
					paiInstance.setPpiC(ppi.getPpiC());
					List<PmActIns> lstPais = getByObject(paiInstance);
					for (Iterator<PmActIns> it = lstPais.iterator(); it
							.hasNext();) {
						paiInstance = it.next();
						PmActInsHis paih = new PmActInsHis();
						BeanUtils.copyProperties(paiInstance, paih);
						paih.setId(new RandomGUID().toString());
						save(paih);
						remove(paiInstance);
					}

					PmProInsHis ppih = new PmProInsHis();
					BeanUtils.copyProperties(ppi, ppih);
					ppih.setId(new RandomGUID().toString());
					save(ppih);
					remove(ppi);
				}
			}
		} catch (Exception ex) {
			throw new ProcessException("通过工作项时产生异常：" + ex.getMessage());
		}

		return result;
	}

	//驳回节点到上一步
	public String backWorkItem(String paiId, UserInterface user)
			throws ProcessException {

		String result = null;

		if (paiId == null) {
			throw new ProcessException("工作项ID不能为空");
		}

		PmActIns paiEx = new PmActIns();
		paiEx.setPaiC(paiId);
		List<PmActIns> lstActIns = getByObject(paiEx);
		if (lstActIns == null || lstActIns.size() == 0) {
			throw new ProcessException("没有找到对应的流程节点实例");
		}

		PmActIns currPai = lstActIns.get(0);

		//得到流程节点列表
		List<PmActive> lstPas = getActives(currPai.getPtC());

		//判断用户权限
		if (!checkUser(currPai, user)) {
			throw new ProcessException("当前用户没有处理此流程的权限");
		}

		if (user == null) {
			throw new ProcessException("当前用户为空，请检查用户是否登陆");
		}

		try {
			//修改当前处理过的工作项的状态
			currPai.setACTION_TYPE(Constants.UPDATE);
			currPai.setState(PROCESS_STATE_BACKED);
			currPai.setExeByC(user.getCode());
			currPai.setExeRes(PROCESS_WORKITEM_BACKTOUP);
			currPai.setEndTime(new Date());

			//得到当前工作项节点
			PmActive pa = getNode(lstPas, currPai.getPaC());
			if (pa == null) {
				throw new ProcessException("没有找到对应的流程节点");
			}

			paiEx.setPaiC(null);
			paiEx.setPpiC(currPai.getPpiC());
			lstActIns = getByObject(paiEx);
			if (lstActIns == null || lstActIns.size() == 0) {
				throw new ProcessException("没有找到对应的流程节点实例");
			}

			String backC = currPai.getBackC();
			if (backC == null) {
				throw new ProcessException("没有设置驳回节点");
			}

			//查找要驳回到的流程节点实例
			PmActIns backPai = null;
			String supC = currPai.getSupC();
			while (supC != null && backPai == null) {
				for (PmActIns paiT : lstActIns) {
					if (paiT.getPaC().equals(supC)) {
						if (paiT.getPaC().equals(backC)) {
							backPai = paiT;
						} else {
							supC = paiT.getSupC();
							remove(paiT);
						}

						break;
					}
				}
			}
			if (backPai == null) {
				throw new ProcessException("没有找到对应要驳回到的节点实例");
			}

			backPai.setExeByC(null);
			backPai.setEndTime(null);
			backPai.setCrtByC(user.getCode());
			backPai.setCrtByTime(new Date());
			backPai.setState(PROCESS_STATE_READY);
			save(backPai);

			//记录日志
			saveLog(currPai, user);

			//删除被驳回的工作项
			remove(currPai);

		} catch (Exception ex) {
			throw new ProcessException("驳回工作项时产生异常：" + ex.getMessage());
		}

		return result;
	}

	//得到上一个工作节点
	private PmActive getPreviewNode(List<PmActive> lstPas, PmActIns pai)
			throws Exception {
		PmActive paResult = null;

		for (Iterator<PmActive> it = lstPas.iterator(); it.hasNext();) {
			PmActive paT = it.next();
			if (paT.getSubC().equals(pai.getPaC())) {
				paResult = paT;
				break;
			}
		}

		return paResult;
	}

	//驳回节点到流程开始
	public void backToStartWorkItem(PmActIns pai) {

	}

	//驳回节点到指定节点
	public void backToNodeWorkItem(PmActIns pai) {

	}

	//终止流程
	public void stopProcess(String paiId, UserInterface user)
			throws ProcessException {

		if (paiId == null) {
			throw new ProcessException("工作项ID不能为空");
		}

		try {

			PmActIns paiInstance = new PmActIns();
			paiInstance.setPaiC(paiId);
			List<PmActIns> lstPais = getByObject(paiInstance);

			if (lstPais == null || lstPais.size() == 0) {
				if (paiId == null) {
					throw new ProcessException("没有找到对应的工作项");
				}
			}

			paiInstance = lstPais.get(0);
			paiInstance.setState(PROCESS_STATE_CANCELED);
			paiInstance.setExeRes(PROCESS_OPERATION_STOP);
			paiInstance.setExeByC(user.getCode());
			paiInstance.setEndTime(new Date());
			saveLog(paiInstance, user);
			save(paiInstance);

			PmProIns pmProIns = new PmProIns();
			pmProIns.setPpiC(paiInstance.getPpiC());
			List objs = getByObject(pmProIns);
			pmProIns = (PmProIns) objs.get(0);

			pmProIns.setState(PROCESS_STATE_CANCELED);
			PmProInsHis ppih = new PmProInsHis();

			BeanUtils.copyProperties(pmProIns, ppih);
			save(ppih);
			remove(pmProIns);

			PmActIns paiT = new PmActIns();
			paiT.setPpiC(paiInstance.getPpiC());
			objs = getByObject(paiT);
			if (objs != null && objs.size() > 0) {
				for (Iterator<PmActIns> it = objs.iterator(); it.hasNext();) {
					paiT = it.next();
					PmActInsHis paih = new PmActInsHis();
					BeanUtils.copyProperties(paiT, paih);
					paih.setId(new RandomGUID().toString());

					save(paih);
					remove(paiT);
				}
			}
		} catch (Exception ex) {
			throw new ProcessException("终止流程实例时产生异常：" + ex.getMessage());
		}
	}

	//挂起工作项
	public String suspendWorkItem(String paiId, UserInterface user)
			throws ProcessException {

		String result = null;

		return result;
	}

	public void workitemTimeout(PmActIns currPai) throws Exception {
		//		PmActIns paiEx = new PmActIns();
		//		paiEx.setPtC( currPai.getPtC() );
		//		paiEx.setPpiC( currPai.getPpiC() );
		//		paiEx.setPaiC( currPai.getPaiC() );
		//		List<PmActIns> lstActIns = getByObject( paiEx );
		//		if( lstActIns == null || lstActIns.size() == 0 )
		//			throw new Exception( "Workitem not found." );
		//		if( lstActIns.size() > 1 )
		//			throw new Exception( "Workitem than one." );
		//		paiEx = lstActIns.get( 0 );
		//		copyPmActIns( currPai, paiEx );
		//		
		//		//得到流程节点列表
		//		List<PmActive> lstPas = getActives( currPai.getPtC() );
		//		
		//		//修改当前处理过的工作项的状态
		//		currPai.setACTION_TYPE( Constants.DELETE );
		//		currPai.setState( PROCESS_STATE_TIMEOUT );
		//		currPai.setExeByC( "System" );
		//		currPai.setExeRes( PROCESS_WORKITEM_TIMEOUT );
		//		currPai.setEndTime( new Date() );
		//		
		//		//得到超时的工作项
		//		PmActive pa = getTimeoutNode(lstPas, lstPms, currPai );
		//		
		//		if( pa != null && !END_NODE.equals( pa.getType() ) && !NODE_TYPE_END.equals( pa.getExeType() ) ){							
		//			PmActIns pai = new PmActIns();
		//			pai.setACTION_TYPE( Constants.INSERT );
		//			pai.setBillC( currPai.getBillC() );
		//			pai.setBillCn( currPai.getBillCn() );
		//			pai.setBillType( currPai.getBillType() );
		//			pai.setContent( currPai.getContent() );			
		//			pai.setCrtByCn( "系统" );			
		//			pai.setDeptC( currPai.getDeptC() );
		//			pai.setDeptC( currPai.getDeptCn() );
		//			pai.setDeptType( currPai.getDeptType() );
		//			pai.setDiscription( pa.getDiscription() );
		//			pai.setEntC( currPai.getEntC() );
		//			pai.setEntCn( currPai.getEntCn() );
		//			pai.setEntType( currPai.getEntType() );
		//			pai.setNameCn( pa.getNameCn() );
		//			pai.setType( pa.getType() );
		//			pai.setPaC(pa.getPaC() );
		//			pai.setPaiC( new RandomGUID().toString() );
		//			pai.setPpiC( currPai.getPpiC() );
		//			pai.setPtC( currPai.getPtC() );
		//			pai.setUrl( pa.getUrl() );
		//			pai.setUrlType( pa.getUrlType() );
		//			pai.setSupC( pa.getSupLogC() );
		//			pai.setState( PROCESS_STATE_READY );
		//			pai.setOwnerC( pa.getExeByCode() );
		//			pai.setOwnerType( pa.getExeByType() );
		//			pai.setOther1Cn( currPai.getOther1Cn() );
		//			pai.setOther2Cn( currPai.getOther2Cn() );
		//			pai.setOther3Cn( currPai.getOther3Cn() );
		//			pai.setOther4Cn( currPai.getOther4Cn() );
		//			pai.setOther5Cn( currPai.getOther5Cn() );
		//			pai.setOther1Type( currPai.getOther1Type() );
		//			pai.setOther2Type( currPai.getOther2Type() );
		//			pai.setOther3Type( currPai.getOther3Type() );
		//			pai.setOther4Type( currPai.getOther4Type() );
		//			pai.setOther5Type( currPai.getOther5Type() );
		//			save( pai );
		//			
		//			if( "Y".equals( pa.getIsWorkMsg() ) ){
		//				pmm = (PmMsgManager)getSpringBean( "messageManager" );
		//				PmMsg msg = new PmMsg();
		//				msg.setReceiverC( pa.getExeByCode() );
		//				msg.setCrtByC( "System" );
		//				msg.setCrtByCn( "VPE消息引擎" );
		//				msg.setPmTitle( "被驳回的工作" );
		//				pmm.saveMsg( msg , pa.getExeByType(), pa.getWorkMsg(), pai );
		//			}
		//			
		//			//记录日志
		//			saveLog( currPai );
		//				
		//			//保存监控图显示
		//			save( lstPms.toArray() );		
		//				
		//			//删除被驳回的工作项
		//			remove( paiEx );
		//		}
		//		
		//		//如果已经是结束节点，则流程完成,删除运行的流程实例，产生流程流程实例日志，删除当然的流程监控图，产生流程监控图日志
		//		if( END_NODE.equals( pa.getType() ) || NODE_TYPE_END.equals( pa.getExeType() ) ){		
		//			
		//			if( pa.getLogicC() != null && pa.getLogicC().trim().length() > 0 ){
		//				PmRule pr = getRuleByC( pa.getLogicC() );
		//				executeRule( pr, getHashMapByBean( currPai ) );
		//			}
		//			
		//			PmProIns ppi = new PmProIns();
		//			ppi.setPtC( currPai.getPtC() );
		//			ppi.setPpiC( currPai.getPpiC() );
		//			List<PmProIns> lstPpis = getByObject( ppi );
		//			if( lstPpis.size() > 0 ){
		//				ppi = lstPpis.get( 0 );
		//				ppi.setComDate( new Date() );
		//				ppi.setState( PROCESS_STATE_FINISHED );
		//				ppi.setACTION_TYPE( Constants.INSERT );
		//				PmProInsLog ppil = new PmProInsLog();
		//				BeanUtils.copyProperties( ppil, ppi );
		//				
		//				save( ppil );				
		//				remove( ppi );
		//			}
		//			
		//			PmLog pl = new PmLog();
		//			pl.setPtC( currPai.getPtC() );
		//			pl.setPpiC( currPai.getPpiC() );
		//			List<PmLog> lstPls = getByObject( pl );
		//			for( Iterator<PmLog> it = lstPls.iterator(); it.hasNext() ; ){
		//				pl = it.next();
		//				pl.setACTION_TYPE( Constants.DELETE );
		//				PmLogLog pll = new PmLogLog();
		//				BeanUtils.copyProperties( pll, pl );
		//				pll.setACTION_TYPE( Constants.INSERT );
		//				pll.setId( null );
		//				save( pll );
		//				remove( pl );
		//			}			
		//			
		//			PmMonitor pm = new PmMonitor();
		//			pm.setPpiC( currPai.getPpiC() );
		//			pm.setPtC( currPai.getPtC() );		
		//			List<PmMonitor> lstPmMonitors = getByObject( pm );			
		//			
		//			for( Iterator<PmMonitor> it = lstPmMonitors.iterator(); it.hasNext() ; ){
		//				pm = it.next();
		//				pm.setACTION_TYPE( Constants.INSERT );
		//				PmMonitorLog pml = new PmMonitorLog();
		//				BeanUtils.copyProperties( pml, pm );
		//				pml.setId( null );
		//				save( pml );
		//				remove( pm );
		//			}
		//		}

	}

	//根据流程模板得到流程节点集
	private List<PmActive> getActives(String ptC) {
		PmActive paInstance = new PmActive();
		paInstance.setPtC(ptC);
		List<PmActive> lstPas = getByObject(paInstance);
		return lstPas;
	}

	//根据流程模板得到流程节点集
	private List<PmLog> getLogs(String ptC, String ppiC) {
		PmLog plInstance = new PmLog();
		plInstance.setPtC(ptC);
		plInstance.setPpiC(ppiC);
		List<PmLog> lstPls = getByObject(plInstance);
		Collections.sort(lstPls, new Comparator() {
			public int compare(Object o1, Object o2) {
				PmLog ba1 = (PmLog) o1;
				PmLog ba2 = (PmLog) o2;

				int result = 0;

				if (ba1 != null && ba2 != null && ba1.getCrtDate() != null) {
					result = ba2.getCrtDate().after(ba1.getCrtDate()) ? 1 : 0;
				}

				return result;
			}
		});
		return lstPls;
	}

	//得到开始节点
	private PmActive getStartNode(List<PmActive> list) {
		PmActive pa = null;
		for (Iterator<PmActive> it = list.iterator(); it.hasNext();) {
			PmActive paT = it.next();
			if ("".equals(paT.getSupC()) || paT.getSupC() == null) {
				pa = paT;
				break;
			}
		}
		return pa;
	}

	private PmActIns convertToPmActIns(PmActIns paiT, PmActive pa)
			throws Exception {
		PmActIns pai = new PmActIns();

		pai.setACTION_TYPE(Constants.INSERT);
		pai.setBillC(paiT.getBillC());
		pai.setBillType(paiT.getBillType());
		pai.setDeptC(paiT.getDeptC());
		pai.setDiscription(pa.getDiscription());
		pai.setNameCn(pa.getNameCn());
		pai.setPaC(pa.getPaC());
		pai.setPaiC(new RandomGUID().toString());
		pai.setPpiC(paiT.getPpiC());
		pai.setPtC(paiT.getPtC());
		pai.setUrl(pa.getUrl());
		pai.setOwnerC(pa.getExeByCode());
		pai.setOwnerType(pa.getExeByType());
		pai.setState(PROCESS_STATE_FINISHED);

		return pai;
	}

	private PmActIns convertToPmActIns(PmProIns ppi, PmActive pa) {
		PmActIns pai = new PmActIns();

		pai.setId(null);
		pai.setBillC(ppi.getBillC());
		pai.setBillType(ppi.getBillType());
		pai.setCrtByC(ppi.getCrtByC());
		pai.setCrtByTime(ppi.getCrtByDate());
		pai.setDeptC(ppi.getDeptC());
		pai.setDiscription(pa.getDiscription());
		pai.setNameCn(pa.getNameCn());
		pai.setPaC(pa.getPaC());
		pai.setPpiC(ppi.getPpiC());
		pai.setPtC(ppi.getPtC());
		pai.setUrl(pa.getUrl());
		pai.setOwnerC(pa.getExeByCode());
		pai.setOwnerType(pa.getExeByType());

		return pai;
	}

	//根据结果集得到第一个任务节点
	private PmActive getFirstNode(List<PmActive> lstPas, PmProIns ppi)
			throws Exception {
		PmActive paResult = getStartNode(lstPas);
		paResult = getNextNode(lstPas, convertToPmActIns(ppi, paResult));

		return paResult;
	}

	//根据节点编码得到下一个节点
	private PmActive getNextNode(List<PmActive> lstPas, PmActIns pai)
			throws Exception {
		PmActive paResult = null;

		for (Iterator<PmActive> it = lstPas.iterator(); it.hasNext();) {
			PmActive paT = it.next();
			if (pai.getPaC().equals(paT.getSupC())) {

				paResult = paT;

				//				if( paiActiveT.getLogicC() != null && paiActiveT.getLogicC().trim().length() > 0 ){
				//					PmRule pr = getRuleByC( paiActiveT.getLogicC() );
				//					executeRule( pr, getHashMapByBean( pai ) );
				//				}

				if (NODE_TYPE_LOGIC.equals(paT.getType())) {
					//					if( paT.getLogicC() != null && paT.getLogicC().trim().length() > 0 ){
					//						PmRule pr = getRuleByC( paT.getLogicC() );
					//						executeRule( pr, getHashMapByBean( pai ) );
					//						PmActIns paiT = convertToPmActIns( pai, paT );
					//						saveLog(paiT);
					//						return getNextNode( lstPas, paiT );
					//					}
				} else if (NODE_TYPE_RULE.equals(paT.getType())) {
					//					if( paT.getLogicC() != null && paT.getLogicC().trim().length() > 0
					//						&& paT.getExeParam() != null && paT.getExeParam() .trim().length() > 0 ){						
					//						PmRule pr = getRuleByC( paT.getLogicC() );
					//						String rst = executeRule( pr, getHashMapByBean( pai ) );
					//						if( rst != null ){
					//							String targetPaC = getOffset( paT.getExeParam(), rst );
					//							PmActive nextPmActive = getNode( lstPas, targetPaC );
					//							if( nextPmActive != null ){
					//								PmActIns paiT = convertToPmActIns( pai, paT );
					//								paiT.setSupC( pai.getSupC() );								
					//								saveLog(paiT);
					//								paiT = convertToPmActIns( pai, nextPmActive );
					//								paiT.setAutoC( paT.getPaC() );
					//								return getNextNode( lstPas, paiT, lstPms );
					//							}
					//							else
					//								return null;
					//							
					//						}
					//					}
				}

				break;
			}
		}

		return paResult;
	}

	//根据节点编码得到节点
	private PmActive getNode(List<PmActive> lstPas, String paC) {
		PmActive paResult = null;

		for (Iterator<PmActive> it = lstPas.iterator(); it.hasNext();) {
			PmActive paT = it.next();
			if (paC.equals(paT.getPaC())) {
				paResult = paT;
				break;
			}
		}

		return paResult;
	}

	private PmLog saveLog(PmActIns currPai, UserInterface user) {
		PmLog pl = null;

		if (currPai != null) {
			pl = new PmLog();
			pl.setId(new RandomGUID().toString());
			pl.setACTION_TYPE(Constants.INSERT);
			pl.setBillC(currPai.getBillC());
			pl.setCrtDate(currPai.getCrtByTime());
			pl.setCrtByC(user.getCode());
			pl.setDeptC(currPai.getDeptC());
			pl.setPaC(currPai.getPaC());
			pl.setPpiC(currPai.getPpiC());
			pl.setPaiC(currPai.getPaiC());
			pl.setPtC(currPai.getPtC());
			pl.setStatusC(currPai.getState());
			pl.setOperC(currPai.getExeRes());
			pl.setMemo(currPai.getMemo());
			pl = (PmLog) save(pl);
		}

		return pl;
	}

	private void copyPmActIns(PmActIns dest, PmActIns src) {
		dest.setId(src.getId());
		dest.setNameCn(src.getNameCn());
		dest.setPaC(src.getPaC());
		dest.setPpiC(src.getPpiC());
		dest.setPaiC(src.getPaiC());
		dest.setPtC(src.getPtC());
		dest.setUrl(src.getUrl());
	}

	//产生工作项
	private PmActIns buildWorkItem(List<PmActive> lstPas, PmProIns ppi,
			UserInterface user) throws Exception {
		PmActIns pai = null;

		if (lstPas.size() > 0) {

			PmActive pa = getStartNode(lstPas);

			if (pa != null) {

				pai = new PmActIns();
				String id = new RandomGUID().toString();
				pai.setId(id);
				pai.setACTION_TYPE(Constants.INSERT);
				pai.setBillC(ppi.getBillC());
				pai.setBillType(ppi.getBillType());
				pai.setCrtByC(ppi.getCrtByC());
				pai.setCrtByTime(ppi.getCrtByDate());
				pai.setDeptC(ppi.getDeptC());
				pai.setDiscription(pa.getDiscription());
				pai.setNameCn(pa.getNameCn());
				pai.setPaC(pa.getPaC());
				pai.setBackC(pa.getBackC());
				pai.setPaiC(id);
				pai.setPpiC(ppi.getPpiC());
				pai.setPtC(ppi.getPtC());
				pai.setUrl(pa.getUrl());
				pai.setState(PROCESS_STATE_READY);
				pai.setOwnerC(pa.getExeByCode());
				pai.setOwnerType(pa.getExeByType());

				save(pai);

				passWorkItem(pai.getPaiC(), user);
			} else {
				throw new ProcessException(ppi.getPtC() + "没有设置任何的人工节点");
			}
		} else {
			throw new ProcessException(ppi.getPtC() + "没有设置任何的流程节点");
		}

		return pai;
	}

	private PmRule getRuleByC(String ruleC) {
		PmRule result = new PmRule();
		result.setPrC(ruleC);
		List<PmRule> lstPrs = getByObject(result);
		result = lstPrs.size() > 0 ? lstPrs.get(0) : null;
		return result;
	}

	private String executeRule(PmRule rule, HashMap param) throws Exception {
		String result = null;

		if (rule != null) {
			Class ruleImpl = Class.forName(rule.getImplClass());
			PmRuleInterface pmRuleInterface = (PmRuleInterface) ruleImpl
					.newInstance();
			result = pmRuleInterface.executeRule(param);
		}

		return result;
	}

	private boolean contain(String src, String tar) {
		boolean result = false;

		if (src != null && tar != null && src.length() > 0 && tar.length() > 0) {
			String[] srcs = src.split(",");
			for (int i = 0; i < srcs.length; i++) {
				if (srcs[i].equals(tar)) {
					result = true;
					break;
				}
			}
		}

		return result;
	}

	private List<PmActive> getActives(PmActive pa) throws Exception {

		return getByObject(pa);
	}

	private boolean checkUser(PmActive pa, UserInterface user) {
		boolean result = false;

		if (pa != null && pa.getExeByCode() != null
				&& pa.getExeByType() != null) {
			if (PROCESS_OWNERTYPE_PERSON.equals(pa.getExeByType())) {
				result = pa.getExeByCode().equals(user.getCode());
			} else if (PROCESS_OWNERTYPE_ROLE.equals(pa.getExeByType())) {
				List<String> rolecodes = user.getRoleCode();
				if (rolecodes != null) {
					for (String rolecode : rolecodes) {
						if (pa.getExeByCode().equals(rolecode)) {
							result = true;
							break;
						}
					}
				}
			}
		}

		return result;
	}

	private boolean checkUser(PmActIns pai, UserInterface user) {
		boolean result = false;

		if (pai != null && pai.getOwnerC() != null
				&& pai.getOwnerType() != null) {
			if (PROCESS_OWNERTYPE_PERSON.equals(pai.getOwnerType())) {
				result = pai.getOwnerC().equals(user.getCode());
			} else if (PROCESS_OWNERTYPE_ROLE.equals(pai.getOwnerType())) {
				List<String> rolecodes = user.getRoleCode();
				if (rolecodes != null) {
					for (String rolecode : rolecodes) {
						if (pai.getOwnerC().equals(rolecode)) {
							result = true;
							break;
						}
					}
				}
			}
		}

		return result;
	}

	public List getProcessInstances(PmProIns ppi, UserInterface user)
			throws ProcessException {

		try {
			return getByObject(ppi);
		} catch (Exception e) {
			throw new ProcessException(e.getMessage());
		}
	}

	public PmTemplate getTemplateByCode(String ptC, UserInterface user)
			throws ProcessException {
		if (null != ptC && ptC.trim().length() > 0) {
			PmTemplate ptEx = new PmTemplate();
			ptEx.setPtC(ptC);
			List<PmTemplate> lstPmTemplates = getTemplates(ptEx, user);
			if (null != lstPmTemplates && lstPmTemplates.size() > 0) {
				return lstPmTemplates.get(0);
			}
		}
		return null;
	}

	public List getTemplates(PmTemplate pt, UserInterface user)
			throws ProcessException {

		List lstObject = getByObject(pt);

		return lstObject;
	}

	public List<PmActIns> getWorkItems(PmActIns pai, UserInterface user)
			throws ProcessException {
		List<PmActIns> results = null;

		if (pai != null) {
			pai.setState(PROCESS_STATE_READY);
			List<PmActIns> objs = getByObject(pai);

			if (objs != null && objs.size() > 0) {
				results = new ArrayList<PmActIns>();

				for (PmActIns workItem : objs) {
					if (checkUser(workItem, user)) {
						results.add(workItem);
					}
				}
			}
		} else {

			PmActIns paiT = new PmActIns();
			paiT.setState(PROCESS_STATE_READY);
			List<PmActIns> objs = getByObject(paiT);

			if (objs != null && objs.size() > 0) {
				results = new ArrayList<PmActIns>();

				for (PmActIns workItem : objs) {
					if (checkUser(workItem, user)) {
						results.add(workItem);
					}
				}
			}
		}

		return results;
	}

	public String passWorkItemByBill(String billC, UserInterface user)
			throws ProcessException {
		PmProIns ppi = new PmProIns();
		ppi.setBillC(billC);
		List lstPpi = getProcessInstances(ppi, user);
		if (lstPpi != null && lstPpi.size() > 0) {
			ppi = (PmProIns) lstPpi.get(0);
			PmActIns pai = new PmActIns();
			pai.setPpiC(ppi.getPpiC());
			List<PmActIns> lstPai = getWorkItems(pai, user);
			if (lstPai != null && lstPai.size() > 0)
				return passWorkItem(lstPai.get(0).getPaiC(), user);
		}
		return null;
	}

	public void stopProcessByBill(String billC, UserInterface user)
			throws ProcessException {
		PmProIns ppi = new PmProIns();
		ppi.setBillC(billC);
		List lstPpi = getProcessInstances(ppi, user);
		if (lstPpi != null && lstPpi.size() > 0) {
			ppi = (PmProIns) lstPpi.get(0);
			PmActIns pai = new PmActIns();
			pai.setPpiC(ppi.getPpiC());
			List<PmActIns> lstPai = getWorkItems(pai, user);
			if (lstPai != null && lstPai.size() > 0)
				stopProcess(lstPai.get(0).getPaiC(), user);
		}
	}

	//驳回节点到指定节点
	public String backWorkItemByBill(String billC, UserInterface user)
			throws ProcessException {
		PmProIns ppi = new PmProIns();
		ppi.setBillC(billC);
		List lstPpi = getProcessInstances(ppi, user);
		if (lstPpi != null && lstPpi.size() > 0) {
			ppi = (PmProIns) lstPpi.get(0);
			PmActIns pai = new PmActIns();
			pai.setPpiC(ppi.getPpiC());
			List<PmActIns> lstPai = getWorkItems(pai, user);
			if (lstPai != null && lstPai.size() > 0)
				return backWorkItem(lstPai.get(0).getPaiC(), user);
		}
		return null;

	}

}
