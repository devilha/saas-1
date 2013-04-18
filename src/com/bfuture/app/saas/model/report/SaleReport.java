package com.bfuture.app.saas.model.report;

import com.bfuture.app.basic.model.BaseObject;

public class SaleReport extends BaseObject implements java.io.Serializable{
	
	private String gsrq;
	private String gsmfid;
	private String gsgdid;
	private String gsgdname;
	private String gsgcid;
	private String gsgcname;
	private String category;
	private String supcode;
	private String startDate;
	private String endDate;
	private String gssgcode;
	private String gysbm;
	private String userType;
	private String suname;
	private String gdbarcode;
	private String temp5;
	private String yesterdayFlag;
	private String hth;      //合同号
    private String floor;    //楼层
    private String deptname; //部门
    private String gdppname; //品牌
	
	public String getGsrq() {
		return gsrq;
	}

	public void setGsrq(String gsrq) {
		this.gsrq = gsrq;
	}

	public String getGsmfid() {
		return gsmfid;
	}

	public void setGsmfid(String gsmfid) {
		this.gsmfid = gsmfid;
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

	public String getGsgdid() {
		return gsgdid;
	}

	public void setGsgdid(String gsgdid) {
		this.gsgdid = gsgdid;
	}

	public String getGsgdname() {
		return gsgdname;
	}

	public void setGsgdname(String gsgdname) {
		this.gsgdname = gsgdname;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getSupcode() {
		return supcode;
	}

	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}
	

	public String getGsgcid() {
		return gsgcid;
	}

	public void setGsgcid(String gsgcid) {
		this.gsgcid = gsgcid;
	}

	public String getGsgcname() {
		return gsgcname;
	}

	public void setGsgcname(String gsgcname) {
		this.gsgcname = gsgcname;
	}	

	public String getGssgcode() {
		return gssgcode;
	}
	
	public void setGssgcode(String gssgcode) {
		this.gssgcode = gssgcode;
	}
	
	public String getGysbm() {
		return gysbm;
	}

	public void setGysbm(String gysbm) {
		this.gysbm = gysbm;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
	
	public String getSuname() {
		return suname;
	}

	public void setSuname(String suname) {
		this.suname = suname;
	}
		
	public String getYesterdayFlag() {
		return yesterdayFlag;
	}

	public void setYesterdayFlag(String yesterdayFlag) {
		this.yesterdayFlag = yesterdayFlag;
	}

	@Override
	public boolean equals(Object o) {
		return this.equals(((SaleReport)o));
	}

	@Override
	public int hashCode() {
		return this.hashCode();
	}

	@Override
	public String toString() {
		return null;
	}

	public String getGdbarcode() {
		return gdbarcode;
	}

	public void setGdbarcode(String gdbarcode) {
		this.gdbarcode = gdbarcode;
	}

	public String getTemp5() {
		return temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}

	public String getHth() {
		return hth;
	}

	public void setHth(String hth) {
		this.hth = hth;
	}

	public String getFloor() {
		return floor;
	}

	public void setFloor(String floor) {
		this.floor = floor;
	}

	public String getDeptname() {
		return deptname;
	}

	public void setDeptname(String deptname) {
		this.deptname = deptname;
	}

	public String getGdppname() {
		return gdppname;
	}

	public void setGdppname(String gdppname) {
		this.gdppname = gdppname;
	}

	
	
}
