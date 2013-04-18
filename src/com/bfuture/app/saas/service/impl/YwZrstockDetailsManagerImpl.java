package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.Stock;
import com.bfuture.app.saas.service.YwZrstockDetailsManager;


public class YwZrstockDetailsManagerImpl extends BaseManagerImpl implements YwZrstockDetailsManager {
	protected final Log log = LogFactory.getLog(GoodsManagerImpl.class);

	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public YwZrstockDetailsManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		Calendar   cal   =   Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String strDate = new SimpleDateFormat( "yyyy-MM-dd").format(cal.getTime());
		try{
			Stock stock = (Stock)o; // 查询条件
			String TableName = "YW_ZRSTOCK"+stock.getSgcode();
			StringBuffer countSql = new StringBuffer( "select count(*)  FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE = G.GDSGCODE and Z.ZSGDID = G.GDID and Z.ZSBARCODE = G.GDBARCODE " );			
			StringBuffer sql = new StringBuffer( " select (to_date(substr(zsfile,1,8),'yyyy-mm-dd')-1) as ZSGXTIME,Z.ZSJYFS,Z.ZSMFID,P.SHPNAME,Z.ZSGDID,Z.ZSBARCODE,G.GDNAME,G.GDSPEC,G.GDUNIT,Z.TEMP1,Z.ZSSUPID,S.SUPNAME,Z.ZSKCSL,Z.ZSKCJE FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE = G.GDSGCODE and Z.ZSGDID = G.GDID and Z.ZSBARCODE = G.GDBARCODE left join INF_SHOP P on Z.ZSSGCODE = P.SGCODE and Z.ZSMFID = P.SHPCODE left JOIN INF_SUPINFO S ON S.SUPSGCODE = Z.ZSSGCODE AND S.SUPID = Z.ZSSUPID " );
			StringBuffer totalSql = new StringBuffer( "SELECT cast('合计：' as varchar2(30)) ZSGXTIME,SUM(ZSKCSL) ZSKCSL,SUM(ZSKCJE) ZSKCJE FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE=G.GDSGCODE  and Z.ZSGDID=G.GDID  and Z.ZSBARCODE = G.GDBARCODE" );
			
			/*查询条件*/
			StringBuffer whereStr = new StringBuffer(" where 1=1 ");
			if( !StringUtil.isBlank( stock.getSgcode() ) ){// [实例编码]
				whereStr.append( " and Z.ZSSGCODE = '" ).append( stock.getSgcode() ).append("'");
			}
			if( !StringUtil.isBlank( stock.getSupcode() ) ){// 供应商编码
				whereStr.append( " and Z.ZSSUPID = '" ).append( stock.getSupcode() ).append("'");
			}
			if( !StringUtil.isBlank( stock.getZsmfid() ) ){// 门店编码
				whereStr.append( " and Z.ZSMFID = '" ).append( stock.getZsmfid() ).append("'");
			}
			if( !StringUtil.isBlank( stock.getZsgdid() ) ){// [商品编码]
				whereStr.append( " and Z.ZSGDID = '" ).append( stock.getZsgdid() ).append("'");
			}
			if( !StringUtil.isBlank( stock.getGdbarcode() ) ){//商品条码
				whereStr.append( " and Z.ZSBARCODE like '%" ).append( stock.getGdbarcode() ).append("%'");
			}
			if( !StringUtil.isBlank( stock.getZsgdname() ) ){// [商品名称]
				whereStr.append( " and G.GDNAME like '%" ).append( stock.getZsgdname() ).append("%'");
			}
			
			/*合计，总条数查询*/
			countSql.append(whereStr);
			List lstResult = dao.executeSqlCount( countSql.toString() );
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
			}
			totalSql.append(whereStr);
			lstResult = dao.executeSql( totalSql.toString() );
			if( lstResult != null && lstResult.size() > 0 ){
				result.setFooter( lstResult );
			}
			int limit = stock.getRows();
			int start = (stock.getPage() - 1) * stock.getRows();
			if( stock.getOrder() != null && stock.getSort() != null ){
				whereStr.append( " order by " ).append( stock.getSort() ).append( " " ).append( stock.getOrder() );
			}
			sql.append(whereStr);
			lstResult = dao.executeSql( sql.toString(), start, limit );
			if( lstResult != null && lstResult.size() > 0 ){
				result.setReturnCode( Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
			}
		}
		catch( Exception ex ){
			log.error("YwZrstockDetailsManagerImpl.stockDetail"+ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		return result;
	}
	
	
}
