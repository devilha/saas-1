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
 * 供应商证件(INF_LICENCE)
 * @author chenjw
 * 2012-01-30
 */
@Entity
@Table(name = "INF_LICENCE")
public class InfLicence extends BaseObject implements java.io.Serializable{

	private static final long serialVersionUID = 6148120709844221950L;
	private Integer id;			//	ID
	private String ins_c;		//	实例编码
	private String licence_name;	// 证件名称
	private String memo;		//	证件备注
	private Date deadline;		//	有效时间
	private String supid;		//	供应商编码
	private String supname;		//	供应商名称
	private String crt_by_c;	// 上传人
	private Date crt_by_time;	// 上传时间
	private String status;		// 状态
	private String refuse_memo;	// 驳回原因
	private String opt_by_c;	// 审核人
	private Date opt_by_time;	// 审核时间
	private String url;			// 下载地址
	private String view_status; //记录查看状态
	
	//查询字段
	private String gdbarcode;
	
	// 辅助字段
	private String deadline_temp; 	// 从页面获取添加操作的有效时间值
	private String starttime_temp; 	// 从页面获取查询操作的开始时间值
	private String endtime_temp;	// 从页面获取查询操作的结束时间值
	
	public InfLicence(){
		
	}
	
	public InfLicence(Integer id){
		this.id = id;
	}
	
//	@Id
//	@Column(name = "ID", unique = true, nullable = false)
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "INF_LICENCE")
	@SequenceGenerator(name = "INF_LICENCE", sequenceName = "SEQ_INF_LICENCE", allocationSize = 1)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "INS_C", length = 30)
	public String getIns_c() {
		return ins_c;
	}
	public void setIns_c(String ins_c) {
		this.ins_c = ins_c;
	}
	@Column(name = "LICENCE_NAME", length = 300)
	public String getLicence_name() {
		return licence_name;
	}
	public void setLicence_name(String licence_name) {
		this.licence_name = licence_name;
	}
	@Column(name = "MEMO", length = 300)
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "DEADLINE", nullable = false, length = 26)
	public Date getDeadline() {
		return deadline;
	}
	public void setDeadline(Date deadline) {
		this.deadline = deadline;
	}
	@Column(name = "SUPID", length = 30)
	public String getSupid() {
		return supid;
	}
	public void setSupid(String supid) {
		this.supid = supid;
	}
	@Column(name = "SUPNAME", length = 300)
	public String getSupname() {
		return supname;
	}
	public void setSupname(String supname) {
		this.supname = supname;
	}
	@Column(name = "CRT_BY_C", length = 30)
	public String getCrt_by_c() {
		return crt_by_c;
	}
	public void setCrt_by_c(String crt_by_c) {
		this.crt_by_c = crt_by_c;
	}
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CRT_BY_TIME", nullable = false, length = 26)
	public Date getCrt_by_time() {
		return crt_by_time;
	}
	public void setCrt_by_time(Date crt_by_time) {
		this.crt_by_time = crt_by_time;
	}
	@Column(name = "STATUS", length = 2)
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@Column(name = "REFUSE_MEMO", length = 300)
	public String getRefuse_memo() {
		return refuse_memo;
	}
	public void setRefuse_memo(String refuse_memo) {
		this.refuse_memo = refuse_memo;
	}
	@Column(name = "OPT_BY_C", length = 30)
	public String getOpt_by_c() {
		return opt_by_c;
	}
	public void setOpt_by_c(String opt_by_c) {
		this.opt_by_c = opt_by_c;
	}
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "OPT_BY_TIME", nullable = true, length = 26)
	public Date getOpt_by_time() {
		return opt_by_time;
	}
	public void setOpt_by_time(Date opt_by_time) {
		this.opt_by_time = opt_by_time;
	}
	@Column(name = "URL", length = 200)
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	@Column(name = "VIEW_STATUS", length = 20)
	public String getView_status() {
		return view_status;
	}

	public void setView_status(String view_status) {
		this.view_status = view_status;
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

	// 辅助字段get set 开始
	@Transient
	public String getDeadline_temp() {
		return deadline_temp;
	}

	public void setDeadline_temp(String deadline_temp) {
		this.deadline_temp = deadline_temp;
	}
	
	@Transient
	public String getStarttime_temp() {
		return starttime_temp;
	}

	public void setStarttime_temp(String starttime_temp) {
		this.starttime_temp = starttime_temp;
	}

	@Transient
	public String getEndtime_temp() {
		return endtime_temp;
	}

	public void setEndtime_temp(String endtime_temp) {
		this.endtime_temp = endtime_temp;
	}
	// 辅助字段get set 结束

	@Transient
	public String getGdbarcode() {
		return gdbarcode;
	}

	public void setGdbarcode(String gdbarcode) {
		this.gdbarcode = gdbarcode;
	}
	
	
}
