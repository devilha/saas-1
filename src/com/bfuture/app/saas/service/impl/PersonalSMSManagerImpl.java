package com.bfuture.app.saas.service.impl;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.SmsAccount;
import com.bfuture.app.saas.model.SmsSend;
import com.bfuture.app.saas.service.PersonalSMSManager;
/**
 * 自写短信
 * @author Administrator
 *
 */
public class PersonalSMSManagerImpl extends BaseManagerImpl implements
		PersonalSMSManager {
	protected final Log log = LogFactory.getLog(PersonalSMSManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}
	public PersonalSMSManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result=new ReturnObject();
		if("checkname".equals(actionType))
		{
			try {
				SmsAccount sa=(SmsAccount)o[0];
				StringBuffer sql=new StringBuffer(" select sa.balance,sa.unit from sms_account sa where 1 = 1 ");
				if(!StringUtil.isBlank(sa.getSgcode()))
				{
					sql.append(" and  sa.sgcode='").append(sa.getSgcode()).append("' ");
					
				}
				if(!StringUtil.isBlank(sa.getSucode()))
				{
					sql.append(" and  sa.sucode='").append(sa.getSucode()).append("' ");
					
				}
				List listresult=dao.executeSql(sql.toString());
				JSONObject jobj=new JSONObject();
				
				if( listresult != null ){
					result.setRows(listresult);
					result.setReturnCode( Constants.SUCCESS_FLAG );

					
				}
				
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}else if("checktel".equals(actionType))
		{
			try {
				SmsSend ss=(SmsSend)o[0];
				StringBuffer sql=new StringBuffer(" select count(*) from sys_scmuser u where 1 = 1 ");
				if(!StringUtil.isBlank(ss.getSgcode()))
				{
					sql.append(" and  u.sgcode='").append(ss.getSgcode()).append("' ");
				
					if(!StringUtil.isBlank(ss.getMobile()))
					{
						sql.append(" and u.mobile in (");
						String[] thistel=ss.getMobile().split(",");
						for(int i=0;i<thistel.length;i++)
						{
								sql.append("'").append(thistel[i]).append("'").append(",");
						}
					}
					sql.deleteCharAt(sql.length()-1).append(")");
				}
				List listresult=dao.executeSqlCount(sql.toString());

				if( listresult != null ){
					result.setTotal(Integer.parseInt(listresult.get(0).toString()));
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}else if("checkbalance".equals(actionType))
		{
			try {
				SmsAccount sa=(SmsAccount)o[0];
				StringBuffer sql=new StringBuffer(" select balance from sms_account sa where 1 = 1 ");
				if(!StringUtil.isBlank(sa.getSgcode()))
				{
					sql.append(" and  sa.sgcode='").append(sa.getSgcode()).append("' ");
				
					if(!StringUtil.isBlank(sa.getSucode()))
					{
						sql.append(" and  sa.sucode='").append(sa.getSucode()).append("' ");
						
					}
				}
				List listresult=dao.executeSqlCount(sql.toString());

				if( listresult != null ){
					result.setTotal(Integer.parseInt(listresult.get(0).toString()));//余额
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}else if("sendSMS".equals(actionType))
		{
			result=sendSMS(o);
		}
		
		return result;
	}
	/**
	 * 发送短信处理
	 * @param o
	 * @return
	 */
	public ReturnObject sendSMS( Object[] o)
	{
		ReturnObject result=new ReturnObject();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			SmsSend ss=(SmsSend)o[0];
			System.out.println("-------------------------"+ss.getMobile());
			ss.setCreatedate(new Date());//创建日期
			ss.setSendstates(0);		//发送状态 默认0 未发送
			ss.setSendtype(1);			//发送类型 默认1 自主 （自写短信）
			if(!StringUtil.isBlank(ss.getMobile()))
			{
				String[] thistel=ss.getMobile().split(",");
				for(int i=0;i<thistel.length;i++)
				{
						ss.setMobile(thistel[i]);
						dao.saveEntity(ss);
				}
			}
			
			//dao.saveEntity(ss);
			//returncode默认为1
			
			//未发送  待处理
		} catch (Exception e) {
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( e.getMessage() );
		}
		return result;
	}
	@Override
	public boolean equals(Object o) {
		return false;
	}

	@Override
	public int hashCode() {
		return 0;
	}

	@Override
	public String toString() {
		return null;
	}

}
