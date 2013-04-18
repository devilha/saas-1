package com.bfuture.app.saas.clientapp.upload;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.ProgressListener;

public class FileUploadListener implements ProgressListener {

	private HttpServletRequest request = null;
	private String uploadFileName;

	public FileUploadListener(HttpServletRequest request, String uploadFileName) {
		this.request = request;
		this.uploadFileName = uploadFileName;
	}

	public String getUploadFileName() {
		return uploadFileName;
	}

	public void setUploadFileName(String uploadFileName) {
		this.uploadFileName = uploadFileName;
	}

	/**
	 * ����״̬
	 */
	public void update(long pBytesRead, long pContentLength, int pItems) {
		if( uploadFileName == null )return;
		
		FileUploadStatus statusBean = UploadControler.getStatusBean(request,
				uploadFileName);
		statusBean.setUploadTotalSize(pContentLength);
		// ��ȡ���
		if (pContentLength == -1) {
			statusBean.setStatus("finished");
			statusBean.setReadTotalSize(pBytesRead);
			statusBean.setSuccessUploadFileCount(pItems);
			statusBean.setProcessEndTime(System.currentTimeMillis());
			statusBean.setProcessRunningTime(statusBean.getProcessEndTime());
			// ��ȡ��
		} else {
			statusBean.setStatus("uploading");
			statusBean.setReadTotalSize(pBytesRead);
			statusBean.setCurrentUploadFileNum(pItems);
			statusBean.setProcessRunningTime(System.currentTimeMillis());
		}
		UploadControler.saveStatusBean(request, statusBean);
	}

}
