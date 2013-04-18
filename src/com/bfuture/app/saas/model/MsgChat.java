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
 * 采购洽淡(MSG_CHAT)
 * @author chenjw
 * 2012-01-30
 */
@Entity
@Table(name = "MSG_CHAT")
public class MsgChat extends BaseObject implements java.io.Serializable{

	private static final long serialVersionUID = 6148120709844221986L;
	private Integer id;		// ID 
	private String ins_c;	// 实例编码 
	private String title;	// 标题
	private String content;	// 内容
	private String cat_id;	// 类别编码
	private String cat_name;	// 类别名称
	private String pp_id;	// 品牌编码
	private String pp_name;	// 品牌名称
	private String shop_id;	// 门店编码
	private String shop_name;	// 门店名称
	private String crt_by_c;	// 创建人 
	private String crt_by_cn;	// 创建人名称
	private Date crt_by_time;	// 创建时间
	private String re_by_c;		// 接收人
	private String re_by_cn;	// 接收人名称
	private Date re_by_time;	// 回复时间
	private String re_flag;	// 回复标识 回复意见（0=未处理；1=同意；2=不同意）
	private String re_memo;	// 回复备注
	
	// 新建字段
	private String email_flag; // 邮件标识(0=未读取；1=已读取；2=已回复)
	private String email_url;  // 邮件附件url
	private String email_fjname;// 邮件附件标题
	
	public MsgChat(){
		
	}
	
	public MsgChat(Integer id){
		this.id = id;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "MSG_CHAT")
	@SequenceGenerator(name = "MSG_CHAT", sequenceName = "SEQ_MSG_CHAT", allocationSize = 1)
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

	@Column(name = "TITLE", length = 500)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "CONTENT", length = 1000)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@Column(name = "CAT_ID", length = 30)
	public String getCat_id() {
		return cat_id;
	}

	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}

	@Column(name = "CAT_NAME", length = 100)
	public String getCat_name() {
		return cat_name;
	}

	public void setCat_name(String cat_name) {
		this.cat_name = cat_name;
	}

	@Column(name = "PP_ID", length = 30)
	public String getPp_id() {
		return pp_id;
	}

	public void setPp_id(String pp_id) {
		this.pp_id = pp_id;
	}

	@Column(name = "PP_NAME", length = 100)
	public String getPp_name() {
		return pp_name;
	}

	public void setPp_name(String pp_name) {
		this.pp_name = pp_name;
	}

	@Column(name = "SHOP_ID", length = 30)
	public String getShop_id() {
		return shop_id;
	}

	public void setShop_id(String shop_id) {
		this.shop_id = shop_id;
	}

	@Column(name = "SHOP_NAME", length = 100)
	public String getShop_name() {
		return shop_name;
	}

	public void setShop_name(String shop_name) {
		this.shop_name = shop_name;
	}

	@Column(name = "CRT_BY_C", length = 30)
	public String getCrt_by_c() {
		return crt_by_c;
	}

	public void setCrt_by_c(String crt_by_c) {
		this.crt_by_c = crt_by_c;
	}

	@Column(name = "CRT_BY_CN", length = 100)
	public String getCrt_by_cn() {
		return crt_by_cn;
	}

	public void setCrt_by_cn(String crt_by_cn) {
		this.crt_by_cn = crt_by_cn;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CRT_BY_TIME", nullable = false, length = 26)
	public Date getCrt_by_time() {
		return crt_by_time;
	}

	public void setCrt_by_time(Date crt_by_time) {
		this.crt_by_time = crt_by_time;
	}

	@Column(name = "RE_BY_C", length = 30)
	public String getRe_by_c() {
		return re_by_c;
	}

	public void setRe_by_c(String re_by_c) {
		this.re_by_c = re_by_c;
	}

	@Column(name = "RE_BY_CN", length = 100)
	public String getRe_by_cn() {
		return re_by_cn;
	}

	public void setRe_by_cn(String re_by_cn) {
		this.re_by_cn = re_by_cn;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "RE_BY_TIME", nullable = true, length = 26)
	public Date getRe_by_time() {
		return re_by_time;
	}

	public void setRe_by_time(Date re_by_time) {
		this.re_by_time = re_by_time;
	}

	@Column(name = "RE_FLAG", length = 1)
	public String getRe_flag() {
		return re_flag;
	}

	public void setRe_flag(String re_flag) {
		this.re_flag = re_flag;
	}

	@Column(name = "RE_MEMO", length = 300)
	public String getRe_memo() {
		return re_memo;
	}

	public void setRe_memo(String re_memo) {
		this.re_memo = re_memo;
	}
	
	@Column(name = "EMAIL_FLAG", length = 30)
	public String getEmail_flag() {
		return email_flag;
	}

	public void setEmail_flag(String email_flag) {
		this.email_flag = email_flag;
	}
	
	@Column(name = "EMAIL_URL", length = 200)
	public String getEmail_url() {
		return email_url;
	}

	public void setEmail_url(String email_url) {
		this.email_url = email_url;
	}
	
	@Column(name = "EMAIL_FJNAME", length = 200)
	public String getEmail_fjname() {
		return email_fjname;
	}

	public void setEmail_fjname(String email_fjname) {
		this.email_fjname = email_fjname;
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
