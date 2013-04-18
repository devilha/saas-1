package com.bfuture.app.basic.clientapp.controller;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.bfuture.app.basic.AppSpringContext;
import com.bfuture.app.basic.Constants;
import com.bfuture.app.saas.util.Tools;

public class StartupListener extends ContextLoaderListener implements
		ServletContextListener {
	private static Log log = LogFactory.getLog(StartupListener.class);

	@Override
	public void contextInitialized(ServletContextEvent event) {
		if (log.isDebugEnabled()) {
			log.debug("initializing context...");
		}
		super.contextInitialized(event);
		ServletContext context = event.getServletContext();

		Map<String, Object> config = (HashMap<String, Object>) context
				.getAttribute(Constants.CONFIG);

		if (config == null) {
			config = new HashMap<String, Object>();
		}

		if (context.getInitParameter(Constants.CSS_THEME) != null) {
			config.put(Constants.CSS_THEME, context
					.getInitParameter(Constants.CSS_THEME));
		}
		context.setAttribute(Constants.CONFIG, config);

		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(context);
		AppSpringContext appContext = AppSpringContext.getInstance();
		appContext.setAppContext(ctx);

		//从备份目录恢复附件文件
		String uploadAbsolutePath = context.getInitParameter( com.bfuture.app.saas.util.Constants.UPLOAD_ABSOLUTE_PATH );
		String webUploadPath = context.getRealPath( "/" + context.getInitParameter( "uploadRelativePath" ) );
		
		File backupDir = new File( uploadAbsolutePath );
		if( backupDir.exists() && backupDir.isDirectory() ){
			
			File[] userDirs = backupDir.listFiles( new FileFilter(){
				public boolean accept(File pathname) {					
					return pathname.isDirectory();
				}
			});
			
			if( userDirs != null && userDirs.length > 0 ){
				for( File userDir : userDirs ){
					File[] uploadFiles = userDir.listFiles( new FileFilter(){
						public boolean accept(File pathname) {					
							return pathname.isFile();
						}
					});
					
					if( uploadFiles != null && uploadFiles.length > 0 ){
						for( File uploadFile : uploadFiles ){
							try {
								Tools.copyFile( uploadFile.getAbsolutePath(), webUploadPath + File.separator + userDir.getName() + File.separator + uploadFile.getName() );
							} catch (IOException e) {}
						}
					}
				}
			}
		}
		
		
	}

	/**
	 * This method uses the LookupManager to lookup available roles from the
	 * data layer.
	 * 
	 * @param context
	 *            The servlet context
	 */
	public static void setupContext(ServletContext context) {
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(context);
		// LookupManager mgr = (LookupManager) ctx.getBean("lookupManager");

		// get list of possible roles
		// context.setAttribute(Constants.AVAILABLE_ROLES, mgr.getAllRoles());
		// log.debug("Drop-down initialization complete [OK]");
	}
}
