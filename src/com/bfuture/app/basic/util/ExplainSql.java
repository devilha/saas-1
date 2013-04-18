package com.bfuture.app.basic.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * 解析sql串 select * from sm_user where 1=1 {@name@ and name=@eee@}{#code# and code =44}
 * @author nope
 *
 */
public class ExplainSql {
	private static Map<String,String> parameters;
	private static String sqlTemp;
	private static String sqlSort;
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		Map<String,String> map = new HashMap<String, String>();
		map.put("CLASS_C", "'0001'");
		map.put("start", "0");
		map.put("limit", "20");
		//map.put("code", "'001'");
		String str = "CLASS_C,CLASS_CN,CLASS_EN,MEMBER_NUM,MEMBER_NUM_ZB,MEMBER_AMOUNT,MEMBER_AM_ZB,MEMBER_ML,MEMBER_ML_ZB,CM_C,INS_C,CRT_BY_C,CRT_BY_TIME,LAST_UP_BY_C,LAST_UP_BY_TIME,ID  FROM CLASS  where 1=1 {@name@ and name=@name@} {#sort# order by  CRT_BY_TIME }";
		try {
			System.out.println(explain(str,map,"DB2"));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static String explain(String sql,Map<String,String> paras,String devDbTypes) throws Exception{
		parameters=paras;
		sqlSort="";
		List<SqlDef> sqlDefs=new ArrayList<SqlDef>();
		sqlTemp=sql;
		String temp=sql;
		if(sql!=null&&parameters!=null&&validateSql(sql)){
			while(temp.contains("{")){
				int start=temp.indexOf("{")+1;
				int end =temp.indexOf("}");
				String sqlDef=temp.substring(start,end);
				sqlDefs.add(setSqlDef(sqlDef));
				temp=temp.substring(end+1,temp.length());
			}
			return addPageSql(getSql(sqlDefs),devDbTypes);
		}else{
			throw new Exception("sql中括号不匹配："+sqlTemp);
		}
	}
	
	private static boolean validateSql(String sql){
		int left=0;
		int right=0;
		for(int i=0;i<sql.length();i++){
			char c=sql.charAt(i);
			if(c=='{')left++;
			if(c=='}')right++;
		}
		if(left==right)
			return true;
		else
			return false;
	}
	
	private static SqlDef setSqlDef(String sql){
		SqlDef sqlDef=new SqlDef();
		sqlDef.originalSql="[{]"+sql+"[}]";
		if(sql.contains("@")){
			sqlDef.varName=sql.substring(sql.indexOf("@")+1,sql.indexOf("@",sql.indexOf("@")+1));
			sqlDef.varValue=parameters.get(sqlDef.varName);
			if(sqlDef.varValue!=null){
				sqlDef.resultSql=sqlDef.originalSql.substring(sqlDef.originalSql.indexOf("@",sqlDef.originalSql.indexOf("@")+1)+1,sqlDef.originalSql.lastIndexOf("["));
				String value="@"+sqlDef.varName+"@";
				sqlDef.resultSql=sqlDef.resultSql.replaceAll(value, sqlDef.varValue==null?"":sqlDef.varValue);
			}			
		}else if(sql.contains("#")){
			sqlDef.varName=sql.substring(sql.indexOf("#")+1,sql.indexOf("#",sql.indexOf("#")+1));
			sqlDef.varValue=parameters.get(sqlDef.varName);
			if(sqlDef.varValue==null)
				sqlDef.resultSql=sqlDef.originalSql.substring(sqlDef.originalSql.indexOf("#",sqlDef.originalSql.indexOf("#")+1)+1,sqlDef.originalSql.lastIndexOf("["));
//				String value="#"+sqlDef.varName+"#";
//				sqlDef.resultSql=sqlDef.resultSql.replaceAll(value, sqlDef.varValue);
		}

		return sqlDef;
	}
	
	private static String getSql(List<SqlDef> sqlDef){
		String result=sqlTemp;
		for(SqlDef sd:sqlDef){
			if(sd!=null&&sd.resultSql!=null){
				if(sd.originalSql.contains("@sort@")||sd.originalSql.contains("#sort#")){
					sqlSort=sd.resultSql;
					result=result.replaceAll(sd.originalSql, " ");
				}else
				result=result.replaceAll(sd.originalSql, sd.resultSql);
			}else{
				result=result.replaceAll(sd.originalSql, " ");
			}
			
		}
		return result;
	}
	
	private static String addPageSql(String sql,String dbType){
		if(sql!=null&&dbType!=null&&sqlSort!=null&&sqlSort.trim().length()>0){
			if(dbType.toUpperCase().equals("DB2")){
				sql= "select * from (select rownumber() over( "+sqlSort+" ) as rowno,"+sql+" ) as temp "+" where rowno >"+parameters.get("start")+" and rowno <= "+(Integer.parseInt(parameters.get("start"))+Integer.parseInt(parameters.get("limit")));
			}
			if(dbType.toUpperCase().equals("ORACLE")){
				sql="SELECT * from ( select rownum rowno, "+sql+" ) "+" where rowno >"+parameters.get("start")+" and rowno <= "+(Integer.parseInt(parameters.get("start"))+Integer.parseInt(parameters.get("limit")))+sqlSort;
			}
		}
		return sql;
	}
}

class SqlDef{
	String	varName;
	String originalSql;
	String varValue;
	String resultSql;
}
