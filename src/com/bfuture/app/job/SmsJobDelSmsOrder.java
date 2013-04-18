package com.bfuture.app.job;
/*
 * 删除掉3天前的信息（当短信成功发送和统计完毕后）。
 * */
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobDelSmsOrder extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		String execupsql = "delete from SMS_ORDER where to_char(sohshtime,'yyyy-mm-dd hh24:mi:ss') < CASE WHEN sohtype='DD' THEN to_char((sysdate-3),'yyyy-mm-dd hh24:mi:ss') WHEN sohtype='TC' THEN to_char((sysdate-15),'yyyy-mm-dd hh24:mi:ss')  ELSE to_char((sysdate-15),'yyyy-mm-dd hh24:mi:ss') end";//清空3天前的(SMS_ORDER)发送单。		
		sjm.insupsql(execupsql);
	}
}
