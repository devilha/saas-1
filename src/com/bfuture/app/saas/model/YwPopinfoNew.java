package com.bfuture.app.saas.model;

import java.sql.Timestamp;
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

import com.bfuture.app.basic.model.BaseObject;

/**
 * YwPopinfoNew entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "YW_POPINFO_NEW")
public class YwPopinfoNew extends BaseObject implements java.io.Serializable {
	// Fields
	private Long popsequece;
	private String ppsgcode;
	private String pplb;
	private String ppgdid;
	private String ppsupid;
	private String ppmarket;
	private Date ppksrq;
	private Date ppjsrq;
	private String ppkssj;
	private String ppjssj;
	private Double ppcxsj;
	private Double ppcxxl;
	private Double ppkl;
	private Double ppzkfd;
	private String ppcxzt;
	private String ppviewstatus;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;
	private Date ppgxtime;
	private String ppfile;
	private Double ppyssj;
	private Date ppbjrq;
	private String pphfyj;
	private String ppcgyj;
	private String ppgdbarcode;
	private String ppgdname;
	private String ppbjyy;
	private Double ppgdyj;
	private String ppsupname;
	// Constructors
	@Column(name = "PPSUPNAME", length = 300)
	public String getPpsupname() {
		return ppsupname;
	}

	public void setPpsupname(String ppsupname) {
		this.ppsupname = ppsupname;
	}

	/** default constructor */
	public YwPopinfoNew() {
	}

	/** minimal constructor */
	public YwPopinfoNew(Long popsequece, String ppsgcode, String ppgdid, String ppsupid, String ppmarket, Date ppksrq, Date ppjsrq) {
		this.popsequece = popsequece;
		this.ppsgcode = ppsgcode;
		this.ppgdid = ppgdid;
		this.ppsupid = ppsupid;
		this.ppmarket = ppmarket;
		this.ppksrq = ppksrq;
		this.ppjsrq = ppjsrq;
	}

	/** full constructor */
	public YwPopinfoNew(Long popsequece, String ppsgcode, String pplb, String ppgdid, String ppsupid, String ppmarket, Date ppksrq, Date ppjsrq, String ppkssj, String ppjssj, Double ppcxsj, Double ppcxxl, Double ppkl, Double ppzkfd, String ppcxzt, String ppviewstatus, String temp2, String temp3, String temp4, String temp5, Timestamp ppgxtime, String ppfile, Double ppyssj, Date ppbjrq, String pphfyj, String ppcgyj, String ppgdbarcode, String ppgdname, String ppbjyy, Double ppgdyj) {
		this.popsequece = popsequece;
		this.ppsgcode = ppsgcode;
		this.pplb = pplb;
		this.ppgdid = ppgdid;
		this.ppsupid = ppsupid;
		this.ppmarket = ppmarket;
		this.ppksrq = ppksrq;
		this.ppjsrq = ppjsrq;
		this.ppkssj = ppkssj;
		this.ppjssj = ppjssj;
		this.ppcxsj = ppcxsj;
		this.ppcxxl = ppcxxl;
		this.ppkl = ppkl;
		this.ppzkfd = ppzkfd;
		this.ppcxzt = ppcxzt;
		this.ppviewstatus = ppviewstatus;
		this.temp2 = temp2;
		this.temp3 = temp3;
		this.temp4 = temp4;
		this.temp5 = temp5;
		this.ppgxtime = ppgxtime;
		this.ppfile = ppfile;
		this.ppyssj = ppyssj;
		this.ppbjrq = ppbjrq;
		this.pphfyj = pphfyj;
		this.ppcgyj = ppcgyj;
		this.ppgdbarcode = ppgdbarcode;
		this.ppgdname = ppgdname;
		this.ppbjyy = ppbjyy;
		this.ppgdyj = ppgdyj;
	}

	// Property accessors
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,generator="ywpopinfonew_seq") 
	@SequenceGenerator(name="ywpopinfonew_seq", sequenceName="YW_POPINFO_NEW_TB_SEQ") 
	@Column(name = "POPSEQUECE", unique = true, nullable = false, precision = 16, scale = 0)
	public Long getPopsequece() {
		return this.popsequece;
	}

	public void setPopsequece(Long popsequece) {
		this.popsequece = popsequece;
	}

	@Column(name = "PPSGCODE", nullable = false, length = 30)
	public String getPpsgcode() {
		return this.ppsgcode;
	}

	public void setPpsgcode(String ppsgcode) {
		this.ppsgcode = ppsgcode;
	}

	@Column(name = "PPLB", length = 24)
	public String getPplb() {
		return this.pplb;
	}

	public void setPplb(String pplb) {
		this.pplb = pplb;
	}

	@Column(name = "PPGDID", nullable = false, length = 24)
	public String getPpgdid() {
		return this.ppgdid;
	}

	public void setPpgdid(String ppgdid) {
		this.ppgdid = ppgdid;
	}

	@Column(name = "PPSUPID", nullable = false, length = 24)
	public String getPpsupid() {
		return this.ppsupid;
	}

	public void setPpsupid(String ppsupid) {
		this.ppsupid = ppsupid;
	}

	@Column(name = "PPMARKET", nullable = false, length = 30)
	public String getPpmarket() {
		return this.ppmarket;
	}

	public void setPpmarket(String ppmarket) {
		this.ppmarket = ppmarket;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "PPKSRQ", nullable = false, length = 7)
	public Date getPpksrq() {
		return this.ppksrq;
	}

	public void setPpksrq(Date ppksrq) {
		this.ppksrq = ppksrq;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "PPJSRQ", nullable = false, length = 7)
	public Date getPpjsrq() {
		return this.ppjsrq;
	}

	public void setPpjsrq(Date ppjsrq) {
		this.ppjsrq = ppjsrq;
	}

	@Column(name = "PPKSSJ", length = 8)
	public String getPpkssj() {
		return this.ppkssj;
	}

	public void setPpkssj(String ppkssj) {
		this.ppkssj = ppkssj;
	}

	@Column(name = "PPJSSJ", length = 8)
	public String getPpjssj() {
		return this.ppjssj;
	}

	public void setPpjssj(String ppjssj) {
		this.ppjssj = ppjssj;
	}

	@Column(name = "PPCXSJ", precision = 16)
	public Double getPpcxsj() {
		return this.ppcxsj;
	}

	public void setPpcxsj(Double ppcxsj) {
		this.ppcxsj = ppcxsj;
	}

	@Column(name = "PPCXXL", precision = 16)
	public Double getPpcxxl() {
		return this.ppcxxl;
	}

	public void setPpcxxl(Double ppcxxl) {
		this.ppcxxl = ppcxxl;
	}

	@Column(name = "PPKL", precision = 16)
	public Double getPpkl() {
		return this.ppkl;
	}

	public void setPpkl(Double ppkl) {
		this.ppkl = ppkl;
	}

	@Column(name = "PPZKFD", precision = 16)
	public Double getPpzkfd() {
		return this.ppzkfd;
	}

	public void setPpzkfd(Double ppzkfd) {
		this.ppzkfd = ppzkfd;
	}

	@Column(name = "PPCXZT", length = 80)
	public String getPpcxzt() {
		return this.ppcxzt;
	}

	public void setPpcxzt(String ppcxzt) {
		this.ppcxzt = ppcxzt;
	}

	@Column(name = "ppviewstatus", length = 64)
	public String getppviewstatus() {
		return this.ppviewstatus;
	}

	public void setppviewstatus(String ppviewstatus) {
		this.ppviewstatus = ppviewstatus;
	}

	@Column(name = "TEMP2", length = 64)
	public String getTemp2() {
		return this.temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	@Column(name = "TEMP3", length = 64)
	public String getTemp3() {
		return this.temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	@Column(name = "TEMP4", length = 64)
	public String getTemp4() {
		return this.temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	@Column(name = "TEMP5", length = 64)
	public String getTemp5() {
		return this.temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "PPGXTIME")
	public Date getPpgxtime() {
		return this.ppgxtime;
	}

	public void setPpgxtime(Date ppgxtime) {
		this.ppgxtime = ppgxtime;
	}

	@Column(name = "PPFILE", length = 64)
	public String getPpfile() {
		return this.ppfile;
	}

	public void setPpfile(String ppfile) {
		this.ppfile = ppfile;
	}

	@Column(name = "PPYSSJ", precision = 16)
	public Double getPpyssj() {
		return this.ppyssj;
	}

	public void setPpyssj(Double ppyssj) {
		this.ppyssj = ppyssj;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "PPBJRQ", length = 7)
	public Date getPpbjrq() {
		return this.ppbjrq;
	}

	public void setPpbjrq(Date ppbjrq) {
		this.ppbjrq = ppbjrq;
	}

	@Column(name = "PPHFYJ", length = 10)
	public String getPphfyj() {
		return this.pphfyj;
	}

	public void setPphfyj(String pphfyj) {
		this.pphfyj = pphfyj;
	}

	@Column(name = "PPCGYJ", length = 500)
	public String getPpcgyj() {
		return this.ppcgyj;
	}

	public void setPpcgyj(String ppcgyj) {
		this.ppcgyj = ppcgyj;
	}

	@Column(name = "PPGDBARCODE", length = 24)
	public String getPpgdbarcode() {
		return this.ppgdbarcode;
	}

	public void setPpgdbarcode(String ppgdbarcode) {
		this.ppgdbarcode = ppgdbarcode;
	}

	@Column(name = "PPGDNAME", length = 80)
	public String getPpgdname() {
		return this.ppgdname;
	}

	public void setPpgdname(String ppgdname) {
		this.ppgdname = ppgdname;
	}

	@Column(name = "PPBJYY", length = 64)
	public String getPpbjyy() {
		return this.ppbjyy;
	}

	public void setPpbjyy(String ppbjyy) {
		this.ppbjyy = ppbjyy;
	}

	@Column(name = "PPGDYJ", precision = 16)
	public Double getPpgdyj() {
		return this.ppgdyj;
	}

	public void setPpgdyj(Double ppgdyj) {
		this.ppgdyj = ppgdyj;
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