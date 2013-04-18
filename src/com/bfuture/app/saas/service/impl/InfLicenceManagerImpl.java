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
import com.bfuture.app.saas.model.InfLicence;
import com.bfuture.app.saas.service.InfLicenceManager;
/**
 * 供应商证件(INF_LICENCE)
 * @author chenjw
 * 2012-02-01
 */
public class InfLicenceManagerImpl extends BaseManagerImpl implements InfLicenceManager {
	
	protected final Log log = LogFactory.getLog(InfLicenceManagerImpl.class);
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public InfLicenceManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if( "SearchInfLicence".equals( actionType ) ){
			result = SearchInfLicence(o);
		}else if( "AddInfLicence".equals( actionType ) ){
			result = AddInfLicence(o);
		}else if( "DelInfLicence".equals( actionType ) ){
			result = DelInfLicence(o);
		}else if( "UpdInfLicence".equals( actionType ) ){
			result = UpdInfLicence(o);
		}else if( "LoadLicenceById".equals( actionType ) ){
			result = LoadLicenceById(o);
		}else if( "updateViewStatus".equals( actionType ) ){
			result = updateViewStatus(o);
		}
		
		return result;
	}
	
	/**
	 * 执行添加
	 * @param o
	 * @return
	 */
	public ReturnObject AddInfLicence(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				InfLicence infLicence = (InfLicence)o[0];
				
				// 填充url字段值
//				shopInfo.setPicurl(shopInfo.getSisgcode() + "_" + shopInfo.getShopcode() + ".jpg");
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				infLicence.setDeadline(sdf.parse(infLicence.getDeadline_temp())); // 有效时间
				infLicence.setCrt_by_time(new Date()); // 上传时间
				infLicence.setStatus("0"); // 状态（0=已提交；1=已驳回）
//				infLicence.setOpt_by_time(null); // 审核时间
				
//				private String url;

				log.info("添加-url：" + infLicence.getUrl()); // 下载地址====(这个需要做处理)
				
				String serverPicName = infLicence.getIns_c() + infLicence.getSupid() + infLicence.getUrl().substring(0,infLicence.getUrl().indexOf("."));
				
				log.info("添加-文件名称：" + serverPicName);
				
				String serverPicNameMD5 = com.bfuture.app.saas.util.Constants.EncoderByMd5(serverPicName);
				
				log.info("添加-md5加密文件名称： " + serverPicNameMD5);
				
				String picend = ".jpg";
				
				String name = infLicence.getIns_c() +"_"+  infLicence.getSupid() +"_"+ serverPicNameMD5 + picend;
				log.info("添加-最终的文件名：" + name);
				
				infLicence.setUrl(name); // 图片名称
				
				dao.saveEntity(infLicence); // 添加操作
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("InfLicenceManagerImpl.AddInfLicence() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行删除
	 * @param o
	 * @return
	 */
	public ReturnObject DelInfLicence(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				
				InfLicence infLicence = null;
				String fileName = null;
				File file = null;
				
				if( o != null && o.length > 0 ){
					for( Object obj : o ){
						infLicence = (InfLicence)obj;
						
						StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.InfLicence il where 1=1 " );
						hql.append( " and il.id = " ).append( infLicence.getId() );
						
						List lstResult = dao.executeHql( hql.toString() );
						if( lstResult != null && lstResult.size() > 0){
							InfLicence licence = (InfLicence)lstResult.get(0);
							fileName = licence.getUrl();
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
				log.error("InfLicenceManagerImpl.DelInfLicence() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改
	 * @param o
	 * @return
	 */
	public ReturnObject UpdInfLicence(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				InfLicence infLicence = (InfLicence)o[0];
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				List lstResult = dao.executeSql("select * from INF_LICENCE il where id = " + infLicence.getId());
				
				Map resMap = (Map)lstResult.get(0);
				
				infLicence.setId(new Integer(resMap.get("ID").toString()));//	ID
				infLicence.setIns_c(resMap.get("INS_C").toString());	//	实例编码
				infLicence.setLicence_name(resMap.get("LICENCE_NAME").toString());// 证件名称
				infLicence.setMemo(resMap.get("MEMO").toString());	//	证件备注
				infLicence.setDeadline(sdf.parse(resMap.get("DEADLINE").toString()));//	有效时间
				infLicence.setSupid(resMap.get("SUPID").toString());	//	供应商编码
				infLicence.setSupname(resMap.get("SUPNAME").toString());//	供应商名称
				infLicence.setCrt_by_c(resMap.get("CRT_BY_C").toString());// 上传人
				infLicence.setCrt_by_time(sdf.parse(resMap.get("CRT_BY_TIME").toString()));// 上传时间
				// infLicence.setStatus("1");// 状态(页面获取)
				// infLicence.setRefuse_memo("");// 驳回原因(页面获取)
				// infLicence.setOpt_by_c("");// 审核人(页面获取)
				infLicence.setOpt_by_time(sdf.parse(sdf.format(new Date())));// 审核时间
				infLicence.setUrl(resMap.get("URL").toString());// 下载地址
				
				dao.updateEntity(infLicence); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("InfLicenceManagerImpl.UpdInfLicence() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行加载一条
	 * @param o
	 * @return
	 */
	public ReturnObject LoadLicenceById(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				InfLicence infLicence = (InfLicence)o[0];
				
				List lstResult = dao.executeSql("select * from INF_LICENCE il where id = " + infLicence.getId());
				
				result.setRows(lstResult);
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("InfLicenceManagerImpl.LoadLicenceById() error:" + ex.getMessage());
			}
		
		return result;
	}
	/**
	 * 执行修改查看状态
	 * @param o
	 * @return
	 */
	public ReturnObject updateViewStatus(Object[] o) {
		ReturnObject result = new ReturnObject();
		try{
			InfLicence infLicence = (InfLicence)o[0];
			
			StringBuffer sql=new StringBuffer("update INF_LICENCE set VIEW_STATUS='readed' where 1=1 ");
			sql.append(" and ID= ").append(infLicence.getId()).append("");
			log.info("update VIEW_STATUS:+"+sql.toString());
			dao.updateSql(sql.toString());
			result.setReturnCode(Constants.SUCCESS_FLAG);
		}
		catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			log.error("InfLicenceManagerImpl.updateViewStatus() error:" + ex.getMessage());
		}
	
	return result;
	}
	
	/**
	 * 执行查询
	 * @param o
	 * @return
	 */
	public ReturnObject SearchInfLicence(Object[] o) {
		ReturnObject result = new ReturnObject();
		
		try{
			InfLicence il = (InfLicence)o[0];
			
			StringBuffer countSql = new StringBuffer( "select count(*) from (select distinct il.* from INF_LICENCE il left join (select * from inf_goodsuply igs left join inf_goods ig on igs.gssgcode = ig.gdsgcode and igs.gsid = ig.gdid) a on il.ins_c = a.gssgcode and il.supid = a.gssupid where il.INS_C =" +il.getIns_c());
			
			if( !StringUtil.isBlank( il.getLicence_name() )){ 	// 证件名称
				countSql.append( " and il.LICENCE_NAME like '%" ).append( il.getLicence_name() ).append("%'");
			}
			if( !StringUtil.isBlank( il.getStarttime_temp() ) ){ // 开始时间
				countSql.append( " and  to_char(il.CRT_BY_TIME,'yyyy-mm-dd') >= '" ).append( il.getStarttime_temp() ).append("'");
			}
			if( !StringUtil.isBlank( il.getEndtime_temp() ) ){ 	// 结束时间
				countSql.append( " and to_char(il.CRT_BY_TIME,'yyyy-mm-dd') <= '" ).append( il.getEndtime_temp() ).append("'");
			}
			if( !StringUtil.isBlank( il.getStatus() ) ){ 	   // 状态
				countSql.append( " and il.STATUS = '" ).append( il.getStatus() ).append("'");
			}
			if( !StringUtil.isBlank( il.getView_status() ) ){ 	   // 查看状态
				countSql.append( " and il.VIEW_STATUS " ).append( il.getView_status() ).append(" ");
			}
			if( !StringUtil.isBlank( il.getSupid() ) ){ 	   // 供应商编号
				countSql.append( " and il.SUPID = '" ).append( il.getSupid() ).append("'");
			}
			if( !StringUtil.isBlank( il.getGdbarcode() ) ){ 	   // 商品条码
				countSql.append( " and a.gdbarcode = '" ).append( il.getGdbarcode() ).append("'");
			}
			countSql.append(")");
			
			List lstResult = dao.executeSql( countSql.toString() );
			log.info("lstResult 1 :" + lstResult);
			log.info("lstResult.size() 1 :" + lstResult.size());
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( ((Map)lstResult.get(0)).get("COUNT(*)").toString() ) );
			}
			
			StringBuffer sql = new StringBuffer( "select distinct il.* from INF_LICENCE il left join (select * from inf_goodsuply igs left join inf_goods ig on igs.gssgcode = ig.gdsgcode and igs.gsid = ig.gdid) a on il.ins_c = a.gssgcode and il.supid = a.gssupid where il.INS_C ="+il.getIns_c() );
			
			int limit = il.getRows();
			int start = ( il.getPage() - 1) * il.getRows() ;
			
			if( !StringUtil.isBlank( il.getLicence_name() )){ 	// 证件名称
				sql.append( " and il.LICENCE_NAME like '%" ).append( il.getLicence_name() ).append("%'");
			}
			if( !StringUtil.isBlank( il.getStarttime_temp() ) ){ // 开始时间
				sql.append( " and to_char(il.CRT_BY_TIME,'yyyy-mm-dd') >= '" ).append( il.getStarttime_temp() ).append("'");
			}
			if( !StringUtil.isBlank( il.getEndtime_temp() ) ){ 	// 结束时间
				sql.append( " and to_char(il.CRT_BY_TIME,'yyyy-mm-dd') <= '" ).append( il.getEndtime_temp() ).append("'");
			}
			if( !StringUtil.isBlank( il.getStatus() ) ){ 	   // 状态
				sql.append( " and il.STATUS = '" ).append( il.getStatus() ).append("'");
			}
			if( !StringUtil.isBlank( il.getView_status() ) ){ 	   // 查看状态
				sql.append( " and il.VIEW_STATUS " ).append( il.getView_status() ).append(" ");
			}
			if( !StringUtil.isBlank( il.getSupid() ) ){ 	   // 供应商编号
				sql.append( " and il.SUPID = '" ).append( il.getSupid() ).append("'");
			}
			if( !StringUtil.isBlank( il.getGdbarcode() ) ){ 	   // 商品条码
				sql.append( " and a.gdbarcode = '" ).append( il.getGdbarcode() ).append("'");
			}
			
			if( il.getOrder() != null && il.getSort() != null ){
				sql.append( " order by " ).append( il.getSort() ).append( " " ).append( il.getOrder() );
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
			log.error("InfLicenceManagerImpl.SearchInfLicence() error:" + ex.getMessage());
		}
		
		return result;
	}
}
