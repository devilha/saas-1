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
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.bfuture.app.basic.model.BaseObject;

@Entity
@Table(name="pm_act_ins_his")
public class PmActInsHis extends BaseObject implements Serializable {

	private static final long serialVersionUID = -8963652731427802465L;
	private String id;
    private String ptC;
    private String paC;
    private String ppiC;
    private String paiC;
    private String nameCn;
    private String discription;
    private String url;
    private Date crtByTime;
    private String ownerType;
    private String ownerC;
    private String exeByC;
    private String exeRes;
    private String state;
    private Date endTime;
    private String billC;
    private String billType;
    private String deptC;    
    private String crtByC;
    private String memo;
    private String temp1;
    private String temp2;
    private String temp3;
    private String temp4;
    private String temp5;

	@Id	
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    
	@Column(name="PT_C", nullable=false, length=50)
    public String getPtC() {
        return this.ptC;
    }
    
    
	public void setPtC(String ptC) {
        this.ptC = ptC;
    }
    
    
	@Column(name="PA_C", nullable=false, length=30)
    public String getPaC() {
        return this.paC;
    }
    
    
	public void setPaC(String paC) {
        this.paC = paC;
    }
    
    
	@Column(name="PPI_C", nullable=false, length=50)
    public String getPpiC() {
        return this.ppiC;
    }
    
    
	public void setPpiC(String ppiC) {
        this.ppiC = ppiC;
    }
    
    @Column(name="PAI_C", nullable=false, length=100)
    public String getPaiC() {
        return this.paiC;
    }
    
    public void setPaiC(String paiC) {
        this.paiC = paiC;
    }
    
    @Column(name="NAME_CN", length=100)
    public String getNameCn() {
        return this.nameCn;
    }
    
    public void setNameCn(String nameCn) {
        this.nameCn = nameCn;
    }
    
    @Column(name="DISCRIPTION", length=500)
    public String getDiscription() {
        return this.discription;
    }
    
    public void setDiscription(String discription) {
        this.discription = discription;
    }
    
    @Column(name="URL", length=200)
    public String getUrl() {
        return this.url;
    }
    
