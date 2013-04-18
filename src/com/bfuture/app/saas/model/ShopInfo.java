package com.bfuture.app.saas.model;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * [SHOPINFO] 门店信息表
 * @author chenjw
 *
 */
@Entity
@Table(name = "SHOPINFO")
public class ShopInfo extends BaseObject implements java.io.Serializable {

	private ShopInfoId id; 		// 实例编码(sisgcode) 门店编号(shopcode)
	private String shopname; 	// 门店简称
	private String shopallname; // 门店全称【备用】
	private String shopadd; 	// 地址
	private String shopcont; 	// 联系人
	private String shoptel; 	// 电话（座机）
	private String contphone; 	// 移动电话【备用】
	private String shopfax;  	// 传真
	private String shopmail;  	// 邮箱
	private String remarks; 	// 备注
	private String picurl; 		// 图片url
	private String temp1;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;
	
	// 辅助
	private String sisgcode;	// 实例编码
	private String shopcode; 	// 门店编号
	private String shopid;		// 用于页面列表显示
	
	public ShopInfo(){
		
	}
	
	public ShopInfo(ShopInfoId id){
		this.id = id;
	}
	
	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "sisgcode", column = @Column(name = "SISGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "shopcode", column = @Column(name = "SHOPCODE", nullable = false, length = 30)) })
	public ShopInfoId getId() {
		return id;
	}


	public void setId(ShopInfoId id) {
		this.id = id;
	}

	@Column(name = "SHOPNAME", length = 30)
	public String getShopname() {
		return shopname;
	}

	public void setShopname(String shopname) {
		this.shopname = shopname;
	}

	@Column(name = "SHOPALLNAME", length = 300)
	public String getShopallname() {
		return shopallname;
	}

	public void setShopallname(String shopallname) {
		this.shopallname = shopallname;
	}

	@Column(name = "SHOPADD", length = 300)
	public String getShopadd() {
		return shopadd;
	}

	public void setShopadd(String shopadd) {
		this.shopadd = shopadd;
	}

	@Column(name = "SHOPCONT", length = 30)
	public String getShopcont() {
		return shopcont;
	}

	public void setShopcont(String shopcont) {
		this.shopcont = shopcont;
	}

	@Column(name = "SHOPTEL", length = 30)
	public String getShoptel() {
		return shoptel;
	}

	public void setShoptel(String shoptel) {
		this.shoptel = shoptel;
	}

	@Column(name = "CONTPHONE", length = 30)
	public String getContphone() {
		return contphone;
	}

	public void setContphone(String contphone) {
		this.contphone = contphone;
	}

	@Column(name = "SHOPFAX", length = 30)
	public String getShopfax() {
		return shopfax;
	}

	public void setShopfax(String shopfax) {
		this.shopfax = shopfax;
	}

	@Column(name = "SHOPMAIL", length = 30)
	public String getShopmail() {
		return shopmail;
	}

	public void setShopmail(String shopmail) {
		this.shopmail = shopmail;
	}

	@Column(name = "REMARKS", length = 300)
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	@Column(name = "PICURL", length = 300)
	public String getPicurl() {
		return picurl;
	}

	public void setPicurl(String picurl) {
		this.picurl = picurl;
	}

	@Column(name = "TEMP1", length = 100)
	public String getTemp1() {
		return temp1;
	}

	public void setTemp1(String temp1) {
		this.temp1 = temp1;
	}

	@Column(name = "TEMP2", length = 100)
	public String getTemp2() {
		return temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	@Column(name = "TEMP3", length = 100)
	public String getTemp3() {
		return temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	@Column(name = "TEMP4", length = 100)
	public String getTemp4() {
		return temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	@Column(name = "TEMP5", length = 100)
	public String getTemp5() {
		return temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}
	
	// 辅助get set 开始
	@Transient
	public String getSisgcode() {
		return sisgcode;
	}

	public void setSisgcode(String sisgcode) {
		this.sisgcode = sisgcode;
	}

	@Transient
	public String getShopcode() {
		return shopcode;
	}

	public void setShopcode(String shopcode) {
		this.shopcode = shopcode;
	}
	
	@Transient
	public String getShopid() {
		return this.id.getShopcode();
	}

	public void setShopid(String shopid) {
		this.shopid = shopid;
	}
	// 辅助get set 结束

	@Override
	public boolean equals(Object o) {
		return false;
	}

	@Override
	public int hashCode() {
		return 0;
	}

	@Override
	public String toString() {
		return null;
	}

	
}
