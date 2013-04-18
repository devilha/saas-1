package com.bfuture.app.saas.model;

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
 * 短信定制(SMS_CUSTOM)
 * @author chenjw
 * 2012-02-15
 */
@Entity
@Table(name = "SMS_CUSTOM")
public class SmsCustom extends BaseObject implements java.io.Serializable{
	
	private static final long serialVersionUID = 6148120709809021986L;
	
	private Integer id; 		//主键 
	private String shopid; 		//门店编码 
	private String shopname; 	//门店名称 
	private String customtype; 	//短信类型 （1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
	private String mobile; 		//手机号码 
	private String lsrname; 	//联系人 
	private String states; 		//状态 （1.未开通 2.有效 3.过期）[数据中的数据暂时未使用]
	private Date customdate; 	//定制使用时间(有效截止时间) 
	private String crecode; 	//创建者编码(登录编号)
	private String crename; 	//创建者名称
	private Date credate; 		//创建时间
	private String sgcode;		//实例编码
	private String supcode;		//供应商编码
	
	// 辅助字段
	private String temp_customdate; 	//有效截止时间
	
	public SmsCustom(){
		
	}
	
	public SmsCustom(Integer id){
		this.id = id;
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SMS_CUSTOM")
	@SequenceGenerator(name = "SMS_CUSTOM", sequenceName = "SEQ_SMS_CUSTOM", allocationSize = 1)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "SHOPID", length = 30)
	public String getShopid() {
		return shopid;
	}

	public void setShopid(String shopid) {
		this.shopid = shopid;
	}

	@Column(name = "SHOPNAME", length = 100)
	public String getShopname() {
		return shopname;
	}

	public void setShopname(String shopname) {
		this.shopname = shopname;
	}

	@Column(name = "CUSTOMTYPE", length = 20)
	public String getCustomtype() {
		return customtype;
	}

	public void setCustomtype(String customtype) {
		this.customtype = customtype;
	}

	@Column(name = "MOBILE", length = 30)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	@Column(name = "LSRNAME", length = 30)
	public String getLsrname() {
		return lsrname;
	}

	public void setLsrname(String lsrname) {
		this.lsrname = lsrname;
	}

	@Column(name = "STATES", length = 20)
	public String getStates() {
		return states;
	}

	public void setStates(String states) {
		this.states = states;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CUSTOMDATE", nullable = true, length = 26)
	public Date getCustomdate() {
		return customdate;
	}

	public void setCustomdate(Date customdate) {
		this.customdate = customdate;
	}

	@Column(name = "CRECODE", length = 30)
	public String getCrecode() {
		return crecode;
	}

	public void setCrecode(String crecode) {
		this.crecode = crecode;
	}

	@Column(name = "CRENAME", length = 100)
	public String getCrename() {
		return crename;
	}

	public void setCrename(String crename) {
		this.crename = crename;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREDATE", nullable = false, length = 26)
	public Date getCredate() {
		return credate;
	}

	public void setCredate(Date credate) {
		this.credate = credate;
	}
	
	@Column(name = "SGCODE", length = 20)
	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}
	
	@Column(name = "supcode", length = 30)
	public String getSupcode() {
		return supcode;
	}

	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}
	
	// 辅助字段get set 开始
	@Transient
	public String getTemp_customdate() {
		return temp_customdate;
	}

	public void setTemp_customdate(String temp_customdate) {
		this.temp_customdate = temp_customdate;
	}
	// 辅助字段get set 结束

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
