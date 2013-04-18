/*
 * 
 */
package com.bfuture.app.basic.util;

import java.net.*;
import java.util.*;
import java.security.*;

/**
 * @version 1.0
 * @author tanghf
 * @description 生成32位随机ID号
 * @date  2005-09-05
 */
public class RandomGUID {
	
	public String valueBeforeMD5 = "";
	public String valueAfterMD5 = "";
	private static Random random;
	private static SecureRandom secureRandom;
	private static String s_id;
	
	static
	{
		secureRandom = new SecureRandom();
		long secureInitializer = secureRandom.nextLong();
		random = new Random( secureInitializer );
		
		try
		{
			s_id = InetAddress.getLocalHost().toString();
		}
		catch( UnknownHostException ex )
		{
			ex.printStackTrace();
		}
	}
	
	public RandomGUID() 
	{
		getRandomGUID(false);
	}


	public RandomGUID(boolean secure) 
	{
		getRandomGUID(secure);
	}
	
	private void getRandomGUID( boolean secure )
	{
		MessageDigest md5 = null;
		StringBuffer sbValueBeforeMD5 = new StringBuffer();
		
		try
		{
			md5 = MessageDigest.getInstance("MD5");
		}
		catch( NoSuchAlgorithmException ex )
		{
			ex.printStackTrace();
		}
		
		try
		{
			long time = System.currentTimeMillis();
			long rand = 0;
			
			if( secure )
			{
				rand = secureRandom.nextLong();
			}
			else
			{
				rand = random.nextLong();
			}
			
			sbValueBeforeMD5.append( s_id );
			sbValueBeforeMD5.append( Long.toString( time ) );
			sbValueBeforeMD5.append( Long.toString( rand ) );
			
			valueBeforeMD5 = sbValueBeforeMD5.toString();
			md5.update(valueBeforeMD5.getBytes());
			
			byte[] array = md5.digest();
			StringBuffer sb = new StringBuffer();
			for (int j = 0; j < array.length; ++j) 
			{
				int b = array[j] & 0xFF;
				if (b < 0x10) 
					sb.append('0');
				sb.append(Integer.toHexString(b));
			}

			valueAfterMD5 = sb.toString();
		}
		catch( Exception ex )
		{
			ex.printStackTrace();
		}
	}
	
	@Override
	public String toString()
	{
		String raw = valueAfterMD5.toUpperCase();		
		return raw;
	}

}
