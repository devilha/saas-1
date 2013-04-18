package com.bfuture.app.job;
/*
 * 导入表和发送表同步更新(短信)。
 * */
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobOrder extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		//ReportDao rm = (ReportDao)applicationContext.getBean("ReportDao");
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		//导入表和发送表同步更新(短信)
		sjm.insupsql("insert into SMS_ORDER(SOHSGCODE,SOHSUPID,SOHBILLNO,SOHTYPE,SOHSHTIME,NONPES,SOHSTATE,SOHSTATUS)select yn.NOSGCODE,yn.NOSUPID,yn.NOBILLNO,yn.NOTYPE,yn.NSHTIME,yn.NONPES,'N' as SOHSTATE,'N' as SOHSTATUS from YW_NORDER yn where not exists(select so.SOHBILLNO from SMS_ORDER so where yn.NOSGCODE=so.SOHSGCODE and yn.NOSUPID=so.SOHSUPID and yn.NOBILLNO=so.SOHBILLNO and yn.NOTYPE=so.SOHTYPE) AND to_char(yn.NSHTIME,'yyyy-mm-dd hh24:mi:ss') > CASE WHEN yn.NOTYPE='DD' THEN to_char((sysdate-1),'yyyy-mm-dd hh24:mi:ss') WHEN yn.NOTYPE='TC' THEN to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') ELSE to_char((sysdate-2),'yyyy-mm-dd hh24:mi:ss') end");
	}

}
