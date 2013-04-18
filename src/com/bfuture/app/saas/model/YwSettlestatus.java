package com.bfuture.app.saas.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;


@Entity
@Table(name = "YW_SETTLE_STATE_FLCS")
public class YwSettlestatus implements Serializable{
	private YwSettlestatusId id;
	private String state;
	private Date mdate;
	private Integer pstate;

	@Column(name = "PSTATE")
	public Integer getPstate() {
		return pstate;
	}

	public void setPstate(Integer pstate) {
		this.pstate = pstate;
	}

	@Column(name = "MDATE")
	public Date getMdate() {
		return mdate;
	}

	public void setMdate(Date mdate) {
		this.mdate = mdate;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "sgcode", column = @Column(name = "SGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "settleno", column = @Column(name = "SETTLENO", nullable = false, length = 32))})
	public YwSettlestatusId getId() {
		return id;
	}

	public void setId(YwSettlestatusId id) {
		this.id = id;
	}

	@Column(name = "STATE", length = 1)
	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	
}
