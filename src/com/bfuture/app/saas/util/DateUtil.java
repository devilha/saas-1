package com.bfuture.app.saas.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
	
	public static String getYear(String date)
	{
		System.out.println("date = " + date);
		int i = date.indexOf("-");
		return date.substring(2, i);
	}
	
	public static String getDayByDate(String date) {
		int j = date.lastIndexOf("-");
		return date.substring(j+1, date.length());
	}
	
	public static String getMonthByDate(String date) {
		int i = date.indexOf("-");
		int j = date.lastIndexOf("-");
		return date.substring(i + 1, j);
	}
	
	public static String getYearByDate(String date) {
		int i = date.indexOf("-");
		return date.substring(0, i);
	}
	
	public static Date convertDate(String date)
	  {
	    try
	    {
	      if ((date != null) && (!"".equals(date)))
	      {
	        if (date.contains("."))
	        {
	          date = date.replace(".", "-");
	        }

	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        return sdf.parse(date);
	      }

	      return null;
	    }
	    catch (Exception ex)
	    {
	      ex.printStackTrace();
	    }return null;
	  }
	
	public static Date getBeforOrAfterDate(Date date,int day)
	{
		Calendar calendar = Calendar.getInstance();
		calendar.add(calendar.DATE, day);
		return calendar.getTime();
	}
	
	public static String getDate(Date date,String format)
	{
		try
		{
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);    
			return simpleDateFormat.format(date);			
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return null;
		}		
	}
}
