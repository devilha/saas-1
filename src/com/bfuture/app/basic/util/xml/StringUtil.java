package com.bfuture.app.basic.util.xml;

import java.util.StringTokenizer;

public class StringUtil {
		
	public static boolean isBlank(String principal) {
		// TODO Auto-generated method stub
		return (principal==null)||(principal.equals(""));
	}
	
	public static String nullToBlank(Object obj) {
		return obj != null ? obj.toString().trim() : "";
	}
	
	/**
	 * 字符串分割
	 * 
	 * @author 丁元
	 * @param str
	 *            java.lang.String 要分割的字符串
	 * @param sp
	 *            java.lang.String 需要被替换的子串
	 * @return 替换之后的字符串
	 * @return 分割失败，返回null
	 */
	public static String[] Split(String str, String sp) {
		StringTokenizer st = new StringTokenizer(str, sp);
		String strSplit[];
		try {
			int stLength = st.countTokens();// 获取分割后的数量
			if (stLength < 1) {
				return null;
			}
			strSplit = new String[stLength];
			int i = 0;
			while (st.hasMoreTokens()) {
				strSplit[i] = st.nextToken().toString();
				i++;
			}
		} catch (Exception e) {
			return null;
		}
		return strSplit;
	}
}
