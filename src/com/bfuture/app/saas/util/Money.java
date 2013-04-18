/*
 * Created on 2008-3-31
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.bfuture.app.saas.util;
/**
 * @author x61
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class Money 
{
	//中文金额单位数组
	static String[] straChineseUnit = new String[] {"分", "角", "元", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟"};
	//中文数字字符数组
	static String[] straChineseNumber = new String[] {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"};

	/**
	* Description   将数字金额转换为中文金额
	* @param        <p>BigDecimal bigdMoneyNumber 转换前的数字金额</P>
	* @return       String
	调用：myToChineseCurrency("101.89")="壹佰零壹圆捌角玖分"
	myToChineseCurrency("100.89")="壹佰零捌角玖分"
	myToChineseCurrency("100")="壹佰圆整"
	*/
	public static String DoNumberCurrencyToChineseCurrency(Double bigdMoneyNumber) 
	{
		String strChineseCurrency = "";
		//零数位标记
		boolean bZero = true;
		//中文金额单位下标
		int ChineseUnitIndex = 0;

		try 
		{
			if (bigdMoneyNumber.intValue() == 0)
				return "零元零角零分";

			//处理小数部分，四舍五入
			double doubMoneyNumber = Math.round(bigdMoneyNumber.doubleValue() * 100);

			//是否负数
			boolean bNegative = doubMoneyNumber < 0;

			//取绝对值
			doubMoneyNumber = Math.abs(doubMoneyNumber);

			//循环处理转换操作
			while (doubMoneyNumber > 0) 
			{
				//整的处理(无小数位)
				if (ChineseUnitIndex == 2 && strChineseCurrency.length() == 0)
					strChineseCurrency = strChineseCurrency + "整";

				//非零数位的处理
				if (doubMoneyNumber % 10 > 0) 
				{
					strChineseCurrency = straChineseNumber[(int)doubMoneyNumber % 10] + straChineseUnit[ChineseUnitIndex] + strChineseCurrency;
					bZero = false;
				}
				//零数位的处理
				else 
				{
					//元的处理(个位)
					if (ChineseUnitIndex == 2 ) 
					{
						//段中有数字
						if (doubMoneyNumber > 0) 
						{
							strChineseCurrency = straChineseUnit[ChineseUnitIndex] + strChineseCurrency;
							bZero = true;
						}
					}
					//万、亿数位的处理
					else if (ChineseUnitIndex == 6 || ChineseUnitIndex == 10) 
					{
						//段中有数字
						if (doubMoneyNumber % 1000 > 0)
							strChineseCurrency = straChineseUnit[ChineseUnitIndex] + strChineseCurrency;
					}

					//前一数位非零的处理
					if (!bZero)
						strChineseCurrency = straChineseNumber[0] + strChineseCurrency;

					bZero = true;
				}

				doubMoneyNumber = Math.floor(doubMoneyNumber / 10);
				ChineseUnitIndex ++;
			}

			//负数的处理
			if (bNegative)
				strChineseCurrency = "负" + strChineseCurrency;
		}
		catch (Exception e) 
		{
			
			e.printStackTrace();

			return "";
		}

		return strChineseCurrency;
	}
 	
 	public static void main(String[] args)
 	{
 		String ss = DoNumberCurrencyToChineseCurrency(new Double(123456.09));
 		System.err.println(ss);
 	}
}