    public void setUrl(String url) {
        this.url = url;
    }    
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="CRT_BY_TIME", length=0)
    public Date getCrtByTime() {
        return this.crtByTime;
    }
    
    public void setCrtByTime(Date crtByTime) {
        this.crtByTime = crtByTime;
    }
    
    @Column(name="OWNER_TYPE", length=30)
    public String getOwnerType() {
        return this.ownerType;
    }
    
    public void setOwnerType(String ownerType) {
        this.ownerType = ownerType;
    }
    
    @Column(name="OWNER_C", length=30)
    public String getOwnerC() {
        return this.ownerC;
    }
    
    public void setOwnerC(String ownerC) {
        this.ownerC = ownerC;
    }
    
    @Column(name="EXE_BY_C", length=30)
    public String getExeByC() {
        return this.exeByC;
    }
    
    public void setExeByC(String exeByC) {
        this.exeByC = exeByC;
    }
    
    @Column(name="EXE_RES", length=30)
    public String getExeRes() {
        return this.exeRes;
    }
    
    public void setExeRes(String exeRes) {
        this.exeRes = exeRes;
    }
    
    @Column(name="STATE", nullable=false, length=30)
    public String getState() {
        return this.state;
    }
    
    public void setState(String state) {
        this.state = state;
    }

	@Temporal(TemporalType.TIMESTAMP)
    @Column(name="END_TIME", length=0)
    public Date getEndTime() {
        return this.endTime;
    }
    
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }
    
    @Column(name="MEMO", length=2000)
	public String getMemo() {
		return memo;
	}
    
    public void setMemo(String memo) {
		this.memo = memo;
	}
    
    @Column(name="TEMP1", length=100)
    public String getTemp1() {
        return this.temp1;
    }
    
    public void setTemp1(String temp1) {
        this.temp1 = temp1;
    }
    
    @Column(name="TEMP2", length=100)
    public String getTemp2() {
        return this.temp2;
    }
    
    public void setTemp2(String temp2) {
        this.temp2 = temp2;
    }
    
    @Column(name="TEMP3", length=100)
    public String getTemp3() {
        return this.temp3;
    }
    
    public void setTemp3(String temp3) {
        this.temp3 = temp3;
    }
    
    @Column(name="TEMP4", length=100)
    public String getTemp4() {
        return this.temp4;
    }
    
    public void setTemp4(String temp4) {
        this.temp4 = temp4;
    }
    
    @Column(name="TEMP5", length=100)
    public String getTemp5() {
        return this.temp5;
    }
    
    public void setTemp5(String temp5) {
        this.temp5 = temp5;
    }    

    @Column(name="BILL_C", length=30)
    public String getBillC() {
		return billC;
	}

	public void setBillC(String billC) {
		this.billC = billC;
	}
	
	@Column(name="BILL_TYPE", length=30)
	public String getBillType() {
		return billType;
	}

	public void setBillType(String billType) {
		this.billType = billType;
	}

	@Column(name="DEPT_C", length=30)
	public String getDeptC() {
		return deptC;
	}

	public void setDeptC(String deptC) {
		this.deptC = deptC;
	}

	@Column(name="CRT_BY_C", length=30)
	public String getCrtByC() {
		return crtByC;
	}

	public void setCrtByC(String crtByC) {
		this.crtByC = crtByC;
	}

	
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmActInsHis pojo = (PmActInsHis) o;

        if (ptC != null ? !ptC.equals(pojo.ptC) : pojo.ptC != null) return false;
        if (paC != null ? !paC.equals(pojo.paC) : pojo.paC != null) return false;
        if (ppiC != null ? !ppiC.equals(pojo.ppiC) : pojo.ppiC != null) return false;
        if (paiC != null ? !paiC.equals(pojo.paiC) : pojo.paiC != null) return false;
        if (nameCn != null ? !nameCn.equals(pojo.nameCn) : pojo.nameCn != null) return false;
        if (discription != null ? !discription.equals(pojo.discription) : pojo.discription != null) return false;
        if (url != null ? !url.equals(pojo.url) : pojo.url != null) return false;
        if (crtByTime != null ? !crtByTime.equals(pojo.crtByTime) : pojo.crtByTime != null) return false;
        if (ownerType != null ? !ownerType.equals(pojo.ownerType) : pojo.ownerType != null) return false;
        if (ownerC != null ? !ownerC.equals(pojo.ownerC) : pojo.ownerC != null) return false;
        if (exeByC != null ? !exeByC.equals(pojo.exeByC) : pojo.exeByC != null) return false;
        if (exeRes != null ? !exeRes.equals(pojo.exeRes) : pojo.exeRes != null) return false;
        if (state != null ? !state.equals(pojo.state) : pojo.state != null) return false;
        if (endTime != null ? !endTime.equals(pojo.endTime) : pojo.endTime != null) return false;
        if (temp1 != null ? !temp1.equals(pojo.temp1) : pojo.temp1 != null) return false;
        if (temp2 != null ? !temp2.equals(pojo.temp2) : pojo.temp2 != null) return false;
        if (temp3 != null ? !temp3.equals(pojo.temp3) : pojo.temp3 != null) return false;
        if (temp4 != null ? !temp4.equals(pojo.temp4) : pojo.temp4 != null) return false;
        if (temp5 != null ? !temp5.equals(pojo.temp5) : pojo.temp5 != null) return false;

        return true;
    }

    
	public int hashCode() {
        int result = 0;
        result = (ptC != null ? ptC.hashCode() : 0);
        result = 31 * result + (paC != null ? paC.hashCode() : 0);
        result = 31 * result + (ppiC != null ? ppiC.hashCode() : 0);
        result = 31 * result + (paiC != null ? paiC.hashCode() : 0);
        result = 31 * result + (nameCn != null ? nameCn.hashCode() : 0);
        result = 31 * result + (discription != null ? discription.hashCode() : 0);
        result = 31 * result + (url != null ? url.hashCode() : 0);
        result = 31 * result + (crtByTime != null ? crtByTime.hashCode() : 0);
        result = 31 * result + (ownerType != null ? ownerType.hashCode() : 0);
        result = 31 * result + (ownerC != null ? ownerC.hashCode() : 0);
        result = 31 * result + (exeByC != null ? exeByC.hashCode() : 0);
        result = 31 * result + (exeRes != null ? exeRes.hashCode() : 0);
        result = 31 * result + (state != null ? state.hashCode() : 0);
        result = 31 * result + (endTime != null ? endTime.hashCode() : 0);
        result = 31 * result + (temp1 != null ? temp1.hashCode() : 0);
        result = 31 * result + (temp2 != null ? temp2.hashCode() : 0);
        result = 31 * result + (temp3 != null ? temp3.hashCode() : 0);
        result = 31 * result + (temp4 != null ? temp4.hashCode() : 0);
        result = 31 * result + (temp5 != null ? temp5.hashCode() : 0);

        return result;
    }

    
	public String toString() {
        StringBuffer sb = new StringBuffer(getClass().getSimpleName());

        sb.append(" [");
        sb.append("id").append("='").append(getId()).append("', ");
        sb.append("ptC").append("='").append(getPtC()).append("', ");
        sb.append("paC").append("='").append(getPaC()).append("', ");
        sb.append("ppiC").append("='").append(getPpiC()).append("', ");
        sb.append("paiC").append("='").append(getPaiC()).append("', ");
        sb.append("nameCn").append("='").append(getNameCn()).append("', ");
        sb.append("discription").append("='").append(getDiscription()).append("', ");
        sb.append("url").append("='").append(getUrl()).append("', ");
        sb.append("crtByTime").append("='").append(getCrtByTime()).append("', ");
        sb.append("ownerType").append("='").append(getOwnerType()).append("', ");
        sb.append("ownerC").append("='").append(getOwnerC()).append("', ");
        sb.append("exeByC").append("='").append(getExeByC()).append("', ");
        sb.append("exeRes").append("='").append(getExeRes()).append("', ");
        sb.append("state").append("='").append(getState()).append("', ");
        sb.append("endTime").append("='").append(getEndTime()).append("', ");
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("'");
        sb.append("]");
      
        return sb.toString();
    }

}
