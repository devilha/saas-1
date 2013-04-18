package com.bfuture.app.saas.model.report;

import com.bfuture.app.basic.model.BaseObject;

public class Downlode extends BaseObject implements java.io.Serializable {
	private String startDate;
	private String endDate;
  
    private String insC;
    
    /**
     * 用户名 
     */
    private String sucode;
	



	public String getInsC() {
		return insC;
	}

	public void setInsC(String insC) {
		this.insC = insC;
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

	public String getSucode() {
		return sucode;
	}

	public void setSucode(String sucode) {
		this.sucode = sucode;
	}
	

}
