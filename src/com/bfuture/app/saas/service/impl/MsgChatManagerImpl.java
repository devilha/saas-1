package com.bfuture.app.saas.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.MsgChat;
import com.bfuture.app.saas.service.MsgChatManager;
/**
 * 采购洽淡(MSG_CHAT)
 * @author chenjw
 * 2012-02-02
 */
public class MsgChatManagerImpl extends BaseManagerImpl implements MsgChatManager {

	protected final Log log = LogFactory.getLog(MsgChatManagerImpl.class);
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public MsgChatManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if( "SearchMsgChat".equals( actionType ) ){
			result = SearchMsgChat(o);  
		}else if( "AddMsgChat".equals( actionType ) ){
			result = AddMsgChat(o);
		}else if( "DelMsgChat".equals( actionType ) ){
			result = DelMsgChat(o);
		}else if( "UpdMsgChat".equals( actionType ) ){
			result = UpdMsgChat(o);
		}else if( "LoadMsgChatById".equals( actionType ) ){
			result = LoadMsgChatById(o);
		}else if( "UpdMsgChatReaded".equals( actionType ) ){
			result = UpdMsgChatReaded(o);
		}
		
		return result;
	}
	
	/**
	 * 添加方法(导入批量添加方法调用)
	 */
	public void InsertMsgChat(MsgChat msgChat) {
		try {
			dao.saveEntity(msgChat);
		} catch (Exception e) {
			log.error("MsgChatManagerImpl.InsertMsgChat() error:" + e.getMessage());
		}
	}
	
	/**
	 * 执行添加(这个方法暂时不用了，由导入批量添加方法代替)
	 * @param o
	 * @return
	 */
	public ReturnObject AddMsgChat(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				MsgChat msgChat = (MsgChat)o[0];
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
//				msgChat.setIns_c("606");		// 实例编码【页面】
//				msgChat.setTitle("标题内容");		// 标题【页面获取】
				msgChat.setContent("content");  // 内容【页面获取】
				msgChat.setCat_id("1002001");	// 类别编码
//				msgChat.setCat_name("类别名称");	// 类别名称【页面获取】
				msgChat.setPp_id("10201");		// 品牌编码
//				msgChat.setPp_name("品牌名称");	// 品牌名称【页面获取】
				msgChat.setShop_id("21011");	// 门店编码
//				msgChat.setShop_name("门店名称");	// 门店名称【页面获取】
//				msgChat.setCrt_by_c("000147");	// 创建人【页面】
//				msgChat.setCrt_by_cn("张三");	// 创建人名称【页面】
				msgChat.setCrt_by_time(sdf.parse(sdf.format(new Date())));// 创建时间
				msgChat.setRe_by_c("0001471");	// 接收人
				msgChat.setRe_by_cn("李英");		// 接收人名称
//				msgChat.setRe_by_time(sdf.parse("2012-02-11"));// 回复时间
				msgChat.setRe_flag("0");		// 回复标识 回复意见（0=未处理；1=同意；2=不同意）
//				msgChat.setRe_memo("回复备注");	// 回复备注
				msgChat.setEmail_flag("0");		// 邮件标识(0=未读取；1=已读取；2=已回复)
				
				
				log.info("添加-url：" + msgChat.getEmail_fjname()); // 下载地址====(这个需要做处理)
				
				String serverPicName = msgChat.getIns_c() + msgChat.getCrt_by_c() + msgChat.getEmail_fjname().substring(0,msgChat.getEmail_fjname().indexOf("."));
				
				log.info("添加-文件名称：" + serverPicName);
				
				String serverPicNameMD5 = com.bfuture.app.saas.util.Constants.EncoderByMd5(serverPicName);
				
				log.info("添加-md5加密文件名称： " + serverPicNameMD5);
				
				String picend = msgChat.getEmail_fjname().substring(msgChat.getEmail_fjname().indexOf(".")); // 文件后缀
				
				String name = msgChat.getIns_c() +"_"+ msgChat.getCrt_by_c() +"_"+ serverPicNameMD5 + picend;
				log.info("添加-最终的文件名：" + name);
				
				msgChat.setEmail_url(name); // 邮件附件url[服务器端存放的文件名]
//				msgChat.setEmail_fjname("这个是附件的原始标题");// 附件的名字【页面获取】
				
				dao.saveEntity(msgChat); 		// 添加操作
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("MsgChatManagerImpl.AddMsgChat() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行删除
	 * @param o
	 * @return
	 */
	public ReturnObject DelMsgChat(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				MsgChat msgChat = null;
				String fileName = null;
				File file = null;
				
				if( o != null && o.length > 0 ){
					for( Object obj : o ){
						msgChat = (MsgChat)obj;
						
						StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.MsgChat mc where 1=1 " );
						hql.append( " and mc.id = " ).append( msgChat.getId() );
						
						List lstResult = dao.executeHql( hql.toString() );
						if( lstResult != null && lstResult.size() > 0){
							MsgChat chat = (MsgChat)lstResult.get(0);
							fileName = chat.getEmail_url();
							remove( lstResult.toArray() );  // 这里执行删除操作
						}
						
						// 执行一个附件的删除操作
						file = new File( com.bfuture.app.saas.util.Constants.FileImgUrl + fileName);
						if(file.exists()) {
							file.delete();
						}
					}
				}
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
				
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("MsgChatManagerImpl.DelMsgChat() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改(回复操作)
	 * @param o
	 * @return
	 */
	public ReturnObject UpdMsgChat(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				MsgChat msgChat = (MsgChat)o[0];
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				List lstResult = dao.executeSql("select * from MSG_CHAT mc where id = " + msgChat.getId());
				
				Map resMap = (Map)lstResult.get(0);
				
				// 将map 中的一条数据，填充到msgChat 对象中 ************************
				msgChat.setId(new Integer(resMap.get("ID").toString()));// ID 
				msgChat.setIns_c(resMap.get("INS_C").toString());// 实例编码
				msgChat.setTitle(resMap.get("TITLE").toString());// 标题
				msgChat.setContent(getMapStringValue(resMap.get("CONTENT"))); // 内容
				msgChat.setCat_id(resMap.get("CAT_ID").toString());// 类别编码
				msgChat.setCat_name(resMap.get("CAT_NAME").toString());// 类别名称
				msgChat.setPp_id(resMap.get("PP_ID").toString());// 品牌编码
				msgChat.setPp_name(resMap.get("PP_NAME").toString());	// 品牌名称
				msgChat.setShop_id(resMap.get("SHOP_ID").toString());// 门店编码
				msgChat.setShop_name(resMap.get("SHOP_NAME").toString());// 门店名称
				msgChat.setCrt_by_c(resMap.get("CRT_BY_C").toString());// 创建人 
				msgChat.setCrt_by_cn(resMap.get("CRT_BY_CN").toString());// 创建人名称
				msgChat.setCrt_by_time(sdf.parse(resMap.get("CRT_BY_TIME").toString()));// 创建时间
				msgChat.setRe_by_c(resMap.get("RE_BY_C").toString());// 接收人
				msgChat.setRe_by_cn(resMap.get("RE_BY_CN").toString());// 接收人名称
				msgChat.setEmail_url(resMap.get("EMAIL_URL").toString());// 邮件附件url
				msgChat.setEmail_fjname(resMap.get("EMAIL_FJNAME").toString());// 邮件附件标题
				
				if(null != msgChat.getRe_flag() && !"".equals(msgChat.getRe_flag())){ // 回复了
					msgChat.setEmail_flag("2");									// 邮件标识(0=未读取；1=已读取；2=已回复)
					msgChat.setRe_by_time(sdf.parse(sdf.format(new Date())));	// 回复时间
					
//					msgChat.setRe_flag(resMap.get("RE_FLAG").toString());		 // 【页面获取】回复标识 回复意见（0=未处理；1=同意；2=不同意）
//					msgChat.setRe_memo(getMapStringValue(resMap.get("RE_MEMO")));// 【页面获取】回复备注
				}else { // 未回复(原样获取)
					msgChat.setEmail_flag(resMap.get("EMAIL_FLAG").toString());			// 邮件标识(0=未读取；1=已读取；2=已回复)
					msgChat.setRe_by_time(sdf.parse(resMap.get("RE_BY_TIME").toString()));// 回复时间
					msgChat.setRe_flag(resMap.get("RE_FLAG").toString());				// 回复标识 回复意见（0=未处理；1=同意；2=不同意）
					msgChat.setRe_memo(getMapStringValue(resMap.get("RE_MEMO")));		// 回复备注
				}
				
				dao.updateEntity(msgChat); // 执行修改 
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("MsgChatManagerImpl.UpdMsgChat() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改(已读操作)
	 * @param o
	 * @return
	 */
	public ReturnObject UpdMsgChatReaded(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				MsgChat msgChat = (MsgChat)o[0];
				
				dao.updateSql( "update MSG_CHAT set email_flag = '1' where id = " + msgChat.getId() );
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("MsgChatManagerImpl.UpdMsgChatReaded() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	// 避免空指针
	public String getMapStringValue(Object object){
		if(object != null)
			return object.toString();
		else
			return "";
	}
	
	/**
	 * 执行加载一条
	 * @param o
	 * @return
	 */
	public ReturnObject LoadMsgChatById(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				MsgChat msgChat = (MsgChat)o[0];
				
				log.info("load id: " + msgChat.getId());
				
				List lstResult = dao.executeSql("select * from MSG_CHAT mc where id = " + msgChat.getId());
				
				result.setRows(lstResult);
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("MsgChatManagerImpl.LoadMsgChatById() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行查询
	 * @param o
	 * @return
	 */
	public ReturnObject SearchMsgChat(Object[] o) {
		ReturnObject result = new ReturnObject();
		
		try{
			MsgChat mc = (MsgChat)o[0];
			
			StringBuffer countSql = new StringBuffer( "select count(*) from MSG_CHAT mc where 1 = 1 " );
			
			if( !StringUtil.isBlank( mc.getTitle() )){ 	// 标题
				countSql.append( " and mc.TITLE like '%" ).append( mc.getTitle() ).append("%'");
			}
			if( !StringUtil.isBlank( mc.getPp_name() ) ){ // 品牌名称
				countSql.append( " and mc.PP_NAME = '" ).append( mc.getPp_name() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getShop_name() ) ){ // 门店名称
				countSql.append( " and mc.SHOP_NAME like '%" ).append( mc.getShop_name() ).append("%'");
			}
			
			if( !StringUtil.isBlank( mc.getRe_flag() ) ){ // 回复标识 回复意见（0=未处理；1=同意；2=不同意）
				countSql.append( " and mc.RE_FLAG = '" ).append( mc.getRe_flag() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getCat_name() ) ){ // 类别名称
				countSql.append( " and mc.CAT_NAME = '" ).append( mc.getCat_name() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getCrt_by_c() ) ){ // 创建人 
				countSql.append( " and mc.crt_by_c = '" ).append( mc.getCrt_by_c() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getRe_by_c() ) ){ // 收件人 
				countSql.append( " and mc.re_by_c = '" ).append( mc.getRe_by_c() ).append("'");
			}
			
			List lstResult = dao.executeSql( countSql.toString() );
			log.info("lstResult 1 :" + lstResult);
			log.info("lstResult.size() 1 :" + lstResult.size());
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( ((Map)lstResult.get(0)).get("COUNT(*)").toString() ) );
			}
			
			StringBuffer sql = new StringBuffer( "select * from MSG_CHAT mc where 1 = 1 " );
			
			int limit = mc.getRows();
			int start = ( mc.getPage() - 1) * mc.getRows() ;
			
			if( !StringUtil.isBlank( mc.getTitle() )){ 	// 标题
				sql.append( " and mc.TITLE like '%" ).append( mc.getTitle() ).append("%'");
			}
			if( !StringUtil.isBlank( mc.getPp_name() ) ){ // 品牌名称
				sql.append( " and mc.PP_NAME = '" ).append( mc.getPp_name() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getShop_name() ) ){ // 门店名称
				sql.append( " and mc.SHOP_NAME like '%" ).append( mc.getShop_name() ).append("%'");
			}
			
			if( !StringUtil.isBlank( mc.getRe_flag() ) ){ // 回复标识 回复意见（0=未处理；1=同意；2=不同意）
				sql.append( " and mc.RE_FLAG = '" ).append( mc.getRe_flag() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getCat_name() ) ){ // 类别名称
				sql.append( " and mc.CAT_NAME = '" ).append( mc.getCat_name() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getCrt_by_c() ) ){ // 创建人 
				sql.append( " and mc.crt_by_c = '" ).append( mc.getCrt_by_c() ).append("'");
			}
			if( !StringUtil.isBlank( mc.getRe_by_c() ) ){ // 收件人 
				sql.append( " and mc.re_by_c = '" ).append( mc.getRe_by_c() ).append("'");
			}
			
			if( mc.getOrder() != null && mc.getSort() != null ){
				sql.append( " order by " ).append( mc.getSort() ).append( " " ).append( mc.getOrder() );
			}else{
				sql.append( " order by ID desc " );
			}
			
			lstResult = dao.executeSql( sql.toString(), start, limit );
			log.info("lstResult 2 :" + lstResult);
			log.info("lstResult.size() 2 :" + lstResult.size());
			if( lstResult != null ){
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstResult );
			}
			
		}catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			log.error("MsgChatManagerImpl.SearchMsgChat() error:" + ex.getMessage());
		}
		
		return result;
	}
	
	
}
