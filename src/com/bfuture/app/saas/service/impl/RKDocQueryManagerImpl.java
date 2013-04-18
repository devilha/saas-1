package com.bfuture.app.saas.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.report.RKDocQuery;
import com.bfuture.app.saas.service.RKDocQueryManager;
import com.bfuture.app.saas.util.StringUtil;
/**
 * 入库单查询
 * @author Zhucs
 *
 */
public class RKDocQueryManagerImpl extends BaseManagerImpl implements RKDocQueryManager {

	protected final Log log = LogFactory.getLog(RKDocQueryManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public RKDocQueryManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();

		return result;
	}
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if ("getRKDocHead".equals(actionType)) {
			result = searchRkdHead(o);
		}else if ("getRKDocDetail".equals(actionType)) { // 入库单明细
			result = searchRkdDetail(o);
		}else if ("getHead".equals(actionType)) {
			result = getHead(o);
		}
	return result;
	}
	
	public ReturnObject searchRkdHead(Object[] o){
		RKDocQuery rKDocQuery = (RKDocQuery) o[0]; // 查询条件
		ReturnObject result = new ReturnObject();
		try {
			StringBuffer Sql=new StringBuffer("select h.BIHORDERNO,h.BIHBILLNO, h.BIHSUPID,sup.supname,h.BIHSHMFID,s.shpname,h.BIHJHRQ,to_char(h.BIHSHTIME, 'yyyy-MM-dd') as BIHSHTIME,h.BIHMEMO,h.bihsl,h.bihhsjjje from yw_binstrhead h left join inf_supinfo sup on sup.supid = h.bihsupid and sup.supsgcode = h.bihsgcode left join inf_shop s on  s.shpcode = h.BIHSHMFID and s.sgcode = h.bihsgcode ");

			StringBuffer sumsql=new StringBuffer("select cast('合计' as varchar2(30)) BIHBILLNO,sum(h.bihsl)bihsl,sum(h.bihhsjjje)bihhsjjje from yw_binstrhead h ");
			StringBuffer count=new StringBuffer("select count(h.bihbillno) from yw_binstrhead h ");
			
			/*查询条件*/
			StringBuffer whereStr = new StringBuffer(" where 1=1 ");
			if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))//实例编码
			{
				whereStr.append(" and h.BIHSGCODE='"+rKDocQuery.getSgcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getShopcode()))//门店编码
			{
				whereStr.append(" and h.BIHSHMFID='"+rKDocQuery.getShopcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getSupcode()))//供应商编码BIHBILLNO
			{
				whereStr.append(" and h.BIHSUPID='"+rKDocQuery.getSupcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))//入库单号//查询单头
			{
				whereStr.append(" and h.BIHBILLNO like '%"+rKDocQuery.getBILLNO()+"%'");
			}
			if (StringUtil.isNotEmpty(rKDocQuery.getStartDate())) {
				whereStr.append(" and to_char(h.BIHSHTIME,'yyyy-mm-dd') >= '").append(
						rKDocQuery.getStartDate()+"'");
			}
			if (StringUtil.isNotEmpty(rKDocQuery.getEndDate())) {
				whereStr.append(" and to_char(h.BIHSHTIME,'yyyy-mm-dd') <= '").append(
						rKDocQuery.getEndDate()+"'");
			}
			
			/*总条数，合计查询*/
			sumsql.append(whereStr);
			List lstSumResult = dao.executeSql(sumsql.toString());
			count.append(whereStr);
			List resultNum = dao.executeSqlCount(count.toString());
			int num=Integer.parseInt(resultNum.get(0).toString());//总条数
			
			if( rKDocQuery.getOrder() != null && rKDocQuery.getSort() != null ){
				whereStr.append( " order by " ).append( rKDocQuery.getSort() ).append( " " ).append( rKDocQuery.getOrder() );
			}else{
				whereStr.append( " order by h.BIHORDERNO desc " );
			}
			//分页查询
			Sql.append(whereStr);
			int limit=rKDocQuery.getRows();
			int start=(rKDocQuery.getPage()-1)*rKDocQuery.getRows();
			List lstResult = dao.executeSql(Sql.toString(),start,limit);
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
				result.setFooter(lstSumResult);
				result.setTotal(num);
			}
		} catch (Exception ex) {
			log.error("RKDocQueryManagerImpl.getRKDocHead() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
	
	public ReturnObject searchRkdDetail(Object[] o){
		ReturnObject result = new ReturnObject();
		RKDocQuery rKDocQuery = (RKDocQuery) o[0]; 
		try {
			StringBuffer Sql = new StringBuffer("select d.BIDGDID,d.BIdBILLNO,s.shpname,g.gdname,g.gdspec,g.gdunit,G.GDBARCODE BARCODE,d.BIDSL,d.BIDHSJJ,d.BIDHSJJJE from YW_BINSTRDETAIL d "
					         + "left join inf_goods g on g.gdid = d.bidgdid and d.bidsgcode = g.gdsgcode left join  inf_shop s on d.bidsgcode = s.sgcode and d.bidshmfid = s.shpcode ");
			StringBuffer count=new StringBuffer("select count(*) from YW_BINSTRDETAIL d ");
			StringBuffer sumsql = new StringBuffer("select cast('合计' as varchar2(30)) BIDGDID,sum(d.bidsl) as BIDSL,sum(d.BIDHSJJJE) as BIDHSJJJE from yw_binstrdetail d ");

			/*查询条件*/
			StringBuffer whereStr = new StringBuffer(" where 1=1 ");
			if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))
			{
				whereStr.append(" and d.BIdSGCODE='"+rKDocQuery.getSgcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))
			{
				whereStr.append(" and d.bidbillno='"+rKDocQuery.getBILLNO()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getShopcode())){
				whereStr.append(" and d.bidshmfid='"+rKDocQuery.getShopcode()+"' ");
			}
			
			/*总条数，合计查询*/
			count.append(whereStr);
			List  resultNum=dao.executeSqlCount(count.toString());
			int num=Integer.parseInt(resultNum.get(0).toString());
			sumsql.append(whereStr);
			List lstSumResult = dao.executeSql(sumsql.toString());
			
			/*分页查询*/
			if( rKDocQuery.getOrder() != null && rKDocQuery.getSort() != null ){
				whereStr.append( " order by " ).append( rKDocQuery.getSort() ).append( " " ).append( rKDocQuery.getOrder() );
			}else{
				whereStr.append( " order by d.bidorderid ,d.BIDGDID asc" );
			}

			Sql.append(whereStr);
			int limit=rKDocQuery.getRows();
			int start=(rKDocQuery.getPage()-1)*rKDocQuery.getRows();
			List lstResult = dao.executeSql(Sql.toString(),start,limit);
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
				result.setTotal(num);
				result.setFooter(lstSumResult);
			}
			
		} catch (Exception ex) {
			log.error("RKDocQueryManagerImpl.getRKDocDetail() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
	
	/*填充入库单明细单头*/
	public ReturnObject getHead(Object[] o) {
		RKDocQuery rKDocQuery = (RKDocQuery) o[0]; // 查询条件
		ReturnObject result = new ReturnObject();
		try {
			StringBuffer Sql=new StringBuffer("select h.BIHORDERNO,h.BIHBILLNO,h.BIHSUPID,h.BIHSHMFID,h.BIHJHRQ,to_char(h.BIHSHTIME,'yyyy-MM-dd') as BIHSHTIME,h.BIHMEMO," +
					"(select distinct(s.shpname) from inf_shop s where s.shpcode=h.BIHSHMFID and s.sgcode=h.bihsgcode ) as shopname ," +
					"(select distinct(sup.supname) from inf_supinfo sup where sup.supid=h.BIHSUPID and sup.supsgcode=h.bihsgcode ) as supname " +
					"from yw_binstrhead h where  '1'='1'  ");
			if(StringUtil.isNotEmpty(rKDocQuery.getSgcode()))//实例编码
			{
				Sql.append(" and h.BIHSGCODE='"+rKDocQuery.getSgcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getShopcode()))//门店编码
			{
				Sql.append(" and h.BIHSHMFID='"+rKDocQuery.getShopcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getSupcode()))//供应商编码BIHBILLNO
			{
				Sql.append(" and h.BIHSUPID='"+rKDocQuery.getSupcode()+"' ");
			}
			if(StringUtil.isNotEmpty(rKDocQuery.getBILLNO()))//入库单号//查询单头
			{
				Sql.append(" and h.BIHBILLNO='"+rKDocQuery.getBILLNO()+"' ");
			}
			List lstResult = dao.executeSql(Sql.toString());
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
			}
			
		} catch (Exception ex) {
			log.error("RKDocQueryManagerImpl.getHead() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
}
