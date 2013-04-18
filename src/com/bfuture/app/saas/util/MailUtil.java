package com.bfuture.app.saas.util;

import java.util.Date;
import java.util.Properties;

import javax.mail.AuthenticationFailedException;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.bfuture.util.mail.MailSenderInfo;
import com.bfuture.util.mail.SimpleMailSender;

import common.Logger;

public class MailUtil {
	
	public static void main(String[] args){
		System.out.println("正在发送邮件");
		
		sendMail( "dingyuan2000@tom.com", "测试", "内容" );
		
		System.out.println("发送邮件完成");
	}
	
	public static void sendMail( String mail, String head, String content ){
		Logger log = Logger.getLogger( MailUtil.class );
		
		MailSenderInfo mailInfo = new MailSenderInfo();   
	    mailInfo.setMailServerHost("smtp.c2.corpease.net");   
	    mailInfo.setMailServerPort("25");   
	    mailInfo.setValidate(true);   
	    mailInfo.setUserName("system@bfuture.com.cn");   
	    mailInfo.setPassword("idw30;rkdo");//您的邮箱密码   
	    mailInfo.setFromAddress( StringUtil.formatAddress( "北京富基标商流通信息科技有限公司","system@bfuture.com.cn" ) );   
	    mailInfo.setToAddress( mail );   
	    mailInfo.setSubject( head );   
	    mailInfo.setContent( content );   
	         //这个类主要来发送邮件  
	    SimpleMailSender.sendHtmlMail(mailInfo);
	}
}
