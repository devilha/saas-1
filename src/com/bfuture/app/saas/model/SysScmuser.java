package com.bfuture.app.saas.model;

// Generated 2011-3-3 14:49:18 by Hibernate Tools 3.2.2.GA

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * SysScmuser generated by hbm2java
 */
@Entity
@Table(name = "SYS_SCMUSER")
public class SysScmuser extends BaseObject implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3997194688164502606L;
	private String sucode;
	private String suname;
	private String supwd;
	private String sutel;
	private Character sutype;
	private Character suflag;
	private Character suenable;
	private String sumemo;
	private String sgcode;
	private String supcode;
	private Date crttime;
	private String supwdq;
	private String supwda;
	private String suoriname;
	private String regaddress;
	private String address;
	private String suoricode;
	private String shortname;
	private String salemethod;
	private String area;
	private String companycode;
	private String zipcode;
	private String industry;
	private String fax;
	private String email;
	private String licensecode;
	private String taxcode;
	private String taxcategory;
	private String organizationcode;
	private String bank;
	private String account;
	private Double yearsale;
	private Double capital;
	private String nature;
	private String companycategory;
	private String legalperson;
	private String legalpersonid;
	private String legalpersontel;
	private String agent;
	private String agentid;
	private String linkman;
	private String linkmanoffice;
	private String linkmantel;
	private String salearea;
	private Double sataffcount;
	private String web;
	private Double salearea2;
	private String region;
	private String salefile;
	private String salefilememo;
	private String memo;
	private String logo;
	private String mobile;
	private Double taxrate;
	private String companydescrib;
	private String signname;
	private Double paymoney;
	private Double realpaymoney;
	private String contracttime;
	private String videofilepath;
	private String videolabel;
	private String videotitle;
	private String agenttel;
	private Double staffcount;
	private String taxarea;
	private String remoteIP;
	private String editFlag;

	private Date lastUpdateTime;
	
	private List roles;
	
	public SysScmuser() {
	}

	public SysScmuser(String sucode) {
		this.sucode = sucode;
	}

	public SysScmuser(String sucode, String suname, String supwd, String sutel,
			Character sutype, Character suflag, Character suenable,
			String sumemo, String sgcode, String supcode, Date crttime,
			String supwdq, String supwda, String suoriname, String regaddress,
			String address, String suoricode, String shortname,
			String salemethod, String area, String companycode, String zipcode,
			String industry, String fax, String email, String licensecode,
			String taxcode, String taxcategory, String organizationcode,
			String bank, String account, Double yearsale, Double capital,
			String nature, String companycategory, String legalperson,
			String legalpersonid, String legalpersontel, String agent,
			String agentid, String linkman, String linkmanoffice,
			String linkmantel, String salearea, Double sataffcount, String web,
			Double salearea2, String region, String salefile,
			String salefilememo, String memo, String logo, String mobile,
			Double taxrate, String companydescrib, String signname,
			Double paymoney, Double realpaymoney, String contracttime,
			String videofilepath, String videolabel, String videotitle,
			String agenttel, Double staffcount, String taxarea) {
		this.sucode = sucode;
		this.suname = suname;
		this.supwd = supwd;
		this.sutel = sutel;
		this.sutype = sutype;
		this.suflag = suflag;
		this.suenable = suenable;
		this.sumemo = sumemo;
		this.sgcode = sgcode;
		this.supcode = supcode;
		this.crttime = crttime;
		this.supwdq = supwdq;
		this.supwda = supwda;
		this.suoriname = suoriname;
		this.regaddress = regaddress;
		this.address = address;
		this.suoricode = suoricode;
		this.shortname = shortname;
		this.salemethod = salemethod;
		this.area = area;
		this.companycode = companycode;
		this.zipcode = zipcode;
		this.industry = industry;
		this.fax = fax;
		this.email = email;
		this.licensecode = licensecode;
		this.taxcode = taxcode;
		this.taxcategory = taxcategory;
		this.organizationcode = organizationcode;
		this.bank = bank;
		this.account = account;
		this.yearsale = yearsale;
		this.capital = capital;
		this.nature = nature;
		this.companycategory = companycategory;
		this.legalperson = legalperson;
		this.legalpersonid = legalpersonid;
		this.legalpersontel = legalpersontel;
		this.agent = agent;
		this.agentid = agentid;
		this.linkman = linkman;
		this.linkmanoffice = linkmanoffice;
		this.linkmantel = linkmantel;
		this.salearea = salearea;
		this.sataffcount = sataffcount;
		this.web = web;
		this.salearea2 = salearea2;
		this.region = region;
		this.salefile = salefile;
		this.salefilememo = salefilememo;
		this.memo = memo;
		this.logo = logo;
		this.mobile = mobile;
		this.taxrate = taxrate;
		this.companydescrib = companydescrib;
		this.signname = signname;
		this.paymoney = paymoney;
		this.realpaymoney = realpaymoney;
		this.contracttime = contracttime;
		this.videofilepath = videofilepath;
		this.videolabel = videolabel;
		this.videotitle = videotitle;
		this.agenttel = agenttel;
		this.staffcount = staffcount;
		this.taxarea = taxarea;
	}

	@Id
	@Column(name = "SUCODE", unique = true, nullable = false)
	public String getSucode() {
		return this.sucode;
	}

	public void setSucode(String sucode) {
		this.sucode = sucode;
	}

	@Column(name = "SUNAME")
	public String getSuname() {
		return this.suname;
	}

	public void setSuname(String suname) {
		this.suname = suname;
	}

	@Column(name = "SUPWD")
	public String getSupwd() {
		return this.supwd;
	}

	public void setSupwd(String supwd) {
		this.supwd = supwd;
	}

	@Column(name = "SUTEL")
	public String getSutel() {
		return this.sutel;
	}

	public void setSutel(String sutel) {
		this.sutel = sutel;
	}

	@Column(name = "SUTYPE")
	public Character getSutype() {
		return this.sutype;
	}

	public void setSutype(Character sutype) {
		this.sutype = sutype;
	}

	@Column(name = "SUFLAG")
	public Character getSuflag() {
		return this.suflag;
	}

	public void setSuflag(Character suflag) {
		this.suflag = suflag;
	}

	@Column(name = "SUENABLE")
	public Character getSuenable() {
		return this.suenable;
	}

	public void setSuenable(Character suenable) {
		this.suenable = suenable;
	}

	@Column(name = "SUMEMO")
	public String getSumemo() {
		return this.sumemo;
	}

	public void setSumemo(String sumemo) {
		this.sumemo = sumemo;
	}

	@Column(name = "SGCODE")
	public String getSgcode() {
		return this.sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	@Column(name = "SUPCODE")
	public String getSupcode() {
		return this.supcode;
	}

	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CRTTIME")
	public Date getCrttime() {
		return this.crttime;
	}

	public void setCrttime(Date crttime) {
		this.crttime = crttime;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "LAST_UPDATE_TIME")
	public Date getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(Date lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	@Column(name = "SUPWDQ")
	public String getSupwdq() {
		return this.supwdq;
	}

	public void setSupwdq(String supwdq) {
		this.supwdq = supwdq;
	}

	@Column(name = "SUPWDA")
	public String getSupwda() {
		return this.supwda;
	}

	public void setSupwda(String supwda) {
		this.supwda = supwda;
	}

	@Column(name = "SUORINAME")
	public String getSuoriname() {
		return this.suoriname;
	}

	public void setSuoriname(String suoriname) {
		this.suoriname = suoriname;
	}

	@Column(name = "REGADDRESS")
	public String getRegaddress() {
		return this.regaddress;
	}

	public void setRegaddress(String regaddress) {
		this.regaddress = regaddress;
	}

	@Column(name = "ADDRESS")
	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@Column(name = "SUORICODE")
	public String getSuoricode() {
		return this.suoricode;
	}

	public void setSuoricode(String suoricode) {
		this.suoricode = suoricode;
	}

	@Column(name = "SHORTNAME")
	public String getShortname() {
		return this.shortname;
	}

	public void setShortname(String shortname) {
		this.shortname = shortname;
	}

	@Column(name = "SALEMETHOD")
	public String getSalemethod() {
		return this.salemethod;
	}

	public void setSalemethod(String salemethod) {
		this.salemethod = salemethod;
	}

	@Column(name = "AREA")
	public String getArea() {
		return this.area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	@Column(name = "COMPANYCODE")
	public String getCompanycode() {
		return this.companycode;
	}

	public void setCompanycode(String companycode) {
		this.companycode = companycode;
	}

	@Column(name = "ZIPCODE")
	public String getZipcode() {
		return this.zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	@Column(name = "INDUSTRY")
	public String getIndustry() {
		return this.industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	@Column(name = "FAX")
	public String getFax() {
		return this.fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	@Column(name = "EMAIL")
	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Column(name = "LICENSECODE")
	public String getLicensecode() {
		return this.licensecode;
	}

	public void setLicensecode(String licensecode) {
		this.licensecode = licensecode;
	}

	@Column(name = "TAXCODE")
	public String getTaxcode() {
		return this.taxcode;
	}

	public void setTaxcode(String taxcode) {
		this.taxcode = taxcode;
	}

	@Column(name = "TAXCATEGORY")
	public String getTaxcategory() {
		return this.taxcategory;
	}

	public void setTaxcategory(String taxcategory) {
		this.taxcategory = taxcategory;
	}

	@Column(name = "ORGANIZATIONCODE")
	public String getOrganizationcode() {
		return this.organizationcode;
	}

	public void setOrganizationcode(String organizationcode) {
		this.organizationcode = organizationcode;
	}

	@Column(name = "BANK")
	public String getBank() {
		return this.bank;
	}

	public void setBank(String bank) {
		this.bank = bank;
	}

	@Column(name = "ACCOUNT")
	public String getAccount() {
		return this.account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	@Column(name = "YEARSALE")
	public Double getYearsale() {
		return this.yearsale;
	}

	public void setYearsale(Double yearsale) {
		this.yearsale = yearsale;
	}

	@Column(name = "CAPITAL")
	public Double getCapital() {
		return this.capital;
	}

	public void setCapital(Double capital) {
		this.capital = capital;
	}

	@Column(name = "NATURE")
	public String getNature() {
		return this.nature;
	}

	public void setNature(String nature) {
		this.nature = nature;
	}

	@Column(name = "COMPANYCATEGORY")
	public String getCompanycategory() {
		return this.companycategory;
	}

	public void setCompanycategory(String companycategory) {
		this.companycategory = companycategory;
	}

	@Column(name = "LEGALPERSON")
	public String getLegalperson() {
		return this.legalperson;
	}

	public void setLegalperson(String legalperson) {
		this.legalperson = legalperson;
	}

	@Column(name = "LEGALPERSONID")
	public String getLegalpersonid() {
		return this.legalpersonid;
	}

	public void setLegalpersonid(String legalpersonid) {
		this.legalpersonid = legalpersonid;
	}

	@Column(name = "LEGALPERSONTEL")
	public String getLegalpersontel() {
		return this.legalpersontel;
	}

	public void setLegalpersontel(String legalpersontel) {
		this.legalpersontel = legalpersontel;
	}

	@Column(name = "AGENT")
	public String getAgent() {
		return this.agent;
	}

	public void setAgent(String agent) {
		this.agent = agent;
	}

	@Column(name = "AGENTID")
	public String getAgentid() {
		return this.agentid;
	}

	public void setAgentid(String agentid) {
		this.agentid = agentid;
	}

	@Column(name = "LINKMAN")
	public String getLinkman() {
		return this.linkman;
	}

	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}

	@Column(name = "LINKMANOFFICE")
	public String getLinkmanoffice() {
		return this.linkmanoffice;
	}

	public void setLinkmanoffice(String linkmanoffice) {
		this.linkmanoffice = linkmanoffice;
	}

	@Column(name = "LINKMANTEL")
	public String getLinkmantel() {
		return this.linkmantel;
	}

	public void setLinkmantel(String linkmantel) {
		this.linkmantel = linkmantel;
	}

	@Column(name = "SALEAREA")
	public String getSalearea() {
		return this.salearea;
	}

	public void setSalearea(String salearea) {
		this.salearea = salearea;
	}

	@Column(name = "SATAFFCOUNT")
	public Double getSataffcount() {
		return this.sataffcount;
	}

	public void setSataffcount(Double sataffcount) {
		this.sataffcount = sataffcount;
	}

	@Column(name = "WEB", length = 30)
	public String getWeb() {
		return this.web;
	}

	public void setWeb(String web) {
		this.web = web;
	}

	@Column(name = "SALEAREA2")
	public Double getSalearea2() {
		return this.salearea2;
	}

	public void setSalearea2(Double salearea2) {
		this.salearea2 = salearea2;
	}

	@Column(name = "REGION")
	public String getRegion() {
		return this.region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	@Column(name = "SALEFILE")
	public String getSalefile() {
		return this.salefile;
	}

	public void setSalefile(String salefile) {
		this.salefile = salefile;
	}

	@Column(name = "SALEFILEMEMO")
	public String getSalefilememo() {
		return this.salefilememo;
	}

	public void setSalefilememo(String salefilememo) {
		this.salefilememo = salefilememo;
	}

	@Column(name = "MEMO")
	public String getMemo() {
		return this.memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	@Column(name = "LOGO")
	public String getLogo() {
		return this.logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}

	@Column(name = "MOBILE")
	public String getMobile() {
		return this.mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	@Column(name = "TAXRATE")
	public Double getTaxrate() {
		return this.taxrate;
	}

	public void setTaxrate(Double taxrate) {
		this.taxrate = taxrate;
	}

	@Column(name = "COMPANYDESCRIB")
	public String getCompanydescrib() {
		return this.companydescrib;
	}

	public void setCompanydescrib(String companydescrib) {
		this.companydescrib = companydescrib;
	}

	@Column(name = "SIGNNAME")
	public String getSignname() {
		return this.signname;
	}

	public void setSignname(String signname) {
		this.signname = signname;
	}

	@Column(name = "PAYMONEY")
	public Double getPaymoney() {
		return this.paymoney;
	}

	public void setPaymoney(Double paymoney) {
		this.paymoney = paymoney;
	}

	@Column(name = "REALPAYMONEY")
	public Double getRealpaymoney() {
		return this.realpaymoney;
	}

	public void setRealpaymoney(Double realpaymoney) {
		this.realpaymoney = realpaymoney;
	}

	@Column(name = "CONTRACTTIME")
	public String getContracttime() {
		return this.contracttime;
	}

	public void setContracttime(String contracttime) {
		this.contracttime = contracttime;
	}

	@Column(name = "VIDEOFILEPATH")
	public String getVideofilepath() {
		return this.videofilepath;
	}

	public void setVideofilepath(String videofilepath) {
		this.videofilepath = videofilepath;
	}

	@Column(name = "VIDEOLABEL")
	public String getVideolabel() {
		return this.videolabel;
	}

	public void setVideolabel(String videolabel) {
		this.videolabel = videolabel;
	}

	@Column(name = "VIDEOTITLE")
	public String getVideotitle() {
		return this.videotitle;
	}

	public void setVideotitle(String videotitle) {
		this.videotitle = videotitle;
	}

	@Column(name = "AGENTTEL")
	public String getAgenttel() {
		return this.agenttel;
	}

	public void setAgenttel(String agenttel) {
		this.agenttel = agenttel;
	}

	@Column(name = "STAFFCOUNT")
	public Double getStaffcount() {
		return this.staffcount;
	}

	public void setStaffcount(Double staffcount) {
		this.staffcount = staffcount;
	}

	@Column(name = "TAXAREA")
	public String getTaxarea() {
		return this.taxarea;
	}

	public void setTaxarea(String taxarea) {
		this.taxarea = taxarea;
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

	@Transient
	public String getRemoteIP() {
		return remoteIP;
	}

	public void setRemoteIP(String remoteIP) {
		this.remoteIP = remoteIP;
	}

	@Transient
	public String getEditFlag() {
		return editFlag;
	}

	public void setEditFlag(String editFlag) {
		this.editFlag = editFlag;
	}

	@Transient
	public List getRoles() {
		return roles;
	}

	public void setRoles(List roles) {
		this.roles = roles;
	}
	
	

}