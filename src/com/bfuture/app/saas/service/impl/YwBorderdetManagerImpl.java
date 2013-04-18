package com.bfuture.app.saas.service.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.YwBorderdet;
import com.bfuture.app.saas.service.YwBorderdetManager;
import com.bfuture.app.saas.util.ShopComparator;
/**
 * 订单明细Manager实现类
 * @author chenjw
 *
 */
public class YwBorderdetManagerImpl extends BaseManagerImpl implements YwBorderdetManager {
	
	protected final Log log = LogFactory.getLog(YwBorderdetManagerImpl.class);
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public YwBorderdetManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if( "SearchYwBorderdet".equals( actionType ) ){
			result = SearchYwBorderdet(o);
		}
		return result;
	}
	
	public ReturnObject SearchYwBorderdet(Object[] o) {
		ReturnObject result = new ReturnObject();
		try{
			YwBorderdet yb = (YwBorderdet)o[0];
			StringBuffer sql = new StringBuffer( "select yb.BODSGCODE, yb.BODBILLNO, yb.BODSHMFID, yb.BODGDID, yb.BODSL, yb.BODTAX, yb.BODHSJJ, yb.BODHSJJJE, yb.TEMP1, yb.TEMP2, yb.TEMP3, yb.TEMP4, yb.TEMP5, yb.BODTIME, yb.BODFILE, ig.GDNAME, ig.GDBARCODE, ig.GDSPEC, ig.GDUNIT from YW_BORDERDET yb left join INF_GOODS ig on yb.BODSGCODE = ig.GDSGCODE and yb.BODGDID = ig.GDID " );			
			StringBuffer totalSql =  new StringBuffer( "select cast('合计' as varchar2(32)) BODGDID,SUM(BODSL) BODSL,SUM(BODHSJJJE) BODHSJJJE from YW_BORDERDET yb " );

			/*查询条件*/
			StringBuffer whereStr = new StringBuffer(" where 1=1 ");
			if( !StringUtil.isBlank( yb.getBodsgcode() )){ // 实例编码
				whereStr.append( " and yb.BODSGCODE = '" ).append( yb.getBodsgcode() ).append("'");
			}
			if( !StringUtil.isBlank( yb.getBodbillno() )){ // 订单编号
				whereStr.append( " and yb.BODBILLNO = '" ).append( yb.getBodbillno() ).append("'");
			}
			if( !StringUtil.isBlank( yb.getBodshmfid() )){ // 门店编号
				whereStr.append( " and yb.BODSHMFID = '" ).append( yb.getBodshmfid() ).append("'");
			}
			if( !StringUtil.isBlank( yb.getBodgdid() )){ // 商品编码
				whereStr.append( " and yb.BODGDID = '" ).append( yb.getBodgdid() ).append("'");
			}
			
			/*合计查询*/
			totalSql.append(whereStr);
			List lstResult =dao.executeSql( totalSql.toString());
			if( lstResult != null && lstResult.size() > 0 ){
				result.setFooter( lstResult );
			}
			
			/*明细查询*/
			if(yb.getOrder() != null && yb.getSort() != null){
            	whereStr.append(" order by "+yb.getSort()).append(" ").append(yb.getOrder());
            }
			sql.append(whereStr);
			lstResult = dao.executeSql( sql.toString());
			if( lstResult != null ){
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstResult );
			}	
			StringBuffer stusql=new StringBuffer("UPDATE YW_BORDERSTATUS SET BOHSTATUS = '2' where 1=1 ");
			if( !StringUtil.isBlank( yb.getBodbillno() )){ // 订单编号
				stusql.append( " and BOHBILLNO = '" ).append( yb.getBodbillno() ).append("'");
			}
			log.info("修改状态："+stusql.toString());
			dao.updateSql(stusql.toString());					
		}catch( Exception ex ){
			log.error("YwBorderdetManagerImpl.SearchYwBorderdet() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
		}
		
		return result;
	}

}
