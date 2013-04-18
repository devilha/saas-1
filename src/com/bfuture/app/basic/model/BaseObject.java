
package com.bfuture.app.basic.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Transient;

/**
 * 模型对象的基础类.其子类需实现toString(), 
 * equals() 和 hashCode()等方法;
 * 
 * @author 丁元
 */
/**
 * @author Administrator
 *
 */
public abstract class BaseObject implements Serializable {

	private String ACTION_CLASS;
	private String ACTION_TYPE;
	private String ACTION_MANAGER;
	private List<Object> list;
	private int rows;
	private int page;
	private String order;
	private String sort;
	private String optType;
	private String optContent;
	private boolean exportExcel;
	private List<String> enTitle;
	private List<String> cnTitle;
	private String sheetTitle;

	@Override
	public abstract String toString();

	@Override
	public abstract boolean equals(Object o);

	@Override
	public abstract int hashCode();	

	@Transient
	public String getACTION_CLASS() {
		return ACTION_CLASS;
	}

	public void setACTION_CLASS(String action_class) {
		ACTION_CLASS = action_class;
	}

	@Transient
	public String getACTION_TYPE() {
		return ACTION_TYPE;
	}

	public void setACTION_TYPE(String action_type) {
		ACTION_TYPE = action_type;
	}	
	
	@Transient
	public String getACTION_MANAGER() {
		return ACTION_MANAGER;
	}

	public void setACTION_MANAGER(String action_manager) {
		ACTION_MANAGER = action_manager;
	}

	@Transient
	public List<Object> getList() {
		return list;
	}

	public void setList(List<Object> list) {
		this.list = list;
	}

	@Transient
	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	@Transient
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	@Transient
	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	@Transient
	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	@Transient
	public String getOptType() {
		return optType;
	}

	public void setOptType(String optType) {
		this.optType = optType;
	}

	@Transient
	public String getOptContent() {
		return optContent;
	}

	public void setOptContent(String optContent) {
		this.optContent = optContent;
	}
	
	@Transient
	public boolean isExportExcel() {
		return exportExcel;
	}

	public void setExportExcel(boolean exportExcel) {
		this.exportExcel = exportExcel;
	}

	@Transient
	public List<String> getEnTitle() {
		return enTitle;
	}

	public void setEnTitle(List<String> enTitle) {
		this.enTitle = enTitle;
	}

	@Transient
	public List<String> getCnTitle() {
		return cnTitle;
	}

	public void setCnTitle(List<String> cnTitle) {
		this.cnTitle = cnTitle;
	}

	@Transient
	public String getSheetTitle() {
		return sheetTitle;
	}

	public void setSheetTitle(String sheetTitle) {
		this.sheetTitle = sheetTitle;
	}	
	
}
