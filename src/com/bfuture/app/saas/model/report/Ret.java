package com.bfuture.app.saas.model.report;

import java.io.Serializable;
import java.util.Date;

import com.bfuture.app.basic.model.BaseObject;

public class Ret extends BaseObject implements Serializable{

	private String sgcode;
	private String sheetid;
	private String refsheetid;
	private String shopid;
	private int venderid;
	private Date retdate;
	private Double paymoney;
	private Double kxsummoney;
	private int acceptflag;
	private int badflag;
	private String notes;
	private int flag;
	private String editor;
	private Date editdate;
	private String operator;
	private String checker;
	private Date checkdate;
	private int manageedeptid;
	private int printcount;
	private String finchecker;
	private int emailflag;
	private int cprintcount;
	private String startDate;
	private String endDate;
	private String supid;
	
	public String getSupid() {
		return supid;
	}

	public void setSupid(String supid) {
		this.supid = supid;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

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

	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	public String getSheetid() {
		return sheetid;
	}

	public void setSheetid(String sheetid) {
		this.sheetid = sheetid;
	}

	public String getRefsheetid() {
		return refsheetid;
	}

	public void setRefsheetid(String refsheetid) {
		this.refsheetid = refsheetid;
	}

	public String getShopid() {
		return shopid;
	}

	public void setShopid(String shopid) {
		this.shopid = shopid;
	}

	public int getVenderid() {
		return venderid;
	}

	public void setVenderid(int venderid) {
		this.venderid = venderid;
	}

	public Date getRetdate() {
		return retdate;
	}

	public void setRetdate(Date retdate) {
		this.retdate = retdate;
	}

	public Double getPaymoney() {
		return paymoney;
	}

	public void setPaymoney(Double paymoney) {
		this.paymoney = paymoney;
	}

	public Double getKxsummoney() {
		return kxsummoney;
	}

	public void setKxsummoney(Double kxsummoney) {
		this.kxsummoney = kxsummoney;
	}

	public int getAcceptflag() {
		return acceptflag;
	}

	public void setAcceptflag(int acceptflag) {
		this.acceptflag = acceptflag;
	}

	public int getBadflag() {
		return badflag;
	}

	public void setBadflag(int badflag) {
		this.badflag = badflag;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public int getFlag() {
		return flag;
	}

	public void setFlag(int flag) {
		this.flag = flag;
	}

	public String getEditor() {
		return editor;
	}

	public void setEditor(String editor) {
		this.editor = editor;
	}

	public Date getEditdate() {
		return editdate;
	}

	public void setEditdate(Date editdate) {
		this.editdate = editdate;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getChecker() {
		return checker;
	}

	public void setChecker(String checker) {
		this.checker = checker;
	}

	public Date getCheckdate() {
		return checkdate;
	}

	public void setCheckdate(Date checkdate) {
		this.checkdate = checkdate;
	}

	public int getManageedeptid() {
		return manageedeptid;
	}

	public void setManageedeptid(int manageedeptid) {
		this.manageedeptid = manageedeptid;
	}

	public int getPrintcount() {
		return printcount;
	}

	public void setPrintcount(int printcount) {
		this.printcount = printcount;
	}

	public String getFinchecker() {
		return finchecker;
	}

	public void setFinchecker(String finchecker) {
		this.finchecker = finchecker;
	}

	public int getEmailflag() {
		return emailflag;
	}

	public void setEmailflag(int emailflag) {
		this.emailflag = emailflag;
	}

	public int getCprintcount() {
		return cprintcount;
	}

	public void setCprintcount(int cprintcount) {
		this.cprintcount = cprintcount;
	}

}
