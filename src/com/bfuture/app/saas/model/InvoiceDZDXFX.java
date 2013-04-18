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

@Entity
@Table(name = "INVOICE_DZD_XFX")

public class InvoiceDZDXFX extends BaseObject implements java.io.Serializable {

	private static final long serialVersionUID = 4366519375995098139L;

	private Integer id;           	//ID
	private String sgcode;			//实例编码
	private String invoiceno;		//发票号码
	private String balanceno;		//结算单号
	private String venderid;		//供应商编码
	private BigDecimal payamt;			//发票金额
	private BigDecimal paynetamt;		//不含税金额
	private BigDecimal paytaxamt;		//税金
	private String invoicetype;		//发票类型
	private Date   invoicedate;		//发票日期
	private String goodsname;		//货物名称
	private Character flag;			//审核标志
	private Date inputdate;			//录入日期
	private String auditor;			//审核人
	private Date shrq;				//审核日期
	private String temp1;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;
	
	//扩充字段
	private String startDate;
	private String endDate;

	public InvoiceDZDXFX() {
	}

	public InvoiceDZDXFX(Integer id, String sgcode) {
		this.id = id;
		this.sgcode = sgcode;
	}

	public InvoiceDZDXFX(Integer id, String sgcode, String invoiceno,
			String balanceno) {
		this.id = id;
		this.sgcode = sgcode;
		this.invoiceno = invoiceno;
		this.balanceno = balanceno;
	}

	@Id
	@SequenceGenerator(name="INV",sequenceName="SEO_INVOICE_DZD_XFX",allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="INV")
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "SGCODE", length = 6)
	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}
	@Column(name = "INVOICENO", length = 16)
	public String getInvoiceno() {
		return invoiceno;
	}

	public void setInvoiceno(String invoiceno) {
		this.invoiceno = invoiceno;
	}
	@Column(name = "BALANCENO", length = 16)
	public String getBalanceno() {
		return balanceno;
	}

	public void setBalanceno(String balanceno) {
		this.balanceno = balanceno;
	}
	@Column(name = "VENDERID", length = 30)
	public String getVenderid() {
		return venderid;
	}

	public void setVenderid(String venderid) {
		this.venderid = venderid;
	}
	@Column(name = "PAYAMT", precision = 16)
	public BigDecimal getPayamt() {
		return payamt;
	}

	public void setPayamt(BigDecimal payamt) {
		this.payamt = payamt;
	}
	@Column(name = "PAYNETAMT", precision = 16)
	public BigDecimal getPaynetamt() {
		return paynetamt;
	}

	public void setPaynetamt(BigDecimal paynetamt) {
		this.paynetamt = paynetamt;
	}
	@Column(name = "PAYTAXAMT", precision = 16)
	public BigDecimal getPaytaxamt() {
		return paytaxamt;
	}

	public void setPaytaxamt(BigDecimal paytaxamt) {
		this.paytaxamt = paytaxamt;
	}
	@Column(name = "INVOICETYPE", length = 30)
	public String getInvoicetype() {
		return invoicetype;
	}

	public void setInvoicetype(String invoicetype) {
		this.invoicetype = invoicetype;
	}
	@Temporal(TemporalType.DATE)
	@Column(name = "INVOICEDATE", length = 7)
	public Date getInvoicedate() {
		return invoicedate;
	}

	public void setInvoicedate(Date invoicedate) {
		this.invoicedate = invoicedate;
	}
	@Column(name = "GOODSNAME", length = 30)
	public String getGoodsname() {
		return goodsname;
	}

	public void setGoodsname(String goodsname) {
		this.goodsname = goodsname;
	}
	@Column(name = "FLAG", length = 1)
	public Character getFlag() {
		return flag;
	}

	public void setFlag(Character flag) {
		this.flag = flag;
	}

	public Date getInputdate() {
		return inputdate;
	}
	@Temporal(TemporalType.DATE)
	@Column(name = "INPUTDATE", length = 7)
	public void setInputdate(Date inputdate) {
		this.inputdate = inputdate;
	}
	@Column(name = "AUDITOR", length = 16)
	public String getAuditor() {
		return auditor;
	}

	public void setAuditor(String auditor) {
		this.auditor = auditor;
	}
	@Temporal(TemporalType.DATE)
	@Column(name = "SHRQ", length = 7)
	public Date getShrq() {
		return shrq;
	}

	public void setShrq(Date shrq) {
		this.shrq = shrq;
	}
	@Column(name = "TEMP1", length = 16)
	public String getTemp1() {
		return temp1;
	}

	public void setTemp1(String temp1) {
		this.temp1 = temp1;
	}
	@Column(name = "TEMP2", length = 16)
	public String getTemp2() {
		return temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}
	@Column(name = "TEMP3", length = 16)
	public String getTemp3() {
		return temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}
	@Column(name = "TEMP4", length = 16)
	public String getTemp4() {
		return temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}
	@Column(name = "TEMP5", length = 16)
	public String getTemp5() {
		return temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}
	
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
