package com.bfuture.app.saas.service.impl;

import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.report.POPQuery;
import com.bfuture.app.saas.service.POPQueryManager;
import com.bfuture.app.saas.util.StringUtil;
import java.util.List;

public class POPQueryManagerImpl extends BaseManagerImpl
    implements POPQueryManager
{

    public void setDao(UniversalAppDao dao)
    {
        this.dao = dao;
    }

    public POPQueryManagerImpl()
    {
        if(dao == null)
            dao = (UniversalAppDao)getSpringBean("universalAppDao");
    }

    public ReturnObject getResult(Object o)
    {
        ReturnObject result = new ReturnObject();
        return result;
    }

    public ReturnObject ExecOther(String actionType, Object o[])
    {
        ReturnObject result = new ReturnObject();
        if("getPOP".equals(actionType))
        {
            POPQuery popQuery = (POPQuery)o[0];
            try
            {	
            	StringBuffer Sql = new StringBuffer("select p.popsequece,p.pplb,p.ppsupid,p.ppcxxl,p.ppkl,p.ppzkfd,p.ppcxzt,p.ppsgcode,p.ppmarket,sup.supname,p.ppgdid,p.ppbarcode,g.gdname,to_char(p.ppshrq, 'yyyy-mm-dd') as ppSHRQ,to_char(p.ppksrq, 'yyyy-mm-dd') as ppksrq,to_char(p.ppjsrq, 'yyyy-mm-dd') AS ppjsrq,p.ppcxsj,p.ppyssj,s.shpname from yw_popinfo p left join inf_goods g on p.ppgdid = g.gdid and p.ppsgcode = g.gdsgcode and p.ppbarcode = g.gdbarcode left join inf_supinfo sup on p.ppsgcode = sup.supsgcode and p.ppsupid = sup.supid left join  inf_shop s on s.shpcode = p.ppmarket and s.sgcode = p.ppsgcode ");
            	StringBuffer count = new StringBuffer("select count(*) from yw_popinfo p left join inf_goods g on p.ppgdid = g.gdid and p.ppsgcode = g.gdsgcode and p.ppbarcode = g.gdbarcode ");
            	StringBuffer  wherestr = new StringBuffer(" where 1=1 ");
                if(StringUtil.isNotEmpty(popQuery.getSgcode()))
                	wherestr.append((new StringBuilder(" and p.ppsgcode='")).append(popQuery.getSgcode()).append("' ").toString());
            	if(StringUtil.isNotEmpty(popQuery.getPopmarket()))
            		wherestr.append((new StringBuilder(" and p.ppmarket='")).append(popQuery.getPopmarket()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopsupcode()))
                	wherestr.append((new StringBuilder(" and p.ppsupid='")).append(popQuery.getPopsupcode()).append("' ").toString());
                if(StringUtil.isNotEmpty(popQuery.getPopgdid())){
                	wherestr.append((new StringBuilder(" and g.gdid = '")).append(popQuery.getPopgdid()).append("' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdbarcode())){
                	wherestr.append((new StringBuilder(" and g.popgdbarcode like '%")).append(popQuery.getPopgdbarcode()).append("%' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getPopgdname())){
                	wherestr.append((new StringBuilder(" and g.gdname like '%")).append(popQuery.getPopgdname()).append("%' ").toString());
                }
                if(StringUtil.isNotEmpty(popQuery.getStartDate())){
                	wherestr.append(" and to_char(p.PPSHRQ,'yyyy-mm-dd') >= '"+popQuery.getStartDate()+"'");
                }
                if(StringUtil.isNotEmpty(popQuery.getEndDate())){
                	wherestr.append(" and to_char(p.PPSHRQ,'yyyy-mm-dd') <= '"+popQuery.getEndDate()+"'");
                }
                
                count.append(wherestr);
                List resultNum = dao.executeSqlCount(count.toString());
                int num = Integer.parseInt(resultNum.get(0).toString());
                
                if(popQuery.getOrder() != null && popQuery.getSort() != null){
                	wherestr.append(" order by ").append(popQuery.getSort()).append(" ").append(popQuery.getOrder());
                } 
                Sql.append(wherestr);
                int limit = popQuery.getRows();
                int start = (popQuery.getPage() - 1) * popQuery.getRows();
                List lstResult = dao.executeSql(Sql.toString(), start, limit);
                if(lstResult != null)
                {
                    result.setReturnCode("1");
                    result.setRows(lstResult);
                    result.setTotal(num);
                }
            }
            catch(Exception ex)
            {
                log.error((new StringBuilder("popQueryManagerImpl.getPOP() error :")).append(ex.getMessage()).toString());
                result.setReturnCode("0");
                result.setReturnInfo(ex.getMessage());
            }
        }
        return result;
    }

}