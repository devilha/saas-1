package com.bfuture.app.basic;

import org.springframework.context.ApplicationContext;

public class AppSpringContext {

	private static AppSpringContext instance;
	private ApplicationContext appContext;
	
	public  static AppSpringContext getInstance() {
		if (instance == null) {
			instance = new AppSpringContext();
		}
		return instance;
	}
	private AppSpringContext() {
	}
	public ApplicationContext getAppContext() {
		return appContext;
	}
	public void setAppContext(ApplicationContext context) {
		this.appContext = context;
	}	
}
