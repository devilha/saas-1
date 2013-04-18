package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.ConversionUtils;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.YwGoodssale;

public class SaleTrendReportImpl extends BaseManagerImpl implements BaseManager {
	
	protected final Log log = LogFactory.getLog(SaleTrendReportImpl.class);
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if( "getChart".equals( actionType ) ){
			try{
				YwGoodssale goodsale = (YwGoodssale)o[0];
				String goodssaleTable = "YW_GOODSSALE" + goodsale.getGssgcode();
				StringBuffer chartSql =  new StringBuffer( "SELECT SYSDATE RQ,TO_CHAR(T.GSRQ,'yyyy-MM-DD') GSRQ,SUM(GSXSSL) GSXSSL FROM "+goodssaleTable+" T WHERE 1 = 1  " );

				if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					chartSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
					chartSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
					chartSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
					chartSql.append( " and T.GSRQ >= to_date('" + goodsale.getStartDate() + "','YYYY-MM-DD')" );
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					chartSql.append( " and T.GSRQ <= to_date('" + goodsale.getEndDate() +"','YYYY-MM-DD')" );
				}
				
				chartSql.append( " GROUP BY TO_CHAR(T.GSRQ,'yyyy-MM-DD') " );			
							
				if( !StringUtil.isBlank( goodsale.getSaleObject() ) ){
					chartSql.append( " ORDER BY GSRQ   ");
				}				
				
				List lstChartResult = dao.executeSql( chartSql.toString());
				
				if( lstChartResult != null && lstChartResult.size() > 0 ){
					
					//按门店重组数据
					Map< String, Map<String,Map>> mapResult = new HashMap< String, Map<String,Map>>();					
					for( Iterator<Map> itMap = lstChartResult.iterator(); itMap.hasNext(); ){
						Map mapGs = itMap.next();
						String mfid = mapGs.get( "RQ" ).toString();//SHPCODE
						
						Map<String,Map> mapMFMap = null;
						if( mapResult.containsKey( mfid ) ){
							mapMFMap = mapResult.get( mfid );
						}
						else{
							mapMFMap = new HashMap<String,Map>();
							mapResult.put( mfid, mapMFMap );
						}
						mapMFMap.put( mapGs.get("GSRQ").toString(), mapGs );
					}
					
					//初始化日期范围
					SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
					Date ed = sdf.parse(goodsale.getEndDate() );
					List<String> lstRq = new ArrayList<String>();
					for( Date sd = sdf.parse(goodsale.getStartDate() ); sd.compareTo( ed ) <= 0;  ){
						lstRq.add( sdf.format(sd) );
						Calendar cal = Calendar.getInstance();
						cal.setTime( sd );
						cal.add( Calendar.DAY_OF_MONTH, 1 );
						sd = cal.getTime();
					}
					
					JSONObject json = new JSONObject();
					
					JSONObject chart = new JSONObject();
					chart.put( "caption", "" );
					chart.put( "xaxisname", "日  期" );
					
					String yaxisname = null;
					if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
						yaxisname = "销售总额";
					}
					chart.put( "yaxisname", yaxisname );
					chart.put( "showvalues", "0" );
					chart.put( "formatNumberScale", "0" );
					chart.put( "decimals", "2" );
					chart.put( "animation", "1" );
					chart.put( "bgColor", "FFFFFF" );
					chart.put( "legendPosition", "BOTTOM");
					json.put( "chart", chart );
					
					JSONArray categories = new JSONArray();
					JSONArray category = new JSONArray();
					JSONArray dataset = new JSONArray();
					
					for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
						String rq = itRq.next();
						JSONObject joCategory = new JSONObject();
						joCategory.put( "label", rq );
						category.add( joCategory );
					}
					
					JSONObject joCategory = new JSONObject();
					joCategory.put( "category", category );
					categories.add( joCategory );
					json.put( "categories", categories );
					
