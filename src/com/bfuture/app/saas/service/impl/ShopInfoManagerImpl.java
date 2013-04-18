package com.bfuture.app.saas.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.ShopInfo;
import com.bfuture.app.saas.model.ShopInfoId;
import com.bfuture.app.saas.service.ShopInfoManager;

/**
 * 门店分布管理
 * @author chenjw
 *
 */
public class ShopInfoManagerImpl extends BaseManagerImpl implements ShopInfoManager {
	
	protected final Log log = LogFactory.getLog(ShopInfoManagerImpl.class);
	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public ShopInfoManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if ("SeaShopInfo".equals(actionType)) {
			result = SeaShopInfo(o);
		}else if ("DelShopInfo".equals(actionType)) {
			result = DelShopInfo(o);
		}else if ("AddShopInfo".equals(actionType)) {
			result = AddShopInfo(o);
		}else if ("UpShopInfo".equals(actionType)) {
			result = UpShopInfo(o);
		}
		return result;
	}
	
	/**
	 * 执行添加
	 * @param o
	 * @return
	 */
	public ReturnObject AddShopInfo(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				ShopInfo shopInfo = (ShopInfo)o[0];
				
				shopInfo.setId(new ShopInfoId(shopInfo.getSisgcode(),shopInfo.getShopcode()));
				shopInfo.setPicurl(shopInfo.getSisgcode() + "_" + shopInfo.getShopcode() + ".jpg");
				
				dao.saveEntity(shopInfo); // 添加操作
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("ShopInfoManagerImpl.AddShopInfo() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行删除
	 * @param o
	 * @return
	 */
	public ReturnObject DelShopInfo(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				ShopInfo shopInfo = (ShopInfo)o[0];
				
				StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.ShopInfo shopinfo where 1=1 " );
				hql.append( " and shopinfo.id.sisgcode = '" ).append( shopInfo.getSisgcode() ).append("'");
				hql.append( " and shopinfo.id.shopcode = '" ).append( shopInfo.getShopcode() ).append("'");
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){					
					remove( lstResult.toArray() );  // 这里执行删除操作
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("ShopInfoManagerImpl.DelShopInfo() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行修改
	 * @param o
	 * @return
	 */
	public ReturnObject UpShopInfo(Object[] o) {
		ReturnObject result = new ReturnObject();
			try{
				ShopInfo shopInfo = (ShopInfo)o[0];
				
				shopInfo.setId(new ShopInfoId(shopInfo.getSisgcode(),shopInfo.getShopcode()));
				
				dao.updateEntity(shopInfo); // 执行修改
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("ShopInfoManagerImpl.UpShopInfo() error:" + ex.getMessage());
			}
		
		return result;
	}
	
	/**
	 * 执行查询
	 * @param o
	 * @return
	 */
	public ReturnObject SeaShopInfo(Object[] o) {
			ReturnObject result = new ReturnObject();
			
			try{
				ShopInfo shopInfo = (ShopInfo)o[0];
				
				StringBuffer countHql = new StringBuffer( "select count(*) from com.bfuture.app.saas.model.ShopInfo shopinfo where 1 = 1" );			
				
				if(shopInfo.getShopcode() != null && !"".equals(shopInfo.getShopcode())){
					countHql.append( " and id.shopcode = '" ).append( shopInfo.getShopcode() ).append( "'" );
				}
				if(shopInfo.getShopname() != null && !"".equals(shopInfo.getShopname())){
					countHql.append( " and shopname = '" ).append( shopInfo.getShopname() ).append( "'" );
				}
				if(shopInfo.getSisgcode() != null && !"".equals(shopInfo.getSisgcode())){
					countHql.append( " and id.sisgcode = '" ).append( shopInfo.getSisgcode() ).append( "'" );
				}
				
				List lstResult = dao.executeHql( countHql.toString() );
				if( lstResult != null ){
					result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
					log.info("lstResult: " + lstResult);
				}
				
				StringBuffer hql = new StringBuffer( "from com.bfuture.app.saas.model.ShopInfo shopinfo where 1 = 1" );
				int limit = shopInfo.getRows();
				int start = ( shopInfo.getPage() - 1) * shopInfo.getRows() ;
				
				if(shopInfo.getShopcode() != null && !"".equals(shopInfo.getShopcode())){
					hql.append( " and id.shopcode = '" ).append( shopInfo.getShopcode() ).append( "'" );
				}
				if(shopInfo.getShopname() != null && !"".equals(shopInfo.getShopname())){
					hql.append( " and shopname = '" ).append( shopInfo.getShopname() ).append( "'" );
				}
				if(shopInfo.getSisgcode() != null && !"".equals(shopInfo.getSisgcode())){
					hql.append( " and id.sisgcode = '" ).append( shopInfo.getSisgcode() ).append( "'" );
				}

				if( shopInfo.getOrder() != null && shopInfo.getSort() != null ){
					hql.append( " order by " ).append( shopInfo.getSort() ).append( " " ).append( shopInfo.getOrder() );
				}else{
					hql.append( "order by id " ); // 默认按id正序加载
				}
				
				lstResult = dao.executeHql( hql.toString(), start, limit );
				if( lstResult != null ){
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
					log.info("lstResult1: " + lstResult);
				}
				
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("ShopInfoManagerImpl.SeaShopInfo() error:" + ex.getMessage());
			}
			
			return result;
	}
	
}
