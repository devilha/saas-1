package com.bfuture.app.job;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.dbcp.BasicDataSource;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

public class DBConnJob extends QuartzJobBean  {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		
		BasicDataSource ds = (BasicDataSource)applicationContext.getBean("dataSource");		
		
		try {
			String strLogDir = applicationContext.getResource("").getFile().getAbsolutePath() + File.separator + "log";
			File logDir = new File( strLogDir );
			
			if( !logDir.exists() ){
				logDir.mkdir();
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat nowFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			StringBuffer sb = null;
			Date now = new Date( System.currentTimeMillis() );
			
			if( ds == null ){
				sb = new StringBuffer( "没有获取到数据源" );
			}
			else{			
				sb = new StringBuffer( "[").append( nowFormat.format( now ) )
					.append( "] 初始化连接数:" ).append( ds.getInitialSize() )
					.append( ", 当前活动连接:" ).append( ds.getNumActive() )
					.append( ", 当前空闲连接:" ).append( ds.getNumIdle() );
			}
			
			log( strLogDir + File.separator + sdf.format( now ) + ".log", sb.toString() );
			
		} catch (IOException e) {		
			e.printStackTrace();
		}			
	}
	
	void log( String filename, String data ) throws FileNotFoundException{
		FileOutputStream fos = null;
		OutputStreamWriter osw = null;
		PrintWriter pw = null;
		try{
			File file = new File( filename );			
			fos = new FileOutputStream( filename, file.exists() );
			osw = new OutputStreamWriter( fos, "UTF-8" );
			pw = new PrintWriter( osw );
			pw.println( data );
			pw.flush();
		}catch( FileNotFoundException fnfe ){
			throw fnfe;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		finally{
			if( fos != null ){
				try{
					fos.close();
				}catch( Exception ioe ){}
			}
			if( osw != null ){
				try{
					osw.close();
				}catch( Exception ioe ){}
			}
			if( pw != null ){
				try{
					pw.close();
				}catch( Exception ioe ){}
			}
		}
	}
}
