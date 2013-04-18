package com.bfuture.app.saas.model;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * DownlodeCenter entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "DOWNLODE_CENTER")
public class DownlodeCenter extends BaseObject implements java.io.Serializable {

	// Fields

	private Integer id;
	private String insC;
	private String title;
	private String url;
	private String crtByC;
	private Date crtByTime;
	private String memo;
	private String form_id;
	private String to_id;	
	
	//辅助字段
	private String startDate; // 开始时间
	/**
	 * 
	 */
	private String endDate;   // 结束时间
	@Transient
	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	@Transient
	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	// Constructors
	@Column(name = "MEMO", nullable = true, length = 200)
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	/** default constructor */
	public DownlodeCenter() {
	}

	/** middle constructor */
	public DownlodeCenter(Integer id, String insC, String title, String url, String crtByC, Date crtByTime,String memo) {
		this.id = id;
		this.insC = insC;
		this.title = title;
		this.url = url;
		this.crtByC = crtByC;
		this.crtByTime = crtByTime;
		this.memo = memo;
	}
	
	/** full constructor */
	public DownlodeCenter(Integer id, String insC, String title, String url, String crtByC, Date crtByTime,String memo,String formid,String toid) {
		this.id = id;
		this.insC = insC;
		this.title = title;
		this.url = url;
		this.crtByC = crtByC;
		this.crtByTime = crtByTime;
		this.memo = memo;
		this.form_id=formid;
		this.to_id=toid;
	}

	// Property accessors
	@Id
	@Column(name = "ID", unique = true, nullable = false, precision = 22, scale = 0)
	@SequenceGenerator(name="download",sequenceName="SEO_DOWNLODE_CENTER",allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="download")
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "INS_C", nullable = false, length = 30)
	public String getInsC() {
		return this.insC;
	}

	public void setInsC(String insC) {
		this.insC = insC;
	}

	@Column(name = "TITLE", nullable = false, length = 200)
	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "URL", nullable = false, length = 300)
	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
	public String getForm_id() {
		return form_id;
	}

	@Column(name = "FORM_ID", nullable = false, length = 30)
	public void setForm_id(String formid) {
		this.form_id = formid;
	}

	@Column(name = "TO_ID", nullable = false, length = 30)
	public String getTo_id() {
		return to_id;
	}

	public void setTo_id(String toid) {
		this.to_id = toid;
	}

	@Column(name = "CRT_BY_C", nullable = false, length = 30)
	public String getCrtByC() {
		return this.crtByC;
	}

	public void setCrtByC(String crtByC) {
		this.crtByC = crtByC;
	}
	@Temporal(TemporalType.DATE)
	@Column(name = "CRT_BY_TIME", nullable = false)
	public Date getCrtByTime() {
		return this.crtByTime;
	}

	public void setCrtByTime(Date crtByTime) {
		this.crtByTime = crtByTime;
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