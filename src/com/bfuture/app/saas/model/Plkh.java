package com.bfuture.app.saas.model;

import com.bfuture.app.basic.model.BaseObject;


/**
 * 批量开户model
 * @author Administrator
 *
 */
public class Plkh extends BaseObject implements java.io.Serializable  {
	// 实例编码
	private String sgcode;
	// 供应商编码
	private String supcodes;
	// 角色编码
	private String rlcode;
	// 密码
	private String password;
	// 密码开始时间
	private String startDate;
	// 密码结束时间
	private String endDate;
	// 是否设置门店
	private String isSetMd;

	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	public String getRlcode() {
		return rlcode;
	}

	public void setRlcode(String rlcode) {
		this.rlcode = rlcode;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getIsSetMd() {
		return isSetMd;
	}

	public void setIsSetMd(String isSetMd) {
		this.isSetMd = isSetMd;
	}

	public String getSupcodes() {
		return supcodes;
	}

	public void setSupcodes(String supcodes) {
		this.supcodes = supcodes;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	@Override
	public boolean equals(Object o) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}

}
