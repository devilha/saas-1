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

import com.bfuture.app.basic.model.BaseObject;

/**
 * 短信发送(SMS_CUSTOM)
 * @author chenjw
 * 2012-02-20
 */
@Entity
@Table(name = "SMS_SEND")
public class SmsSend extends BaseObject implements java.io.Serializable{
	
	private static final long serialVersionUID = 6148120709021986666L;
	
	private Integer id;			//主键[*]
	private String sgcode;		//实例编码[*]
	private Integer customid;	//外键（定制表id）
	private String lsrname;		//联系人
	private String mobile;		//手机号[*]
	private String sendcontent;	//内容[*]
	private String sender;		//发送者[*]
	private Date sendtime;		//发送时间[*]
	private Integer sendtype;	//发送类型（1 自主  2 系统 ）[*]
	private Integer messagetype;//信息类型（1.定制销售日/月报 2.定制销售排行 3.定制销售占比 4.定制采购订单 5.定制昨日库存）
	private String shopid;		//门店编号  
	private String shopname;	//门店名称
	private Integer sendstates;	//发送状态  （0 未发送  1 已发送  2 欠费  3 系统故障）[*]
	private String createcode;	//创建者编码
	private String createname;	//创建者名称
	private Date createdate;	//创建时间
	
	public SmsSend(){
		
	}
	
	public SmsSend(Integer id){
		this.id = id;
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SMS_SEND")
	@SequenceGenerator(name = "SMS_SEND", sequenceName = "SEQ_SMS_SEND", allocationSize = 1)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "SGCODE", length = 20)
	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	@Column(name = "CUSTOMID", length = 11)
	public Integer getCustomid() {
		return customid;
	}

	public void setCustomid(Integer customid) {
		this.customid = customid;
	}

	@Column(name = "LSRNAME", length = 30)
	public String getLsrname() {
		return lsrname;
	}

	public void setLsrname(String lsrname) {
		this.lsrname = lsrname;
	}

	@Column(name = "MOBILE", length = 30)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	@Column(name = "SENDCONTENT", length = 1000)
	public String getSendcontent() {
		return sendcontent;
	}

	public void setSendcontent(String sendcontent) {
		this.sendcontent = sendcontent;
	}

	@Column(name = "SENDER", length = 100)
	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "SENDTIME", nullable = true, length = 26)
	public Date getSendtime() {
		return sendtime;
	}

	public void setSendtime(Date sendtime) {
		this.sendtime = sendtime;
	}

	@Column(name = "SENDTYPE", length = 11)
	public Integer getSendtype() {
		return sendtype;
	}

	public void setSendtype(Integer sendtype) {
		this.sendtype = sendtype;
	}

	@Column(name = "MESSAGETYPE", length = 11)
	public Integer getMessagetype() {
		return messagetype;
	}

	public void setMessagetype(Integer messagetype) {
		this.messagetype = messagetype;
	}

	@Column(name = "SHOPID", length = 20)
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

	@Column(name = "SENDSTATES", length = 11)
	public Integer getSendstates() {
		return sendstates;
	}

	public void setSendstates(Integer sendstates) {
		this.sendstates = sendstates;
	}

	@Column(name = "CREATECODE", length = 30)
	public String getCreatecode() {
		return createcode;
	}

	public void setCreatecode(String createcode) {
		this.createcode = createcode;
	}

	@Column(name = "CREATENAME", length = 100)
	public String getCreatename() {
		return createname;
	}

	public void setCreatename(String createname) {
		this.createname = createname;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATEDATE", nullable = true, length = 26)
	public Date getCreatedate() {
		return createdate;
	}

	public void setCreatedate(Date createdate) {
		this.createdate = createdate;
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
