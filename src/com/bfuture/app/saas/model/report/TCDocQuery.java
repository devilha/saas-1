package com.bfuture.app.saas.model.report;

import java.io.Serializable;

import com.bfuture.app.basic.model.BaseObject;

public class TCDocQuery extends BaseObject implements Serializable{
	private String sgcode;
	private String supcode;
	private String shopcode;
	private String shopname;
	private String supname;
	private String BTLLNO;
	private String startDate;
	private String endDate;
	private String bthstatus;
	private String temp5;
	public String getBthstatus() {
		return bthstatus;
	}

	public void setBthstatus(String bthstatus) {
		this.bthstatus = bthstatus;
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

	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	public String getSupcode() {
		return supcode;
	}

	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}

	public String getShopcode() {
		return shopcode;
	}

	public void setShopcode(String shopcode) {
		this.shopcode = shopcode;
	}

	public String getShopname() {
		return shopname;
	}

	public void setShopname(String shopname) {
		this.shopname = shopname;
	}

	public String getSupname() {
		return supname;
	}

	public void setSupname(String supname) {
		this.supname = supname;
	}

	public String getBTLLNO() {
		return BTLLNO;
	}

	public void setBTLLNO(String btllno) {
		BTLLNO = btllno;
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

	public String getTemp5() {
		return temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}
}
