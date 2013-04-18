package com.bfuture.app.saas.service.impl;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.SmsCustom;
import com.bfuture.app.saas.model.SmsSend;
import com.bfuture.app.saas.service.SmsCustomManager;
/**
 * 短信定制(SMS_CUSTOM)
 * @author chenjw
 * 2012-02-16
 */
public class SmsCustomManagerImpl extends BaseManagerImpl implements SmsCustomManager {

	protected final Log log = LogFactory.getLog(ShopInfoManagerImpl.class);
	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public SmsCustomManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	
	private Map<String, String> sgcodetoname;
	
	public void setSgcodetoname(Map<String, String> sgcodetoname) {
		this.sgcodetoname = sgcodetoname;
	}

	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if ("SeaSmsCustom".equals(actionType)) {
			result = SeaSmsCustom(o);
		}else if ("DelSmsCustom".equals(actionType)) {
			result = DelSmsCustom(o);
		}else if ("AddSmsCustom".equals(actionType)) {
			result = AddSmsCustom(o);
		}else if ("UpdSmsCustom".equals(actionType)) {
			result = UpdSmsCustom(o);
		}else if ("UpdOKSmsCustom".equals(actionType)) {
			result = UpdOKSmsCustom(o);
		}else if ("UpdNOSmsCustom".equals(actionType)) {
			result = UpdNOSmsCustom(o);
		}else if ("UpdSmsCustomInf".equals(actionType)) {
			result = UpdSmsCustomInf(o);
		}else if ("AddSmsSend".equals(actionType)) {
			result = AddSmsSend(o);
		}
		return result;
	}
	
	/**
	 * 执行添加[by供应商]
	 * @param o
	 * @return
	 */
	public ReturnObject AddSmsCustom(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
//				private String shopid; 		//门店编码 【页面】【注：所有门店就发送一个总额】
//				private String shopname; 	//门店名称 【页面】
//				private String customtype; 	//短信类型 【页面】（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
//				private String mobile; 		//手机号码 【页面】
//				private String lsrname; 	//联系人   【页面】
//				private String states; 		//状态 【默认初始】（1.可用 2.停用）
				smsCustom.setStates("2");
//				private Date customdate; 	//定制使用期限时间【默认初始】 
//				smsCustom.setCustomdate(null);
//				private String crecode; 	//创建者编码(登录编号)【页面】
//				private String crename; 	//创建者名称【页面】
//				private Date credate; 		//创建时间【系统】
				smsCustom.setCredate(sdf.parse(sdf.format(new Date())));
//				private String sgcode;		//实例编码【页面】
//				private String supcode;		//供应商编码【页面】
				
				dao.saveEntity(smsCustom); // 添加操作
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.AddSmsCustom() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行删除[byAll]
	 * @param o
	 * @return
	 */
	public ReturnObject DelSmsCustom(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				
				StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.SmsCustom sc where 1=1 " );
				hql.append( " and sc.id = " ).append( smsCustom.getId() );
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){					
					remove( lstResult.toArray() );  // 这里执行删除操作
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.DelSmsCustom() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改[by供应商]
	 * @param o
	 * @return
	 */
	public ReturnObject UpdSmsCustom(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				
				SmsCustom newSmsCustom = new SmsCustom();
				ReturnObject reObject = SeaSmsCustom(new Object[]{new SmsCustom(smsCustom.getId())});
				if(null != reObject){
					newSmsCustom = (SmsCustom)reObject.getRows().get(0);
					newSmsCustom.setLsrname(smsCustom.getLsrname()); //更新联系人
					newSmsCustom.setMobile(smsCustom.getMobile());   //更新手机号
				}
				
				dao.updateEntity(newSmsCustom); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.UpdSmsCustom() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改[by客服]
	 * @param o
	 * @return
	 */
	public ReturnObject UpdSmsCustomInf(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				SmsCustom newSmsCustom = new SmsCustom();
				ReturnObject reObject = SeaSmsCustom(new Object[]{new SmsCustom(smsCustom.getId())});
				if(null != reObject){
					newSmsCustom = (SmsCustom)reObject.getRows().get(0);
					
					newSmsCustom.setLsrname(smsCustom.getLsrname()); 		// 联系人
					newSmsCustom.setMobile(smsCustom.getMobile());   		// 手机号
					newSmsCustom.setCustomtype(smsCustom.getCustomtype()); 	// 定制类型
					newSmsCustom.setShopname(smsCustom.getShopname()); 		// 门店名称
					newSmsCustom.setShopid(smsCustom.getShopid()); 			// 门店编号
					if(null != smsCustom.getTemp_customdate() && !"".equals(smsCustom.getTemp_customdate())){
						newSmsCustom.setCustomdate(sdf.parse(smsCustom.getTemp_customdate())); // 截止时间
					}
				}
				
				dao.updateEntity(newSmsCustom); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.UpdSmsCustomInf() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改(启用)[by客服]
	 * @param o
	 * @return
	 */
	public ReturnObject UpdOKSmsCustom(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				SmsCustom newSmsCustom = new SmsCustom();
				ReturnObject reObject = SeaSmsCustom(new Object[]{new SmsCustom(smsCustom.getId())});
				if(null != reObject){
					newSmsCustom = (SmsCustom)reObject.getRows().get(0);
					newSmsCustom.setCustomdate(sdf.parse(smsCustom.getTemp_customdate())); // 有效截止时间
				}
				
				dao.updateEntity(newSmsCustom); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.UpdOKSmsCustom() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改(禁用)[by客服]
	 * @param o
	 * @return
	 */
	public ReturnObject UpdNOSmsCustom(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				
				SmsCustom newSmsCustom = new SmsCustom();
				ReturnObject reObject = SeaSmsCustom(new Object[]{new SmsCustom(smsCustom.getId())});
				if(null != reObject){
					newSmsCustom = (SmsCustom)reObject.getRows().get(0);
					newSmsCustom.setCustomdate(null); // 有效截止时间
				}
				
				dao.updateEntity(newSmsCustom); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.UpdNOSmsCustom() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行查询[byAll]
	 * @param o
	 * @return
	 */
	public ReturnObject SeaSmsCustom(Object[] o) {
			ReturnObject result = new ReturnObject();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try{
				SmsCustom smsCustom = (SmsCustom)o[0];
				
				StringBuffer countHql = new StringBuffer( "select count(*) from com.bfuture.app.saas.model.SmsCustom sc where 1 = 1" );			
				
				if(null != smsCustom.getSgcode() && !"".equals(smsCustom.getSgcode())){
					countHql.append( " and sc.sgcode = '" ).append( smsCustom.getSgcode() ).append( "'" );
				}
				if(null != smsCustom.getCrecode() && !"".equals(smsCustom.getCrecode())){
					countHql.append( " and sc.crecode = '" ).append( smsCustom.getCrecode() ).append( "'" );
				}
				if(null != smsCustom.getId()){
					countHql.append( " and sc.id = " ).append( smsCustom.getId() );
				}
				if(null != smsCustom.getCrename() && !"".equals(smsCustom.getCrename())){
					countHql.append( " and sc.crename like '%" ).append( smsCustom.getCrename() ).append( "%'" );
				}
				if(null != smsCustom.getCustomtype() && !"".equals(smsCustom.getCustomtype()) && !"0".equals(smsCustom.getCustomtype())){
					countHql.append( " and sc.customtype = '" ).append( smsCustom.getCustomtype() ).append( "'" );
				}
				if( null != smsCustom.getStates() && !"".equals(smsCustom.getStates()) && !"0".equals(smsCustom.getStates())){ //（1.未开通 2.有效 3.过期）
					if("1".equals(smsCustom.getStates())){ // 1.未开通
						countHql.append( " and sc.customdate is null" );
					}else if ("2".equals(smsCustom.getStates())) { // 2.有效
						countHql.append( " and sc.customdate >= to_date('" ).append( sdf.format(new Date()) ).append("','yyyy-MM-dd')");
					}else if ("3".equals(smsCustom.getStates())) {// 3.过期
						countHql.append( " and sc.customdate < to_date('" ).append( sdf.format(new Date()) ).append("','yyyy-MM-dd')");
					}
				}
				
				List lstResult = dao.executeHql( countHql.toString() );
				if( lstResult != null ){
					result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
					log.info("lstResult: " + lstResult);
				}
				
				StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.SmsCustom sc where 1 = 1" );
				int limit = smsCustom.getRows();
				int start = ( smsCustom.getPage() - 1) * smsCustom.getRows() ;
				
				if(null != smsCustom.getSgcode() && !"".equals(smsCustom.getSgcode())){
					hql.append( " and sc.sgcode = '" ).append( smsCustom.getSgcode() ).append( "'" );
				}
				if(null != smsCustom.getCrecode() && !"".equals(smsCustom.getCrecode())){
					hql.append( " and sc.crecode = '" ).append( smsCustom.getCrecode() ).append( "'" );
				}
				if(null != smsCustom.getId()){
					hql.append( " and sc.id = " ).append( smsCustom.getId() );
				}
				if(null != smsCustom.getCrename() && !"".equals(smsCustom.getCrename())){
					hql.append( " and sc.crename like '%" ).append( smsCustom.getCrename() ).append( "%'" );
				}
				if(null != smsCustom.getCustomtype() && !"".equals(smsCustom.getCustomtype()) && !"0".equals(smsCustom.getCustomtype())){
					hql.append( " and sc.customtype = '" ).append( smsCustom.getCustomtype() ).append( "'" );
				}
				if( null != smsCustom.getStates() && !"".equals(smsCustom.getStates()) && !"0".equals(smsCustom.getStates())){ //（1.未开通 2.有效 3.过期）
					if("1".equals(smsCustom.getStates())){ // 1.未开通
						hql.append( " and sc.customdate is null" );
					}else if ("2".equals(smsCustom.getStates())) { // 2.有效
						hql.append( " and sc.customdate >= to_date('" ).append( sdf.format(new Date()) ).append("','yyyy-MM-dd')");
					}else if ("3".equals(smsCustom.getStates())) {// 3.过期
						hql.append( " and sc.customdate < to_date('" ).append( sdf.format(new Date()) ).append("','yyyy-MM-dd')");
					}
				}

				if( smsCustom.getOrder() != null && smsCustom.getSort() != null ){
					hql.append( " order by " ).append( smsCustom.getSort() ).append( " " ).append( smsCustom.getOrder() );
				}else{
					hql.append( " order by id desc" ); // 默认按id倒序加载
				}
				
				lstResult = dao.executeHql( hql.toString(), start, limit );
				if( lstResult != null ){
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
					log.info("lstResult1: " + lstResult);
				}
				
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.SeaSmsCustom() error:" + ex.getMessage());
			}
			
			return result;
	}
	
	// 短信记录保存部分=====================================================================
	/**
	 * 执行添加[记录发送的短信]
	 * @param o
	 * @return
	 */
	public ReturnObject AddSmsSend(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				SmsSend smsSend = (SmsSend)o[0];
//				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				// 测试填充内容
//				smsSend.setSgcode("606");	//实例编码[*]
//				smsSend.setCustomid(42);	//外键（定制表id）
//				smsSend.setLsrname("张三");	//联系人
//				smsSend.setMobile("13810007777");//手机号[*]
//				smsSend.setSendcontent("这个是发送的短息内容");//内容[*]
//				smsSend.setSender("张三");	//发送者[*]
//				smsSend.setSendtime(sdf.parse(sdf.format(new Date())));//发送时间[*]
//				smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
//				smsSend.setMessagetype(5);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
//				smsSend.setShopid("21011");	//门店编号
//				smsSend.setShopname("百货大楼");//门店名称
//				smsSend.setSendstates(1);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
//				smsSend.setCreatecode("0001470");//创建者编码
//				smsSend.setCreatename("李宁");	//创建者名称
//				smsSend.setCreatedate(sdf.parse(sdf.format(new Date())));//创建时间
				
				dao.saveEntity(smsSend); // 添加操作
				
				log.info("短信添加操作完成！！！");
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SmsCustomManagerImpl.AddSmsSend() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	// 数据查询部分=======================================================================
	SimpleDateFormat sdf_l = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf_zh = new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat sdf_zh_l = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
	SimpleDateFormat sdf_dd = new SimpleDateFormat("dd");
	
	/**
	 * 获取数据 【1】.定制销售日/月报(每天定时)
	 * @param o
	 * @return 销售日/月报：尊敬的xxx(供应商编码)供应商，您2012年2月21日在xxx(零售商的名称)超市xx门店销售额是￥4000.00元，本月截止21日，您的应收账款为￥15,000.00元。【富基标商】
	 */
	public List<SmsSend> getXSRYB() {
		
		DecimalFormat df = new DecimalFormat("#.00"); 
		
		List<SmsSend> sendList = new ArrayList<SmsSend>();
		SmsSend smsSend;
		
		List customList = getSmsCustom("1"); // 获取定制[销售日/月报]定制列表
		
		SmsCustom smsCustom;
		String sendmessage; // 消息内容
		Double xse = new Double(0);// 销售额
		Double yszk = new Double(0);// 应收账款
		for (int i = 0; i < customList.size(); i++) {
			smsCustom = (SmsCustom) customList.get(i);
			
			log.info("实例编码：" + smsCustom.getSgcode());
			log.info("供应商编号：" + smsCustom.getSupcode());
			log.info("门店名称：" + smsCustom.getShopname());
			log.info("手机号码：" + smsCustom.getMobile());
			
			List lstResult = null;
														// 返回：日期 销售数量 含税进价金额 销售收入
			StringBuffer sql = new StringBuffer( "SELECT to_char(GSRQ,'YYYY-MM-DD') GSRQ,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE where 1=1 " );
			sql.append(" and gssgcode = '").append( "606" ).append("'");// 实例编码
			sql.append(" and gssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql.append(" and gsmfid= '").append( "0001" ).append("'");// 门店编码
			sql.append(" and gsrq = to_date('").append( "2012-02-19" ).append("', 'yyyy-MM-dd')");// 日期
			sql.append(" group by to_char(GSRQ,'YYYY-MM-DD')");
			
			StringBuffer sql1 = new StringBuffer( "SELECT SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE where 1=1 " );
			sql1.append(" and gssgcode = '").append( "606" ).append("'");// 实例编码
			sql1.append(" and gssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql1.append(" and gsmfid= '").append( "0001" ).append("'");// 门店编码
			sql1.append(" and gsrq <= to_date('").append( "2012-02-19" ).append("', 'yyyy-MM-dd')");// 日期
			sql1.append(" and gsrq >= to_date('").append( "2012-02-01" ).append("', 'yyyy-MM-dd')");// 日期
			

			try {
				lstResult = dao.executeSql(sql.toString());
				log.info("lstResult: " + lstResult);
				log.info("lstResult1: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					xse = new Double( ((Map)lstResult.get(0)).get("GSHSJJJE").toString() );
				}
				
				lstResult = dao.executeSql(sql1.toString());
				log.info("lstResult2: " + lstResult);
				log.info("lstResult3: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					yszk = new Double( ((Map)lstResult.get(0)).get("GSHSJJJE").toString() );
				}
				
				sendmessage = "尊敬的"+smsCustom.getSupcode()+"供应商，您"+sdf_zh.format(new Date())+"在"+sgcodetoname.get(smsCustom.getSgcode())+"超市"+smsCustom.getShopname()+"门店销售额是￥"+df.format(xse)+"元，本月截止"+sdf_dd.format(new Date())+"日，您的应收账款为￥"+df.format(yszk)+"元。";
				
				log.info("1001: " + sgcodetoname.get("1001"));
				log.info("1002: " + sgcodetoname.get("1002"));
				log.info("1003: " + sgcodetoname.get("1003"));
				log.info("1004: " + sgcodetoname.get("1004"));
				
				smsSend = new SmsSend();
				smsSend.setSgcode(smsCustom.getSgcode());	//实例编码[*]
				smsSend.setCustomid(smsCustom.getId());	//外键（定制表id）
				smsSend.setLsrname(smsCustom.getLsrname());	//联系人
				smsSend.setMobile(smsCustom.getMobile());//手机号[*]
				smsSend.setSendcontent(sendmessage);//内容[*]
				smsSend.setSender("系统");	//发送者[*]
				smsSend.setSendtime(sdf_l.parse(sdf_l.format(new Date())));//发送时间[*]
				smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
				smsSend.setMessagetype(1);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
				smsSend.setShopid(smsCustom.getShopid());	//门店编号
				smsSend.setShopname(smsCustom.getShopname());//门店名称
				smsSend.setSendstates(0);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				smsSend.setCreatecode("system");//创建者编码
				smsSend.setCreatename("系统");	//创建者名称
				smsSend.setCreatedate(sdf_l.parse(sdf_l.format(new Date())));//创建时间
				
				sendList.add(smsSend); // 根据customList 中的每一条记录 循环查询，并填充sendList 集合
			} catch (Exception e) {
				log.error("SmsCustomManagerImpl.getXSRYB() error:" + e.getMessage());
			}
				
		}
		
		return sendList;
	}
	
	/**
	 * 获取数据 【2】.定制销售排行 (每天定时)
	 * @param o
	 * @return 销售排行：尊敬的xxx供应商，您2012年2月21日在xxx超市xx门店销售额是￥4000.00元，在全场同类商品销售中排第15名。【富基标商】
	 */
	public List<SmsSend> getXSPH() {
		
		DecimalFormat df = new DecimalFormat("#.00"); 
		
		List<SmsSend> sendList = new ArrayList<SmsSend>();
		SmsSend smsSend;
		
		List customList = getSmsCustom("2"); // 获取定制[销售排行]定制列表
		
		SmsCustom smsCustom;
		String sendmessage; // 消息内容
		Double xse = new Double(0);// 销售额
		String xspm;// 销售排名
		for (int i = 0; i < customList.size(); i++) {
			smsCustom = (SmsCustom) customList.get(i);
			
			log.info("实例编码：" + smsCustom.getSgcode());
			log.info("供应商编号：" + smsCustom.getSupcode());
			log.info("门店名称：" + smsCustom.getShopname());
			log.info("手机号码：" + smsCustom.getMobile());
			
			List lstResult = null;
														// 返回：日期 销售数量 含税进价金额 销售收入
			StringBuffer sql = new StringBuffer( "SELECT to_char(GSRQ,'YYYY-MM-DD') GSRQ,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE where 1=1 " );
			sql.append(" and gssgcode = '").append( "606" ).append("'");// 实例编码
			sql.append(" and gssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql.append(" and gsmfid= '").append( "0001" ).append("'");// 门店编码
			sql.append(" and gsrq = to_date('").append( "2012-02-19" ).append("', 'yyyy-MM-dd')");// 日期
			sql.append(" group by to_char(GSRQ,'YYYY-MM-DD')");
			
			// 获取销售排名的sql
			// ----

			try {
				lstResult = dao.executeSql(sql.toString());
				log.info("lstResult: " + lstResult);
				log.info("lstResult1: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					xse = new Double( ((Map)lstResult.get(0)).get("GSHSJJJE").toString() );
				}

				// 获取销售排名
				xspm = "10"; 
				// -------
				
				sendmessage = "尊敬的"+smsCustom.getSupcode()+"供应商，您"+sdf_zh.format(new Date())+"在"+sgcodetoname.get(smsCustom.getSgcode())+"超市"+smsCustom.getShopname()+"门店销售额是￥"+df.format(xse)+"元，在全场同类商品销售中排第"+xspm+"名。";
				
				smsSend = new SmsSend();
				smsSend.setSgcode(smsCustom.getSgcode());	//实例编码[*]
				smsSend.setCustomid(smsCustom.getId());	//外键（定制表id）
				smsSend.setLsrname(smsCustom.getLsrname());	//联系人
				smsSend.setMobile(smsCustom.getMobile());//手机号[*]
				smsSend.setSendcontent(sendmessage);//内容[*]
				smsSend.setSender("系统");	//发送者[*]
				smsSend.setSendtime(sdf_l.parse(sdf_l.format(new Date())));//发送时间[*]
				smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
				smsSend.setMessagetype(2);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
				smsSend.setShopid(smsCustom.getShopid());	//门店编号
				smsSend.setShopname(smsCustom.getShopname());//门店名称
				smsSend.setSendstates(0);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				smsSend.setCreatecode("system");//创建者编码
				smsSend.setCreatename("系统");	//创建者名称
				smsSend.setCreatedate(sdf_l.parse(sdf_l.format(new Date())));//创建时间
				
				sendList.add(smsSend);
			} catch (Exception e) {
				log.error("SmsCustomManagerImpl.getXSPH() error:" + e.getMessage());
			}
				
		}
		
		return sendList;
	}
	
	/**
	 * 获取数据 【3】.定制销售占比 (每天定时)
	 * @param o
	 * @return 销售占比：尊敬的xxx供应商，您2012年2月21日在xxx超市xx门店销售额是￥4000.00元，占全场同类销售总额的5%。【富基标商】
	 */
	public List<SmsSend> getXHZB() {
		
		DecimalFormat df = new DecimalFormat("#.00"); 
		
		List<SmsSend> sendList = new ArrayList<SmsSend>();
		SmsSend smsSend;
		
		List customList = getSmsCustom("3"); // 获取定制[销售占比]定制列表
		
		SmsCustom smsCustom;
		String sendmessage; // 消息内容
		Double xse = new Double(0);// 销售额
		String xszb;// 销售占比
		for (int i = 0; i < customList.size(); i++) {
			smsCustom = (SmsCustom) customList.get(i);
			
			log.info("实例编码：" + smsCustom.getSgcode());
			log.info("供应商编号：" + smsCustom.getSupcode());
			log.info("门店名称：" + smsCustom.getShopname());
			log.info("手机号码：" + smsCustom.getMobile());
			
			List lstResult = null;
														// 返回：日期 销售数量 含税进价金额 销售收入
			StringBuffer sql = new StringBuffer( "SELECT to_char(GSRQ,'YYYY-MM-DD') GSRQ,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE where 1=1 " );
			sql.append(" and gssgcode = '").append( "606" ).append("'");// 实例编码
			sql.append(" and gssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql.append(" and gsmfid= '").append( "0001" ).append("'");// 门店编码
			sql.append(" and gsrq = to_date('").append( "2012-02-19" ).append("', 'yyyy-MM-dd')");// 日期
			sql.append(" group by to_char(GSRQ,'YYYY-MM-DD')");
			
			//获取销售占比的sql
			// -----
			

			try {
				lstResult = dao.executeSql(sql.toString());
				log.info("lstResult: " + lstResult);
				log.info("lstResult1: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					xse = new Double( ((Map)lstResult.get(0)).get("GSHSJJJE").toString() );
				}
				
				// 获取销售占比值
				xszb = "5";
				// ----
				
				sendmessage = "尊敬的"+smsCustom.getSupcode()+"供应商，您"+sdf_zh.format(new Date())+"在"+sgcodetoname.get(smsCustom.getSgcode())+"超市"+smsCustom.getShopname()+"门店销售额是￥"+df.format(xse)+"元，占全场同类销售总额的"+xszb+"%。";
				
				smsSend = new SmsSend();
				smsSend.setSgcode(smsCustom.getSgcode());	//实例编码[*]
				smsSend.setCustomid(smsCustom.getId());	//外键（定制表id）
				smsSend.setLsrname(smsCustom.getLsrname());	//联系人
				smsSend.setMobile(smsCustom.getMobile());//手机号[*]
				smsSend.setSendcontent(sendmessage);//内容[*]
				smsSend.setSender("系统");	//发送者[*]
				smsSend.setSendtime(sdf_l.parse(sdf_l.format(new Date())));//发送时间[*]
				smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
				smsSend.setMessagetype(3);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
				smsSend.setShopid(smsCustom.getShopid());	//门店编号
				smsSend.setShopname(smsCustom.getShopname());//门店名称
				smsSend.setSendstates(0);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				smsSend.setCreatecode("system");//创建者编码
				smsSend.setCreatename("系统");	//创建者名称
				smsSend.setCreatedate(sdf_l.parse(sdf_l.format(new Date())));//创建时间
				
				sendList.add(smsSend);
			} catch (Exception e) {
				log.error("SmsCustomManagerImpl.getXHZB() error:" + e.getMessage());
			}
				
		}
		
		return sendList;
	}
	
	/**
	 * 获取数据 【4】.定制采购订单(即时)
	 * @param o
	 * @return 采购订单：尊敬的xxx供应商，xxx超市XXX于2012年2月21日13:00给您发送了一个新订单，编号为：XXXXXXXXX，请您及时登录SCM系统进行处理。【富基标商】
	 */
	public List<SmsSend> getCGDD() {
		
		DecimalFormat df = new DecimalFormat("#.00"); 
		
		List<SmsSend> sendList = new ArrayList<SmsSend>();
		SmsSend smsSend;
		
		List customList = getSmsCustom("4"); // 获取定制[销售占比]定制列表
		
		SmsCustom smsCustom;
		String sendmessage; // 消息内容
		String ddbh;// 订单编号
		for (int i = 0; i < customList.size(); i++) {
			smsCustom = (SmsCustom) customList.get(i);
			
			log.info("实例编码：" + smsCustom.getSgcode());
			log.info("供应商编号：" + smsCustom.getSupcode());
			log.info("门店名称：" + smsCustom.getShopname());
			log.info("手机号码：" + smsCustom.getMobile());
			
			List lstResult = null;
			
			// 查询新订单编号的sql
			StringBuffer sql = new StringBuffer( "select BH.BOHBILLNO BOHBILLNO from YW_BORDERSTATUS BS left join YW_BORDERHEAD BH ON BS.BOHBILLNO=BH.BOHBILLNO AND BS.BOHSGCODE=BH.BOHSGCODE where BS.BOHSTATUS = 1 " );
			sql.append(" and BH.BOHSGCODE = '").append( "606" ).append("'");// 实例编码
			sql.append(" and BH.BOHSUPID = '").append( "0001470" ).append("'");// 供应商编码
			sql.append(" and BH.BOHMFID = '").append( "21012" ).append("'");// 门店编码

			try {
				// 执行查询，获取新订单编号值
				lstResult = dao.executeSql(sql.toString());
				log.info("lstResult: " + lstResult);
				log.info("lstResult1: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					ddbh = ((Map)lstResult.get(0)).get("BOHBILLNO").toString();
					
					sendmessage = "尊敬的"+smsCustom.getSupcode()+"供应商，"+sgcodetoname.get(smsCustom.getSgcode())+"超市"+smsCustom.getShopname()+"门店于"+sdf_zh_l.format(new Date())+"给您发送了一个新订单，编号为："+ddbh+"，请您及时登录SCM系统进行处理。";
					
					smsSend = new SmsSend();
					smsSend.setSgcode(smsCustom.getSgcode());	//实例编码[*]
					smsSend.setCustomid(smsCustom.getId());	//外键（定制表id）
					smsSend.setLsrname(smsCustom.getLsrname());	//联系人
					smsSend.setMobile(smsCustom.getMobile());//手机号[*]
					smsSend.setSendcontent(sendmessage);//内容[*]
					smsSend.setSender("系统");	//发送者[*]
					smsSend.setSendtime(sdf_l.parse(sdf_l.format(new Date())));//发送时间[*]
					smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
					smsSend.setMessagetype(4);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
					smsSend.setShopid(smsCustom.getShopid());	//门店编号
					smsSend.setShopname(smsCustom.getShopname());//门店名称
					smsSend.setSendstates(0);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
					smsSend.setCreatecode("system");//创建者编码
					smsSend.setCreatename("系统");	//创建者名称
					smsSend.setCreatedate(sdf_l.parse(sdf_l.format(new Date())));//创建时间
					
					sendList.add(smsSend);
				}
				
			} catch (Exception e) {
				log.error("SmsCustomManagerImpl.getCGDD() error:" + e.getMessage());
			}
				
		}
		
		return sendList;
	}
	
	/**
	 * 获取数据 【5】.定制昨日库存(每天定时)
	 * @param o
	 * @return 昨日库存：尊敬的xxx供应商，今天是2012年2月21日，您昨日在xxx超市xx门店销售额是￥3500.00元，昨日库存数量为450，库存额为￥5000.00元。【富基标商】
	 */
	public List<SmsSend> getZRKC() {
		
		DecimalFormat df = new DecimalFormat("#.00"); 
		
		List<SmsSend> sendList = new ArrayList<SmsSend>();
		SmsSend smsSend;
		
		List customList = getSmsCustom("5"); // 获取定制[昨日库存]定制列表
		
		SmsCustom smsCustom;
		String sendmessage; // 消息内容
		Double xse = new Double(0);// 销售额
		Double kcsl = new Double(0);// 库存数量
		Double kce = new Double(0);// 库存额
		for (int i = 0; i < customList.size(); i++) {
			smsCustom = (SmsCustom) customList.get(i);
			
			log.info("实例编码：" + smsCustom.getSgcode());
			log.info("供应商编号：" + smsCustom.getSupcode());
			log.info("门店名称：" + smsCustom.getShopname());
			log.info("手机号码：" + smsCustom.getMobile());
			
			List lstResult = null;
														// 返回：日期 销售数量 含税进价金额 销售收入
			StringBuffer sql = new StringBuffer( "SELECT to_char(GSRQ,'YYYY-MM-DD') GSRQ,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE where 1=1 " );
			sql.append(" and gssgcode = '").append( "606" ).append("'");// 实例编码
			sql.append(" and gssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql.append(" and gsmfid= '").append( "0001" ).append("'");// 门店编码
			sql.append(" and gsrq = to_date('").append( "2012-02-19" ).append("', 'yyyy-MM-dd')");// 日期
			sql.append(" group by to_char(GSRQ,'YYYY-MM-DD')");
			
			// 查询 库存数量和库存额的sql
			StringBuffer sql1 = new StringBuffer( "select SUM(ZSKCSL) ZSKCSL,SUM(ZSKCJE) ZSKCJE from YW_ZRSTOCK where 1=1 " );
			sql1.append(" and zssgcode = '").append( "606" ).append("'");// 实例编码
			sql1.append(" and zssupid = '").append( "0001470" ).append("'");// 供应商编码
			sql1.append(" and zsmfid = '").append( "21015" ).append("'");// 门店编码

			try {
				lstResult = dao.executeSql(sql.toString());
				log.info("lstResult: " + lstResult);
				log.info("lstResult1: " + lstResult.size());
				
				if(null != lstResult && lstResult.size() > 0){
					xse = new Double( ((Map)lstResult.get(0)).get("GSHSJJJE").toString() );
				}
				
				lstResult = dao.executeSql(sql1.toString());
				log.info("lstResult2: " + lstResult);
				log.info("lstResult3: " + lstResult.size());
				
				// 获取库存数量和库存额
				if(null != lstResult && lstResult.size() > 0){
					kcsl = new Double( ((Map)lstResult.get(0)).get("ZSKCSL").toString() );
					kce = new Double( ((Map)lstResult.get(0)).get("ZSKCJE").toString() );
				}
				
				sendmessage = "尊敬的"+smsCustom.getSupcode()+"供应商，今天是"+sdf_zh.format(new Date())+"，您昨日在"+sgcodetoname.get(smsCustom.getSgcode())+"超市"+smsCustom.getShopname()+"门店销售额是￥"+df.format(xse)+"元，昨日库存数量为"+kcsl+"，库存额为￥"+df.format(kce)+"元。";
				
				smsSend = new SmsSend();
				smsSend.setSgcode(smsCustom.getSgcode());	//实例编码[*]
				smsSend.setCustomid(smsCustom.getId());	//外键（定制表id）
				smsSend.setLsrname(smsCustom.getLsrname());	//联系人
				smsSend.setMobile(smsCustom.getMobile());//手机号[*]
				smsSend.setSendcontent(sendmessage);//内容[*]
				smsSend.setSender("系统");	//发送者[*]
				smsSend.setSendtime(sdf_l.parse(sdf_l.format(new Date())));//发送时间[*]
				smsSend.setSendtype(2);		//发送类型（1 自主  2 系统 ）[*]
				smsSend.setMessagetype(5);	//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
				smsSend.setShopid(smsCustom.getShopid());	//门店编号
				smsSend.setShopname(smsCustom.getShopname());//门店名称
				smsSend.setSendstates(0);	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				smsSend.setCreatecode("system");//创建者编码
				smsSend.setCreatename("系统");	//创建者名称
				smsSend.setCreatedate(sdf_l.parse(sdf_l.format(new Date())));//创建时间
				
				sendList.add(smsSend);
			} catch (Exception e) {
				log.error("SmsCustomManagerImpl.getZRKC() error:" + e.getMessage());
			}
				
		}
		
		return sendList;
	}
	
	// 短信发送部分 ============================================================================
	
	/**
	 * 获取短信定制列表
	 * @param o
	 * @return
	 */
	public List getSmsCustom(String customtype) {
		List lstResult = null;
		try{
			
			StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.SmsCustom sc where 1 = 1" );
			hql.append( " and sc.customtype = '" ).append( customtype ).append( "'" ); // 定制类型
			hql.append( " and sc.customdate >= to_date('" ).append( sdf.format(new Date()) ).append("','yyyy-MM-dd')"); // 有效截止时间
			
			lstResult = dao.executeHql( hql.toString() );// find
			
		}catch( Exception ex ){
			log.error("SmsCustomManagerImpl.getSmsCustom() error:" + ex.getMessage());
		}
		
		return lstResult;
	}
	
	
	/**
	 * 发送短信 1.定制销售日/月报 (每天定时)
	 * @param o
	 * @return
	 */
	public void sendXSRYB() {
		
		try {
			// 1. getXSRYB 获取 发送SmsSend实体列表
			List<SmsSend> list = getXSRYB();
			log.info("SmsCustomManagerImpl.sendXSRYB() list: " + list);
			log.info("SmsCustomManagerImpl.sendXSRYB() list.size(): " + list.size());
			
			// 2. 循环发送 并 记录发送结果信息
			SmsSend smsSend;
			for (int i = 0; i < list.size(); i++) {
				smsSend = list.get(0);
				log.info("模拟发送： SmsCustomManagerImpl.sendXSRYB()发送号码：" + smsSend.getMobile() + " 发送内容： " + smsSend.getSendcontent());
				
				// 发送操作
//				int sendresult = com.bfuture.app.saas.util.Constants.sendMessage(smsSend);
				
				// 记录发送状态
//				smsSend.setSendstates(sendresult); //发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				
				AddSmsSend(new Object[]{smsSend}); // 数据库添加操作
				
			}
		} catch (Exception e) {
			log.error("SmsCustomManagerImpl.sendXSRYB() error:" + e.getMessage());
		}
		
	}
	
	/**
	 * 发送短信 2.定制销售排行 (每天定时)
	 * @param o
	 * @return
	 */
	public void sendXSPH() {
		
		try {
			// 1. getXSPH 获取 发送SmsSend实体列表
			List<SmsSend> list = getXSPH();
			log.info("SmsCustomManagerImpl.sendXSPH() list: " + list);
			log.info("SmsCustomManagerImpl.sendXSPH() list.size(): " + list.size());
			
			// 2. 循环发送 并 记录发送结果信息
			SmsSend smsSend;
			for (int i = 0; i < list.size(); i++) {
				smsSend = list.get(0);
				log.info("模拟发送： SmsCustomManagerImpl.sendPH()发送号码：" + smsSend.getMobile() + " 发送内容： " + smsSend.getSendcontent());
				
				// 发送操作
//				int sendresult = com.bfuture.app.saas.util.Constants.sendMessage(smsSend);
				
				// 记录发送状态
//				smsSend.setSendstates(sendresult); //发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				
				AddSmsSend(new Object[]{smsSend}); // 数据库添加操作
				
			}
		} catch (Exception e) {
			log.error("SmsCustomManagerImpl.sendXSPH() error:" + e.getMessage());
		}
		
	}
	
	/**
	 * 发送短信 3.定制销售占比 (每天定时)
	 * @param o
	 * @return
	 */
	public void sendXHZB() {
		
		try {
			// 1. getXHZB 获取 发送SmsSend实体列表
			List<SmsSend> list = getXHZB();
			log.info("SmsCustomManagerImpl.sendXHZB() list: " + list);
			log.info("SmsCustomManagerImpl.sendXHZB() list.size(): " + list.size());
			
			// 2. 循环发送 并 记录发送结果信息
			SmsSend smsSend;
			for (int i = 0; i < list.size(); i++) {
				smsSend = list.get(0);
				log.info("模拟发送： SmsCustomManagerImpl.sendXHZB()发送号码：" + smsSend.getMobile() + " 发送内容： " + smsSend.getSendcontent());
				
				// 发送操作
//				int sendresult = com.bfuture.app.saas.util.Constants.sendMessage(smsSend);
				
				// 记录发送状态
//				smsSend.setSendstates(sendresult); //发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				
				AddSmsSend(new Object[]{smsSend}); // 数据库添加操作
				
			}
		} catch (Exception e) {
			log.error("SmsCustomManagerImpl.sendXHZB() error:" + e.getMessage());
		}
		
	}
	
	/**
	 * 发送短信 4.定制采购订单(即时)
	 * @param o
	 * @return
	 */
	public void sendCGDD() {
		
		try {
			// 1. getCGDD 获取 发送SmsSend实体列表
			List<SmsSend> list = getCGDD();
			log.info("SmsCustomManagerImpl.sendCGDD() list: " + list);
			log.info("SmsCustomManagerImpl.sendCGDD() list.size(): " + list.size());
			
			// 2. 循环发送 并 记录发送结果信息
			SmsSend smsSend;
			for (int i = 0; i < list.size(); i++) {
				smsSend = list.get(0);
				log.info("模拟发送： SmsCustomManagerImpl.sendCGDD()发送号码：" + smsSend.getMobile() + " 发送内容： " + smsSend.getSendcontent());
				
				// 发送操作
//				int sendresult = com.bfuture.app.saas.util.Constants.sendMessage(smsSend);
				
				// 记录发送状态
//				smsSend.setSendstates(sendresult); //发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				
				AddSmsSend(new Object[]{smsSend}); // 数据库添加操作
				
			}
		} catch (Exception e) {
			log.error("SmsCustomManagerImpl.sendCGDD() error:" + e.getMessage());
		}
		
	}
	
	/**
	 * 发送短信 5.定制昨日库存(每天定时)
	 * @param o
	 * @return
	 */
	public void sendZRKC() {
		
		try {
			// 1. getZRKC 获取 发送SmsSend实体列表
			List<SmsSend> list = getZRKC();
			log.info("SmsCustomManagerImpl.sendZRKC() list: " + list);
			log.info("SmsCustomManagerImpl.sendZRKC() list.size(): " + list.size());
			
			// 2. 循环发送 并 记录发送结果信息
			SmsSend smsSend;
			for (int i = 0; i < list.size(); i++) {
				smsSend = list.get(0);
				log.info("模拟发送： SmsCustomManagerImpl.sendZRKC()发送号码：" + smsSend.getMobile() + " 发送内容： " + smsSend.getSendcontent());
				
				// 发送操作
//				int sendresult = com.bfuture.app.saas.util.Constants.sendMessage(smsSend);
				
				// 记录发送状态
//				smsSend.setSendstates(sendresult); //发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
				
				AddSmsSend(new Object[]{smsSend}); // 数据库添加操作
				
			}
		} catch (Exception e) {
			log.error("SmsCustomManagerImpl.sendZRKC() error:" + e.getMessage());
		}
		
	}
	
	
	
}
