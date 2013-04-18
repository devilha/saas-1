package com.bfuture.app.basic;

/**
 * Constant values used throughout the application.
 * 
 * 
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 */
public class Constants {
	// ~ Static fields/initializers
	// =============================================
	/**
	 * Name of user counter variable
	 */
	public static final String COUNT_KEY = "SmUserSCounter";
	/**
	 * Name of users Set in the ServletContext
	 */
	public static final String SmUserS_KEY = "SmUserS";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String DELETE = "delete";

	public static final String FIND = "find";
	public static final String DATAGRID = "datagrid";
	public static final String TREEGRID = "treegrid";
	public static final String COMBOGRID = "combogrid";
	public static final String COMBOBOX = "combobox";

	public static final String TREE = "tree";
	/**
	 * "SP_"+table.name()+"_AFTER_INSERT"
	 */
	public static final String INSERTANDEXEC = "InsertAndExec";
	/**
	 * "SP_"+table.name()+"_BEFORE_DELETE"
	 */
	public static final String EXECANDDELETE = "ExecAndDelete";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String UPDATEANDEXEC = "UpdateAndExec";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String UPDATEPARTANDEXEC = "UpdatePartAndExec";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String LASTAUDIT = "LastAudit";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PsRufuseTobegin = "PsRufuseTobegin";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PsRufuseToUp = "PsRufuseToUp";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PsAuditPass = "PsAuditPass";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PsHandle = "PsHandle";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PsStop = "PsStop";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String UPDATE = "update";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String UPDATE_PART = "updatePart";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String LOAD_BY_OBJECT = "loadByObject";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String LOAD_ALL = "loadall";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String INSERT = "insert";

	public static final String TESTCONN = "testconn";

	public static final String COPY = "copy";

	public static final String IMPORT = "import";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String STOP_TIMER = "stopTimer";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String Start_TIMER = "startTimer";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String LOGIN_USER = "LoginUser";
	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String PROCEDURE_PREFIX = "GET_";

	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String NO_LOGIN = "nologin";

	/**
	 * The name of the ResourceBundle used in this application
	 */
	public static final String BUNDLE_KEY = "ApplicationResources";

	/**
	 * File separator from System properties
	 */
	public static final String FILE_SEP = System.getProperty("file.separator");

	/**
	 * User home from System properties
	 */
	public static final String USER_HOME = System.getProperty("user.home")
			+ FILE_SEP;

	/**
	 * The name of the configuration hashmap stored in application scope.
	 */
	public static final String CONFIG = "appConfig";

	/**
	 * Session scope attribute that holds the locale set by the user. By setting
	 * this key to the same one that Struts uses, we get synchronization in
	 * Struts w/o having to do extra work or have two session-level variables.
	 */
	public static final String PREFERRED_LOCALE_KEY = "org.apache.struts2.action.LOCALE";

	/**
	 * The request scope attribute under which an editable user form is stored
	 */
	public static final String USER_KEY = "userForm";

	/**
	 * The request scope attribute that holds the user list
	 */
	public static final String USER_LIST = "userList";

	/**
	 * The request scope attribute for indicating a newly-registered user
	 */
	public static final String REGISTERED = "registered";

	/**
	 * The name of the Administrator role, as specified in web.xml
	 */
	public static final String ADMIN_ROLE = "ROLE_ADMIN";

	/**
	 * The name of the User role, as specified in web.xml
	 */
	public static final String USER_ROLE = "ROLE_USER";

	/**
	 * The name of the user's role list, a request-scoped attribute when
	 * adding/editing a user.
	 */
	public static final String USER_ROLES = "userRoles";

	/**
	 * The name of the available roles list, a request-scoped attribute when
	 * adding/editing a user.
	 */
	public static final String AVAILABLE_ROLES = "availableRoles";

	/**
	 * The name of the CSS Theme setting.
	 */
	public static final String CSS_THEME = "csstheme";

	public static final String PATH_REPORT_PATH = "temp/";

	public static final String JSON_DATA = "data";
	public static final String JSON_LIST = "list";
	public static final String ACTION_CLASS = "ACTION_CLASS";
	public static final String ACTION_TYPE = "ACTION_TYPE";
	public static final String ACTION_MANAGER = "ACTION_MANAGER";
	public static final String OPT_TYPE = "optType";
	public static final String OPT_CONTENT = "optContent";

	public static final String SUCCESS_FLAG = "1";
	public static final String ERROR_FLAG = "0";

	public static final String SGCODE = "7003";
	public static final String PAGE_PASSWORD_ERROR = "passwordErrorPage";
	public static final String PAGE_SYSTEM_ERROR = "systemErrorPage";
	/**
	 * 配置资源文件名称
	 */
	public static final String PROPERTIESNAME = "excel";
	
	/**
	 * 系统管理员
	 */
	public static final String ADMINISTRATORSGCODE = "admin";

}
