
package com.bfuture.app.basic.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;

import org.springframework.context.i18n.LocaleContextHolder;


/**
 * ���ڹ�����,���԰�Stringת��ΪDate��Timestamp��.
 * <p>
 * <b>ע��:</b>���Ҫת��ʱ������,������ҪдΪmm����MM,MM��ʾ����
 * </p>
 * <p>
 * <a href="DateUtil.java.html"><i>View Source</i></a>
 * </p>
 * 
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 *  Modified by <a href="mailto:dan@getrolling.com">Dan Kibler </a> 
 * @version  1.2 Date: 2007/05/05 
 */
public class DateUtil {
    //~ Static fields/initializers =============================================

    private static Log log = LogFactory.getLog(DateUtil.class);
    private static String defaultDatePattern = null;
    private static String timePattern = "HH:mm";

    //~ Methods ================================================================

    /**
     * ����Ĭ��ʱ���ʽ����(MM/dd/yyyy).
     * 
     * @return ����һ�����û������ϱ�ʾ�������͵��ַ�
     */
    public static synchronized String getDatePattern() {
        Locale locale = LocaleContextHolder.getLocale();
        try {
            defaultDatePattern = ResourceBundle.getBundle(Constants.BUNDLE_KEY, locale)
                .getString("date.format");
        } catch (MissingResourceException mse) {
            defaultDatePattern = "MM/dd/yyyy";
        }
        
        return defaultDatePattern;
    }
    
    /**
     * �������ʱ������.
     */
    public static String getDateTimePattern() {
        return DateUtil.getDatePattern() + " HH:mm:ss.S";
    }

    /**
     * ��Oracle��ʽ�����ڸ�ʽdd-MMM-yyyy ת���� mm/dd/yyyy
     *
     * @param aDate 4Դ����ݿ������
     * @return Ϊ�û������ʽ�����string
     */
    public static final String getDate(Date aDate) {
        SimpleDateFormat df = null;
        String returnValue = "";

        if (aDate != null) {
            df = new SimpleDateFormat(getDatePattern());
            returnValue = df.format(aDate);
        }

        return (returnValue);
    }

    /**
     * ���ָ����ʽ��string��ʾ��date/timeת��������(Date)����.
     * <p>
     * This method generates a string representation of a date/time
     * in the format you specify on input
     *</p>
     *
     * @param aMask String�͵����ڸ�ʽ
     * @param strDate һ������(date)��String�ͱ�ʾ
     * @return ת���������
     * @see java.text.SimpleDateFormat
     * @throws ParseException
     */
    public static final Date convertStringToDate(String aMask, String strDate)
      throws ParseException {
        SimpleDateFormat df = null;
        Date date = null;
        df = new SimpleDateFormat(aMask);

        if (log.isDebugEnabled()) {
            log.debug("converting '" + strDate + "' to date with mask '"
                      + aMask + "'");
        }

        try {
            date = df.parse(strDate);
        } catch (ParseException pe) {
            //log.error("ParseException: " + pe);
            throw new ParseException(pe.getMessage(), pe.getErrorOffset());
        }

        return (date);
    }

    /**
     * �ѵ�ǰʱ��ת����MM/dd/yyyy HH:MM�͵�String.
     *
     * @param theTime ��ǰʱ��
     * @return ��ʽ���˵�String��ʱ��
     */
    public static String getTimeNow(Date theTime) {
        return getDateTime(timePattern, theTime);
    }

    /**
     * �õ���ǰ����,��ʽ:MM/dd/yyyy.
     * 
     * @return ��ǰ����
     * @throws ParseException
     */
    public static Calendar getToday() throws ParseException {
        Date today = new Date();
        SimpleDateFormat df = new SimpleDateFormat(getDatePattern());

        // This seems like quite a hack (date -> string -> date),
        // but it works ;-)
        String todayAsString = df.format(today);
        Calendar cal = new GregorianCalendar();
        cal.setTime(convertStringToDate(todayAsString));

        return cal;
    }

