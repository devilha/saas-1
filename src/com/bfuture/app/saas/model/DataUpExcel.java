package com.bfuture.app.saas.model;

import com.bfuture.app.basic.model.BaseObject;
import com.bfuture.util.ini.IniSection;

public class DataUpExcel extends BaseObject implements java.io.Serializable {
	
	private String sgcode;
	private IniSection iniSection;
	private String importFilePath;

	public IniSection getIniSection() {
		return iniSection;
	}

	public void setIniSection(IniSection iniSection) {
		this.iniSection = iniSection;
	}

	public String getImportFilePath() {
		return importFilePath;
	}

	public void setImportFilePath(String importFilePath) {
		this.importFilePath = importFilePath;
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

}
