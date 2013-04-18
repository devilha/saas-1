package com.bfuture.app.saas.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class YwSettlestatusId implements Serializable{
	private String sgcode;
	private String settleno;

	public String getSgcode() {
		return sgcode;
	}
	
	@Column(name = "SGCODE", nullable = false, length = 30)
	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}
   
	public String getSettleno() {
		return settleno;
	}

	@Column(name = "SETTLENO", nullable = false, length = 30)
	public void setSettleno(String settleno) {
		this.settleno = settleno;
	}

	public YwSettlestatusId(String sgcode, String settleno) {
		super();
		this.sgcode = sgcode;
		this.settleno = settleno;
	}
	public YwSettlestatusId() { }
}
