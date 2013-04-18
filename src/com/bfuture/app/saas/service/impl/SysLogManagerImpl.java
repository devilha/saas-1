package com.bfuture.app.saas.service.impl;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.SysLogevent;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.SysLogManager;

public class SysLogManagerImpl extends BaseManagerImpl implements
		SysLogManager {

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public SysLogManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	/* (non-Javadoc)
	 * @see com.bfuture.app.basic.service.impl.BaseManagerImpl#ExecOther(java.lang.String, java.lang.Object[])
	 */
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if( "search".equals( actionType ) ){
			try{
				SysLogevent log = (SysLogevent)o[0];
				StringBuffer countSql = new StringBuffer( "select count(distinct log.letime) ")
				.append( "from SYS_LOGEVENT log left join INF_SUPINFO supinfo on log.supcode = supinfo.supid and log.sgcode = supinfo.supsgcode left join SYS_LOGTYPE type on log.letype=type.type left join sys_scmuser user on log.sucode=user.sucode and log.sgcode=user.sgcode where user.sutype = 'S' ");
				
				if( !StringUtil.isBlank( log.getSucode() ) ){
					countSql.append( " and log.sucode = '" ).append( log.getSucode() ).append("'");
				}	
				if( !StringUtil.isBlank( log.getSupcode() ) ){
					countSql.append( " and log.supcode = '" ).append( log.getSupcode() ).append("'");
				}
				if( !StringUtil.isBlank( log.getSgcode() ) ){
					countSql.append( " and log.sgcode = '" ).append( log.getSgcode() ).append("'");
				}
				if( !StringUtil.isBlank( log.getBdate())){
					countSql.append(" and log.letime >= '").append( log.getBdate() ).append(" 00:00:00").append("'");
				}
				if( !StringUtil.isBlank( log.getEdate())){
					countSql.append(" and log.letime <= '").append( log.getEdate()+" 24:00:00" ).append("'");
				}
				List lstResult = dao.executeSql( countSql.toString() );
				if( lstResult != null ){
					Map m = (Map) lstResult.get(0);
					result.setTotal(Integer.parseInt(m.get("1").toString()));				  
			}
					
				int limit =  log.getRows();
				int start = ( log.getPage() - 1) * log.getRows() ;
				String str_order = "order by letime desc";
				if( log.getOrder() != null && log.getSort() != null ){
					str_order =  "order by " + log.getSort() + ( " " ) + ( log.getOrder() );
				}
				StringBuffer sql = new StringBuffer( "select distinct log.sucode,log.supcode,supinfo.supname,type.name,log.lecontent,user.suname,substr(char(log.letime),1,10)||' '||substr(char(log.letime),12,5) letime ")
				.append( "from SYS_LOGEVENT log left join INF_SUPINFO supinfo on log.supcode = supinfo.supid and log.sgcode = supinfo.supsgcode left join SYS_LOGTYPE type on log.letype=type.type left join sys_scmuser user on log.sucode=user.sucode and log.sgcode=user.sgcode where user.sutype = 'S' ");	
				if( !StringUtil.isBlank( log.getSucode() ) ){
					sql.append( " and log.sucode = '" ).append( log.getSucode() ).append("'");
				}	
				if( !StringUtil.isBlank( log.getSupcode() ) ){
					sql.append( " and log.supcode = '" ).append( log.getSupcode() ).append("'");
				}
				if( !StringUtil.isBlank( log.getSgcode() ) ){
					sql.append( " and log.sgcode = '" ).append( log.getSgcode() ).append("'");
				}
				if( !StringUtil.isBlank( log.getBdate())){
					sql.append(" and log.letime >= '").append( log.getBdate() ).append(" 00:00:00").append("'");
				}
				if( !StringUtil.isBlank( log.getEdate())){
					sql.append(" and log.letime <= '").append( log.getEdate()+" 24:00:00" ).append("' ");
				}
				sql.append(str_order);
				lstResult = dao.executeSql( sql.toString(), start, limit );
				if( lstResult != null ){
					result.setRows(lstResult);
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}			
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		return result;
	}

	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			SysLogevent log = (SysLogevent)o;
			
			StringBuffer countHql = new StringBuffer( "select count(*) from SysLogevent log where 1 = 1" );			
			
			if( !StringUtil.isBlank( log.getSucode() ) ){
				countHql.append( " and user.sucode like '%" ).append( log.getSucode() ).append("'");
			}
			if( !StringUtil.isBlank( log.getSupcode() ) ){
				countHql.append( " and log.supcode like '%" ).append( log.getSupcode() ).append("%'");
			}
			
			List lstResult = dao.executeHql( countHql.toString() );
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
			}
			
			StringBuffer hql = new StringBuffer( "from SysLogevent log where 1 = 1" );
			int limit = log.getRows();
			int start = ( log.getPage() - 1) * log.getRows() ;
			
			if( !StringUtil.isBlank( log.getSucode() ) ){
				hql.append( "and log.sucode = '" ).append( log.getSucode() ).append("'");
			}
			if( !StringUtil.isBlank( log.getSupcode() ) ){
				hql.append( "and log.supcode like '%" ).append( log.getSupcode() ).append("%'");
			}
			
			if( log.getOrder() != null && log.getSort() != null ){
				hql.append( " order by " ).append( log.getSort() ).append( " " ).append( log.getOrder() );
			}
			
			lstResult = dao.executeHql( hql.toString(), start, limit );
			if( lstResult != null ){
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstResult );
			}
			
		}
		catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
		}
		
		return result;
	}

	public void log(SysScmuser smUser, BaseObject bo) throws Exception {
		
		if( smUser != null && bo != null ){
			
			if( !StringUtil.isBlank( bo.getOptType() ) && !StringUtil.isBlank( bo.getOptContent() ) ){
				SysLogevent sysLog = new SysLogevent();
				sysLog.setSgcode( smUser.getSgcode() );
				sysLog.setSucode( smUser.getSucode() );
				sysLog.setSupcode( smUser.getCompanycode() != null ? smUser.getCompanycode().toString() : "unknow" );
				sysLog.setLetype( bo.getOptType() );
				sysLog.setLetime( new Date() );
				sysLog.setLecontent( bo.getOptContent() );
				
				save( sysLog );
			}
		}
	}

	public SysLogevent getLastLog(SysScmuser smUser, String optType)
			throws Exception {
		SysLogevent result = new SysLogevent();
		
		try{
			
			StringBuffer hql = new StringBuffer( "from SysLogevent log where 1 = 1" );			
			
			if( !StringUtil.isBlank( smUser.getSucode() ) ){
				hql.append( "and log.sucode = '" ).append( smUser.getSucode() ).append("'");
			}
			if( !StringUtil.isBlank( optType ) ){
				hql.append( "and log.letype = '" ).append( optType ).append("'");
			}
			
			hql.append( " order by log.letime desc " );
			
			List lstResult = dao.executeHql( hql.toString() );
			if( lstResult != null && lstResult.size() > 1 ){
				result = (SysLogevent)lstResult.get( 1 );
			}
			
		}
		catch( Exception ex ){
			ex.printStackTrace();
		}
		
		return result;
	}
}
