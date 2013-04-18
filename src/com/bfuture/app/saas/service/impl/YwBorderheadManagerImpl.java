package com.bfuture.app.saas.service.impl;


import java.util.List;
import java.util.Map;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.YwBorderhead;
import com.bfuture.app.saas.service.YwBorderheadManager;

public class YwBorderheadManagerImpl extends BaseManagerImpl
    implements YwBorderheadManager
{

    public void setDao(UniversalAppDao dao)
    {
        this.dao = dao;
    }

    public YwBorderheadManagerImpl()
    {
        if(dao == null)
            dao = (UniversalAppDao)getSpringBean("universalAppDao");
    }

    public ReturnObject ExecOther(String actionType, Object o[])
    {
        ReturnObject result = new ReturnObject();
        if("SearchYwBorderhead".equals(actionType))
            result = SearchYwBorderhead(o);
        return result;
    }

    public ReturnObject searchIns(String sgcode)
    {
        ReturnObject result = new ReturnObject();
        try
        {
            StringBuffer sql = new StringBuffer("SELECT OI_CN FROM ORG_INS WHERE 1=1 ");
            if(!StringUtil.isBlank(sgcode))
                sql.append(" AND OI_C='").append(sgcode).append("'");
            List lstResult = dao.executeSql(sql.toString());
            result.setRows(lstResult);
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.searchIns() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
        }
        return result;
    }

    public ReturnObject SearchYwBorderhead(Object o[])
    {
        ReturnObject result = new ReturnObject();
        try
        {
            YwBorderhead yb = (YwBorderhead)o[0];
            int limit = yb.getRows();
            int start = (yb.getPage() - 1) * yb.getRows();

        	StringBuffer sql =  new StringBuffer("select DISTINCT yb.bohsgcode,yb.bohmfid,yb.bohbillno,yb.bohsupid,yb.bohshmfid,(to_char(yb.bohdhrq,'yyyy-mm-dd'))bohdhrq,(to_char(yb.bohjhrq,'yyyy-mm-dd'))bohjhrq,(to_char(yb.bohshtime,'yyyy-mm-dd'))bohshtime,(to_char(yb.bohqxtime,'yyyy-mm-dd'))bohqxtime,yb.bohrkdd,");
        	sql.append(" yb.bohjyfs,yb.bohgz,yb.bohmemo,yb.temp1,yb.temp2,yb.temp3,yb.temp4,yb.temp5,sta.BOHSTATUS BOHSTATUS,sp.SHPNAME,sp.TEMP1 LINKTELE,sp.TEMP2 ADDRESS,su.SUPNAME SUNAME,yb.bohsl SL,yb.bohhsjjje JE,su.supcont ,su.supfax ,su.supadd ,su.supcontphone from YW_BORDERHEAD yb left join INF_SHOP sp on yb.bohsgcode = sp.SGCODE ");
        	sql.append(" and yb.bohmfid = sp.SHPCODE left join INF_SUPINFO su on yb.bohsgcode = su.supsgcode and yb.BOHSUPID = su.supid left join YW_BORDERSTATUS sta on sta.bohsgcode=yb.bohsgcode and sta.bohbillno=yb.bohbillno and sta.bohshmfid = yb.bohmfid ");
            StringBuffer countSql = new StringBuffer("select count(*) from YW_BORDERHEAD yb ");
            StringBuffer sumSql =  new StringBuffer("select cast('\u5408\u8BA1' as varchar2(32)) BOHBILLNO,SUM(yb.bohsl) SL,SUM(yb.bohhsjjje) JE,'4' BOHSTATUS from YW_BORDERHEAD yb ");
            
            /*查询条件*/   
            StringBuffer whereStr = new StringBuffer(" where 1=1 ");
            if(!StringUtil.isBlank(yb.getBohbillno())){
            	whereStr.append(" and yb.BOHBILLNO like '%").append(yb.getBohbillno()).append("%'");
            }   
        	if(!StringUtil.isBlank(yb.getTemp1())){
        		whereStr.append(" and yb.Temp1 = '").append(yb.getTemp1()).append("'");
        	}
            if(!StringUtil.isBlank(yb.getBohstatus()))
            	whereStr.append(" and sta.BOHSTATUS = '").append(yb.getBohstatus()).append("'");
        	if(!StringUtil.isBlank(yb.getStartDate()))
        		whereStr.append(" and to_char(yb.BOHSHTIME,'yyyy-mm-dd') >='").append(yb.getStartDate()).append("'");
            if(!StringUtil.isBlank(yb.getEndDate()))
            	whereStr.append(" and to_char(yb.BOHSHTIME,'yyyy-mm-dd') <= '").append(yb.getEndDate()).append("'");
            if(!StringUtil.isBlank(yb.getBohmfid()))
            	whereStr.append(" and yb.BOHMFID = '").append(yb.getBohmfid()).append("'");
            if(!StringUtil.isBlank(yb.getBohsupid()))
            	whereStr.append(" and yb.BOHSUPID = '").append(yb.getBohsupid()).append("'");
            if(!StringUtil.isBlank(yb.getBohsgcode()))
            	whereStr.append(" and yb.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
            
            /*总条数,合计查询*/
            countSql.append(whereStr);
            List lstResult = dao.executeSql(countSql.toString());
            if(lstResult != null){
            	 result.setTotal(Integer.parseInt(((Map)lstResult.get(0)).get("COUNT(*)").toString()));
            } 
            sumSql.append(whereStr);
            lstResult = dao.executeSql(sumSql.toString());
            if(lstResult != null){
            	result.setFooter(lstResult);
            }
            
            /*分页查询*/
            if(yb.getOrder() != null && yb.getSort() != null){
            	whereStr.append(" order by "+yb.getSort()).append(" ").append(yb.getOrder());
            }else{
            	whereStr.append(" order by yb.bohbillno desc ");
            }
            sql.append(whereStr);
            lstResult = dao.executeSql(sql.toString(), start, limit);
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setRows(lstResult);
            }
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.SearchYwBorderhead() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
            ex.printStackTrace();
        }
        return result;
    }
}