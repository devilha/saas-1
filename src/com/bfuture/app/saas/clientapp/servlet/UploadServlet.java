package com.bfuture.app.saas.clientapp.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.saas.clientapp.upload.FileUploadListener;
import com.bfuture.app.saas.clientapp.upload.FileUploadStatus;
import com.bfuture.app.saas.clientapp.upload.UploadControler;

/**
 * Servlet implementation class UploadServlet
 */
public class UploadServlet extends BasicServlet {
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
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// �����ڴ滺������������д����ʱ�ļ�
		factory.setSizeThreshold(10240000);
		// ������ʱ�ļ��洢λ��
		factory.setRepository(new File( request.getSession().getServletContext().getRealPath( "/" + UploadControler.UPLOAD_DIR + "/temp")));
		ServletFileUpload upload = new ServletFileUpload(factory);
		// ���õ����ļ�������ϴ�ֵ
		upload.setFileSizeMax(102400000);
//		upload.setFileSizeMax(Integer.MAX_VALUE);
		// ��������request�����ֵ
		upload.setSizeMax(102400000);
//		upload.setSizeMax(Integer.MAX_VALUE);
		
		upload.setHeaderEncoding("GBK");
		FileUploadListener uploadListener = new FileUploadListener(request, request.getRemoteAddr() ); 
		upload.setProgressListener( uploadListener );
		
		String plC = "";
		String attId = "";
		
		ReturnObject ro = new ReturnObject();
		PrintWriter out = null;
		try {
			response.setCharacterEncoding("GBK");
			out = response.getWriter();			
		} catch (IOException e) {			
			e.printStackTrace();
			return;
		}
		
		// �����ϴ��ļ��б�
		FileUploadStatus satusBean = UploadControler.initStatusBean(request);
		satusBean.setUploadAddr( request.getRemoteAddr() );
		satusBean.setUploadTotalSize( request.getContentLength() );
		UploadControler.saveStatusBean(request, satusBean);
		
		try {
			List items = upload.parseRequest(request);
			// ��ô������
			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);
				if (item.isFormField() && "plC".equals( item.getFieldName() ) ) {
					plC = item.getString();					
				}
				else if (item.isFormField() && "attId".equals( item.getFieldName() ) ) {
					attId = item.getString();
					break;
				}
			}
			// �����ļ��ϴ�
			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);
				
				if( item.getSize() > 1 * 1024 * 1024 ){
					ro.setReturnInfo( "�����ϴ���С����1M���ļ�" );
					ro.setReturnCode( Constants.ERROR_FLAG );
					break;
				}
				
				// �����ļ�
				if (!item.isFormField() && item.getName().length() > 0) {
					String fileExtName = takeOutFileName(item.getName());
					File uploadedDir = new File( request.getSession().getServletContext().getRealPath( "/" + UploadControler.UPLOAD_DIR + "/" + plC ) );
					File uploadedFile = new File( uploadedDir.getPath()	+ File.separator + attId + fileExtName );
					if( !uploadedDir.exists() ){
						uploadedDir.mkdir();
					}
					
					System.out.println( uploadedFile.getPath() );					
					
					// ��ʼ�ϴ��ļ�
					item.write(uploadedFile);
					
					Thread.sleep(500);
					
					ro.setReturnInfo( UploadControler.UPLOAD_DIR + "/" + plC + "/" + attId + fileExtName );
					ro.setReturnCode( Constants.SUCCESS_FLAG );
				}
			}			
			
		} catch (FileUploadException e) {
			ro.setReturnCode( Constants.ERROR_FLAG );
			ro.setReturnInfo( "�ϴ��ļ�ʱ��������:" + e.getMessage() );			
		} catch (Exception e) {
			ro.setReturnCode( Constants.ERROR_FLAG );
			ro.setReturnInfo( "�����ϴ��ļ�ʱ��������:" + e.getMessage() );
		}
		finally{
			out.println( JSONObject.fromObject( ro ).toString() );			
			out.close();
		}
	}
}