					for( Iterator<String> itMfid = mapResult.keySet().iterator(); itMfid.hasNext(); ){
						String mfid = itMfid.next();
						Map<String,Map> mapRqgs = mapResult.get( mfid );	
						JSONObject joDataset = new JSONObject();
						JSONArray jaData = new JSONArray();
						
						for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
							String rq = itRq.next();
							JSONObject joData = new JSONObject();
							
							if( mapRqgs.containsKey( rq ) ){
								Map mapGs = mapRqgs.get( rq );
								if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
									joData.put( "value", Double.parseDouble( mapGs.get("GSXSSL") != null ? mapGs.get("GSXSSL").toString() : "0" ) );
								}
								if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
									joData.put( "value", Double.parseDouble( mapGs.get("GSXSSR") != null ? mapGs.get("GSXSSR").toString() : "0" ) );
								}
							}
							else{
								joData.put( "value", "0" ); 
							}
							jaData.add( joData );
						}
						
						joDataset.put( "data", jaData );
						dataset.add( joDataset );
					}
					
					json.put( "dataset", dataset );
					
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setChartData( json );
				}
			
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}else if ("getSaleTrendReport".equals( actionType )) {
			result = getSaleTrendReport(o);
		}
		
		return result;
	}

	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			YwGoodssale goodsale = (YwGoodssale)o;			
			
			StringBuffer countSql = new StringBuffer( "select count(*) from (SELECT T.GSRQ FROM YW_GOODSSALE T  " );
				countSql.append( " LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE WHERE 1 = 1 " );
				
				if( "Y".equals( goodsale.getIsSup() ) ){
					countSql.append( " and T.GSMFID in ( select MDCODE from SYS_SUPMD ss where ss.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					countSql.append( " and ss.SUPCODE = '").append( goodsale.getGssupid() ).append( "' and current date between BDATE and ENDDATE )" );
					countSql.append( " and T.GSMFID in ( select MDCODE from SYS_VENDMD sv where sv.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					countSql.append( " and sv.VENDID = '").append( goodsale.getSucode() ).append( "' )");
				}				
				
				if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					countSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
					countSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
					countSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
					countSql.append( " and T.GSRQ >= '" + goodsale.getStartDate() + " 00:00:00'" );
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					countSql.append( " and T.GSRQ <= '" + goodsale.getEndDate() +" 23:59:59'" );
				}
				
				countSql.append( " GROUP BY T.GSRQ,T1.SHPCODE,T1.SHPNAME ) a" );
								
				List lstCountResult = dao.executeSql( countSql.toString() );				
				if( lstCountResult != null ){
					Map countMap = (Map)lstCountResult.get( 0 );
					result.setTotal( Integer.parseInt( countMap.get( "1" ).toString() ) );
				}
				
				StringBuffer sql = new StringBuffer( "SELECT T.GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE T  " );
				sql.append( " LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE WHERE 1 = 1 " );
				
				if( "Y".equals( goodsale.getIsSup() ) ){
					sql.append( " and T.GSMFID in ( select MDCODE from SYS_SUPMD ss where ss.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					sql.append( " and ss.SUPCODE = '").append( goodsale.getGssupid() ).append( "' and current date between BDATE and ENDDATE )" );
					sql.append( " and T.GSMFID in ( select MDCODE from SYS_VENDMD sv where sv.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					sql.append( " and sv.VENDID = '").append( goodsale.getSucode() ).append( "' )");
				}				
				
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
					sql.append( " and T.GSRQ >= '" + goodsale.getStartDate() + " 00:00:00'" );
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					sql.append( " and T.GSRQ <= '" + goodsale.getEndDate() +" 23:59:59'" );
				}
				
				sql.append( " GROUP BY T.GSRQ,T1.SHPCODE,T1.SHPNAME " );			
							
				if( !StringUtil.isBlank( goodsale.getSaleObject() ) ){
					sql.append( " order by GSRQ,SHPCODE  ");
				}
				
				List lstResult = dao.executeSql( sql.toString() );			
				
				if( lstResult != null && lstResult.size() > 0 ){
					List<Object> lstSumResult = new ArrayList<Object>();
					
					double gsxssl = 0,gshsjjje = 0, gsxssr = 0;
					for( Object obj : lstResult ){
						Map mapGs = (Map)obj;
						gsxssl += mapGs.get( "GSXSSL" ) != null ? Double.parseDouble( mapGs.get( "GSXSSL" ).toString() ) : 0;
						gshsjjje += mapGs.get( "GSHSJJJE" ) != null ? Double.parseDouble( mapGs.get( "GSHSJJJE" ).toString() ) : 0;
						gsxssr += mapGs.get( "GSXSSR" ) != null ? Double.parseDouble( mapGs.get( "GSXSSR" ).toString() ) : 0;
					}
					
					Map<String, Object> mapSum = new HashMap<String, Object>();
					mapSum.put( "gsrq", "合计" );
					mapSum.put( "gsxssl", gsxssl );
					mapSum.put( "gshsjjje", gshsjjje );
					mapSum.put( "gsxssr", gsxssr );
					lstSumResult.add( mapSum );
					
					lstResult = ConversionUtils.convertPOJOList( lstResult );					
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
					result.setFooter( lstSumResult );
				}
				
				StringBuffer chartSql = new StringBuffer( "SELECT T.GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR FROM YW_GOODSSALE T  " );
				chartSql.append( " LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE WHERE 1 = 1 " );
				
				if( "Y".equals( goodsale.getIsSup() ) ){
					chartSql.append( " and T.GSMFID in ( select MDCODE from SYS_SUPMD ss where ss.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					chartSql.append( " and ss.SUPCODE = '").append( goodsale.getGssupid() ).append( "' and current date between BDATE and ENDDATE )" );
					chartSql.append( " and T.GSMFID in ( select MDCODE from SYS_VENDMD sv where sv.SGCODE = '" ).append( goodsale.getGssgcode() ).append( "' ");
					chartSql.append( " and sv.VENDID = '").append( goodsale.getSucode() ).append( "' )");
				}				
				
				if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					chartSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
					chartSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
					chartSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
				}
				
				if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
					chartSql.append( " and T.GSRQ >= '" + goodsale.getStartDate() + " 00:00:00'" );
				}
				
				if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
					chartSql.append( " and T.GSRQ <= '" + goodsale.getEndDate() +" 23:59:59'" );
				}
				
				chartSql.append( " GROUP BY T.GSRQ,T1.SHPCODE,T1.SHPNAME " );			
							
				if( !StringUtil.isBlank( goodsale.getSaleObject() ) ){
					chartSql.append( " order by GSRQ,SHPCODE  ");
				}				
				
				List lstChartResult = dao.executeSql( chartSql.toString() );			
				
				if( lstChartResult != null && lstChartResult.size() > 0 ){
					
					//按门店重组数据
					Map< String, Map<String,Map>> mapResult = new HashMap< String, Map<String,Map>>();					
					for( Iterator<Map> itMap = lstChartResult.iterator(); itMap.hasNext(); ){
						Map mapGs = itMap.next();
						String mfid = mapGs.get( "SHPCODE" ).toString();
						Map<String,Map> mapMFMap = null;
						if( mapResult.containsKey( mfid ) ){
							mapMFMap = mapResult.get( mfid );
						}
						else{
							mapMFMap = new HashMap<String,Map>();
							mapResult.put( mfid, mapMFMap );
						}
						mapMFMap.put( mapGs.get("GSRQ").toString(), mapGs );
					}
					
					//初始化日期范围
					SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
					Date ed = sdf.parse(goodsale.getEndDate() );
					List<String> lstRq = new ArrayList<String>();
					for( Date sd = sdf.parse(goodsale.getStartDate() ); sd.compareTo( ed ) <= 0;  ){
						lstRq.add( sdf.format(sd) );
						Calendar cal = Calendar.getInstance();
						cal.setTime( sd );
						cal.add( Calendar.DAY_OF_MONTH, 1 );
						sd = cal.getTime();
					}
					
					JSONObject json = new JSONObject();
					
					JSONObject chart = new JSONObject();
					chart.put( "caption", "销售趋势分析" );
					chart.put( "xaxisname", "日  期" );
					
					String yaxisname = null;
					if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
						yaxisname = "销售数量";
					}
					else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
						yaxisname = "含税进价金额";						
					}
					else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
						yaxisname = "销售收入";
					}
					chart.put( "yaxisname", yaxisname );
					chart.put( "showvalues", "0" );
					chart.put( "formatNumberScale", "0" );
					chart.put( "decimals", "2" );
					chart.put( "animation", "1" );
					chart.put( "bgColor", "FFFFFF" );
					chart.put( "legendPosition", "BOTTOM");
					json.put( "chart", chart );
					
					JSONArray categories = new JSONArray();
					JSONArray category = new JSONArray();
					JSONArray dataset = new JSONArray();
					
					for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
						String rq = itRq.next();
						JSONObject joCategory = new JSONObject();
						joCategory.put( "label", rq );
						category.add( joCategory );
					}
					
					JSONObject joCategory = new JSONObject();
					joCategory.put( "category", category );
					categories.add( joCategory );
					json.put( "categories", categories );
					
					for( Iterator<String> itMfid = mapResult.keySet().iterator(); itMfid.hasNext(); ){
						String mfid = itMfid.next();
						Map<String,Map> mapRqgs = mapResult.get( mfid );
						String mfname = mapRqgs.values().iterator().next().get( "SHPNAME" ).toString();
						
						JSONObject joDataset = new JSONObject();
						joDataset.put( "seriesname", mfname );
						JSONArray jaData = new JSONArray();
						
						for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
							String rq = itRq.next();
							JSONObject joData = new JSONObject();
							if( mapRqgs.containsKey( rq ) ){
								Map mapGs = mapRqgs.get( rq );
								if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
									joData.put( "value", Double.parseDouble( mapGs.get("GSXSSL") != null ? mapGs.get("GSXSSL").toString() : "0" ) );
								}
								else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
									joData.put( "value", Double.parseDouble( mapGs.get("GSHSJJJE") != null ? mapGs.get("GSHSJJJE").toString() : "0" ) );						
								}
								else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
									joData.put( "value", Double.parseDouble( mapGs.get("GSXSSR") != null ? mapGs.get("GSXSSR").toString() : "0" ) );
								}
							}
							else{
								joData.put( "value", "0" ); 
							}
							jaData.add( joData );
						}
						
						joDataset.put( "data", jaData );
						dataset.add( joDataset );
					}
					
					json.put( "dataset", dataset );
					
					result.setChartData( json );
				}
						
		}
		catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
		}
		
		return result;
	}
	
	/**
	 * 销售趋势分析
	 * @param o
	 * @return 
	 */
	public ReturnObject getSaleTrendReport(Object[] o) {
		ReturnObject result = new ReturnObject();
		log.info("SaleTrendReportImpl.getSaleTrendReport()");
		try{
			YwGoodssale goodsale = (YwGoodssale)o[0];
			String gsTableName="YW_GOODSSALE"+(StringUtil.isBlank(goodsale.getGssgcode())?"":goodsale.getGssgcode());
			StringBuffer chartSql = new StringBuffer( "SELECT to_char(T.GSRQ,'YYYY-MM-DD') GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR,SUM(GSXSJE) GSXSJE, T2.supid INFSUPID,T2.supname INFSUPNAME FROM ").append(gsTableName).append("  T  " );				
			chartSql.append( " LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE left join inf_supinfo T2 on T2.supsgcode = T.gssgcode and T2.supid = T.gssupid WHERE 1 = 1 " );
							
			if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					chartSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
				chartSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
				chartSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
				chartSql.append( " and T.GSRQ >= to_date('" + goodsale.getStartDate() + "','YYYY-MM-DD')" );
			}
			
			if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
				chartSql.append( " and T.GSRQ <= to_date('" + goodsale.getEndDate() +"','YYYY-MM-DD')" );
			}
			
			chartSql.append( " GROUP BY to_char(T.GSRQ,'YYYY-MM-DD'), case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end, case when T1.SHPNAME is null then '其他' else T1.SHPNAME end, T2.supid, T2.supname" );		
						
			if( !StringUtil.isBlank( goodsale.getSaleObject() ) ){
				chartSql.append( " order by "+goodsale.getSaleObject());
			}				
			
			List lstChartResult = dao.executeSql( chartSql.toString() );	
			
			// 计算合计部分开始
			if( lstChartResult != null && lstChartResult.size() > 0 ){
				List<Object> lstSumResult = new ArrayList<Object>();
				
				double gsxssl = 0,gshsjjje = 0, gsxssr = 0, gsxsje = 0;
				for( Object obj : lstChartResult ){
					Map mapGs = (Map)obj;
					gsxssl += mapGs.get( "GSXSSL" ) != null ? Double.parseDouble( mapGs.get( "GSXSSL" ).toString() ) : 0;
					gshsjjje += mapGs.get( "GSHSJJJE" ) != null ? Double.parseDouble( mapGs.get( "GSHSJJJE" ).toString() ) : 0;
					gsxssr += mapGs.get( "GSXSSR" ) != null ? Double.parseDouble( mapGs.get( "GSXSSR" ).toString() ) : 0;
					gsxsje += mapGs.get( "GSXSJE" ) != null ? Double.parseDouble( mapGs.get( "GSXSJE" ).toString() ) : 0;
				}
				
				Map<String, Object> mapSum = new HashMap<String, Object>();
				mapSum.put( "GSRQ", "合计" );
				mapSum.put( "GSXSSL", gsxssl );
				mapSum.put( "GSHSJJJE", gshsjjje );
				mapSum.put( "GSXSSR", gsxssr );
				mapSum.put( "GSXSJE", gsxsje );
				lstSumResult.add( mapSum );
				
				result.setFooter( lstSumResult );
			}// 计算合计部分结束
			
			if( lstChartResult != null && lstChartResult.size() > 0 ){
				
				//按门店重组数据
				Map< String, Map<String,Map>> mapResult = new HashMap< String, Map<String,Map>>();					
				for( Iterator<Map> itMap = lstChartResult.iterator(); itMap.hasNext(); ){
					Map mapGs = itMap.next();
					String mfid = mapGs.get( "SHPCODE" ).toString();
					Map<String,Map> mapMFMap = null;
					if( mapResult.containsKey( mfid ) ){
						mapMFMap = mapResult.get( mfid );
					}
					else{
						mapMFMap = new HashMap<String,Map>();
						mapResult.put( mfid, mapMFMap );
					}
					mapMFMap.put( mapGs.get("GSRQ").toString(), mapGs );
				}
				
				//初始化日期范围
				SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
				Date ed = sdf.parse(goodsale.getEndDate() );
				List<String> lstRq = new ArrayList<String>();
				for( Date sd = sdf.parse(goodsale.getStartDate() ); sd.compareTo( ed ) <= 0;  ){
					lstRq.add( sdf.format(sd) );
					Calendar cal = Calendar.getInstance();
					cal.setTime( sd );
					cal.add( Calendar.DAY_OF_MONTH, 1 );
					sd = cal.getTime();
				}
				
				JSONObject json = new JSONObject();
				
				JSONObject chart = new JSONObject();
				chart.put( "caption", "" );
				chart.put( "xaxisname", "日  期" );
				
				String yaxisname = null;
				if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售数量";
				}
				else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "含税进价金额";						
				}
				else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售收入";
				}
				else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售金额";
				}
				chart.put( "yaxisname", yaxisname );
				chart.put( "showvalues", "0" );
				chart.put( "formatNumberScale", "0" );
				chart.put( "decimals", "2" );
				chart.put( "animation", "1" );
				chart.put( "bgColor", "FFFFFF" );
				chart.put( "legendPosition", "BOTTOM");
				json.put( "chart", chart );
				
				JSONArray categories = new JSONArray();
				JSONArray category = new JSONArray();
				JSONArray dataset = new JSONArray();
				
				for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
					String rq = itRq.next();
					JSONObject joCategory = new JSONObject();
					joCategory.put( "label", rq );
					category.add( joCategory );
				}
				
				JSONObject joCategory = new JSONObject();
				joCategory.put( "category", category );
				categories.add( joCategory );
				json.put( "categories", categories );
				
				for( Iterator<String> itMfid = mapResult.keySet().iterator(); itMfid.hasNext(); ){
					String mfid = itMfid.next();
					Map<String,Map> mapRqgs = mapResult.get( mfid );
					String mfname = mapRqgs.values().iterator().next().get( "SHPNAME" ).toString();
					
					JSONObject joDataset = new JSONObject();
					joDataset.put( "seriesname", mfname );
					JSONArray jaData = new JSONArray();
					
					for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
						String rq = itRq.next();
						JSONObject joData = new JSONObject();
						if( mapRqgs.containsKey( rq ) ){
							Map mapGs = mapRqgs.get( rq );
							if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSL") != null ? mapGs.get("GSXSSL").toString() : "0" ) );
							}
							else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSHSJJJE") != null ? mapGs.get("GSHSJJJE").toString() : "0" ) );						
							}
							else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSR") != null ? mapGs.get("GSXSSR").toString() : "0" ) );
							}
							else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSJE") != null ? mapGs.get("GSXSJE").toString() : "0" ) );
							}

						}
						else{
							joData.put( "value", "0" ); 
						}
						jaData.add( joData );
					}
					
					joDataset.put( "data", jaData );
					dataset.add( joDataset );
				}
				
				json.put( "dataset", dataset );
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setChartData( json );
				result.setRows(lstChartResult); // 列表
			}
		
		}catch( Exception ex ){
			log.error("SaleTrendReportImpl.getSaleTrendReport() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		
		return result;
	}
}
