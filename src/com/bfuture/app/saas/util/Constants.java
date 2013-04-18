package com.bfuture.app.saas.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bfuture.app.saas.model.SmsSend;

import sun.misc.BASE64Encoder;

public class Constants {
	
	public static final int MESSAGE_DATE = -1;
	
	public static final String SMS_ACCOUNT_USERNAME = "fjbsyd";
	
	public static final String SMS_ACCOUNT_PASSWORD = "123456";
	
	//经营方式
	public static final String JX = "J";
	
	public static final String DX = "D";
	
	public static final String LX = "L";
	
	public static final String ZX = "Z";
	
	
	public static final String UPLOAD_ABSOLUTE_PATH = "uploadPath_" + (File.separator.equals( "\\" ) ? "window" : "linux");
	
	// 图片保存的物理路径(FileImgUrl)
	// 图片访问的虚拟路径(HttpImgUrl)
	public static final String FileImgUrl = ProReader.getInstance().getProperty("fileimgurl");
	public static final String HttpImgUrl = ProReader.getInstance().getProperty("httpimgurl");
	// 促销申请表的上传路径
	public static final String PromotionApplUrl = ProReader.getInstance().getProperty("promotionApplUrl");
	
	
	/** *//**利用MD5进行加密
     * @param str   待加密的字符串
     * @return   加密后的字符串
     * @throws NoSuchAlgorithmException   没有这种产生消息摘要的算法
     * @throws UnsupportedEncodingException  
     */
     public static String EncoderByMd5(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException{
         //确定计算方法
         MessageDigest md5=MessageDigest.getInstance("MD5");
         BASE64Encoder base64en = new BASE64Encoder();
         //加密后的字符串
         String newstr=base64en.encode(md5.digest(str.getBytes("utf-8")));
         return newstr.toLowerCase().replace('/', '0').replace('=', '0').replace('+', '0');
     }
     
     public static void main(String[] args) throws NoSuchAlgorithmException,
     UnsupportedEncodingException, Exception {
    	 
//    	 // 数组操作
//    	 
//    	 // 加密
//    	 String str = EncoderByMd5("606_gys_这个是中文证件的通知信息"); //12345为密码
//		 System.out.println(str);
//		 
//		 // 截取
//		 String fileName = "123456.jpg";
//		 System.out.println("要文件名称：" + fileName.substring(0,fileName.indexOf(".")));
//		 
//		 String tempString = "尊敬的0001470供应商，您2012年02月23日在xxx(零售商的名称)超市所有门店门店销售额是￥465.47元，本月截止23日，您的应收账款为￥3438.30元。";
		 String tempString = "尊敬的供应商，供应链管理系统的登录网址为www.bfuture.com.cn，您的用户名：000000，密码：00000，如有疑问请联系北京富基标商流通信息科技有限公司客服(010)5128-3636。";
		 System.out.println("tempString.length(): " + tempString.length());
		 
//		  发送
		 SmsSend smsSend = new SmsSend();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			smsSend.setSgcode("606");	//实例编码[*]
			smsSend.setCustomid(42);	//外键（定制表id）
			smsSend.setLsrname("张三");	//联系人
			smsSend.setMobile("13886166320");//手机号[*] 
			smsSend.setSendcontent(tempString);//内容[*]
			smsSend.setSender("张三");	//发送者[*]
			smsSend.setSendtime(sdf.parse(sdf.format(new Date())));//发送时间[*]
			smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
			smsSend.setMessagetype(5);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
			smsSend.setShopid("21011");	//门店编号
			smsSend.setShopname("百货大楼");//门店名称
			smsSend.setSendstates(1);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
			smsSend.setCreatecode("0001470");//创建者编码
			smsSend.setCreatename("李宁");	//创建者名称
			smsSend.setCreatedate(sdf.parse(sdf.format(new Date())));//创建时间

			System.out.println("短信发送开始");
		 int result = sendMessage(smsSend);
		 System.out.println("结果： " + result);
		 System.out.println("短信发送结束！！！");

     }
     
 	// 短信发送部分===================================
 	public static int sendMessage(SmsSend message) 
 	{		
 	    int result = 0; // 返回结果状态
 		try 
 		{
 			if (message.getMobile() != null)
 			{
 				if (message.getMobile().startsWith("13") || message.getMobile().startsWith("15") || message.getMobile().startsWith("18"))
 				{
 					List contentList = new ArrayList();
 					String messageContent = message.getSendcontent();
 					while (messageContent.length() > 56)
 			        {
 						contentList.add(messageContent.substring(0, 56) + "(待续)");
 			        	messageContent = messageContent.substring(56,messageContent.length());
 			        }
 					contentList.add(messageContent);
 					for (int i=0;i<contentList.size();i++)
 					{
 						System.out.println(contentList.get(i).toString());
 						System.out.println(contentList.get(i).toString().length());
 						
 						URL url = new URL("http://sms.mobsms.net/send/g70send.aspx?name=" + SMS_ACCOUNT_USERNAME + "&pwd=" + SMS_ACCOUNT_PASSWORD + "&dst=" + message.getMobile() + "&msg=" + java.net.URLEncoder.encode((String)contentList.get(i), "GBK"));						
 						URLConnection connection = url.openConnection();
 						connection.connect();
 						//accountDAO.setAccount(message.getSupid());
 					    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
 					    String line = in.readLine();
 					    System.out.println(line); // num=1&success=13810007777,&faile=&err=发送成功&errid=0
 					    line = line.substring(line.indexOf("num=")+4,line.indexOf("&s"));
 					    in.close(); 
 						if ("1".equals(line))
 						{
 							result = 1; // 发送成功
 						}
 						else
 						{
 							result  = 2;
 						}						
 					}		
 					System.out.println("内容：" + message.getSendcontent());
 				}				
 			}			
 		}
 		catch (Exception ex) 
 		{
 			ex.printStackTrace();
 			return 3;
 		
 		}
 	    System.out.println("sending !!!");
 		return result;
 	}




	
}
