package com.bfuture.app.saas.model.report;

import com.bfuture.app.basic.model.BaseObject;

public class Stock extends BaseObject implements java.io.Serializable{
	
	private String sgcode;
	private String supcode;
	private String zsmfid;
	private String zsgdid;
	private String zsgdname;
	private String zsgcid;
	private String zsgcname;
	private String gdcatid;
	private String gdcatname;
	private String gdbarcode;
	
	
	public String getGdcatid() {
		return gdcatid;
	}
	public void setGdcatid(String gdcatid) {
		this.gdcatid = gdcatid;
	}
	public String getGdcatname() {
		return gdcatname;
	}
	public void setGdcatname(String gdcatname) {
		this.gdcatname = gdcatname;
	}
	public String getSgcode() {
		return sgcode;
	}
	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}	
	public String getSupcode() {
		return supcode;
	}
	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}
	public String getZsmfid() {
		return zsmfid;
	}
	public void setZsmfid(String zsmfid) {
		this.zsmfid = zsmfid;
	}
	public String getZsgdid() {
		return zsgdid;
	}
	public void setZsgdid(String zsgdid) {
		this.zsgdid = zsgdid;
	}
	public String getZsgdname() {
		return zsgdname;
	}
	public void setZsgdname(String zsgdname) {
		this.zsgdname = zsgdname;
	}
	public String getZsgcid() {
		return zsgcid;
	}
	public void setZsgcid(String zsgcid) {
		this.zsgcid = zsgcid;
	}
	public String getZsgcname() {
		return zsgcname;
	}
	public void setZsgcname(String zsgcname) {
		this.zsgcname = zsgcname;
	}
	
	@Override
	public boolean equals(Object o) {
		return this.equals(((Stock)o));
	}

	@Override
	public int hashCode() {
		return this.hashCode();
	}

	@Override
	public String toString() {
		return null;
	}
	public String getGdbarcode() {
		return gdbarcode;
	}
	public void setGdbarcode(String gdbarcode) {
		this.gdbarcode = gdbarcode;
	}

}
