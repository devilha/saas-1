package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.Shop;
import com.bfuture.app.saas.service.ShopManager;

public class ShopManagerImpl extends BaseManagerImpl implements ShopManager {
	
	protected final Log log = LogFactory.getLog(ShopManagerImpl.class);
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public ShopManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}

	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{		
			StringBuffer sql = new StringBuffer("select P.SHPCODE,P.SHPNAME from INF_SHOP P where 1=1 ");
			
			Shop shop = (Shop)o; // 查询条件			
			if( !StringUtil.isBlank(shop.getSgcode()) ){
				log.debug("shop.getUsercode(): " + shop.getUsercode());
				sql.append( " and sgcode = '" ).append( shop.getSgcode() ).append("'");
				if("3007".equals(shop.getSgcode())){
					sql.append(" and shpcode not in('999998','999999') ");
				}
				if("3018".equals(shop.getSgcode())){
					sql.append(" and P.SHPCODE in ('0001','0101') ");
				}
			}
			sql.append(" order by P.SHPCODE asc");
			
			log.info(sql);
			
			List lstResult = dao.executeSql( sql.toString());

			log.debug("ShopManagerImpl.getResult() lstResult 1 :" + lstResult);
			if( lstResult != null ){
				log.debug("ShopManagerImpl.getResult() lstResult.size() 1 :" + lstResult.size());
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstResult );
			}			
		}
		catch( Exception ex ){
			log.error("ShopManagerImpl.getResult() error:"+ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		return result;
	}

}
