package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.MsgMessage;
import com.bfuture.app.saas.service.MsgMessageManager;
import com.bfuture.app.saas.util.StringUtil;
import com.bfuture.app.saas.util.Tools;

public class MsgMessageManagerImpl extends BaseManagerImpl implements
		MsgMessageManager {

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public MsgMessageManagerImpl(){
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
		if( "getMessageNum".equals( actionType ) ){
			try{				
				StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_MESSAGE msg where msg.MM_RE_BY_C = '").append( user.getSucode() ).append( "'" )
					.append( " and MM_STATUS = '").append( MESSAGE_STATE_OFFICIAL ).append( "'" );
								
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
		else if( "editMsg".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];				
				
				if( msg.getId() != null ){
					
					StringBuffer hql = new StringBuffer("from MsgMessage where id=").append( msg.getId() );
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						
						if( "Y".equalsIgnoreCase( msg.getViewFlag() ) ){
						
							msg = (MsgMessage)lstResult.get( 0 );
							msg.setMmStatus( MESSAGE_STATE_READED );
							
							
						}
						
						result.setRows( lstResult );
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					else{
						result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( "没有找到匹配的消息" );
					}
				}			
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}		
		else if( "saveMsg".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];				
				
				if( msg.getId() == null ){
					Date now = new Date();
					msg.setInsC( user.getSgcode() );
					msg.setCrtByC( user.getSucode() );					
					msg.setCrtByTime( now );
					msg.setMmSendC( user.getSucode() );
					msg.setMmSendCn( user.getSuname() );
					msg.setMmStatus( MESSAGE_STATE_DRAFT );
					
					save( msg );
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				else{
					StringBuffer hql = new StringBuffer("from MsgMessage where id=").append( msg.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						MsgMessage mm = (MsgMessage) lstResult.get(0);						
						
						Tools.copyProperties( msg, mm, false );
						mm.setLastUpByC( user.getSucode() );
						mm.setLastUpByTime( new Date() );
						
						save( mm );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
				}
								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "send".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];				
				
				Date now = new Date();
				if( msg.getId() == null ){
					
					msg.setInsC( user.getSgcode() );
					msg.setCrtByC( user.getSucode() );					
					msg.setCrtByTime( now );
					msg.setMmFbDate( now );
					msg.setMmSendC( user.getSucode() );
					msg.setMmSendCn( user.getSuname() );
					msg.setMmStatus( MESSAGE_STATE_OFFICIAL );
					
					save( msg );					
					
					MsgMessage mmSend = new MsgMessage();
					Tools.copyProperties( msg, mmSend, false );
					mmSend.setMmStatus( MESSAGE_STATE_SENDED );
					save( mmSend );
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
				else{
					StringBuffer hql = new StringBuffer("from MsgMessage where id=").append( msg.getId() );
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null && lstResult.size() > 0 ){
						MsgMessage mm = (MsgMessage) lstResult.get(0);						
						
						Tools.copyProperties( msg, mm, false );
						mm.setLastUpByC( user.getSucode() );
						mm.setLastUpByTime( now );
						mm.setMmFbDate( now );
						mm.setMmStatus( MESSAGE_STATE_OFFICIAL );
						
						save( mm );
						
						MsgMessage mmSend = new MsgMessage();
						Tools.copyProperties( mm, mmSend, false );
						mmSend.setId( null );
						mmSend.setMmStatus( MESSAGE_STATE_SENDED );
						save( mmSend );
						
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
				}
								
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "removeMsg".equals( actionType ) ){
			try{
				
				if( o != null && o.length > 0 ){
					for( Object obj : o ){
						MsgMessage msg = (MsgMessage)obj;
						if( msg.getId() != null ){
							
							StringBuffer hql = new StringBuffer("from MsgMessage where id=").append( msg.getId() );
							
							List lstResult = dao.executeHql( hql.toString() );
							if( lstResult != null && lstResult.size() > 0 ){
								
								MsgMessage mm = (MsgMessage)lstResult.get( 0 );
								
								remove( mm );
								
								
							}							
						}
					}
				}
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
							
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "getMyMessages".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];
				StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_MESSAGE msg where msg.MM_RE_BY_C = '").append( user.getSucode() ).append( "'" )
					.append( " and (MM_STATUS = '").append( MESSAGE_STATE_OFFICIAL ).append( "' or MM_STATUS = '" ).append( MESSAGE_STATE_READED ).append( "')" );
								
				List lstResult = dao.executeSql( countSql.toString() );
				if( lstResult != null ){
					Map m = (Map) lstResult.get(0);
					result.setTotal(Integer.parseInt(m.get("C").toString()));				  
				}
					
				int limit =  msg.getRows();
				int start = ( msg.getPage() - 1) * msg.getRows() ;
				String str_order = "order by mmFbDate desc";
				if( msg.getOrder() != null && msg.getSort() != null ){
					str_order =  "order by " + msg.getSort() + ( " " ) + ( msg.getOrder() );
				}
				StringBuffer hql = new StringBuffer( " from MsgMessage m where m.mmReByC = '").append( user.getSucode() ).append( "'" )
					.append( " and (m.mmStatus = '").append( MESSAGE_STATE_OFFICIAL ).append( "' or m.mmStatus = '" ).append( MESSAGE_STATE_READED ).append( "')" );;
				
				hql.append( str_order );
					
				lstResult = dao.executeHql( hql.toString(), start, limit );
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
		else if( "getSendMessages".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];
				StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_MESSAGE msg where msg.MM_SEND_C = '").append( user.getSucode() ).append( "'" )
					.append( " and MM_STATUS = '").append( MESSAGE_STATE_SENDED ).append( "'" );
								
				List lstResult = dao.executeSql( countSql.toString() );
				if( lstResult != null ){
					Map m = (Map) lstResult.get(0);
					result.setTotal(Integer.parseInt(m.get("C").toString()));				  
				}
					
				int limit =  msg.getRows();
				int start = ( msg.getPage() - 1) * msg.getRows() ;
				String str_order = "order by crtByTime desc";
				if( msg.getOrder() != null && msg.getSort() != null ){
					str_order =  "order by " + msg.getSort() + ( " " ) + ( msg.getOrder() );
				}
				StringBuffer hql = new StringBuffer( " from MsgMessage m where m.mmSendC = '").append( user.getSucode() ).append( "'" )
					.append( " and m.mmStatus = '").append( MESSAGE_STATE_SENDED ).append( "'" );;
				
				hql.append( str_order );
					
				lstResult = dao.executeHql( hql.toString(), start, limit );
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
		else if( "getDraftMessages".equals( actionType ) ){
			try{
				MsgMessage msg = (MsgMessage)o[0];
				StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_MESSAGE msg where msg.MM_SEND_C = '").append( user.getSucode() ).append( "'" )
					.append( " and MM_STATUS = '").append( MESSAGE_STATE_DRAFT ).append( "'" );
								
				List lstResult = dao.executeSql( countSql.toString() );
				if( lstResult != null ){
					Map m = (Map) lstResult.get(0);
					result.setTotal(Integer.parseInt(m.get("C").toString()));				  
				}
					
				int limit =  msg.getRows();
				int start = ( msg.getPage() - 1) * msg.getRows() ;
				String str_order = "order by crtByTime desc";
				if( msg.getOrder() != null && msg.getSort() != null ){
					str_order =  "order by " + msg.getSort() + ( " " ) + ( msg.getOrder() );
				}
				StringBuffer hql = new StringBuffer( " from MsgMessage m where m.mmSendC = '").append( user.getSucode() ).append( "'" )
					.append( " and m.mmStatus = '").append( MESSAGE_STATE_DRAFT ).append( "'" );;
				
				hql.append( str_order );
					
				lstResult = dao.executeHql( hql.toString(), start, limit );
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
		else if( "getReceivers".equals( actionType ) ){
			MsgMessage mm = (MsgMessage)o[0];
			StringBuffer sql = new StringBuffer( " select SUCODE,nvl(SUPCODE,'')||'-'||SUNAME SUNAME from SYS_SCMUSER u where u.SUTYPE = '").append( "S".equals( StringUtil.nullToBlank( user.getSutype() ) ) ? "L" : "S" ).append( "'" )
					.append( " and u.SGCODE = '").append( user.getSgcode() ).append( "' and u.SUENABLE = 'Y'");
			//简家超市供应商新建信息给简家超市零售商时接受人修改为“简家超市零售商”
			if("3011".equals(user.getSgcode())&& "S".equalsIgnoreCase(StringUtil.nullToBlank(user.getSutype()))){
				sql=new StringBuffer( " select SUCODE,cast('简家超市零售商' as varchar2(30)) SUNAME from SYS_SCMUSER u where u.SUTYPE = '").append( "S".equals( StringUtil.nullToBlank( user.getSutype() ) ) ? "L" : "S" ).append( "'" )
				.append( " and u.SGCODE = '").append( user.getSgcode() ).append( "' and u.SUENABLE = 'Y'");
			}
				
			if("3018".equals(user.getSgcode())){
				sql = new StringBuffer( " select SUPCODE,nvl(SUPCODE,'')||'-'||SUNAME SUNAME from SYS_SCMUSER u where u.SUTYPE = '").append( "S".equals( StringUtil.nullToBlank( user.getSutype() ) ) ? "L" : "S" ).append( "'" )
				.append( " and u.SGCODE = '").append( user.getSgcode() ).append( "' and u.SUENABLE = 'Y'");
			}
			
			if( StringUtil.isNotEmpty( mm.getMmReByC() ) ){
				sql.append( " and (u.SUCODE like '" ).append( mm.getMmReByC() ).append( "%'" );
				sql.append( " or u.SUNAME like '" ).append( mm.getMmReByC() ).append( "%'" );
				sql.append( " or u.SUPCODE like '" ).append( mm.getMmReByC() ).append( "%')" );
			}
			
			List lstResult = dao.executeSql( sql.toString(), 0, 20 );
			if( lstResult != null ){
				result.setRows(lstResult);
				result.setReturnCode( Constants.SUCCESS_FLAG );						
			}			
		}
		else if( "getMess".equals( actionType ) ){
			try{
			
				StringBuffer hql = new StringBuffer( " from MsgMessage m where m.mmSendC = '").append( user.getSucode() ).append( "'" )
				.append( " and m.mmStatus = '").append( MESSAGE_STATE_SENDED ).append( "'" );
				hql.append(" order by m.mmFbDate desc");
			
				List lstResult = dao.executeHql( hql.toString(),0,5 );
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
			
			
		}
		catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
		}
		
		return result;
	}

	public ReturnObject getMyMsgList(String mmReByC) {
		// TODO Auto-generated method stub
		return null;
	}

	
}
