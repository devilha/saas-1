package com.bfuture.app.saas.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.AppSpringContext;
import com.bfuture.app.saas.service.SmsCustomManager;

public class SendQuartz {
	final Log log = LogFactory.getLog(SendQuartz.class);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	AppSpringContext appContext;
	SmsCustomManager manager;
	
	// 一天执行一次
	public void MyQuartzRun() {
		appContext = AppSpringContext.getInstance();
		manager = (SmsCustomManager)appContext.getAppContext().getBean("SmsCustomManager"); // 这一行只有把项目运行起来才能获取值
		
	    log.info("Quartz start...");
	    
		log.info("run...." + sdf.format(new Date()));
		
		// action
		log.info(appContext);
		log.info(manager);
		
		manager.sendXSRYB();// 1.定制销售日/月报 (每天定时)
		manager.sendXSPH();// 2.定制销售排行 (每天定时)
		manager.sendXHZB();// 3.定制销售占比 (每天定时)
		manager.sendZRKC();// 5.定制昨日库存(每天定时)
		
		log.info("Quartz end!!!");
		
	}
	
	// 实时发送
	public void MyQuartzRun1() {
		appContext = AppSpringContext.getInstance();
		manager = (SmsCustomManager)appContext.getAppContext().getBean("SmsCustomManager"); // 这一行只有把项目运行起来才能获取值
		
	    log.info("Quartz1 start...");
	    
		log.info("run1...." + sdf.format(new Date()));
		
		// action1
		log.info(appContext);
		log.info(manager);
		
		manager.sendCGDD();// 4.定制采购订单(即时)
		
		log.info("Quartz1 end!!!");
		
	}
	
	
	
	
	
	
	
	
	
	/**
	字段 允许值 允许的特殊字符 
	秒 0-59 , - * / 
	分 0-59 , - * / 
	小时 0-23 , - * / 
	日期 1-31 , - * ? / L W C 
	月份 1-12 或者 JAN-DEC , - * / 
	星期 1-7 或者 SUN-SAT , - * ? / L C # 
	年（可选） 留空, 1970-2099 , - * / 
	表达式意义 
	"0 0 12 * * ?" 每天中午12点触发 
	"0 15 10 ? * *" 每天上午10:15触发 
	"0 15 10 * * ?" 每天上午10:15触发 
	"0 15 10 * * ? *" 每天上午10:15触发 
	"0 15 10 * * ? 2005" 2005年的每天上午10:15触发 
	"0 * 14 * * ?" 在每天下午2点到下午2:59期间的每1分钟触发 
	"0 0/5 14 * * ?" 在每天下午2点到下午2:55期间的每5分钟触发 
	"0 0/5 14,18 * * ?" 在每天下午2点到2:55期间和下午6点到6:55期间的每5分钟触发 
	"0 0-5 14 * * ?" 在每天下午2点到下午2:05期间的每1分钟触发 
	"0 10,44 14 ? 3 WED" 每年三月的星期三的下午2:10和2:44触发 
	"0 15 10 ? * MON-FRI" 周一至周五的上午10:15触发 
	"0 15 10 15 * ?" 每月15日上午10:15触发 
	"0 15 10 L * ?" 每月最后一日的上午10:15触发 
	"0 15 10 ? * 6L" 每月的最后一个星期五上午10:15触发 
	"0 15 10 ? * 6L 2002-2005" 2002年至2005年的每月的最后一个星期五上午10:15触发 
	"0 15 10 ? * 6#3" 每月的第三个星期五上午10:15触发
	*/
}
