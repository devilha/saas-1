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
 * 用户短信账户(SMS_Account)
 * @author chenjw
 * 2012-02-20
 */
@Entity
@Table(name = "SMS_ACCOUNT")
public class SmsAccount extends BaseObject implements java.io.Serializable{
	
	private static final long serialVersionUID = 6148120709021986666L;
	
	private Integer id;			//主键
	private String sgcode;		//实例编码
	private String sucode;	//用户名
	private Integer count;		//已发送条数
	private BigDecimal unit;	//元/每条
	private BigDecimal total;	//总充值额（充值额累加）  
	private BigDecimal balance;	//余额（总充值额-总发送费用）
	private Date lasttime;		//充值时间（最近一次）
	private BigDecimal lastamount;	//充值额（最近一次）
	
	//扩充字段 
	private Integer sumcount;

	
	public SmsAccount(){
		
	}
	
	public SmsAccount(Integer id){
		this.id = id;
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SMS_ACCOUNT")
	@SequenceGenerator(name = "SMS_ACCOUNT", sequenceName = "SEQ_SMS_ACCOUNT", allocationSize = 1)
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

	@Column(name = "SUCODE", length = 11)
	public String getSucode() {
		return sucode;
	}

	public void setSucode(String sucode) {
		this.sucode = sucode;
	}
	@Column(name = "UNIT", precision = 16)
	public BigDecimal getUnit() {
		return unit;
	}

	public void setUnit(BigDecimal unit) {
		this.unit = unit;
	}
	
	
	@Column(name = "COUNT", length = 11)
	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	@Column(name = "TOTAL", precision = 16)
	public BigDecimal getTotal() {
		return total;
	}

	public void setTotal(BigDecimal total) {
		this.total = total;
	}
	@Column(name = "BALANCE", precision = 16)
	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	@Temporal(TemporalType.DATE)
	@Column(name = "LASTTIME", length = 7)
	public Date getLasttime() {
		return lasttime;
	}

	public void setLasttime(Date lasttime) {
		this.lasttime = lasttime;
	}
	@Column(name = "LASTAMOUNT", precision = 16)
	public BigDecimal getLastamount() {
		return lastamount;
	}

	public void setLastamount(BigDecimal lastamount) {
		this.lastamount = lastamount;
	}
	
	
	
	@Transient
	public Integer getSumcount() {
		return sumcount;
	}

	public void setSumcount(Integer sumcount) {
		this.sumcount = sumcount;
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
