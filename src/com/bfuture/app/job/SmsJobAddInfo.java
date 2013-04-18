package com.bfuture.app.job;
/*
 * 删除掉3天前的信息。
 * */
import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobAddInfo extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-01 00:00:00");
		String [] execupsql = {
				"insert into sms_info select sgcode,supcode,0,'Y',sysdate,60,mobile from sys_scmuser temp where temp.sgcode='4005' and not exists (select sifsupid from sms_info sif where temp.sgcode=sif.sifsgcode and temp.supcode=sif.sifsupid)",//添加新加入的供应商信息
				"update sms_info sif set siftelphoto=(select mobile from sys_scmuser scu where scu.sgcode='4005' and scu.supcode=sif.sifsupid  ) where sifsgcode='4005'" //更新供应商电话号码
				};
		
		sjm.execessql(execupsql);
	}

}
