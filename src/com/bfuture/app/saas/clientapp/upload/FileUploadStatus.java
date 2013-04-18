package com.bfuture.app.saas.clientapp.upload;

import java.io.Serializable;

public class FileUploadStatus implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4299210990638670553L;
	// �ϴ���ַ
	private String uploadAddr;
	// �ϴ���
	private long uploadTotalSize = 0;
	// ��ȡ�ϴ���
	private long readTotalSize = 0;
	// ��ǰ�ϴ��ļ���
	private int currentUploadFileNum = 0;
	// �ɹ���ȡ�ϴ��ļ���
	private int successUploadFileCount = 0;
	// ״̬
	private String status = "";
	// ������ʼʱ��
	private long processStartTime = 0l;
	// ������ֹʱ��
	private long processEndTime = 0l;
	// ����ִ��ʱ��
	private long processRunningTime = 0l;
	
	// �ϴ�baseĿ¼
	private String baseDir = "";

	public FileUploadStatus() {
	}

	public String getBaseDir() {
		return baseDir;
	}

	public void setBaseDir(String baseDir) {
		this.baseDir = baseDir;
	}

	public long getProcessRunningTime() {
		return processRunningTime;
	}

	public void setProcessRunningTime(long processRunningTime) {
		this.processRunningTime = processRunningTime;
	}

	public long getProcessEndTime() {
		return processEndTime;
	}

	public void setProcessEndTime(long processEndTime) {
		this.processEndTime = processEndTime;
	}

	public long getProcessStartTime() {
		return processStartTime;
	}

	public void setProcessStartTime(long processStartTime) {
		this.processStartTime = processStartTime;
	}

	public long getReadTotalSize() {
		return readTotalSize;
	}

	public void setReadTotalSize(long readTotalSize) {
		this.readTotalSize = readTotalSize;
	}

	public int getSuccessUploadFileCount() {
		return successUploadFileCount;
	}

	public void setSuccessUploadFileCount(int successUploadFileCount) {
		this.successUploadFileCount = successUploadFileCount;
	}

	public int getCurrentUploadFileNum() {
		return currentUploadFileNum;
	}

	public void setCurrentUploadFileNum(int currentUploadFileNum) {
		this.currentUploadFileNum = currentUploadFileNum;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getUploadTotalSize() {
		return uploadTotalSize;
	}

	public String getUploadAddr() {
		return uploadAddr;
	}

	public void setUploadTotalSize(long uploadTotalSize) {
		this.uploadTotalSize = uploadTotalSize;
	}

	public void setUploadAddr(String uploadAddr) {
		this.uploadAddr = uploadAddr;
	}
}
