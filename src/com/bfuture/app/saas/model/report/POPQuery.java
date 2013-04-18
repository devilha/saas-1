package com.bfuture.app.saas.model.report;

import java.io.Serializable;

import com.bfuture.app.basic.model.BaseObject;

public class POPQuery extends BaseObject implements Serializable {

	private String sgcode;
	private String billno;
	private String popgdid;
	private String popgdname;
	private String popmarket;
	private String popsupcode;
	private String startDate;
	private String endDate;
	private String pphfyj;
	private String popgdbarcode;
	private String popsequece;
	private String ppsupid;
	private String ppsupname;
	private String ppviewstatus;
	
	
	public String getBillno() {
		return billno;
	}

	public void setBillno(String billno) {
		this.billno = billno;
	}

	public String getPpsupname() {
		return ppsupname;
	}

	public void setPpsupname(String ppsupname) {
		this.ppsupname = ppsupname;
	}

	public String getPpsupid() {
		return ppsupid;
	}

	public void setPpsupid(String ppsupid) {
		this.ppsupid = ppsupid;
	}

	@Override
	public boolean equals(Object o) {
		// TODO Auto-generated method stub
		return false;
	}

	public String getPopgdbarcode() {
		return popgdbarcode;
	}

	public void setPopgdbarcode(String popgdbarcode) {
		this.popgdbarcode = popgdbarcode;
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

	public String getPopgdid() {
		return popgdid;
	}

	public void setPopgdid(String popgdid) {
		this.popgdid = popgdid;
	}

	public String getPopgdname() {
		return popgdname;
	}

	public void setPopgdname(String popgdname) {
		this.popgdname = popgdname;
	}

	public String getPopsupcode() {
		return popsupcode;
	}

	public void setPopsupcode(String popsupcode) {
		this.popsupcode = popsupcode;
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

	public String getPopmarket() {
		return popmarket;
	}

	public void setPopmarket(String popmarket) {
		this.popmarket = popmarket;
	}

	public String getPopsequece() {
		return popsequece;
	}

	public void setPopsequece(String popsequece) {
		this.popsequece = popsequece;
	}

	public String getPphfyj() {
		return pphfyj;
	}

	public void setPphfyj(String pphfyj) {
		this.pphfyj = pphfyj;
	}

	public String getPpviewstatus() {
		return ppviewstatus;
	}

	public void setPpviewstatus(String ppviewstatus) {
		this.ppviewstatus = ppviewstatus;
	}

}
