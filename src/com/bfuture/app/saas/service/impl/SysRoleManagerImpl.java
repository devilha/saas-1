package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.ConversionUtils;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.SysMenu;
import com.bfuture.app.saas.model.SysRlmeu;
import com.bfuture.app.saas.model.SysRole;
import com.bfuture.app.saas.service.SysRoleManager;

public class SysRoleManagerImpl extends BaseManagerImpl implements
		SysRoleManager {

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public SysRoleManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}

	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if( "remove".equals( actionType ) ){
			try{
				SysRole role = (SysRole)o[0];
				String sql = "select * from sys_rlmeu where rlcode = '"+role.getRlcode()+"'";
				List list = dao.executeSql(sql);
				if(list.size()==0){
					StringBuffer hql = new StringBuffer( "from SysRole role where 1 = 1" );				
					
					if( !StringUtil.isBlank( role.getRlcode() ) ){
						hql.append( "and role.rlcode = '" ).append( role.getRlcode() ).append("'");
					}	
					if( !StringUtil.isBlank( role.getSgcode() ) ){
						hql.append( "and role.sgcode = '" ).append( role.getSgcode() ).append("'");
					}	
					
					List lstResult = dao.executeHql( hql.toString() );
					if( lstResult != null ){
						remove( lstResult.get( 0 ) );
						result.setReturnCode( Constants.SUCCESS_FLAG );
					}
				}else{
					result.setReturnCode( "-2");
				}				
			}
			catch( Exception ex ){
				result.setReturnCode( Constants.ERROR_FLAG );
				result.setReturnInfo( ex.getMessage() );
			}
		}if( "saveRlMeu".equals( actionType)){
			SysRlmeu roleMenu = (SysRlmeu)o[0];
			StringBuffer hql = new StringBuffer( "from SysRlmeu roleMenu where 1 = 1" );				
			
			if( !StringUtil.isBlank( roleMenu.getSgcode() ) && !StringUtil.isBlank( roleMenu.getId().getMeucode() ) && !StringUtil.isBlank( roleMenu.getId().getRlcode() ) ){
				//hql.append( " and roleMenu.id.meucode = '" ).append( roleMenu.getId().getMeucode() ).append("'");
				hql.append( " and roleMenu.id.rlcode = '" ).append( roleMenu.getId().getRlcode() ).append("'");
				hql.append( " and roleMenu.sgcode = '" ).append( roleMenu.getSgcode() ).append("'");
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
				}
			}
		}
		
		return result;
	}

	
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			SysRole role = (SysRole)o;
			
			StringBuffer countHql = new StringBuffer( "select count(*) from SysRole role where 1 = 1 " );			
			
			if( !StringUtil.isBlank( role.getRlcode() ) ){
				countHql.append( "and role.rlcode = '" ).append( role.getRlcode() ).append("'");
			}
			if( !StringUtil.isBlank( role.getRlname() ) ){
				countHql.append( "and role.rlname like '" ).append( role.getRlname() ).append("%'");
			}
			if( !StringUtil.isBlank( role.getSgcode() ) ){
				countHql.append( "and role.sgcode = '" ).append( role.getSgcode() ).append("'");
			}
			if( !StringUtil.isBlank( role.getRltype()+"" ) ){
				countHql.append( "and role.rltype = '" ).append( role.getRltype() ).append("'");
			}
			
			List lstResult = dao.executeHql( countHql.toString() );
			if( lstResult != null ){
				result.setTotal( Integer.parseInt( lstResult.get(0).toString() ) );
			}
			
			StringBuffer hql = new StringBuffer( "from SysRole role where 1 = 1 " );
			int limit = role.getRows();
			int start = ( role.getPage() - 1) * role.getRows() ;
			
			if( !StringUtil.isBlank( role.getRlcode() ) ){
				hql.append( "and role.rlcode = '" ).append( role.getRlcode() ).append("'");
			}
			if( !StringUtil.isBlank( role.getRlname() ) ){
				hql.append( "and role.rlname like '" ).append( role.getRlname() ).append("%'");
			}
			if( !StringUtil.isBlank( role.getSgcode() ) ){
				hql.append( "and role.sgcode = '" ).append( role.getSgcode() ).append("'");
			}
			if( !StringUtil.isBlank( role.getRltype()+"" ) ){
				hql.append( "and role.rltype = '" ).append( role.getRltype() ).append("'");
			}
			if( role.getOrder() != null && role.getSort() != null ){
				hql.append( " order by " ).append( role.getSort() ).append( " " ).append( role.getOrder() );
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
	
	private void createSysMenu( SysMenu sm, Collection<SysMenu> lstMenus ){
		for( SysMenu om : lstMenus ){
			if( sm.getMeucode().equals( om.getMeupcode() ) ){
				List<SysMenu> lstSubMenus = sm.getChildren();
				if( lstSubMenus == null ){
					lstSubMenus = new ArrayList<SysMenu>();
					sm.setState("open");
					sm.setChildren( lstSubMenus );
				}
				om.setState("open");
				lstSubMenus.add( om );
				
				//if( "N".equals( om.getMeuleaf() ) ){
					createSysMenu( om, lstMenus );
				//}
			}
		}
	}

	@Override
	public ReturnObject getTreeResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			SysRole role = (SysRole)o;
			StringBuffer sql = null;
			if("admin".equals(role.getSgcode())){
				sql = new StringBuffer( "select b.meucode,b.meuname,b.meulevel,b.meupcode,b.meuleaf,case when exists(select 1 from sys_rlmeu a where a.meucode=b.meucode AND meuleaf ='Y' " );
				if( !StringUtil.isBlank( role.getRlcode() ) ){
					sql.append( " and a.rlcode= '" ).append( role.getRlcode() ).append("'");
				}
					sql.append( " ) then 'true' else '' end checked from sys_menu b ");
					sql.append(" where b.meuenable = 'Y' ");
//					if( !StringUtil.isBlank( role.getSgcode() ) ){
//						sql.append( " and b.sgcode= '" ).append( role.getSgcode() ).append("'");
//					}
			}else{
				sql=new StringBuffer("select a.*,case b.rlcode when '"+role.getRlcode()+"' then 'true' else '' end checked from (select distinct b.meucode,b.meuname,b.meulevel,"
				   + "b.meupcode,b.meuleaf from sys_menu b,(select * from sys_rlmeu where sgcode = '"+role.getSgcode()+"' and rlcode in (select rlcode from sys_role "
                   + "where sgcode = '"+role.getSgcode()+"' and rltype = 'S')) a where b.meuenable = 'Y' and b.meucode = a.meucode)a left join (select * from sys_rlmeu "
                   + "where sgcode = '"+role.getSgcode()+"'and rlcode='"+role.getRlcode()+"')b on a.meucode=b.meucode");
			}
			sql.append(" order by b.meucode ");
			List lstResult = dao.executeSql( sql.toString() );
			if( lstResult != null ){
				
				List lstMenus = new ArrayList<SysMenu>();
//				for( Iterator<SysMenu> itMenu = lstResult.iterator(); itMenu.hasNext(); ){
//					SysMenu sm = itMenu.next();
//					if( Integer.valueOf( 1 ).compareTo( sm.getMeulevel() ) == 0 ){
//						lstMenus.add( sm );
//						createSysMenu( sm, lstResult );
//					}
//				}
				if( lstResult != null && lstResult.size() > 0 ){
					lstMenus = new ArrayList<SysMenu>();
					lstResult = ConversionUtils.convertPOJOList( lstResult );
					JSONArray jsonArray = JSONArray.fromObject( lstResult );
					Collection<SysMenu> list = JSONArray.toCollection( jsonArray, SysMenu.class );
					if( list != null && list.size() > 0 ){
						for( Iterator<SysMenu> itMenu = list.iterator(); itMenu.hasNext(); ){
							SysMenu sm = itMenu.next();
							if( Integer.valueOf( 1 ).compareTo( sm.getMeulevel() ) == 0 ){
								lstMenus.add( sm );
								createSysMenu( sm, list );
							}
						}
					}
				}
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setRows( lstMenus );
			}
			
		}
		catch( Exception ex ){
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
		}
		
		return result;
	}
	
	
	@Override
	public List<SysMenu> getTreeByRlcode(Object o) throws Exception {
		List<SysMenu> lstMenus = null;		
		SysRole role = (SysRole)o;
		StringBuffer sql = new StringBuffer( "select b.meucode,b.meuname,case when exists(select 1 from sys_rlmeu a where a.meucode=b.meucode " );
		if( !StringUtil.isBlank( role.getRlcode() ) ){
			sql.append( " and a.rlcode= '" ).append( role.getRlcode() ).append("'");
		}
			sql.append( " ) then 'true' else 'false' end checked from sys_menu b ");
			
		if( !StringUtil.isBlank( role.getRlcode() ) ){
			//sql.append( " and sur.sucode = '" ).append( sucode ).append("'");				
			List lstResult = dao.executeSql( sql.toString() );
			if( lstResult != null && lstResult.size() > 0 ){
				lstMenus = new ArrayList<SysMenu>();
				lstResult = ConversionUtils.convertPOJOList( lstResult );
				JSONArray jsonArray = JSONArray.fromObject( lstResult );
				Collection<SysMenu> list = JSONArray.toCollection( jsonArray, SysMenu.class );
				if( list != null && list.size() > 0 ){
					for( Iterator<SysMenu> itMenu = list.iterator(); itMenu.hasNext(); ){
						SysMenu sm = itMenu.next();
						if( Integer.valueOf( 3 ).compareTo( sm.getMeulevel() ) == 0 ){
							lstMenus.add( sm );
							createSysMenu( sm, list );
						}
					}
				}
			}
		}
			
		return lstMenus;
	}
}
