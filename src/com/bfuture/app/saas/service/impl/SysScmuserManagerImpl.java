package com.bfuture.app.saas.service.impl;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.security.providers.encoding.PasswordEncoder;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.InfSupinfo;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.model.SysSurl;
import com.bfuture.app.saas.model.newProductApplyBean;
import com.bfuture.app.saas.service.SysScmuserManager;

public class SysScmuserManagerImpl extends BaseManagerImpl implements
		SysScmuserManager {

	private PasswordEncoder passwordEncoder;
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public String encoder(String passWord){
    	return passwordEncoder.encodePassword(passWord, null);
    }

	public SysScmuserManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public Object[] save(Object[] o) throws Exception {
		
		if( o != null ){
			for( Object obj : o ){
				SysScmuser smUser = (SysScmuser)obj;
				
				if( smUser.getCrttime() == null ){
					smUser.setCrttime( new Timestamp( System.currentTimeMillis() ) );
				}
				
				if( StringUtil.isBlank( smUser.getEditFlag() ) ){
					smUser.setSupwd( encoder( smUser.getSupwd() ) );
				}
			}
		}
		
		return super.save(o);
	}

	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if( "remove".equals( actionType ) ){
			try{
				SysScmuser user = (SysScmuser)o[0];
				
				StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );				
				
				if( !StringUtil.isBlank( user.getSucode() ) ){
					hql.append( " and user.sucode = '" ).append( user.getSucode() ).append("'");
				}			
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){
					remove( lstResult.get( 0 ) );
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
								
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		else if( "initPassword".equals( actionType ) ){
			try{
				SysScmuser user = (SysScmuser)o[0];
				
				StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );				
				
				if( !StringUtil.isBlank( user.getSucode() ) ){
					hql.append( " and user.sucode = '" ).append( user.getSucode() ).append("'");
				}			
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){
					user = (SysScmuser)lstResult.get( 0 ) ;
					user.setSupwd( encoder( user.getSucode() ) );
					save(user);
					result.setReturnCode( Constants.SUCCESS_FLAG );
				}
								
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}
		//查询所有供应商用户
		else if( "supplyUsers".equals( actionType ) ){
			try{
				InfSupinfo sup = (InfSupinfo)o[0];
				
				StringBuffer countSql = new StringBuffer( "select count(distinct u.sucode) ")
				.append( "from sys_scmuser u left join inf_supinfo s on u.supcode = s.supid and u.sgcode = s.supsgcode where 1 = 1 ");			
				
				if( !StringUtil.isBlank( sup.getSupid() ) ){
					countSql.append( " and u.supcode like '" ).append( sup.getSupid() ).append("%'");				
				}
				
				if( !StringUtil.isBlank( sup.getSupname() ) ){
					countSql.append( " and s.supname like '%" ).append( sup.getSupname() ).append("%'");				
				}
				
				if( !StringUtil.isBlank( sup.getSupsgcode() ) ){
					countSql.append( " and u.sgcode = '" ).append( sup.getSupsgcode() ).append("'");				
				}
				/*
				if( !StringUtil.isBlank( sup.getSutype() ) ){
					countSql.append( " and u.sutype = '" ).append( sup.getSutype() ).append("'");				
				}
				*/
				log.debug("SysScmuserManagerImpl.supplyUsers() countsql="+countSql.toString());
				List lstResult = dao.executeSqlCount( countSql.toString() );
				if( lstResult != null && lstResult.size() > 0 ){
					log.debug("lstResult.get(0):"+lstResult.get(0).toString());
					result.setTotal( Integer.parseInt( lstResult.get( 0 ).toString() ) );
				}
				
				StringBuffer sql = new StringBuffer( "select distinct u.sucode,u.suname, s.supid,s.supname,s.supsgcode,u.crttime,u.suenable ")
				.append( "from sys_scmuser u left join inf_supinfo s on u.supcode = s.supid and u.sgcode = s.supsgcode where 1 = 1 ");
			
				if( !StringUtil.isBlank( sup.getSupid() ) ){
					sql.append( " and u.supcode like '" ).append( sup.getSupid() ).append("%'");				
				}
				
				if( !StringUtil.isBlank( sup.getSupname() ) ){
					sql.append( " and s.supname like '%" ).append( sup.getSupname() ).append("%'");				
				}
				
				if( !StringUtil.isBlank( sup.getSupsgcode() ) ){
					sql.append( " and u.sgcode = '" ).append( sup.getSupsgcode() ).append("'");				
				}
				/*
				if( !StringUtil.isBlank( sup.getSutype() ) ){
					sql.append( " and u.sutype = '" ).append( sup.getSutype() ).append("'");				
				}
				*/
				if( sup.getOrder() != null && sup.getSort() != null ){
					sql.append( " order by " ).append( sup.getSort() ).append( " " ).append( sup.getOrder() );
				}
				log.debug("SysScmuserManagerImpl.supplyUsers() sql="+sql.toString());	
				int limit = sup.getRows();
				int start = ( sup.getPage() - 1) * sup.getRows() ;
				lstResult = dao.executeSql( sql.toString(), start, limit );
					
				if( lstResult != null ){
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
				}				
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SysScmuserManagerImpl.supplyUsers() error:"+ex.getMessage()); 
			}
		}
		//保存修改后的供应商角色信息
		else if( "saveUserRole".equals( actionType) ){
			for( int i = 0; i < o.length; i ++ ){
				SysSurl userRole = (SysSurl)o[i];
				System.out.println(userRole.getSucode()+" "+userRole.getRlcode());
				StringBuffer hql = new StringBuffer( "from SysSurl userRole where 1 = 1" );				
				
				if( !StringUtil.isBlank( userRole.getSucode() ) && !StringUtil.isBlank( userRole.getSgcode() ) ){
					hql.append( " and userRole.id.sgcode = '" ).append( userRole.getSgcode() ).append("'");
					hql.append( " and userRole.id.sucode = '" ).append( userRole.getSucode() ).append("'");
					try{
						List lstResult = dao.executeHql( hql.toString() );
						
						if( lstResult != null ){
							remove( lstResult.toArray() );
							super.save( o );
						}
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
					catch( Exception ex ){
						result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( ex.getMessage() );
						log.error("SysScmuserManagerImpl.saveUserRole() error:"+ex.getMessage());
					}
				}
				
			}
			
			
			
		}//查询供应商是否重复
		else if( "changeUserExist".equals( actionType) ){
		
				SysSurl userRole = (SysSurl)o[0];
				System.out.println(userRole.getSucode()+" "+userRole.getRlcode());
				StringBuffer hql = new StringBuffer( "from SysSurl userRole where 1 = 1" );				
				
				if( !StringUtil.isBlank( userRole.getSucode() ) && !StringUtil.isBlank( userRole.getSgcode() ) ){
					hql.append( " and userRole.id.sgcode = '" ).append( userRole.getSgcode() ).append("'");
					hql.append( " and userRole.id.sucode = '" ).append( userRole.getSgcode() ).append( userRole.getSucode() ).append("'");
					try{
						List lstResult = dao.executeHql( hql.toString() );
						System.out.println(lstResult.size());
						if( lstResult.size() > 0 ){
							result.setReturnCode("2");
						}
						
					}
					catch( Exception ex ){
						//result.setReturnCode( Constants.ERROR_FLAG );
						result.setReturnInfo( ex.getMessage() );
						log.error("SysScmuserManagerImpl.saveUserRole() error:"+ex.getMessage());
					}
				}
				
			
		}
		//获取供应商用户角色信息
		else if( "hadRoles".equals( actionType ) ){
			for( int i = 0; i < o.length; i ++ ){
				SysSurl userRole = (SysSurl)o[i];		
				System.out.println(userRole.getSucode()+" "+userRole.getRlcode());
				try{						
					StringBuffer sql = new StringBuffer( "select role.rlcode, role.rlname ")
						.append( "from SYS_SURL userRole left join SYS_ROLE role on userRole.rlcode = role.rlcode and userRole.sgcode = role.sgcode where 1 = 1 and role.rlflag='Y' ");
					
					if( !StringUtil.isBlank( userRole.getRltype() ) ){
						sql.append( " and role.rltype = '" ).append( userRole.getRltype() ).append( "'" );
					}
					
					if( !StringUtil.isBlank( userRole.getSucode() ) && !StringUtil.isBlank( userRole.getSgcode() ) ){
						sql.append( " and userRole.sgcode = '" ).append( userRole.getSgcode() ).append("'");
						sql.append( " and userRole.sucode = '" ).append( userRole.getSucode() ).append("'");
					}
					if(!Constants.ADMINISTRATORSGCODE.equals(userRole.getSgcode())){
						sql.append( " and role.rltype = 'S'" );
					}
					
					log.debug("SysScmuserManagerImpl.hadRoles() sql:"+sql.toString());
					List lstResult = dao.executeSql( sql.toString() );
					
					if( lstResult != null ){
						result.setReturnCode( Constants.SUCCESS_FLAG );
						result.setRows( lstResult );
					}
					
				}catch(Exception e){			
					result.setReturnCode( Constants.ERROR_FLAG );
					result.setReturnInfo( e.getMessage() );
					log.error("SysScmuserManagerImpl.hadRoles() error:"+e.getMessage());
				}
			}
			
		}
		//获取供应商用户未赋角色信息
		else if( "notRoles".equals( actionType ) ){
			SysSurl userRole = (SysSurl)o[0];		
			try{						
				if( !StringUtil.isBlank( userRole.getSucode() ) && !StringUtil.isBlank( userRole.getSgcode() ) ){
					StringBuffer sql = new StringBuffer( "select role.rlcode, role.rlname ")
					.append( "from SYS_ROLE role where role.rlflag='Y' and role.rlcode not in ( select userRole.rlcode from SYS_SURL userRole where 1 = 1 ");
					sql.append( " and userRole.sgcode = '" ).append( userRole.getSgcode() ).append("'");
					sql.append( " and userRole.sucode = '" ).append( userRole.getSucode() ).append("')");
					sql.append( " and role.sgcode = '").append( userRole.getSgcode() ).append("'");
					
					if(!Constants.ADMINISTRATORSGCODE.equals(userRole.getSgcode())){
						sql.append( " and role.rltype = 'S'" );
					}else{
						if( !StringUtil.isBlank( userRole.getRltype() ) ){
							sql.append( " and role.rltype = '" ).append( userRole.getRltype() ).append( "'" );
						}
					}
					log.debug("SysScmuserManagerImpl.notRoles() sql="+sql.toString());
					List lstResult = dao.executeSql( sql.toString() );
					
					if( lstResult != null ){
						result.setReturnCode( Constants.SUCCESS_FLAG );
						result.setRows( lstResult );
					}
				}else{
					String sql = "select role.rlcode, role.rlname from SYS_ROLE role where role.rlflag='Y' and sgcode='"+userRole.getSgcode()+"'";
					List lstResult = dao.executeSql(sql);
					if( lstResult != null ){
						result.setReturnCode( Constants.SUCCESS_FLAG );
						result.setRows( lstResult );
					}
				}
				
			}catch(Exception e){			
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
				log.error("SysScmuserManagerImpl.notRoles() error:"+e.getMessage());
			}
		}
		else if( "checkUser".equals( actionType ) ){
			try{
				SysScmuser user = (SysScmuser)o[0];
				
				
				StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );
				int limit = user.getRows();
				int start = ( user.getPage() - 1) * user.getRows() ;
				
				if( !StringUtil.isBlank( user.getSucode() ) ){
					hql.append( " and user.sucode = '" ).append( user.getSucode() ).append("'");
				}				
				if( !StringUtil.isBlank( user.getSupwd() ) ){
					hql.append( " and user.supwd = '" ).append( encoder( user.getSupwd() ) ).append("'");
				}				
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
				}
				
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
				log.error("SysScmuserManagerImpl checkUser:"+ex.getMessage());
			}
		}else if("szUser".equals( actionType )){
			try{
				SysScmuser user = (SysScmuser)o[0];
				
				StringBuffer countHql = new StringBuffer( "select count(*) from SysScmuser user where 1 = 1" );			
				
				if( !StringUtil.isBlank( user.getSgcode() ) ){
					countHql.append( " and user.sgcode ='" ).append( user.getSgcode() ).append("'");
				}
				if( !StringUtil.isBlank( user.getSucode() ) ){
					countHql.append( " and user.sucode = '" ).append( user.getSucode() ).append("'");
				}
				if( !StringUtil.isBlank( user.getSuname() ) ){
					countHql.append( " and user.suname like '" ).append( user.getSuname() ).append("%'");
				}
				countHql.append( " and (user.supcode is not null or user.supcode<>'' ) " );
				List lstResult = dao.executeHql( countHql.toString() );
				if( lstResult != null ){
					result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
				}
				
				StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );
				int limit = user.getRows();
				int start = ( user.getPage() - 1) * user.getRows() ;
				
				if( !StringUtil.isBlank( user.getSgcode() ) ){
					hql.append( " and user.sgcode = '" ).append( user.getSgcode() ).append("'");
				}
				if( !StringUtil.isBlank( user.getSucode() ) ){
					hql.append( " and user.sucode = '" ).append( user.getSucode() ).append("'");
				}
				if( !StringUtil.isBlank( user.getSuname() ) ){
					hql.append( " and user.suname like '" ).append( user.getSuname() ).append("%'");
				}
				hql.append( " and (user.supcode is not null or user.supcode<>'' ) " );
				
				if( user.getOrder() != null && user.getSort() != null ){
					hql.append( " order by " ).append( user.getSort() ).append( " " ).append( user.getOrder() );
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
		}else if("getBatchOpenUser".equals( actionType )){
			try {
				SysScmuser user = (SysScmuser)o[0];
				String sql = "select supsgcode sgcode,supsgcode || supid sucode,supname suname,supid,supadd address,'S' sutype,'N' suenable ,'' salemethod,"
					       + "supfax fax,'' linkman,'' linkmantel,'' sumemo from inf_supinfo s where supsgcode='"+user.getSgcode()+"' and not exists "
					       + "(select * from sys_scmuser u where sutype ='S' and sgcode='"+user.getSgcode()+"' and rtrim(ltrim(s.supid)) = rtrim(ltrim(u.supcode)))";
				int limit = user.getRows();
				int start = ( user.getPage() - 1) * user.getRows() ;
				List lstResult = dao.executeSql( sql, start, limit );
				List rowNum = dao.executeSql(sql);
				if( lstResult != null ){
					result.setReturnCode( Constants.SUCCESS_FLAG );
					result.setRows( lstResult );
					result.setTotal(rowNum.size());
				}
				return result;
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}else if( "saveUserList".equals( actionType) ){
			try {
				SysScmuser user = (SysScmuser)o[0];
				String[] supid = user.getSupcode().split(",");
				for( int i = 0; i < supid.length; i ++ ){
					String sucode = user.getSgcode() + supid[i];
					String sql = "select * from sys_scmuser where sucode = '"+sucode+"'";
					List userList = dao.executeSql(sql);
					if(userList.size()==0){
						sql = "insert into sys_scmuser(sucode,suname,supwd,sutype,suenable,sgcode,supcode,crttime) "
							+ "select supsgcode||supid,supname,'e10adc3949ba59abbe56e057f20f883e','S','Y',supsgcode,supid,sysdate "
							+ "from scmuser.inf_supinfo where supsgcode='"+user.getSgcode()+"' and supid = '"+supid[i]+"'";
						dao.saveBySQL(sql);
					}
				}
				result.setReturnCode( Constants.SUCCESS_FLAG);
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}else if( "saveBatchOpenUserRole".equals( actionType) ){
			try {
				SysSurl userRole = (SysSurl)o[0];
				String[] sucode = userRole.getSucode().split(",");
				for( int i = 0; i < sucode.length; i ++ ){
					String sql = "select * from sys_scmuser where sucode = '"+sucode[i]+"'";
					List userList = dao.executeSql(sql);
					if(userList.size()>0){
						SysSurl ss = new SysSurl();
						ss.setRlcode(userRole.getRlcode());
						ss.setSgcode(userRole.getSgcode());
						ss.setSucode(sucode[i]);
						dao.save(ss);
					}
				}
				result.setReturnCode( Constants.SUCCESS_FLAG);
			} catch (Exception e) {
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( e.getMessage() );
			}
		}
		
		return result;
	}

	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		try{
			SysScmuser user = (SysScmuser)o;
			
			StringBuffer countHql = new StringBuffer( "select count(*) from SysScmuser user where 1 = 1" );			
			
			if( !StringUtil.isBlank( user.getSgcode() ) ){
				countHql.append( " and user.sgcode = '" ).append( user.getSgcode() ).append("'");
			}
			if( !StringUtil.isBlank( user.getSucode() ) ){
				countHql.append( " and user.sucode like '" ).append( user.getSucode() ).append("%'");
			}
			if( !StringUtil.isBlank( user.getSuname() ) ){
				countHql.append( " and user.suname like '%" ).append( user.getSuname() ).append("%'");
			}			
			if( user.getSutype() != null ){
				countHql.append( " and user.sutype = '" ).append( user.getSutype() ).append("'");
			}
			
			List lstResult = dao.executeHql( countHql.toString() );
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
			}
			
			StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );
			int limit = user.getRows();
			int start = ( user.getPage() - 1) * user.getRows() ;
			
			if( !StringUtil.isBlank( user.getSgcode() ) ){
				hql.append( " and user.sgcode = '" ).append( user.getSgcode() ).append("'");
			}
			if( !StringUtil.isBlank( user.getSucode() ) ){
				hql.append( " and user.sucode like '" ).append( user.getSucode() ).append("%'");
			}
			if( !StringUtil.isBlank( user.getSuname() ) ){
				hql.append( " and user.suname like '%" ).append( user.getSuname() ).append("%'");
			}			
			if( user.getSutype() != null ){
				hql.append( " and user.sutype = '" ).append( user.getSutype() ).append("'");
			}			
			
			if( user.getOrder() != null && user.getSort() != null ){
				hql.append( " order by " ).append( user.getSort() ).append( " " ).append( user.getOrder() );
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

	public SysScmuser getSysScmuserBySucode(String usercode) throws SQLException {
		SysScmuser smUser = null;
		
		StringBuffer hql = new StringBuffer( "from SysScmuser user where 1 = 1" );
		hql.append( "and user.sucode = '" ).append( usercode ).append("'");
		List lstResult = dao.executeHql( hql.toString() );
		if( lstResult != null && lstResult.size() > 0 ){
			smUser = (SysScmuser)lstResult.get( 0 );
		}
		
		return smUser;
	}

	public List getRolesBySucode(String usercode) {
		
		List lstResults = null;
		
		StringBuffer sql = new StringBuffer( " select s.rlcode,r.rlname from sys_surl s left join sys_role r on s.rlcode = r.rlcode and s.sgcode = r.sgcode where 1 = 1 and r.rlflag='Y' " );
		sql.append( " and s.sucode = '" ).append( usercode ).append("'");
		lstResults = dao.executeSql( sql.toString() );
		return lstResults;
	}
	
	/**
	 * 验证新品申请中的商品条码是否已经存在
	 */
	public boolean checkGdbarecode(String Gdbarecode,String sgcode,String supid) throws SQLException{
		String sql = "select yn.GDBARCODE from YW_NEWPRODUCTAPPLY yn where yn.GDBARCODE = '"+Gdbarecode+"' and sgcode='"+sgcode+"' and supid='"+supid+"'";
		List list = dao.executeSql(sql);
		if(list.size()>0){
			return true;
		}else{
			return false;
		}
	}
	
	
	/**
	 * 查找新商品
	 */
	@Override
	public ReturnObject findNewPrds(Object o,String sgcode,String supid,String applyStatus,String startDate,String endDate,String applyname,
			String gdbarcode,String gdname,String custType,String gysbm,String supname,String printstatus){
		ReturnObject result = new ReturnObject();
		try {
			String sql ="";
			int limit = 0;
			int start = 0;
			if(o != null){
				BaseObject bo = (BaseObject)o;
				limit = bo.getRows();
				start = ( bo.getPage() - 1) * bo.getRows() ;
			}
			
			if("S".equalsIgnoreCase(custType)){
				   sql = "select decode(yn.gdname,null,'',yn.gdname)gdname,decode(yn.gdcatid,null,'',yn.gdcatid)gdcatid,decode(yn.gdunit,null,'',yn.gdunit)gdunit,decode(yn.supid,null,'',yn.supid)supid,"
					   + "decode(yn.supname,null,'',yn.supname)supname,decode(yn.gdarea,null,'',yn.gdarea)gdarea,decode(yn.bohjyfs,null,'',yn.bohjyfs)bohjyfs,decode(yn.gdppname,null,'',yn.gdppname)gdppname,"
					   + "yn.bidhsjj,yn.gsxsje,yn.gdbarcode,yn.applydate,case yn.applystatus when '0' then '未审批' when '1' then '已审批' "
					   + "when '2' then '驳回' end applystatus,decode(yn.appayername,null,'',yn.appayername)appayername,decode(yn.temp1,null,'',yn.temp1) gg,decode(yn.temp2,null,'',yn.temp2) hh,decode(yn.temp3,null,'',yn.temp3) zd,"
					   + "decode(yn.temp4,null,'',yn.temp4) pp,decode(yn.temp8,null,'',yn.temp8) bhms,decode(yn.temp9,null,'',yn.temp9) ms from yw_newproductapply yn where 1=1";
			
			}else if("L".equalsIgnoreCase(custType)){
				   sql = "select decode(yn.gdname,null,'',yn.gdname)gdname,decode(yn.gdcatid,null,'',yn.gdcatid)gdcatid,decode(yn.gdunit,null,'',yn.gdunit)gdunit,decode(yn.supid,null,'',yn.supid)supid,"
					   + "decode(yn.supname,null,'',yn.supname)supname,decode(yn.gdarea,null,'',yn.gdarea)gdarea,decode(yn.bohjyfs,null,'',yn.bohjyfs)bohjyfs,decode(yn.gdppname,null,'',yn.gdppname)gdppname,"
					   + "yn.bidhsjj,yn.gsxsje,yn.gdbarcode,yn.applydate,case yn.applystatus when '0' then '未审批' when '1' then '已审批' "
					   + "when '2' then '驳回' end applystatus,case yn.printstatus when '0' then '否'  when '1' then '是' end  printstatus,decode(yn.appayername,null,'',yn.appayername)appayername,decode(yn.temp1,null,'',yn.temp1) gg,"
					   + "decode(yn.temp2,null,'',yn.temp2) hh,decode(yn.temp3,null,'',yn.temp3) zd,"
					   + "decode(yn.temp4,null,'',yn.temp4) pp,decode(yn.temp8,null,'',yn.temp8) bhms,decode(yn.temp9,null,'',yn.temp9) ms from yw_newproductapply yn where 1=1";
			}
			if(!StringUtil.isBlank(applyStatus) && "shStatus".equals(applyStatus)){
				sql += " and applystatus='1' and temp7 is not null ";
			}else if(!StringUtil.isBlank(applyStatus) && "bhStatus".equals(applyStatus)){
				sql += " and applystatus='2' and temp7 is null ";
			}else if(!StringUtil.isBlank(applyStatus) && "wspStatus".equals(applyStatus)){
				sql += " and applystatus='0' and temp7 is null ";
			}else{
				if(!StringUtil.isBlank(applyStatus) && !"-1".equals(applyStatus)){
					sql += " and yn.applystatus = '"+applyStatus+"'";
				}
				if(!StringUtil.isBlank(startDate) && !StringUtil.isBlank(endDate)){
					sql += " and yn.applydate >= '"+startDate+"' and yn.applydate <= '"+endDate+"'";
				}
				if(!StringUtil.isBlank(startDate) && StringUtil.isBlank(endDate)){
					sql += " and yn.applydate >= '"+startDate+"'";
				}
				if(!StringUtil.isBlank(endDate) && StringUtil.isBlank(startDate)){
					sql += " and yn.applydate <= '"+endDate+"'";
				}
				if(!StringUtil.isBlank(applyname)){
					sql += " and yn.appayername = '"+applyname+"'";
				}
				if(!StringUtil.isBlank(gdbarcode)){
					sql += " and yn.gdbarcode = '"+gdbarcode+"'";
				}
				if(!StringUtil.isBlank(gdname)){
					sql += " and yn.gdname like '%"+gdname+"%'";
				}
				if(!StringUtil.isBlank(supname)){
					sql += " and yn.supname = '"+supname+"'";
				}
				if(!StringUtil.isBlank(printstatus) && ! "-1".equals(printstatus)){
					sql += " and yn.printstatus = '"+printstatus+"'";
				}
			} 
			if(!StringUtil.isBlank(gysbm)){
				sql += " and yn.supid = '"+gysbm+"'";
			}
			if(!StringUtil.isBlank(sgcode)){
				sql += " and yn.sgcode = '"+sgcode+"'";
			}
			List lstResult = null;
			if(o != null){
				lstResult = dao.executeSql(sql, start, limit);
			}else{
				lstResult = dao.executeSql(sql);
			}
			
			if( lstResult != null ){
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows(lstResult);
			}
			String countsql = "select count(*) from ("+sql+")";
			lstResult = dao.executeSqlCount(countsql);
			result.setTotal(Integer.parseInt(lstResult.get(0).toString()));
			//改变打印的状态
			if(o==null){
				String changeSql = "update yw_newproductapply set printstatus='1' where gdbarcode in (select gdbarcode from ("+sql+"))";
				dao.updateSql(changeSql);
			}
		} catch (Exception e) {
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( e.getMessage() );
		}
		return result;
	}

	/**
	 * 审核通过以及驳回操作
	 */
	public boolean changeApplyStatus(String rowsid,String sgcode,String supid,int status,String bhms) throws Exception {
		String sql = "";
		try {
			String[] rowsids = rowsid.split(",");
			String[] supids = supid.split(",");
			String param = "";
			if(!"".equals(bhms)){
				param = ",temp8='"+bhms+"'";
			}
			for (int i = 0; i < rowsids.length; i++) {
				sql = "update yw_newproductapply yn set yn.applystatus = '"+status+"'"+param+"where yn.gdbarcode='"+rowsids[i]+"' and sgcode='"+sgcode+"' and supid = '"+supids[i]+"'";
				dao.saveBySQL(sql);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	/**
	 * 查询所有通过审核的新商品
	 */
	public List printNewPrds() throws Exception {
		String sql = "select * from yw_newproductapply yn where yn.applystatus = '1' and yn.printstatus='0'";
		try {
			List list = dao.executeSql(sql);
			if(list.size()>0){
				sql = "update yw_newproductapply yn set yn.printstatus = '1' where yn.printstatus = '0' and yn.applystatus = '1'";
				dao.updateSql(sql);
			}
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public boolean dropNewGoods(String sgcode, String supid, String spbm)
			throws SQLException {
		String sql = "delete from yw_newproductapply where sgcode='"+sgcode+"' and supid='"+supid+"' and gdbarcode='"+spbm+"'";
		try {
			dao.updateSql(sql);
			return true;
		} catch (Exception e){
			return false;
		}
	}

	//获得供应商的经营方式
	public List getSupplierJyfs(String sgcode, String supid) {
		String sql = "select temp2 JYFS from inf_supinfo where supsgcode='"+sgcode+"' and supid = '"+supid+"' ";
		List list = dao.executeSql(sql);
		return list;
	}
	
	// 验证供应商是否可以登录(存在于这张表，不可登陆……（是不是搞反了……？）)
	public boolean checksuplyenable(String sgcode,String supid) throws SQLException{ 
		String sql ="select sgcode,supid from suplyenable where sgcode='"+sgcode+"' and supid='"+supid+"'and start_date < sysdate and end_date > sysdate";
 		List list = dao.executeSql(sql);
		if(list.size()>0){  
			return true; //供应商用户登录
		}else{ 
			return false; //供应商用户试用期后不可用
		}
	}
	
	
}
