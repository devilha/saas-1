package com.bfuture.app.saas.service.impl;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.ConversionUtils;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.Stock;
import com.bfuture.app.saas.service.YwZrstockCategoryManager;


public class YwZrstockCategoryManagerImpl extends BaseManagerImpl implements YwZrstockCategoryManager {
	protected final Log log = LogFactory.getLog(GoodsManagerImpl.class);

	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public YwZrstockCategoryManagerImpl() {
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
			Stock stock = (Stock)o;
			String TableName = "YW_ZRSTOCK"+stock.getSgcode();
			StringBuffer countSql = new StringBuffer( "select count(Z.ZSSGCODE) as ZSGXTIME FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE = G.GDSGCODE and Z.ZSGDID = G.GDID and Z.Zsbarcode = G.GDBARCODE " );
			StringBuffer totalSql = new StringBuffer( "SELECT cast('合计：' as varchar2(30)) ZSGXTIME,SUM(ZSKCSL) ZSKCSL,SUM(ZSKCJE) ZSKCJE FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE=G.GDSGCODE  and Z.ZSGDID=G.GDID left join INF_SHOP P on G.GDSGCODE=P.SGCODE and Z.ZSMFID=P.SHPCODE  left JOIN INF_SUPINFO S ON S.SUPSGCODE=Z.ZSSGCODE AND S.SUPID=Z.ZSSUPID " );
			StringBuffer sql = new StringBuffer( "select (to_date(substr(zsfile,1,8),'yyyy-mm-dd')-1) as ZSGXTIME,Z.ZSMFID,P.SHPNAME,G.GDCATID,G.GDCATNAME,Z.ZSGDID,Z.ZSBARCODE,G.GDNAME,G.GDSPEC,G.GDUNIT,Z.ZSSUPID,S.SUPNAME,SUM(Z.ZSKCSL) ZSKCSL,SUM(Z.ZSKCJE) ZSKCJE FROM "+TableName+" Z left join INF_GOODS G on Z.ZSSGCODE = G.GDSGCODE and Z.ZSGDID = G.GDID and Z.Zsbarcode = G.GDBARCODE left join INF_SHOP P on Z.ZSSGCODE = P.SGCODE and Z.ZSMFID = P.SHPCODE left JOIN INF_SUPINFO S ON S.SUPSGCODE = Z.ZSSGCODE AND S.SUPID = Z.ZSSUPID " );

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
			if( !StringUtil.isBlank( stock.getGdcatid() ) ){// [商品类别编码]
				whereStr.append( " and G.GDCATID = '" ).append( stock.getGdcatid() ).append("'");
			}
			if( !StringUtil.isBlank( stock.getGdcatname() ) ){// [商品名称]
				whereStr.append( " and G.GDCATNAME like '%" ).append( stock.getGdcatname()).append("%'");
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
			
			/*分页查询*/
			int limit = stock.getRows();
			int start = (stock.getPage() - 1) * stock.getRows();
			whereStr.append(" group by (to_date(substr(zsfile,1,8),'yyyy-mm-dd')-1),Z.ZSMFID,P.SHPNAME,G.GDCATID,G.GDCATNAME,Z.ZSGDID,Z.ZSBARCODE,G.GDNAME,G.GDSPEC,G.GDUNIT,Z.ZSSUPID,S.SUPNAME ");
			if( stock.getOrder() != null && stock.getSort() != null ){
				whereStr.append( " order by " ).append( stock.getSort() ).append( " " ).append( stock.getOrder() );
			}
			sql.append(whereStr);
			lstResult = dao.executeSql( sql.toString(), start, limit );
			if( lstResult != null ){
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstResult );
			}
		}
		catch( Exception ex ){
			log.error("YwZrstockCategoryManagerImpl.stockCategory"+ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		return result;
	}
	
}

	

	

