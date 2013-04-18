package com.bfuture.app.saas.model;

import javax.persistence.Column;

import com.bfuture.app.basic.model.BaseObject;

public class ShopInfoId extends BaseObject implements java.io.Serializable{

	private String sisgcode;	// 实例编码
	private String shopcode; 	// 门店编号
	
	public ShopInfoId(){
		
	}
	
	public ShopInfoId(String sisgcode,String shopcode){
		this.sisgcode = sisgcode;
		this.shopcode = shopcode;
	}
	
	@Column(name = "SISGCODE", nullable = false, length = 30)
	public String getSisgcode() {
		return sisgcode;
	}

	public void setSisgcode(String sisgcode) {
		this.sisgcode = sisgcode;
	}

	@Column(name = "SHOPCODE", nullable = false, length = 30)
	public String getShopcode() {
		return shopcode;
	}

	public void setShopcode(String shopcode) {
		this.shopcode = shopcode;
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
