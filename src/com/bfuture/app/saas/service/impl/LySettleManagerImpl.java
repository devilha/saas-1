package com.bfuture.app.saas.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.BillHead;
import com.bfuture.app.saas.service.GoodsManager;

public class LySettleManagerImpl extends BaseManagerImpl implements GoodsManager {
   protected final Log log = LogFactory.getLog(LySettleManagerImpl.class);

	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public LySettleManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if("searchLysettle".equals(actionType)){
			try {
				BillHead billhead = (BillHead) o[0];
				StringBuffer countSql = new StringBuffer(
						"select count(*) FROM billhead A LEFT JOIN inf_supinfo B ON A.SGCODE = B.SUPSGCODE AND A.VENDERID = B.SUPID where 1=1 ");
				if (!StringUtil.isBlank(billhead.getSgcode())) {
					countSql.append(" and A.SGCODE = '").append(
							billhead.getSgcode()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getSdate())) {
					countSql.append(" and CHECKDATE  >= to_date('").append(
							billhead.getSdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getEdate())) {
					countSql.append(" and CHECKDATE  <= to_date('").append(
							billhead.getEdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getBillno())) {
					countSql.append(" and A.sheetid = '").append(
							billhead.getBillno()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getVendrno())) {
					countSql.append(" and A.venderid = '").append(
							billhead.getVendrno()).append("'");
				}
				log.debug("GysJxDocManagerImp.getSerchjxsettle() countsql="
						+ countSql.toString());
				List lstResult = dao.executeSqlCount(countSql.toString());
				if (lstResult != null && lstResult.size() > 0) {
					result.setTotal(Integer.parseInt(lstResult.get(0)
							.toString()));
				}

				StringBuffer sumSql = new StringBuffer("select  cast('合计' as varchar2(32)) sheetid,SUM(PAYABLEMONEY) DJAMT FROM billhead A LEFT JOIN inf_supinfo B ON A.SGCODE = B.SUPSGCODE AND A.VENDERID = B.SUPID where 1=1  ");
				if (!StringUtil.isBlank(billhead.getSgcode())) {
					sumSql.append(" and A.SGCODE = '").append(
							billhead.getSgcode()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getSdate())) {
					sumSql.append(" and CHECKDATE  >= to_date('").append(
							billhead.getSdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getEdate())) {
					sumSql.append(" and CHECKDATE  <= to_date('").append(
							billhead.getEdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getBillno())) {
					sumSql.append(" and A.sheetid = '").append(
							billhead.getBillno()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getVendrno())) {
					sumSql.append(" and A.venderid = '").append(
							billhead.getVendrno()).append("'");
				}
				log.debug("GysJxDocManagerImp.getSerchjxsettle() sumSql="
						+ sumSql.toString());
				List lstSumResult = dao.executeSql(sumSql.toString());

				int limit = billhead.getRows();
				int start = (billhead.getPage() - 1) * billhead.getRows();

				StringBuffer sql = new StringBuffer(
						"select SHEETID,A.VENDERID,B.SUPNAME,to_char(A.BEGINDATE,'yyyy-MM-dd') BEGINDATE,A.PAYABLEMONEY FROM billhead A LEFT JOIN inf_supinfo B ON A.SGCODE = B.SUPSGCODE AND A.VENDERID = B.SUPID where 1=1   ");
				if (!StringUtil.isBlank(billhead.getSgcode())) {
					sql.append(" and A.SGCODE = '")
							.append(billhead.getSgcode()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getSdate())) {
					sql.append(" and CHECKDATE  >= to_date('").append(
							billhead.getSdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getEdate())) {
					sql.append(" and CHECKDATE  <= to_date('").append(
							billhead.getEdate()).append("','yyyy-MM-dd')");
				}
				if (!StringUtil.isBlank(billhead.getBillno())) {
					sql.append(" and A.sheetid = '").append(
							billhead.getBillno()).append("'");
				}
				if (!StringUtil.isBlank(billhead.getVendrno())) {
					sql.append(" and A.venderid = '").append(
							billhead.getVendrno()).append("'");
				}
				log.debug("GysJxDocManagerImp.getSerchjxsettle() sql="
						+ sql.toString());
				lstResult = dao.executeSql(sql.toString(), start, limit);
				if (lstResult != null) {
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
					result.setFooter(lstSumResult);
				}
			} catch (Exception e) {
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(e.getMessage());
				log.error("GysJxDocManagerImp.getSerchjxsettle() error :"
						+ e.getMessage());
		
			}
		}
			return result;
		}
	}


