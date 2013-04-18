package com.bfuture.app.saas.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.saas.model.YwBorderstatus;
import com.bfuture.app.saas.model.YwBorderstatusId;
import com.bfuture.app.saas.service.YwBorderstatusManager;
import com.bfuture.app.saas.util.Tools;

/**
 * 订单状态Manager实现类
 * @author chenjw
 *
 */
public class YwBorderstatusManagerImpl extends BaseManagerImpl implements YwBorderstatusManager {
	
	protected final Log log = LogFactory.getLog(YwBorderstatusManagerImpl.class);
	
	public void setDao( UniversalAppDao dao ){
		this.dao = dao;
	}
	
	public YwBorderstatusManagerImpl(){
		if( this.dao == null ){
			this.dao = (UniversalAppDao)getSpringBean( "universalAppDao" );
		}
	}
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if( "addYwBorderstatus".equals( actionType ) ){
			result = addYwBorderstatus(o);
		}else if( "actionType2".equals( actionType ) ){
			
		}
		
		return result;
	}
	
	public ReturnObject addYwBorderstatus(Object[] o){
		ReturnObject result = new ReturnObject();
		try {
			
			for( int i = 0; i < o.length; i ++ ){
				YwBorderstatus borderstatus = (YwBorderstatus)o[i];
				
				YwBorderstatusId ywBorderstatusId = new YwBorderstatusId(borderstatus.getBohsgcode(),borderstatus.getBohbillno(),borderstatus.getBohshmfid());
				Object obj = get( YwBorderstatus.class, ywBorderstatusId );
				
				if( obj == null ){				
					borderstatus.setId( ywBorderstatusId );
				//常德广兴打印次数更改保存
					save( borderstatus );
				}
				else{
					YwBorderstatus targetYwBorderstatus = (YwBorderstatus)obj;
					Tools.copyProperties( borderstatus, obj, false );
					save( obj );
				}
			}
			 
			result.setReturnCode( Constants.SUCCESS_FLAG );
		} catch (Exception ex) {
			log.error("YwBorderstatusManagerImpl.addYwBorderstatus() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		return result;
	}
	
}
