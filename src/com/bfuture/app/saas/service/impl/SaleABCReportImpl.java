package com.bfuture.app.saas.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.YwGoodssale;

public class SaleABCReportImpl extends BaseManagerImpl implements BaseManager {
	
	protected final Log log = LogFactory.getLog(SaleABCReportImpl.class);
	
	@Override
	public ReturnObject getResult(Object o) {
		log.info("SaleABCReportImpl.getResult()");
		ReturnObject result = new ReturnObject();
		
		try{
			YwGoodssale goodsale = (YwGoodssale)o;		
			String gsTableName="YW_GOODSSALE"+(StringUtil.isBlank(goodsale.getGssgcode())?"":goodsale.getGssgcode());
			StringBuffer sumSql = new StringBuffer( "SELECT cast('合计' as varchar2(32)) GDID,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR, 100 ZB, 100 LJZB FROM ").append(gsTableName).append("  T WHERE 1 = 1 " );
			if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					sumSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
				sumSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
				sumSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
				sumSql.append( " and T.GSRQ >= to_date('" ).append( goodsale.getStartDate() ).append("','yyyy-MM-dd')");
			}
			
			if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
				sumSql.append( " and T.GSRQ <= to_date('" ).append( goodsale.getEndDate() ).append("','yyyy-MM-dd')");
			}
			
			List lstSumResult = dao.executeSql( sumSql.toString() );
			
			if( lstSumResult != null && lstSumResult.size() > 0 ){
				
				Map sumGs = (Map)lstSumResult.get( 0 );
				double sumXssl = sumGs.get("GSXSSL") != null ? Double.parseDouble( sumGs.get( "GSXSSL" ).toString() ) : 0;
				double sumHsjjje = sumGs.get("GSHSJJJE") != null ? Double.parseDouble( sumGs.get( "GSHSJJJE" ).toString() ) : 0;
				double sumXssr = sumGs.get("GSXSSR") != null ? Double.parseDouble( sumGs.get( "GSXSSR" ).toString() ) : 0;
				double sumGsxsje = sumGs.get("GSXSJE") != null ? Double.parseDouble( sumGs.get( "GSXSJE" ).toString() ) : 0;

				StringBuffer sql = new StringBuffer( "SELECT case when T1.GDID is null then 'unknow' else T1.GDID end GDID,case when T1.GDNAME is null then '其他' else T1.GDNAME end GDNAME,T1.GDSPEC,T1.GDUNIT,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR,SUM(GSXSJE) GSXSJE FROM ").append(gsTableName).append("  T  " );
				sql.append( " LEFT JOIN INF_GOODS T1 ON T.GSGDID=T1.GDID AND T.GSSGCODE = T1.GDSGCODE WHERE 1 = 1 " );
				if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
						sql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
					}
				
