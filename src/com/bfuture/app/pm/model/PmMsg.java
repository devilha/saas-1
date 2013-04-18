package com.bfuture.app.pm.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.GenericGenerator;

import com.bfuture.app.basic.model.BaseObject;

@Entity
@Table(name="pm_msg")
public class PmMsg extends BaseObject implements Serializable {
    private String id;
    private String pmC;
    private String pmTitle;
    private String pmContext;
    private String crtByC;
    private String crtByCn;
    private Date crtByTime;
    private String receiverC;
    private String receiverCn;
    private String receiverMobile;
    private String receiverEmail;
    private Date receiveTime;    

	@Id
	@GeneratedValue(generator = "guidGenerator")     
    @GenericGenerator(name = "guidGenerator", strategy = "assigned")
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }    
    
	@Column(name="PM_C", nullable=false, length=30)
    public String getPmC() {
        return this.pmC;
    }    
    
	public void setPmC(String pmC) {
        this.pmC = pmC;
    }   
    
	@Column(name="PM_TITLE", length=100)
	public String getPmTitle() {
		return pmTitle;
	}

	public void setPmTitle(String pmTitle) {
		this.pmTitle = pmTitle;
	}

	@Column(name="PM_CONTEXT", length=2000)
	public String getPmContext() {
		return pmContext;
	}

	public void setPmContext(String pmContext) {
		this.pmContext = pmContext;
	}

	@Column(name="CRT_BY_C", length=30)
	public String getCrtByC() {
		return crtByC;
	}

	public void setCrtByC(String crtByC) {
		this.crtByC = crtByC;
	}

	@Column(name="CRT_BY_CN", length=100)
	public String getCrtByCn() {
		return crtByCn;
	}

	public void setCrtByCn(String crtByCn) {
		this.crtByCn = crtByCn;
	}

	@Temporal(TemporalType.TIMESTAMP)
    @Column(name="CRT_BY_TIME", length=0)
	public Date getCrtByTime() {
		return crtByTime;
	}

	public void setCrtByTime(Date crtByTime) {
		this.crtByTime = crtByTime;
	}

	@Column(name="RECEIVER_C", length=30)
	public String getReceiverC() {
		return receiverC;
	}

	public void setReceiverC(String receiverC) {
		this.receiverC = receiverC;
	}

	@Column(name="RECEIVER_CN", length=100)
	public String getReceiverCn() {
		return receiverCn;
	}

	public void setReceiverCn(String receiverCn) {
		this.receiverCn = receiverCn;
	}	

	@Column(name="RECEIVER_MOBILE", length=30)
	public String getReceiverMobile() {
		return receiverMobile;
	}

	public void setReceiverMobile(String receiverMobile) {
		this.receiverMobile = receiverMobile;
	}

	@Column(name="RECEIVER_EMAIL", length=100)
	public String getReceiverEmail() {
		return receiverEmail;
	}

	public void setReceiverEmail(String receiverEmail) {
		this.receiverEmail = receiverEmail;
	}

	@Temporal(TemporalType.TIMESTAMP)
    @Column(name="RECEIVE_TIME", length=0)
	public Date getReceiveTime() {
		return receiveTime;
	}

	public void setReceiveTime(Date receiveTime) {
		this.receiveTime = receiveTime;
	}

	@Override
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmMsg pojo = (PmMsg) o;

        if (pmC != null ? !pmC.equals(pojo.pmC) : pojo.pmC != null) return false;
        if (pmTitle != null ? !pmTitle.equals(pojo.pmTitle) : pojo.pmTitle != null) return false;        
        if (crtByC != null ? !crtByC.equals(pojo.crtByC) : pojo.crtByC != null) return false;
        if (crtByCn != null ? !crtByCn.equals(pojo.crtByCn) : pojo.crtByCn != null) return false;
        if (crtByTime != null ? !crtByTime.equals(pojo.crtByTime) : pojo.crtByTime != null) return false;
        if (receiverC != null ? !receiverC.equals(pojo.receiverC) : pojo.receiverC != null) return false;
        if (receiverCn != null ? !receiverCn.equals(pojo.receiverCn) : pojo.receiverCn != null) return false;
        if (receiveTime != null ? !receiveTime.equals(pojo.receiveTime) : pojo.receiveTime != null) return false;

        return true;
    }

    @Override
	public int hashCode() {
        int result = 0;
        result = (pmC != null ? pmC.hashCode() : 0);
        result = 31 * result + (pmTitle != null ? pmTitle.hashCode() : 0);        

        return result;
    }

    @Override
	public String toString() {
        StringBuffer sb = new StringBuffer(getClass().getSimpleName());

        sb.append(" [");
        sb.append("id").append("='").append(getId()).append("', ");
        sb.append("pmC").append("='").append(getPmC()).append("', ");
        sb.append("pmTitle").append("='").append(getPmTitle()).append("', ");
        sb.append("pmContext").append("='").append(getPmContext()).append("', ");
        
        sb.append("]");
      
        return sb.toString();
    }

}
