package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

import javax.persistence.Column;
import javax.persistence.Embeddable;

import com.bfuture.app.basic.model.BaseObject;

/**
 * YwBorderheadId generated by hbm2java
 */
@Embeddable
public class YwBorderheadId extends BaseObject implements java.io.Serializable {

	private String bohsgcode; // 实例编码
	private String bohbillno;
	private String bohmfid;

	public YwBorderheadId() {
	}

	public YwBorderheadId(String bohsgcode, String bohbillno, String bohmfid) {
		this.bohsgcode = bohsgcode;
		this.bohbillno = bohbillno;
		this.bohmfid = bohmfid;
	}

	@Column(name = "BOHSGCODE", nullable = false, length = 30)
	public String getBohsgcode() {
		return this.bohsgcode;
	}

	public void setBohsgcode(String bohsgcode) {
		this.bohsgcode = bohsgcode;
	}

	@Column(name = "BOHBILLNO", nullable = false, length = 32)
	public String getBohbillno() {
		return this.bohbillno;
	}

	public void setBohbillno(String bohbillno) {
		this.bohbillno = bohbillno;
	}

	@Column(name = "BOHMFID", nullable = false, length = 30)
	public String getBohmfid() {
		return this.bohmfid;
	}

	public void setBohmfid(String bohmfid) {
		this.bohmfid = bohmfid;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof YwBorderheadId))
			return false;
		YwBorderheadId castOther = (YwBorderheadId) other;

		return ((this.getBohsgcode() == castOther.getBohsgcode()) || (this
				.getBohsgcode() != null
				&& castOther.getBohsgcode() != null && this.getBohsgcode()
				.equals(castOther.getBohsgcode())))
				&& ((this.getBohbillno() == castOther.getBohbillno()) || (this
						.getBohbillno() != null
						&& castOther.getBohbillno() != null && this
						.getBohbillno().equals(castOther.getBohbillno())))
				&& ((this.getBohmfid() == castOther.getBohmfid()) || (this
						.getBohmfid() != null
						&& castOther.getBohmfid() != null && this.getBohmfid()
						.equals(castOther.getBohmfid())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getBohsgcode() == null ? 0 : this.getBohsgcode().hashCode());
		result = 37 * result
				+ (getBohbillno() == null ? 0 : this.getBohbillno().hashCode());
		result = 37 * result
				+ (getBohmfid() == null ? 0 : this.getBohmfid().hashCode());
		return result;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}

}
