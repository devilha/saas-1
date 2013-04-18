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
@Table(name="pm_pro_ins_his")
public class PmProInsHis extends BaseObject implements Serializable {
    
	private static final long serialVersionUID = -7932421993793376134L;
	private String id;
    private String ppiC;
    private String ptC;
    private String nameCn;
    private String discription;
    private String crtByC;
    private Date crtByDate;
    private String billType;
    private String state;
    private Date comDate;
    private String temp1;
    private String temp2;
    private String temp3;
    private String temp4;
    private String temp5;    
    private String billC;
    private String deptC;
    

    @Id
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    
	@Column(name="PPI_C", nullable=false, length=50)
    public String getPpiC() {
        return this.ppiC;
    }
    
    
	public void setPpiC(String ppiC) {
        this.ppiC = ppiC;
    }
    
    
	@Column(name="PT_C", nullable=false, length=50)
    public String getPtC() {
        return this.ptC;
    }
    
    
	public void setPtC(String ptC) {
        this.ptC = ptC;
    }
    
    @Column(name="NAME_CN", length=100)
    public String getNameCn() {
        return this.nameCn;
    }
    
    public void setNameCn(String nameCn) {
        this.nameCn = nameCn;
    }
    
    @Column(name="DISCRIPTION", length=200)
    public String getDiscription() {
        return this.discription;
    }
    
    public void setDiscription(String discription) {
        this.discription = discription;
    }
    
    @Column(name="CRT_BY_C", length=30)
    public String getCrtByC() {
        return this.crtByC;
    }
    
    public void setCrtByC(String crtByC) {
        this.crtByC = crtByC;
    }
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="CRT_BY_DATE", length=0)
    public Date getCrtByDate() {
        return this.crtByDate;
    }
    
    public void setCrtByDate(Date crtByDate) {
        this.crtByDate = crtByDate;
    }
    
    @Column(name="BILL_TYPE", length=30)
    public String getBillType() {
        return this.billType;
    }
    
    public void setBillType(String billType) {
        this.billType = billType;
    }
    
    @Column(name="STATE", nullable=false, length=30)
    public String getState() {
        return this.state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="COM_DATE", length=0)
    public Date getComDate() {
        return this.comDate;
    }
    
    public void setComDate(Date comDate) {
        this.comDate = comDate;
    }
    
    @Column(name="TEMP1", length=30)
    public String getTemp1() {
        return this.temp1;
    }
    
    public void setTemp1(String temp1) {
        this.temp1 = temp1;
    }
    
    @Column(name="TEMP2", length=30)
    public String getTemp2() {
        return this.temp2;
    }
    
    public void setTemp2(String temp2) {
        this.temp2 = temp2;
    }
    
    @Column(name="TEMP3", length=30)
    public String getTemp3() {
        return this.temp3;
    }
    
    public void setTemp3(String temp3) {
        this.temp3 = temp3;
    }
    
    @Column(name="TEMP4", length=30)
    public String getTemp4() {
        return this.temp4;
    }
    
    public void setTemp4(String temp4) {
        this.temp4 = temp4;
    }
    
    @Column(name="TEMP5", length=30)
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

	@Column(name="DEPT_C", length=30)
	public String getDeptC() {
		return deptC;
	}

	public void setDeptC(String deptC) {
		this.deptC = deptC;
	}
    
    
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmProInsHis pojo = (PmProInsHis) o;

        if (ppiC != null ? !ppiC.equals(pojo.ppiC) : pojo.ppiC != null) return false;
        if (ptC != null ? !ptC.equals(pojo.ptC) : pojo.ptC != null) return false;
        if (nameCn != null ? !nameCn.equals(pojo.nameCn) : pojo.nameCn != null) return false;
        if (discription != null ? !discription.equals(pojo.discription) : pojo.discription != null) return false;
        if (crtByC != null ? !crtByC.equals(pojo.crtByC) : pojo.crtByC != null) return false;
        if (crtByDate != null ? !crtByDate.equals(pojo.crtByDate) : pojo.crtByDate != null) return false;
        if (billType != null ? !billType.equals(pojo.billType) : pojo.billType != null) return false;
        if (state != null ? !state.equals(pojo.state) : pojo.state != null) return false;
        if (comDate != null ? !comDate.equals(pojo.comDate) : pojo.comDate != null) return false;
        if (temp1 != null ? !temp1.equals(pojo.temp1) : pojo.temp1 != null) return false;
        if (temp2 != null ? !temp2.equals(pojo.temp2) : pojo.temp2 != null) return false;
        if (temp3 != null ? !temp3.equals(pojo.temp3) : pojo.temp3 != null) return false;
        if (temp4 != null ? !temp4.equals(pojo.temp4) : pojo.temp4 != null) return false;
        if (temp5 != null ? !temp5.equals(pojo.temp5) : pojo.temp5 != null) return false;

        return true;
    }

    
	public int hashCode() {
        int result = 0;
        result = (ppiC != null ? ppiC.hashCode() : 0);
        result = 31 * result + (ptC != null ? ptC.hashCode() : 0);
        result = 31 * result + (nameCn != null ? nameCn.hashCode() : 0);
        result = 31 * result + (discription != null ? discription.hashCode() : 0);
        result = 31 * result + (crtByC != null ? crtByC.hashCode() : 0);
        result = 31 * result + (crtByDate != null ? crtByDate.hashCode() : 0);
        result = 31 * result + (billType != null ? billType.hashCode() : 0);
        result = 31 * result + (state != null ? state.hashCode() : 0);
        result = 31 * result + (comDate != null ? comDate.hashCode() : 0);
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
        sb.append("ppiC").append("='").append(getPpiC()).append("', ");
        sb.append("ptC").append("='").append(getPtC()).append("', ");
        sb.append("nameCn").append("='").append(getNameCn()).append("', ");
        sb.append("discription").append("='").append(getDiscription()).append("', ");
        sb.append("crtByC").append("='").append(getCrtByC()).append("', ");
        sb.append("crtByDate").append("='").append(getCrtByDate()).append("', ");
        sb.append("billType").append("='").append(getBillType()).append("', ");
        sb.append("state").append("='").append(getState()).append("', ");
        sb.append("comDate").append("='").append(getComDate()).append("', ");
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("'");
        sb.append("]");
      
        return sb.toString();
    }
}
