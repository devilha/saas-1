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
	 * 从文件路径中取出文件名
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
		// 设置内存缓冲区，超过后写入临时文件
		factory.setSizeThreshold(10240000);
		// 设置临时文件存储位置
		factory.setRepository(new File( request.getSession().getServletContext().getRealPath( "/" + UploadControler.UPLOAD_DIR + "/temp")));
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置单个文件的最大上传值
		upload.setFileSizeMax(102400000);
//		upload.setFileSizeMax(Integer.MAX_VALUE);
		// 设置整个request的最大值
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
		
		// 更新上传文件列表
		FileUploadStatus satusBean = UploadControler.initStatusBean(request);
		satusBean.setUploadAddr( request.getRemoteAddr() );
		satusBean.setUploadTotalSize( request.getContentLength() );
		UploadControler.saveStatusBean(request, satusBean);
		
		try {
			List items = upload.parseRequest(request);
			// 获得贷款编码
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
			// 处理文件上传
			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);
				
				if( item.getSize() > 1 * 1024 * 1024 ){
					ro.setReturnInfo( "不能上传大小超过1M的文件" );
					ro.setReturnCode( Constants.ERROR_FLAG );
					break;
				}
				
				// 保存文件
				if (!item.isFormField() && item.getName().length() > 0) {
					String fileExtName = takeOutFileName(item.getName());
					File uploadedDir = new File( request.getSession().getServletContext().getRealPath( "/" + UploadControler.UPLOAD_DIR + "/" + plC ) );
					File uploadedFile = new File( uploadedDir.getPath()	+ File.separator + attId + fileExtName );
					if( !uploadedDir.exists() ){
						uploadedDir.mkdir();
					}
					
					System.out.println( uploadedFile.getPath() );					
					
					// 开始上传文件
					item.write(uploadedFile);
					
					Thread.sleep(500);
					
					ro.setReturnInfo( UploadControler.UPLOAD_DIR + "/" + plC + "/" + attId + fileExtName );
					ro.setReturnCode( Constants.SUCCESS_FLAG );
				}
			}			
			
		} catch (FileUploadException e) {
			ro.setReturnCode( Constants.ERROR_FLAG );
			ro.setReturnInfo( "上传文件时发生错误:" + e.getMessage() );			
		} catch (Exception e) {
			ro.setReturnCode( Constants.ERROR_FLAG );
			ro.setReturnInfo( "保存上传文件时发生错误:" + e.getMessage() );
		}
		finally{
			out.println( JSONObject.fromObject( ro ).toString() );			
			out.close();
		}
	}
}
