package com.bfuture.app.saas.service.impl;



import java.util.List;
import java.util.Map;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.InfGoods;
import com.bfuture.app.saas.service.GoodsManager;

public class GoodsManagerImpl extends BaseManagerImpl implements GoodsManager{
	protected final Log log = LogFactory.getLog(GoodsManagerImpl.class);

	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public GoodsManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
        ReturnObject result = new ReturnObject();
		if( "getDetail".equals( actionType ) ){
			try{
				InfGoods infGoods = (InfGoods)o[0];
				int limit = infGoods.getRows();
				int start = ( infGoods.getPage() - 1) * infGoods.getRows() ;
				
				StringBuffer countSql = new StringBuffer( " select count(G.GDID)AMOUNT from INF_GOODS G  " );
				StringBuffer sql = new StringBuffer( " select G.* from INF_GOODS G  " );
				
				/*查询条件*/
				StringBuffer whereStr = new  StringBuffer(" where 1=1 ");;
				if(!StringUtil.isBlank(infGoods.getGdsgcode())){
					whereStr.append( " and G.GDSGCODE = '" ).append( infGoods.getGdsgcode() ).append("'");
				}
				if(!StringUtil.isBlank(infGoods.getGdid())){
					whereStr.append( " and G.GDID like '%" ).append( infGoods.getGdid() ).append("%'");
				}
				if(!StringUtil.isBlank(infGoods.getSupcode())){
					whereStr.append( " and exists (select GS.GSID from INF_GOODSUPLY GS where G.GDSGCODE = GS.GSSGCODE AND G.GDID = GS.GSID and GS.GSSUPID='"+infGoods.getSupcode()+"') " );
				}
				if(!StringUtil.isBlank(infGoods.getGdbarcode())){
					whereStr.append( " and G.GDBARCODE like '%" ).append( infGoods.getGdbarcode() ).append("%'");
				}
				if(!StringUtil.isBlank(infGoods.getGdname())){
					whereStr.append( " and G.GDNAME like '%" ).append( infGoods.getGdname() ).append("%'");
				}
				if(!StringUtil.isBlank(infGoods.getGdcatid())){
					whereStr.append( " and G.GDCATID like '%" ).append( infGoods.getGdcatid() ).append("%'");
				}
				if(!StringUtil.isBlank(infGoods.getGdcatname())){
					whereStr.append( " and G.GDCATNAME like '%" ).append( infGoods.getGdcatname() ).append("%'");
				}
				
				/*总条数查询*/
				countSql.append(whereStr);
				log.info(countSql);
				List lstResult = dao.executeSql(countSql.toString());
				if( lstResult != null ){
					result.setTotal( Integer.parseInt( ((Map)lstResult.get(0)).get("AMOUNT").toString()));
				}
				
				/*分页查询*/
				if( infGoods.getOrder() != null && infGoods.getSort() != null ){
					whereStr.append( " order by " ).append( infGoods.getSort() ).append( " " ).append( infGoods.getOrder() );
				}
				sql.append(whereStr);
				log.info(sql);
				lstResult = dao.executeSql( sql.toString(),start,limit);
				
			
				if (lstResult != null && lstResult.size() > 0) {
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );	
				}
			}catch (Exception ex) {
				log.error("GoodsManagerImpl.getCategory() error : " + ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
				ex.printStackTrace();
			}
		}
		return result;
	}
}
