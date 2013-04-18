package com.bfuture.app.job;
/*
 * 删除掉3天前的信息。
 * */
import java.util.Date;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobDelOrder extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		String execupsql ="delete from yw_norder where to_char(nshtime,'yyyy-mm-dd hh24:mi:ss') < CASE WHEN notype='DD' THEN to_char((sysdate-3),'yyyy-mm-dd hh24:mi:ss') WHEN notype='TC' THEN to_char((sysdate-15),'yyyy-mm-dd hh24:mi:ss')  ELSE to_char((sysdate-15),'yyyy-mm-dd hh24:mi:ss') end";//清空3天前的导入单	
		sjm.insupsql(execupsql);
	}

}
