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
import com.bfuture.app.saas.service.SysMenuManager;

public class SysMenuManagerImpl extends BaseManagerImpl implements
		SysMenuManager {

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public SysMenuManagerImpl(){
		if( this.dao == null ){ 
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if( "remove".equals( actionType ) ){
			try{
				SysMenu menu = (SysMenu)o[0];
				
				StringBuffer hql = new StringBuffer( "from SysMenu menu where 1 = 1 " );				
				
				if( !StringUtil.isBlank( menu.getRelationC() ) ){
					hql.append( " and menu.relationC like '" ).append( menu.getRelationC() ).append("%'");
				}			
				
				List lstResult = dao.executeHql( hql.toString() );
				if( lstResult != null ){					
					remove( lstResult.toArray() );
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

	private void createSysMenu( SysMenu sm, Collection<SysMenu> lstMenus ){
		for( SysMenu om : lstMenus ){
			if( sm.getMeucode().equals( om.getMeupcode() ) ){
				List<SysMenu> lstSubMenus = sm.getChildren();
				if( lstSubMenus == null ){
					lstSubMenus = new ArrayList<SysMenu>();
					sm.setChildren( lstSubMenus );
				}
				lstSubMenus.add( om );
				
				if( "N".equals( om.getMeuleaf() ) ){
					createSysMenu( om, lstMenus );
				}
			}
		}
	}
	
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			SysMenu sysMenu = (SysMenu)o;
			StringBuffer hql = new StringBuffer( "from SysMenu menu where 1 = 1 " );			
			
			if( !StringUtil.isBlank( sysMenu.getMeupcode() ) ){
				hql.append( " and menu.meupcode = '" ).append( sysMenu.getMeupcode() ).append( "'" );
			}
			
			if( !StringUtil.isBlank( sysMenu.getMeucode() ) ){
				hql.append( " and menu.meucode = '" ).append( sysMenu.getMeucode() ).append( "'" );
			}
			
			hql.append( " order by menu.relationC " );
			List lstResult = dao.executeHql( hql.toString() );
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

	@Override
	public ReturnObject getTreeResult(Object o) {
		ReturnObject result = new ReturnObject();
		
		try{
			SysMenu sysMenu = (SysMenu)o;
			StringBuffer hql = new StringBuffer( "from SysMenu menu where 1 = 1 " );			
			
			if( !StringUtil.isBlank( sysMenu.getMeupcode() ) ){
				hql.append( " and menu.meupcode = '" ).append( sysMenu.getMeupcode() ).append( "'" );
			}
			
			if( !StringUtil.isBlank( sysMenu.getMeucode() ) ){
				hql.append( " and menu.meucode = '" ).append( sysMenu.getMeucode() ).append( "'" );
			}
			
			hql.append( " order by menu.relationC " );
			List lstResult = dao.executeHql( hql.toString() );
			if( lstResult != null ){
				
				List lstMenus = new ArrayList<SysMenu>();
				for( Iterator<SysMenu> itMenu = lstResult.iterator(); itMenu.hasNext(); ){
					SysMenu sm = itMenu.next();
					if( Integer.valueOf( 1 ).compareTo( sm.getMeulevel() ) == 0 ){
						lstMenus.add( sm );
						createSysMenu( sm, lstResult );
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

	public List<SysMenu> getMenusByUsercode(String sucode) throws Exception {
		List<SysMenu> lstMenus = null;		
		
		StringBuffer sql = new StringBuffer( "select distinct sm.* from SYS_SURL sur" )
			.append( " left join SYS_ROLE sr on sur.rlcode = sr.rlcode and sr.rlflag = 'Y' ")
			.append( " left join SYS_RLMEU rm on sr.rlcode = rm.rlcode ")
			.append( " left join SYS_MENU sm on rm.meucode = sm.meucode where sm.meulevel <> 1 and sm.meuenable = 'Y' ");
			
		if( !StringUtil.isBlank( sucode ) ){
			sql.append( " and sur.sucode = '" ).append( sucode ).append("'");
			sql.append( " order by relation_c" );
			List lstResult = dao.executeSql( sql.toString() );
			if( lstResult != null && lstResult.size() > 0 ){
				lstMenus = new ArrayList<SysMenu>();
				lstResult = ConversionUtils.convertPOJOList( lstResult );
				JSONArray jsonArray = JSONArray.fromObject( lstResult );
				Collection<SysMenu> list = JSONArray.toCollection( jsonArray, SysMenu.class );
				if( list != null && list.size() > 0 ){
					for( Iterator<SysMenu> itMenu = list.iterator(); itMenu.hasNext(); ){
						SysMenu sm = itMenu.next();
						if( Integer.valueOf( 2 ).compareTo( sm.getMeulevel() ) == 0 ){
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
