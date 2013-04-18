package com.bfuture.app.saas.model.report;

import com.bfuture.app.basic.model.BaseObject;

public class Shop extends BaseObject implements java.io.Serializable {
	private String sgcode;
	private String usercode;
	private String supid;
	private String code;
	private String name;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	public String getUsercode() {
		return usercode;
	}

	public void setUsercode(String usercode) {
		this.usercode = usercode;
	}

	public String getSupid() {
		return supid;
	}

	public void setSupid(String supid) {
		this.supid = supid;
	}

	@Override
	public int hashCode() {
		return this.hashCode();
	}

	@Override
	public boolean equals(Object o) {
		return this.equals(((Shop) o));
	}

	@Override
	public String toString() {
		return null;
	}
}
