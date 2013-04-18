package com.bfuture.app.saas.service.impl;

import java.util.List;
import java.util.Map;



import oracle.sql.NCLOB;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.Billheaditem;
import com.bfuture.app.saas.model.BillheaditemId;
import com.bfuture.app.saas.model.InfLicence;
import com.bfuture.app.saas.model.MsgNotice;
import com.bfuture.app.saas.model.report.Stock;
import com.bfuture.app.saas.service.GoodsManager;
import com.bfuture.app.saas.service.WarningRemindManager;

public class WarningRemindManagerImpl extends BaseManagerImpl implements WarningRemindManager {
protected final Log log = LogFactory.getLog(WarningRemindManagerImpl.class);

	
	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public WarningRemindManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		// TODO Auto-generated method stub
		  ReturnObject result = new ReturnObject();

			
			if( "getStockNum".equals( actionType ) ){
				try{
				
					StringBuffer sql = new StringBuffer( "select count(*) c FROM YW_ZRSTOCK  where ZSKCSL<=0 " );
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						sql.append( " and ZSSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						sql.append( " and ZSSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
					List	lstResult = dao.executeSql( sql.toString() );

					if( lstResult != null ){
						Map m = (Map) lstResult.get(0);
						result.setTotal(Integer.parseInt(m.get("C").toString()));				
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}			
				}
			catch (Exception ex) {
				log.error("WarningRemindManagerImpl error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
				ex.printStackTrace();
			}
	}
			
			if( "getOrderNum".equals( actionType ) ){
				try{
				
					StringBuffer countSql = new StringBuffer( "SELECT COUNT(*) c FROM YW_BORDERSTATUS BS left join YW_BORDERHEAD BH ON BS.BOHBILLNO=BH.BOHBILLNO AND BS.BOHSGCODE=BH.BOHSGCODE where BS.BOHSTATUS is null AND BH.BOHJHRQ BETWEEN (SYSDATE-2) AND SYSDATE " );
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and BH.BOHSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and BH.BOHSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
					List	lstResult = dao.executeSql( countSql.toString() );

					if( lstResult != null ){
						Map m = (Map) lstResult.get(0);
						result.setTotal(Integer.parseInt(m.get("C").toString()));				
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					
				}
			catch (Exception ex) {
				log.error("WarningRemindManagerImpl error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
				ex.printStackTrace();
			}
	}
			if( "getBorderNum".equals( actionType ) ){
				try{				
					StringBuffer countSql = new StringBuffer( "select count(*) c from YW_BORDERSTATUS BS left join YW_BORDERHEAD BH ON BS.BOHBILLNO=BH.BOHBILLNO AND BS.BOHSGCODE=BH.BOHSGCODE AND BS.BOHSHMFID = BH.BOHSHMFID where BS.BOHSTATUS = 1  ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and BH.BOHSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and BH.BOHSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "getBtcdNum".equals( actionType ) ){
				try{				
					StringBuffer countSql = new StringBuffer( "select count(*) c FROM yw_btcdhead h ,inf_supinfo sup,yw_btcdstatus st WHERE sup.supid  =h.BTHsupid AND sup.supsgcode=h.bthsgcode   AND st.bthbillno=h.bthbillno and  st.BTHSTATUS =1  ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and h.BTHSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and h.BTHSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "yuQiBtcdNum".equals( actionType ) ){
				try{				
					StringBuffer countSql = new StringBuffer( "select count(*) c FROM yw_btcdhead h ,inf_supinfo sup,yw_btcdstatus st WHERE sup.supid  =h.BTHsupid AND sup.supsgcode=h.bthsgcode   AND st.bthbillno=h.bthbillno and  st.BTHSTATUS =2 AND h.BTHSHTIME BETWEEN (SYSDATE-5) AND SYSDATE  ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and h.BTHSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and h.BTHSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "getZhengBHNum".equals( actionType ) ){
				try{	
				
					StringBuffer countSql = new StringBuffer( "select count(*) c from INF_LICENCE  where  STATUS = 2 AND VIEW_STATUS IS NULL ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and INS_C = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and SUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "getZhengNum".equals( actionType ) ){
				try{	
				
					StringBuffer countSql = new StringBuffer( "select count(*) c from INF_LICENCE  where  STATUS = 0 ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and INS_C = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and SUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "getPopNum".equals( actionType ) ){
				try{				
					StringBuffer countSql = new StringBuffer( "select count(*) c from YW_POPINFO_NEW  where  (PPHFYJ ='1' or PPHFYJ ='2') and PPVIEWSTATUS IS NULL  ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and PPSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and PPSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			
			if( "getlshPopNum".equals( actionType ) ){
				try{				
					StringBuffer countSql = new StringBuffer( "select count(*) c from YW_POPINFO_NEW  where  PPHFYJ ='0'   ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and PPSGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and PPSUPID = '" ).append( user.getSupcode() ).append("'");
					}
					
									
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
			if( "getBillNum".equals( actionType ) ){
				BillheaditemId billheaditem=(BillheaditemId) o[0];
				try{		
					
					StringBuffer countSql = new StringBuffer( " select count(*) c from BILLHEAD BH LEFT JOIN BILLHEADITEM BM ON BH.SGCODE=BM.SGCODE AND BH.SHEETID=BM.SHEETID    where BH.FLAG=0  ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						countSql.append( " and BH.SGCODE = '" ).append( user.getSgcode() ).append("'");
					}
					if( !StringUtil.isBlank(  user.getSupcode() ) ){// 供应商编码
						
						countSql.append( " and BH.VENDERID = '" ).append( user.getSupcode() ).append("'");
					}
                   if( !StringUtil.isBlank(  billheaditem.getPaytypesortid() ) ){// 结算类型
						
						countSql.append( " and BM.PAYTYPESORTID = '" ).append( billheaditem.getPaytypesortid() ).append("'");
					}
					
									
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
			if( "getSupMess".equals( actionType ) ){
			
				try{		
					
					StringBuffer countSql = new StringBuffer( "select count(*) c from MSG_MESSAGE msg where msg.MM_RE_BY_C = '").append( user.getSucode() ).append( "'" )
					.append( " and MM_STATUS = '").append( MESSAGE_STATE_OFFICIAL ).append( "' " );
								
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
			if( "getNoticeDetail".equals( actionType ) ){
				
				try{	
				   
                   
					StringBuffer hql = new StringBuffer( " from MsgNotice notice where 1=1  ");
					hql.append( " and (notice.mnStatus   ='official' or notice.mnStatus   ='readed') ")
					.append( " and notice.enabled = 'Y'").append(" and notice.mnEndDate >=sysdate ");
					if( !StringUtil.isBlank( user.getSgcode() ) ){// [实例编码]
						
						hql.append( " and notice.insC = '" ).append( user.getSgcode() ).append("'");
					}
					
					hql.append(" order by notice.mnFbDate desc");	
					List lstResult = dao.executeHql(hql.toString(),0,1);

				
					
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
	
	

}
