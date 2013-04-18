package com.bfuture.app.basic.clientapp.controller;


import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.service.UniversalAppManager;


public class UniversalXmlClientController extends BaseClientController {
	private UniversalAppManager universalAppManager;
	


	public void setUniversalAppManager(UniversalAppManager universalAppManager) {
		this.universalAppManager = universalAppManager;
	}

	
	public BaseManager getAppManager(BaseObject bo) {
		//System.out.println(bo.getClass().getSimpleName()+"Mananger");
		BaseManager appManager=null;
		try {
			//log.debug(bo.getClass().getSimpleName()+"Manager");
			String otherMananger=bo.getClass().getSimpleName()+"Manager";
			otherMananger =
				otherMananger.substring(0, 1).toLowerCase()
					+ otherMananger.substring(1);
		 appManager=(BaseManager)getSpringBean(otherMananger);}
		catch (Exception e)
		{}
		if (appManager==null)
		{appManager= universalAppManager;}
	
		return appManager;
	}

}
