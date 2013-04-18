package com.bfuture.app.saas.clientapp.upload;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.bfuture.app.basic.util.xml.StringUtil;

public class UploadControler {
	private static UploadControler beanControler = new UploadControler();
	public static final String UPLOAD_DIR = "upload";
	public static final String UPLOAD_MAP_KEY = "uploadFiles";
	
	private UploadControler() {
	}	
	
	/**
	 * ��request��ȡ��FileUploadStatus Bean
	 */
	public static FileUploadStatus getStatusBean(HttpServletRequest request,String fileUrl) {		
		FileUploadStatus fus = null;
		Object obj = request.getSession().getAttribute( UPLOAD_MAP_KEY );
		
		if( obj != null && !StringUtil.isBlank( fileUrl ) ){
			Object objFileUploadStatus = ((Map)obj).get( fileUrl );
			if( objFileUploadStatus != null ){
				fus = (FileUploadStatus)objFileUploadStatus;
			}
		}
		
		return fus;
	}

	/**
	 * ��FileUploadStatus Bean���浽�������BeanControler
	 */
	public static void saveStatusBean(HttpServletRequest request,
			FileUploadStatus statusBean) {				
		HttpSession session = request.getSession(); 
		Object obj = session.getAttribute( UPLOAD_MAP_KEY );
		Map map = null;
		if( obj != null ){
			map = (Map)obj;			
		}
		else{
			map = new HashMap<String, FileUploadStatus>();
			session.setAttribute( UPLOAD_MAP_KEY, map );
		}
		
		if( !StringUtil.isBlank( statusBean.getUploadAddr() ) ){
			map.put( statusBean.getUploadAddr(), statusBean );
		}
		
	}
	
	/**
	 * ��ʼ���ļ��ϴ�״̬Bean
	 */
	public static FileUploadStatus initStatusBean(HttpServletRequest request) {
		FileUploadStatus satusBean = new FileUploadStatus();
		satusBean.setStatus("����׼������");
		satusBean.setUploadTotalSize(request.getContentLength());
		satusBean.setProcessStartTime(System.currentTimeMillis());
		satusBean.setBaseDir(request.getContextPath() + File.separator + UPLOAD_DIR);
		return satusBean;
	}

}
