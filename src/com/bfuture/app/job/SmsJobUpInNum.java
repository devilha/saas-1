package com.bfuture.app.job;
/*
 * 月初清理发送条数。
 * */
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobUpInNum extends QuartzJobBean {
	
	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-01 00:00:00");
		String [] execupsql = {
				"update SMS_INFO set SIFSMSNUM=0",//月初清理发送条数。
				"delete from yw_norder where to_char(nshtime,'yyyy-mm-dd hh24:mi:ss') < CASE WHEN NOTYPE='DD' THEN '"+sdf.format(new Date()).toString()+"' WHEN NOTYPE='TC' THEN  to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') ELSE  to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') END", //月初清空导入单表。
				"delete from SMS_ORDER where to_char(SOHSHTIME,'yyyy-mm-dd hh24:mi:ss') < CASE WHEN SOHTYPE='DD' THEN '"+sdf.format(new Date()).toString()+"' WHEN SOHTYPE='TC' THEN  to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') ELSE  to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') END"};//月初清空导发送单表。
		
		sjm.execessql(execupsql);
	}
	
	
	
}