    /**
     * ���������ָ���ĸ�ʽ����ʱ��/���ڵ�String�ͱ�ʾ.
     * <p>
     * This method generates a string representation of a date's date/time
     * in the format you specify on input
     * </p>
     * 
     * @param aMask ָ���ĸ�ʽ
     * @param aDate һ��Date����
     * @return ��ʽ�����String������
     * 
     * @see java.text.SimpleDateFormat
     */
    public static final String getDateTime(String aMask, Date aDate) {
        SimpleDateFormat df = null;
        String returnValue = "";

        if (aDate == null) {
            log.error("aDate is null!");
        } else {
            df = new SimpleDateFormat(aMask);
            returnValue = df.format(aDate);
        }

        return (returnValue);
    }

    /**
     * ���ϵͳ����'dateFormat'������(Date)ת����String.
     * <p>
     * This method generates a string representation of a date based
     * on the System Property 'dateFormat'
     * in the format you specify on input
     * </p>
     * 
     * @param aDate ��ת����date
     * @return date��string�ͱ�ʾ
     */
    public static final String convertDateToString(Date aDate) {
        return getDateTime(getDatePattern(), aDate);
    }

    /**
     * ��MM/dd/yyyy��Stringת��ΪDate.
     * 
     * @param strDate MM/dd/yyyy��String
     * @return һ��Date����
     * 
     * @throws ParseException
     */
    public static Date convertStringToDate(String strDate)
      throws ParseException {
        Date aDate = null;

        try {
            if (log.isDebugEnabled()) {
                log.debug("converting date with pattern: " + getDatePattern());
            }

            aDate = convertStringToDate(getDatePattern(), strDate);
        } catch (ParseException pe) {
            log.error("Could not convert '" + strDate
                      + "' to a date, throwing exception");
            pe.printStackTrace();
            throw new ParseException(pe.getMessage(),
                                     pe.getErrorOffset());
                    
        }

        return aDate;
    }
    
    /**
     * �õ���ǰ���� (��ʽ:2007-3-21).
     * 
     * @return String������
     */
    static public String getCurrentDate() 
    {
    	Date current = new Date( System.currentTimeMillis() );
    	SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd" );
    	String dateCurretn = dateFormat.format( current );
    	
    	return dateCurretn;
    }
    
    /**
     * ��ȡϵͳ��ǰ���ڵ��ַ����磺20070308.
     * 
     * @return	ϵͳ��ǰ���ڵ��ַ�
     */
    public static String getCurrentDateString()
    {
    	StringBuffer stringBuffer = new StringBuffer();
		
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get( Calendar.YEAR );
		int month = calendar.get( Calendar.MONTH ) + 1;
		int date = calendar.get( Calendar.DATE );
			
		if( month < 10 && date < 10 )
		{
			stringBuffer.append(year).append("0").append(month).append("0").append(date); 
		}
		else if( month < 10 && date >= 10 )
		{
			stringBuffer.append(year).append("0").append(month).append(date);
		}
		else if( month >= 10 && date < 10 )
		{
			stringBuffer.append(year).append(month).append("0").append(date);
		}
		else
		{
			stringBuffer.append(year).append(month).append(date);
		}
		
		return stringBuffer.toString();
    }
    
    /**
     * �뵱ǰϵͳʱ��Ƚ�.
     * 
     * @param date	ָ��ʱ��
     * @return	intֵ.����0����ϵͳ��ǰʱ���?����0����ϵͳ��ǰʱ��ͬ�գ�С��0����ϵͳ��ǰʱ���硣
     */
    public static int dateCompare( Date date )
    {
    	int result = 0;
    	
    	SimpleDateFormat simpleDateFormat = new SimpleDateFormat( "yyyy-MM-dd" );
    	Date today = new Date();
    	
    	String date1 = simpleDateFormat.format( date );
    	String date2 = simpleDateFormat.format( today );
    	
    	result = date1.compareTo( date2 );
    	
    	return result;
    }
}
