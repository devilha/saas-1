
package com.bfuture.app.basic.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.persistence.Transient;

import net.sf.json.JSONObject;

/**
 * 模型对象的基础类.其子类需实现toString(), 
 * equals() 和 hashCode()等方法;
 * 
 * @author 丁元
 */
public class ReturnObject implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6939279207070966425L;
	
	private List<Object> rows;
	private List<Object> footer;
	private JSONObject chartData;
	private int total;

	//1为成功0为失败
	private String returnCode="1";	
	private String returnInfo;

	
	
	@Transient
	public String getReturnInfo() {
		return returnInfo;
	}

	public void setReturnInfo(String returnInfo) {
		this.returnInfo = returnInfo;
	}
	
	@Transient
	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}	

	@Transient
	public List<Object> getRows() {
		return rows;
	}

	public void setRows(List<Object> rows) {
		this.rows = rows;
	}
	
	@Transient
	public List<Object> getFooter() {
		return footer;
	}

	public void setFooter(List<Object> footer) {
		this.footer = footer;
	}

	@Transient
	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	@Transient
	public JSONObject getChartData() {
		return chartData;
	}

	public void setChartData(JSONObject chartData) {
		this.chartData = chartData;
	}
	
}
