package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.saas.clientapp.upload.UploadControler;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.util.Tools;

/**
 * Servlet implementation class UploadServlet
 */
public class EditorUploadServlet extends BasicServlet {
	/**
	 * ���ļ�·����ȡ���ļ���
	 */
	private String takeOutFileName(String filePath) {
		int pos = filePath.lastIndexOf(".");
		if (pos > 0) {
			return filePath.substring(pos);
		} else {
			return filePath;
		}
	}
	
	@Override
	public void performTask(HttpServletRequest request,
			HttpServletResponse response) {
		
		JSONObject ro = new JSONObject();
		
		String uploadAbsolutePath = getServletContext().getInitParameter( "uploadAbsolutePath" );
		String uploadRelativePath = getServletContext().getInitParameter( "uploadRelativePath" );
		
		DiskFileItemFactory factory = new DiskFileItemFactory();
		
		// �����ڴ滺�������д����ʱ�ļ�
		factory.setSizeThreshold(10240000);
		
		// ������ʱ�ļ��洢λ��
		File tempDir = new File( request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath + "/temp" ) );
		
		if( !tempDir.exists() ){
			tempDir.mkdirs();
		}
		
		factory.setRepository( tempDir );
		ServletFileUpload upload = new ServletFileUpload(factory);
		// ���õ����ļ�������ϴ�ֵ
		upload.setFileSizeMax(102400000);
//		upload.setFileSizeMax(Integer.MAX_VALUE);
		// �������request�����ֵ
		upload.setSizeMax(102400000);
//		upload.setSizeMax(Integer.MAX_VALUE);
		
		upload.setHeaderEncoding("UTF-8");
		
		SysScmuser smUser = getCurrentUser(request);
		
		PrintWriter out = null;
		try {
			response.setCharacterEncoding("GBK");
			out = response.getWriter();			
		} catch (IOException e) {			
			e.printStackTrace();
			return;
		}
		
		if( smUser == null ){
			ro.put( "err", "��ǰ��¼�ѳ�ʱ�������µ�¼��" );
			ro.put( "msg", "" );
			out.println( JSONObject.fromObject( ro ).toString() );			
			out.close();
			return;
		}
		
		try {
			List items = upload.parseRequest(request);
			
			// �����ļ��ϴ�			
			FileItem item = (FileItem) items.get(0);
			
			if( item.getSize() > 1 * 1024 * 1024 ){
				ro.put("err", "上传图片不能大于1M!");
				ro.put( "msg", "" );
				return;
			}
				
			// �����ļ�
			if (!item.isFormField() && item.getName().length() > 0) {
				String fileExtName = takeOutFileName(item.getName());
				SimpleDateFormat sdf = new SimpleDateFormat( "yyyyMMddhhmmss" );
				String filename = sdf.format( new Date() );
				File uploadedDir = new File( request.getSession().getServletContext().getRealPath( "/" + uploadRelativePath + "/" + smUser.getSucode() ) );
				File uploadedFile = new File( uploadedDir.getPath()	+ File.separator + filename + fileExtName );
				if( !uploadedDir.exists() ){
					uploadedDir.mkdir();
				}
					
				log.debug( "uploadFilePath:" + uploadedFile.getPath() );					
					
				// ��ʼ�ϴ��ļ�
				item.write(uploadedFile);
					
				Thread.sleep(500);
				
				//�����ļ������·��
				File backupDir = new File( uploadAbsolutePath + File.separator + smUser.getSucode() );
				if( !backupDir.exists() ){
					backupDir.mkdirs();
				}
				Tools.copyFile( uploadedFile.getAbsolutePath(), backupDir.getAbsolutePath() + File.separator + uploadedFile.getName() );
				
				ro.put( "err", "" );
				ro.put( "msg", uploadRelativePath + "/" + smUser.getSucode() + "/" + uploadedFile.getName() );
			}
						
			
		} catch (FileUploadException e) {						
			ro.put( "err", "�ϴ��ļ�ʱ�������:" + e.getMessage() );
			ro.put( "msg", "" );
		} catch (Exception e) {
			ro.put( "err", "�����ϴ��ļ�ʱ�������:" + e.getMessage() );
			ro.put( "msg", "" );
		}
		finally{
			out.println( JSONObject.fromObject( ro ).toString() );			
			out.close();
		}
	}
	
	/**
	 * ��ȡϵͳ��ǰ�û�
	 * 
	 * @return ϵͳ��ǰ�û�HttpServletRequest request
	 */
	public SysScmuser getCurrentUser(HttpServletRequest request)
	{
		SysScmuser smUser=null;
		smUser=(SysScmuser) request.getSession().getAttribute( Constants.LOGIN_USER );
		return smUser;
	}
}