				if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
					sql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
					sql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
					sql.append( " and T.GSRQ >= to_date('" ).append( goodsale.getStartDate() ).append("','yyyy-MM-dd')");
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					sql.append( " and T.GSRQ <= to_date('" ).append( goodsale.getEndDate() ).append("','yyyy-MM-dd')");
				}
				
				sql.append( " GROUP BY T1.GDID,T1.GDNAME,T1.GDSPEC,T1.GDUNIT " );			

				List lstResult = dao.executeSql( sql.toString() );			
				
				if( lstResult != null && lstResult.size() > 0 ){
					
					List<Object> gds = new ArrayList<Object>();
					double tXssl = 0, xssl = 0,tXsje= 0,tHsjjje = 0, hsjjje = 0,tXssr=0, xssr = 0,xsje = 0,zbXssl = 0, zbHsjjje = 0, zbXssr = 0,zbxsje = 0, ljzbXssl = 0, ljzbHsjjje = 0, ljzbXssr = 0,ljxsje=0,hzb=0, tZb = 0, zb = 0,tLjzb = 0, ljzb = 0;
					String flag = "A";
					for( Iterator<Map> itMap = lstResult.iterator(); itMap.hasNext(); ){
						Map gs = itMap.next();
											
						
						tXssl = xssl;
						tHsjjje = hsjjje;
						tXssr = xssr;
						tXsje = xsje;
						tLjzb = ljzb;
						hzb = tZb;
						
						xssl += gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
						hsjjje += gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
						xssr += gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
						xsje += gs.get("GSXSJE") != null ? Double.parseDouble( gs.get( "GSXSJE" ).toString() ) : 0;
						zbXssl = (gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0) / sumXssl * 100;
						zbHsjjje = (gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0) / sumHsjjje * 100;
						zbXssr = (gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0) / sumXssr * 100;
						zbxsje = (gs.get("GSXSJE") != null ? Double.parseDouble( gs.get( "GSXSJE" ).toString() ) : 0) / sumGsxsje * 100;
						ljzbXssl += zbXssl ;
						ljzbHsjjje += zbHsjjje;
						ljzbXssr += zbXssr;
						ljxsje += xsje;
						
						if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
							zb = zbXssl;
							ljzb = ljzbXssl;
						}
						else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
							zb = zbHsjjje;
							ljzb = ljzbHsjjje;						
						}
						else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
							zb = zbXssr;
							ljzb = ljzbXssr;
						}
						else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
							zb = zbxsje;
							ljzb = ljxsje;
						}
						
						tZb += zb;											
						
						if( ljzb > 70  && "A".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , tXssl );
							totalGs.put( "GSHSJJJE" , tHsjjje );
							totalGs.put( "GSXSSR" , tXssr );
							totalGs.put( "GSXSJE" , tXsje );
							totalGs.put( "ZB", hzb );
							totalGs.put( "LJZB", tLjzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
							xsje = gs.get("GSXSJE") != null ? Double.parseDouble( gs.get( "GSXSJE" ).toString() ) : 0;
							flag = "B";
						}
						else if( ljzb > 90  && "B".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , tXssl );
							totalGs.put( "GSHSJJJE" , tHsjjje );
							totalGs.put( "GSXSSR" , tXssr );
							totalGs.put( "GSXSJE" , tXsje );
							totalGs.put( "ZB", hzb );
							totalGs.put( "LJZB", tLjzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
							xsje = gs.get("GSXSJE") != null ? Double.parseDouble( gs.get( "GSXSJE" ).toString() ) : 0;
							flag = "C";
						}
						
						gs.put( "FLAG", flag );	
						gs.put( "ZB", zb );
						gs.put( "LJZB", ljzb );	
						gds.add( gs );
						
						if( !itMap.hasNext() && "C".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , xssl );
							totalGs.put( "GSHSJJJE" , hsjjje );
							totalGs.put( "GSXSSR" , xssr );
							totalGs.put( "GSXSJE" , tXsje );
							totalGs.put( "ZB", tZb );
							totalGs.put( "LJZB", ljzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
							xsje = gs.get("GSXSJE") != null ? Double.parseDouble( gs.get( "GSXSJE" ).toString() ) : 0;
							flag = null;
						}
					}
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( gds );
					result.setFooter( lstSumResult );
					
					log.info("gds.size(): " + gds.size());
					log.info("gds: " + gds);
					log.info("lstSumResult.size(): " + lstSumResult.size());
					log.info("lstSumResult: " + lstSumResult);
				}
			}			
		}
		catch( Exception ex ){
			log.error("SaleABCReportImpl.getResult() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		
		return result;
	}
	
	@Override
	public ReturnObject getTreeResult(Object o) {
		log.info("SaleABCReportImpl.getTreeResult()");
		ReturnObject result = new ReturnObject();
		
		try{
			YwGoodssale goodsale = (YwGoodssale)o;			
			StringBuffer sumSql = new StringBuffer( "SELECT cast('合计' as varchar2(32)) GDID,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR, 100 ZB, 100 LJZB FROM YW_GOODSSALE_M T WHERE 1 = 1 " );
			if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					sumSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
				sumSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
				sumSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
				sumSql.append( " and T.GSRQ >= to_date('" ).append( goodsale.getStartDate() ).append("','yyyy-MM-dd')");
			}
			
			if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
				sumSql.append( " and T.GSRQ <= to_date('" ).append( goodsale.getEndDate() ).append("','yyyy-MM-dd')");
			}
			
			List lstSumResult = dao.executeSql( sumSql.toString() );
			
			if( lstSumResult != null && lstSumResult.size() > 0 ){
				
				Map sumGs = (Map)lstSumResult.get( 0 );
				double sumXssl = sumGs.get("GSXSSL") != null ? Double.parseDouble( sumGs.get( "GSXSSL" ).toString() ) : 0;
				double sumHsjjje = sumGs.get("GSHSJJJE") != null ? Double.parseDouble( sumGs.get( "GSHSJJJE" ).toString() ) : 0;
				double sumXssr = sumGs.get("GSXSSR") != null ? Double.parseDouble( sumGs.get( "GSXSSR" ).toString() ) : 0;
				StringBuffer sql =  new StringBuffer( "SELECT case when T1.GDID is null then 'unknow' else T1.GDID end GDID,case when T1.GDNAME is null then '其他' else T1.GDNAME end GDNAME,T1.GDSPEC,T1.GDUNIT,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE_M T  " );
					sql.append( " LEFT JOIN INF_GOODS T1 ON T.GSGDID=T1.GDID AND T.GSSGCODE = T1.GDSGCODE WHERE 1 = 1 " );
				if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
						sql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
					sql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
					sql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
					sql.append( " and T.GSRQ >= to_date('" ).append( goodsale.getStartDate() ).append("','yyyy-MM-dd')");
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					sql.append( " and T.GSRQ <= to_date('" ).append( goodsale.getEndDate() ).append("','yyyy-MM-dd')");
				}
				
				sql.append( " GROUP BY T1.GDID,T1.GDNAME,T1.GDSPEC,T1.GDUNIT " );			
				List lstResult = dao.executeSql( sql.toString() );			
				
				if( lstResult != null && lstResult.size() > 0 ){
					
					List<Object> gds = new ArrayList<Object>();
					double tXssl = 0, xssl = 0,tHsjjje = 0, hsjjje = 0,tXssr=0, xssr = 0,zbXssl = 0, zbHsjjje = 0, zbXssr = 0, ljzbXssl = 0, ljzbHsjjje = 0, ljzbXssr = 0,hzb=0, tZb = 0, zb = 0,tLjzb = 0, ljzb = 0;
					String flag = "A";
					for( Iterator<Map> itMap = lstResult.iterator(); itMap.hasNext(); ){
						Map gs = itMap.next();
											
						
						tXssl = xssl;
						tHsjjje = hsjjje;
						tXssr = xssr;
						tLjzb = ljzb;
						hzb = tZb;
						
						xssl += gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
						hsjjje += gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
						xssr += gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
						zbXssl = (gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0) / sumXssl * 100;
						zbHsjjje = (gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0) / sumHsjjje * 100;
						zbXssr = (gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0) / sumXssr * 100;
						ljzbXssl += zbXssl ;
						ljzbHsjjje += zbHsjjje;
						ljzbXssr += zbXssr;						
						
						if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
							zb = zbXssl;
							ljzb = ljzbXssl;
						}
						else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
							zb = zbHsjjje;
							ljzb = ljzbHsjjje;						
						}
						else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
							zb = zbXssr;
							ljzb = ljzbXssr;
						}
						
						tZb += zb;											
						
						if( ljzb > 70  && "A".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , tXssl );
							totalGs.put( "GSHSJJJE" , tHsjjje );
							totalGs.put( "GSXSSR" , tXssr );
							totalGs.put( "ZB", hzb );
							totalGs.put( "LJZB", tLjzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;							
							flag = "B";
						}
						else if( ljzb > 90  && "B".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , tXssl );
							totalGs.put( "GSHSJJJE" , tHsjjje );
							totalGs.put( "GSXSSR" , tXssr );
							totalGs.put( "ZB", hzb );
							totalGs.put( "LJZB", tLjzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;							
							flag = "C";
						}
						
						gs.put( "FLAG", flag );	
						gs.put( "ZB", zb );
						gs.put( "LJZB", ljzb );	
						gds.add( gs );
						
						if( !itMap.hasNext() && "C".equals( flag ) ){							
							Map totalGs = new HashMap<String, Object>();
							totalGs.put( "GDID", "小计" );
							totalGs.put( "GSXSSL" , xssl );
							totalGs.put( "GSHSJJJE" , hsjjje );
							totalGs.put( "GSXSSR" , xssr );
							totalGs.put( "ZB", tZb );
							totalGs.put( "LJZB", ljzb );
							totalGs.put( "FLAG", "T" );
							gds.add( totalGs );
							
							tZb = zb;
							xssl = gs.get("GSXSSL") != null ? Double.parseDouble( gs.get( "GSXSSL" ).toString() ) : 0;
							hsjjje = gs.get("GSHSJJJE") != null ? Double.parseDouble( gs.get( "GSHSJJJE" ).toString() ) : 0;
							xssr = gs.get("GSXSSR") != null ? Double.parseDouble( gs.get( "GSXSSR" ).toString() ) : 0;
							flag = null;
						}
					}
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( gds );
					result.setFooter( lstSumResult );
					
					log.info("gds.size(): " + gds.size());
					log.info("gds: " + gds);
					log.info("lstSumResult.size(): " + lstSumResult.size());
					log.info("lstSumResult: " + lstSumResult);
				}
			}			
		}
		catch( Exception ex ){
			log.error("SaleABCReportImpl.getResult() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		
		return result;
	}

}
