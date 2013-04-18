package com.bfuture.app.saas.model.report;

import java.util.Date;

import com.bfuture.app.basic.model.BaseObject;

public class YwPopinfoForm extends BaseObject implements java.io.Serializable {
	
	//-----------------------------
	private String id;
	private String supname;// 供应商名称
	private String shpname;// 门店名称
	//-----------------------------
	private String ppsgcode;// 实例编码
	private String popsequece;// 序号
	private String pplb;// 促销类别
	private String ppgdid;// 商品编码
	private String ppsupid;// 供应商编码
	private String ppmarket;// 门店代码
	private String ppbjrq;// 变价日期
	private String pphfyj;// 回复意见
	private String ppcgyj;// 采购意见
	private String ppgdbarcode;// 商品条码
	private String ppgdname;// 商品名称
	private String ppksrq;// 开始日期
	private String ppjsrq;// 结束日期
	private String ppkssj;// 开始时间
	private String ppjssj;// 结束时间
	private Double ppcxsj;// 促销售价
	private Double ppcxxl;// 促销限量
	private Double ppkl;// 促销扣率
	private Double ppzkfd;// 供应商折扣分担
	private Double ppgdyj;// 原价
	private String ppcxzt;// 促销主题
	private Date ppgxtime;// 创建日期
	private String ppfile;// 导入文件名
	private String ppbjyy;// 变价原因
	private String ppviewstatus;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;

	// 查询条件
	private String startDate;
	private String endDate;

	public YwPopinfoForm() {
	}

	public YwPopinfoForm(String ppsgcode, String popsequece, String pplb, String ppgdid, String ppsupid, String ppmarket, String ppbjrq, String pphfyj, String ppcgyj, String ppgdbarcode, String ppgdname, String ppksrq, String ppjsrq, String ppkssj, String ppjssj, Double ppcxsj, Double ppcxxl, Double ppkl, Double ppzkfd, Double ppgdyj, String ppcxzt, Date ppgxtime, String ppfile, String ppbjyy) {
		this.ppsgcode = ppsgcode;
		this.popsequece = popsequece;
		this.pplb = pplb;
		this.ppgdid = ppgdid;
		this.ppsupid = ppsupid;
		this.ppmarket = ppmarket;
		this.ppbjrq = ppbjrq;
		this.pphfyj = pphfyj;
		this.ppcgyj = ppcgyj;
		this.ppgdbarcode = ppgdbarcode;
		this.ppgdname = ppgdname;
		this.ppksrq = ppksrq;
		this.ppjsrq = ppjsrq;
		this.ppkssj = ppkssj;
		this.ppjssj = ppjssj;
		this.ppcxsj = ppcxsj;
		this.ppcxxl = ppcxxl;
		this.ppkl = ppkl;
		this.ppzkfd = ppzkfd;
		this.ppgdyj = ppgdyj;
		this.ppcxzt = ppcxzt;
		this.ppgxtime = ppgxtime;
		this.ppfile = ppfile;
		this.ppbjyy = ppbjyy;
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

	public String getPpsgcode() {
		return ppsgcode;
	}

	public void setPpsgcode(String ppsgcode) {
		this.ppsgcode = ppsgcode;
	}

	public String getPopsequece() {
		return popsequece;
	}

	public void setPopsequece(String popsequece) {
		this.popsequece = popsequece;
	}

	public String getPplb() {
		return pplb;
	}

	public void setPplb(String pplb) {
		this.pplb = pplb;
	}

	public String getPpgdid() {
		return ppgdid;
	}

	public void setPpgdid(String ppgdid) {
		this.ppgdid = ppgdid;
	}

	public String getPpsupid() {
		return ppsupid;
	}

	public void setPpsupid(String ppsupid) {
		this.ppsupid = ppsupid;
	}

	public String getPpmarket() {
		return ppmarket;
	}

	public void setPpmarket(String ppmarket) {
		this.ppmarket = ppmarket;
	}

	public String getPpbjrq() {
		return ppbjrq;
	}

	public void setPpbjrq(String ppbjrq) {
		this.ppbjrq = ppbjrq;
	}

	public String getPphfyj() {
		return pphfyj;
	}

	public void setPphfyj(String pphfyj) {
		this.pphfyj = pphfyj;
	}

	public String getPpcgyj() {
		return ppcgyj;
	}

	public void setPpcgyj(String ppcgyj) {
		this.ppcgyj = ppcgyj;
	}

	public String getPpgdbarcode() {
		return ppgdbarcode;
	}

	public void setPpgdbarcode(String ppgdbarcode) {
		this.ppgdbarcode = ppgdbarcode;
	}

	public String getPpgdname() {
		return ppgdname;
	}

	public void setPpgdname(String ppgdname) {
		this.ppgdname = ppgdname;
	}

	public String getPpksrq() {
		return ppksrq;
	}

	public void setPpksrq(String ppksrq) {
		this.ppksrq = ppksrq;
	}

	public String getPpjsrq() {
		return ppjsrq;
	}

	public void setPpjsrq(String ppjsrq) {
		this.ppjsrq = ppjsrq;
	}

	public String getPpkssj() {
		return ppkssj;
	}

	public void setPpkssj(String ppkssj) {
		this.ppkssj = ppkssj;
	}

	public String getPpjssj() {
		return ppjssj;
	}

	public void setPpjssj(String ppjssj) {
		this.ppjssj = ppjssj;
	}

	public Double getPpcxsj() {
		return ppcxsj;
	}

	public void setPpcxsj(Double ppcxsj) {
		this.ppcxsj = ppcxsj;
	}

	public Double getPpcxxl() {
		return ppcxxl;
	}

	public void setPpcxxl(Double ppcxxl) {
		this.ppcxxl = ppcxxl;
	}

	public Double getPpkl() {
		return ppkl;
	}

	public void setPpkl(Double ppkl) {
		this.ppkl = ppkl;
	}

	public Double getPpzkfd() {
		return ppzkfd;
	}

	public void setPpzkfd(Double ppzkfd) {
		this.ppzkfd = ppzkfd;
	}

	public Double getPpgdyj() {
		return ppgdyj;
	}

	public void setPpgdyj(Double ppgdyj) {
		this.ppgdyj = ppgdyj;
	}

	public String getPpcxzt() {
		return ppcxzt;
	}

	public void setPpcxzt(String ppcxzt) {
		this.ppcxzt = ppcxzt;
	}

	public Date getPpgxtime() {
		return ppgxtime;
	}

	public void setPpgxtime(Date ppgxtime) {
		this.ppgxtime = ppgxtime;
	}

	public String getPpfile() {
		return ppfile;
	}

	public void setPpfile(String ppfile) {
		this.ppfile = ppfile;
	}

	public String getPpbjyy() {
		return ppbjyy;
	}

	public void setPpbjyy(String ppbjyy) {
		this.ppbjyy = ppbjyy;
	}

	public String getppviewstatus() {
		return ppviewstatus;
	}

	public void setppviewstatus(String ppviewstatus) {
		this.ppviewstatus = ppviewstatus;
	}

	public String getTemp2() {
		return temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	public String getTemp3() {
		return temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	public String getTemp4() {
		return temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	public String getTemp5() {
		return temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSupname() {
		return supname;
	}

	public void setSupname(String supname) {
		this.supname = supname;
	}

	public String getShpname() {
		return shpname;
	}

	public void setShpname(String shpname) {
		this.shpname = shpname;
	}
}
