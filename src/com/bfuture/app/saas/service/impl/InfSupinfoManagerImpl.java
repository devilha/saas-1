package com.bfuture.app.saas.service.impl;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.InfSupinfo;
import com.bfuture.app.saas.service.InfSupinfoManager;

public class InfSupinfoManagerImpl extends BaseManagerImpl implements InfSupinfoManager {
	
	@Override
	public ReturnObject getResult(Object o){
		ReturnObject result = new ReturnObject();
		InfSupinfo sup = (InfSupinfo)o;
		try {
			StringBuffer sql = new StringBuffer("select sup.supid,sup.supname from inf_supinfo sup where 1=1 ");
			if(!StringUtil.isBlank(sup.getSupsgcode())){
				sql.append(" and sup.supsgcode='").append(sup.getSupsgcode()).append("'");
			}
			if(!StringUtil.isBlank(sup.getSupid())){
				sql.append(" and sup.supid='").append(sup.getSupid()).append("'");
			}
			
			//得到所有记录
			result.setTotal(Integer.parseInt(dao.executeSqlCount("select count(*) from ("+sql.toString()+")").get(0).toString()));
			//分页查询
			int limit = sup.getRows();
			int statr = (sup.getPage() - 1) * sup.getRows();
			result.setRows(dao.executeSql(sql.toString(), statr, limit));
		} catch (Exception e) {
			log.error("SaleSummaryImpl.getSaleDetail() error :"
					+ e.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(e.getMessage());
		}
		return result;
	}

}
