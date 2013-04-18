package com.bfuture.app.saas.util;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.mail.internet.MimeUtility;

public class StringUtil {
	
	public static boolean isEmpty(String str) {
		return str == null || "".equals(str.trim());
	}

	public static boolean isNotEmpty(String str) {
		return str != null && !"".equals(str);
	}
	
	public static String nullToBlank(Object obj){
		return obj != null ? obj.toString() : "";
	}
	
	public static String getFilePath(String fileName)
	{       
       String date = getFormatTime(new Date(), "yyyyMMdd-hhmmss");
       //String name = fileName.substring(fileName.lastIndexOf("\\")+1,fileName.lastIndexOf("."));  
       String name = fileName.substring(0,fileName.lastIndexOf("."));
       return name + date;
	}
	
	public static String getFilePath( String dir, String fileName )
	{       
    	String d = dir;
    	if( !fileName.endsWith( "\\" ) && !fileName.endsWith( "/" ) ){
    	   d += File.separator;
		}
	
		return d + fileName;
	}
	
	public static String getFileName(String fileName)
	{  
		if( fileName.indexOf( "\\" ) > 0 )
			return fileName.substring(fileName.lastIndexOf("\\")+1,fileName.length());
		else if(fileName.indexOf( "/" ) > 0 ) {
			return fileName.substring(fileName.lastIndexOf("/")+1,fileName.length());
		}
		else{
			return fileName;
		}
	}
	
	public static String getFileEXTName(String fileName)
	{       
       return fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length()).toLowerCase();
	}
	
	public static String getFormatTime(Date date,String format)
	{
		SimpleDateFormat df = new SimpleDateFormat(format);
		if (date == null)
		{
			return df.format(new Date());
		}
		else
		{
			return df.format(date);
		}		
	}
	
	/**
	 * 格式化 Name <email@address.com> 的地址
	 * @param name 名字
	 * @param email Email地址
	 * @return 格式化的地址
	 */
	public static String formatAddress(String name, String email) {
		if ( isEmpty(name) ) {
			return email;
		}
		try {
			return String.format("%1$s <%2$s>", MimeUtility.encodeText(name,"GBK", "B"), email);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return email;
	}
	
	public static String getShowTime(Date date,String format)
	{
		SimpleDateFormat df = new SimpleDateFormat(format);
		if (date == null)
		{
			return "";
		}
		else
		{
			return df.format(date);
		}
	}
	
	public static String roundDoule(double value)
	{       
		DecimalFormat format = new DecimalFormat("0.00");		
		return format.format(value);
	}
}
