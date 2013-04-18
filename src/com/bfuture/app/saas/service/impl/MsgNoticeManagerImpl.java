package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;

import com.bfuture.app.saas.model.MsgMessage;
import com.bfuture.app.saas.model.MsgNotice;
import com.bfuture.app.saas.model.SysLogevent;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.MsgNoticeManager;
import com.bfuture.app.saas.util.StringUtil;
import com.bfuture.app.saas.util.Tools;

public class MsgNoticeManagerImpl extends BaseManagerImpl implements
		MsgNoticeManager {

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public MsgNoticeManagerImpl(){
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
		if( "getNoticeNum".equals( actionType ) ){
			try{
				
				String now = sdf.format( new Date() );
				
				StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_NOTICE n ,MSG_NOTICE_STATE s where n.ENABLED = 'Y' and n.id=s.id and n.ins_c=s.ins_c  and n.INS_C = '").append( user.getSgcode() ).append( "'" )
					.append( " and mn_begin_date <= to_date('").append( now ).append( "','YYYY-MM-DD') " ).append("and s.supid='"+user.getSupcode()+"'").append(" and s.state='1'")
					.append( " and mn_end_date >= to_date('").append( now ).append( "','YYYY-MM-DD') " )
					.append( " and MN_STATUS = '" ).append( NOTICE_STATE_OFFICIAL ).append( "'");
								
				List lstResult = dao.executeSql( countSql.toString() );
				if( lstResult != null ){
					Map m = (Map) lstResult.get(0);
					result.setTotal(Integer.parseInt(m.get("C").toString()));				
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}			
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "editNotice".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				if( notice.getId() != null ){
					
					StringBuffer hql = new StringBuffer("from MsgNotice where id=").append( notice.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						if (notice.getTemp1()!=null&&notice.getTemp1().equals("S")){
						StringBuffer sql=new StringBuffer("update MSG_NOTICE_STATE SET STATE ='2'").append(" where id=").append(notice.getId());
						sql.append(" and ins_c='"+user.getSgcode()+"'").append(" and supid='"+user.getSupcode()+"'");
						log.info("修改公告查看状态：—"+sql.toString());
						dao.updateSql(sql.toString());
						}
						result.setRows( lstResult );
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					else{
						result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( "没有找到匹配的公告" );
					}
					
				}								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}		
		else if( "saveNotice".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				if( notice.getId() == null ){
					
					String sql="select SEQ_MSG_NOTICE.Nextval seq from dual";
					List lstResult = dao.executeSql( sql );
					int id=Integer.parseInt(((Map)lstResult.get(0)).get("SEQ").toString());
					StringBuffer note=new StringBuffer(" insert into msg_notice(id,ins_c,mn_title,mn_content,crt_by_cn,crt_by_time,mn_fb_date,mn_status,enabled,mn_begin_date,mn_end_date) values(");
					note.append(id+",'"+user.getSgcode()+"','"+notice.getMnTitle()+"','"+notice.getMnContent()+"','"+user.getSuname()+"'");
					note.append(",sysdate,sysdate,'"+NOTICE_STATE_DRAFT+"','Y'");
					note.append(",to_date('"+notice.getStartDate().toString()+"','yyyy-mm-dd')");
					note.append(",to_date('"+notice.getEndDate().toString()+"','yyyy-mm-dd'))");
					dao.saveBySQL(note.toString());
					
					StringBuffer state=new StringBuffer(" insert into msg_notice_state select ").append(id+",");
					state.append(" sgcode,supcode,'1','','','','','' from sys_scmuser where suenable='Y' and sutype='S' and  sgcode='").append(user.getSgcode()+"'");
					dao.saveBySQL(state.toString());
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				else{
					StringBuffer hql = new StringBuffer("from MsgNotice where id=").append( notice.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						MsgNotice mn = (MsgNotice) lstResult.get(0);						
						
						Tools.copyProperties( notice, mn, false );
						mn.setLastUpByC( user.getSucode() );
						mn.setLastUpByTime( new Date() );
						
						save( mn );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
				}
								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "publish".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				Date now = new Date();
				if( notice.getId() == null ){
					String sql="select SEQ_MSG_NOTICE.Nextval seq from dual";
					List lstResult = dao.executeSql( sql );
					int id=Integer.parseInt(((Map)lstResult.get(0)).get("SEQ").toString());
					
					StringBuffer note=new StringBuffer(" insert into msg_notice(id,ins_c,mn_title,mn_content,crt_by_cn,crt_by_time,mn_fb_date,mn_status,enabled,mn_begin_date,mn_end_date) values(");
					note.append(id+",'"+user.getSgcode()+"','"+notice.getMnTitle()+"','"+notice.getMnContent()+"','"+user.getSuname()+"'");
					note.append(",sysdate,sysdate,'"+NOTICE_STATE_OFFICIAL+"','Y'");
					note.append(",to_date('"+notice.getStartDate().toString()+"','yyyy-mm-dd')");
					note.append(",to_date('"+notice.getEndDate().toString()+"','yyyy-mm-dd'))");
					dao.saveBySQL(note.toString());
					
					StringBuffer state=new StringBuffer(" insert into msg_notice_state select ").append(id+",");
					state.append(" sgcode,supcode,'1','','','','','' from sys_scmuser where suenable='Y' and sutype='S' and  sgcode='").append(user.getSgcode()+"'");
					dao.saveBySQL(state.toString());
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				else{
					StringBuffer hql = new StringBuffer("from MsgNotice where id=").append( notice.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						MsgNotice mn = (MsgNotice) lstResult.get(0);						
						
						Tools.copyProperties( notice, mn, false );
						mn.setLastUpByC( user.getSucode() );
						mn.setLastUpByTime( now );
						mn.setMnFbDate( now );
						mn.setMnStatus( NOTICE_STATE_OFFICIAL );
						mn.setEnabled( "Y" );
						
						notice.setMnStatus( NOTICE_STATE_OFFICIAL );
						
						save( mn );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
				}
								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}		
		else if( "publishNotice".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				if( notice.getId() != null && StringUtil.isNotEmpty( notice.getMnStatus() ) ){
					
					StringBuffer hql = new StringBuffer("from MsgNotice where id=").append( notice.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						
						MsgNotice mn = (MsgNotice)lstResult.get( 0 );
						mn.setMnStatus( notice.getMnStatus() );
						mn.setEnabled( "Y" );
						
						if( NOTICE_STATE_OFFICIAL.equals( notice.getMnStatus() ) ){
							mn.setMnFbDate( new Date() );
						}
						
						save( mn );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					else{
						result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( "没有找到匹配的公告" );
					}				
					
				}								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "enableNotice".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				if( notice.getId() != null && StringUtil.isNotEmpty( notice.getEnabled() ) ){
					
					StringBuffer hql = new StringBuffer("from MsgNotice where id=").append( notice.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						
						MsgNotice mn = (MsgNotice)lstResult.get( 0 );
						mn.setEnabled( notice.getEnabled() );
						
						save( mn );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					else{
						result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( "没有找到匹配的公告" );
					}				
					
				}								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "removeNotice".equals( actionType ) ){
			try{
				MsgNotice notice = (MsgNotice)o[0];				
				
				if( notice.getId() != null ){
						
					String sql=" delete from msg_notice where id="+notice.getId();
					String state=" delete from msg_notice_state where id="+notice.getId();
					dao.saveBySQL(sql);
					dao.saveBySQL(state);
				}								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}else if( "getNoticeS".equals( actionType ) ){
			try{
			
					StringBuffer hql = new StringBuffer( "from MsgNotice notice where 1 = 1" );
					hql.append( " and notice.insC = '" ).append( user.getSgcode() ).append( "'" );
					hql.append( " and notice.mnStatus = '" ).append( NOTICE_STATE_OFFICIAL ).append( "'").append( " or notice.mnStatus = '" )
					.append( NOTICE_STATE_READED ).append( "' ").append( " and notice.enabled = 'Y'");
					
					hql.append( " order by notice.mnFbDate desc" );
					
					List lstResult = dao.executeHql( hql.toString(),0,5 );
					
					if( lstResult != null ){		
						result.setReturnCode( Constants.SUCCESS_FLAG );
						result.setRows( lstResult );
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
			MsgNotice notice = (MsgNotice)o;
			String now = sdf.format( new Date() );
			
			StringBuffer countHql = new StringBuffer( "select count(*) from MsgNotice notice where 1 = 1" );			
			countHql.append( " and notice.insC = '" ).append( user.getSgcode() ).append( "'" );
		
			if( "S".equalsIgnoreCase( user.getSutype().toString() ) ){
				 countHql.append( " and notice.mnBeginDate <= to_date('").append( now ).append( "','YYYY-MM-DD') " )
						.append( " and notice.mnEndDate >= to_date('").append( now ).append( "','YYYY-MM-DD') " )
						.append( " and (notice.mnStatus = '" ).append( NOTICE_STATE_OFFICIAL ).append( "' ").append( " or notice.mnStatus = '" )
						.append( NOTICE_STATE_READED ).append( "') ")
						.append( " and notice.enabled = 'Y'");
			}
		
			List lstResult = dao.executeHql( countHql.toString() );
		
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
			}
		
			StringBuffer hql = new StringBuffer( "from MsgNotice notice where 1 = 1" );
			hql.append( " and notice.insC = '" ).append( user.getSgcode() ).append( "'" );
			
			if( "S".equalsIgnoreCase( user.getSutype().toString() ) ){
				hql.append( " and notice.mnBeginDate <= to_date('").append( now ).append( "','YYYY-MM-DD') " )
					.append( " and notice.mnEndDate >= to_date('").append( now ).append( "','YYYY-MM-DD') " )
					.append( " and (notice.mnStatus = '" ).append( NOTICE_STATE_OFFICIAL ).append( "'").append( " or notice.mnStatus = '" )
					.append( NOTICE_STATE_READED ).append( "') ")
					.append( " and notice.enabled = 'Y'");
			}
			
			int limit = notice.getRows();
			int start = ( notice.getPage() - 1) * notice.getRows() ;
			
			if( notice.getOrder() != null && notice.getSort() != null ){
				hql.append( " order by " ).append( notice.getSort() ).append( " " ).append( notice.getOrder() );
			}
			else{
				hql.append( " order by notice.mnFbDate desc" );
			}
			System.out.println("hql"+hql.toString());
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
}
