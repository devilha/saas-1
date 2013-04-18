package com.bfuture.app.job;
/*
 * 发送短信。
 * */

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.bfuture.app.job.service.SmsJobManager;

public class SmsJobSend extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		ApplicationContext applicationContext = (ApplicationContext)context.getJobDetail().getJobDataMap().get( "applicationContext" );
		SmsJobManager sjm = (SmsJobManager)applicationContext.getBean("SmsJobManager");
		List list=sjm.executeSql("select * from (select so.SOHSGCODE,so.SOHSUPID,so.SOHBILLNO,so.SOHTYPE,so.SOHSHTIME,so.NONPES,so.SOHSTATE,so.SOHSTATUS,sio.SIFTELPHOTO,sio.SIFSMSNUM,sio.SIFSMSTOTNUM from sms_order so,sys_scmuser su,sms_info sio where so.SOHSGCODE=su.sgcode and so.SOHSUPID=su.supcode and so.SOHSGCODE = sio.SIFSGCODE and so.SOHSUPID = sio.SIFSUPID and sio.SIFTELPHOTO is not null and sio.SIFTELPHOTO != ' ' and su.SUENABLE = 'Y' and sio.SIFSMSSTATE='Y' and so.SOHSTATE='N') temp where not exists(select sss.SSDBILLNO from SMS_SENDES sss where temp.SOHSGCODE=sss.SSDSGCODE and temp.SOHSUPID=sss.SSDSUPID and temp.SOHBILLNO=sss.SSDBILLNO and temp.SOHTYPE=sss.SSDTYPE)");
		Iterator it = list.iterator();
		while(it.hasNext()){
			HashMap hm =(HashMap)it.next();
			//发送短信.
			 int strlenjq = Integer.parseInt(""+hm.get("SIFSMSTOTNUM")) ;  //短信总条数。
			 StringBuffer smscfstrbuf = new StringBuffer();   //字符串需要拼接。
			 String sumobile = hm.get("SIFTELPHOTO").toString().trim();
			 //西安唯购对信息头的处理
			 if("4005".equals(hm.get("SOHSGCODE"))){
				 smscfstrbuf.append("您好,西安唯购商贸"+hm.get("NONPES").toString().trim()+"给您发送了一个");
			 }			
			 if(hm.get("SOHTYPE").toString().trim().equals("DD"))//订货单
				 smscfstrbuf.append("新订单");
		     else if(hm.get("SOHTYPE").toString().trim().equals("TC"))//退厂单
		    	 smscfstrbuf.append("退货单");
			 smscfstrbuf.append("，编号:"+hm.get("SOHBILLNO").toString().trim()+"，请及时登录SCM系统进行处理。");	   
			 int smsstrlen= length(smscfstrbuf.toString().trim());  //短信长度。按1个中文2个字节算。
			 int smssendflagnum = 100;
			 int smssendflag = 99;        //当大于100时...采用99的长度拆分。
			 int SmsNum = 1; //短信内容条数（如果需要拆分就是拆分后需要发送的条数）。
			 int smsstrnlen = 1;
			 if(smsstrlen >= smssendflagnum){
					   SmsNum = 1;
					   smsstrnlen = smsstrlen/smssendflag;   //大于100时，应发送的条数。
					   if(smsstrlen%smssendflag!=0)smsstrnlen = smsstrnlen+1;
					   SmsNum = smsstrnlen;
		      }

			 int listexe = Integer.parseInt(""+hm.get("SIFSMSNUM")) ;  //短信已发送的条数
			if((listexe+SmsNum)<=strlenjq){
			  if(Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$").matcher(sumobile).matches()){
				//发送短信 smscfstrbuf--短信内容,hm.get("SIFTELPHOTO").toString()--短信号码
				  ArrayList al = new ArrayList();
				  al = splitsms(smsstrlen,SmsNum,smssendflag,smssendflagnum,smscfstrbuf);   //拆分字符串(短信内容)。
				  //循环三次发送。
			       Iterator ital = al.iterator();
		           boolean flagsms = false;
		           Integer flagcount = 0;
			       while(ital.hasNext()){
		        	 String strital=(String)ital.next();
		  	          try{//2 是失败 1 是成功
		  	        	  for(int SMSi=0;SMSi<3;SMSi++){
		  	        		String sendsms=sendSMS(strital,sumobile);  
		  	        		if(sendsms.equals("1")){
			                	 flagsms = true;
			                	 flagcount++;
			                	 break;
			                 }else{
			                	 flagsms = false; 
			                 }
		  	        	  }
		  	        	  if(!flagsms)System.out.println("手机号码为:"+sumobile+" 内容为："+strital+" 长度为:"+length(strital)+" 发送三次都失败!");
		  	          }catch(IOException ex){
			    	     ex.printStackTrace();
			          }
		           }
				if(flagsms&&(flagcount==SmsNum)){//如果短信成功
					String [] execupsql = {
							"update sms_order set SOHSTATE='Y',SOHSTATUS='Y' where SOHSGCODE='"+hm.get("SOHSGCODE").toString().trim()+"' and SOHSUPID='"+hm.get("SOHSUPID").toString().trim()+"' and SOHBILLNO='"+hm.get("SOHBILLNO").toString().trim()+"' and SOHSTATE='N'",
							"update sms_info set SIFSMSNUM=SIFSMSNUM+"+SmsNum+" where SIFSGCODE='"+hm.get("SOHSGCODE").toString().trim()+"' and SIFSUPID='"+hm.get("SOHSUPID").toString().trim()+"'",
							"INSERT INTO sms_sendes (SSDSGCODE,SSDSUPID,SSDBILLNO,SSDTYPE,SSDTIME,SSDMEMO,SBOHTELEPHOTO,SSDSHTIME,NONPES) VALUES ('"+hm.get("SOHSGCODE").toString().trim()+"','"+hm.get("SOHSUPID").toString().trim()+"','"+hm.get("SOHBILLNO").toString().trim()+"','"+hm.get("SOHTYPE").toString().trim()+"',to_date('"+new SimpleDateFormat("yyyy-MM-dd kk:mm:ss").format(new Date()).toString()+"','yyyy-mm-dd hh24:mi:ss'),'"+smscfstrbuf.toString()+"','"+sumobile+"',to_date(substr('"+hm.get("SOHSHTIME").toString()+"',0,19),'yyyy-mm-dd hh24:mi:ss'),'"+hm.get("NONPES").toString()+"')"};
					sjm.execessql(execupsql);
				}
			  }
			}

		}
		
	}
	
	public static ArrayList splitsms(int smsstrlen,int SmsNum,int flag,int smssendflagnum,StringBuffer smscfstrbuf){  //拆分字符串(短信内容)。
		ArrayList al = new ArrayList();
		  if(smsstrlen>smssendflagnum){
		        int chrlen = 0;//拆分后的长度。
		        int flagj = 0;
		        int lengsmsnumes = 5;//短信内容被拆分后提示内容"(1/2)"长度。
		        char[] dstChar = smscfstrbuf.toString().toCharArray();
		        smscfstrbuf.toString().getChars(0, smscfstrbuf.toString().length(), dstChar, 0);
		       for(int i=0;i<SmsNum;i++){
		    	   StringBuffer smscfchrbuf=new StringBuffer();
		        for (int j = flagj; j < dstChar.length; j++) 
		        {
		        	smscfchrbuf.append(dstChar[j]);
		        	chrlen=length(smscfchrbuf.toString());
		        	if(length("("+(i+1)+"/"+SmsNum+")")>5){
			        	lengsmsnumes = length("("+(i+1)+"/"+SmsNum+")");	        		
		        	}
		        	if((chrlen+lengsmsnumes)>flag){
		        	  smscfchrbuf.append("("+(i+1)+"/"+SmsNum+")");
		        	  al.add(smscfchrbuf.toString());
			          chrlen=length(smscfchrbuf.toString());
			          flagj = j+1;
			          break;
		        	}else if(i==(SmsNum-1)&&(j==dstChar.length-1)){
		        	  smscfchrbuf.append("("+(i+1)+"/"+SmsNum+")");
		        	  al.add(smscfchrbuf.toString());
		        	}
		          }
		        }
			  }else if(smsstrlen<=100){
				  al.add(smscfstrbuf.toString().trim());
			  }
		  return al;
	}
	
	public static String sendSMS(String message, String phone) throws IOException {
		if (message == null) return null;
		int result = 0;
		String line = "";
		String surl = "http://sms.mobsms.net/send/g70send.aspx?name=fjbsyd&pwd=123456&dst="+ phone;
		URL url = new URL(surl + "&msg="+ java.net.URLEncoder.encode(message, "GBK"));
		URLConnection connection = url.openConnection();
		connection.connect();
	    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String line2 = in.readLine();
		byte[] bts = line2.getBytes("GBK");
		sun.io.ByteToCharConverter convertor = sun.io.ByteToCharConverter.getConverter("GBK");
		char[] charArray = convertor.convertAll(bts);
		for (int j = 0; j < charArray.length; j++) {
			line += String.valueOf(charArray[j]);
		}
		line = line.substring(line.indexOf("num=") + 4, line.indexOf("&s"));
			in.close();
		if ("1".equals(line)){
			result = 1;
		}else{
			result = 2;
		}
		return String.valueOf(result);
    }
	
	public static int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1 */
        for (int i = 0; i < value.length(); i++) {
            /* 获取一个字符 */
            String temp = value.substring(i, i + 1);
            /* 判断是否为中文字符 */
            if (temp.matches(chinese)) {
                /* 中文字符长度为2 */
                valueLength += 2;
            } else {
                /* 其他字符长度为1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }
	
}
