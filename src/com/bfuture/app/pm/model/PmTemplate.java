package com.bfuture.app.pm.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

@Entity
@Table(name="pm_template")
public class PmTemplate extends BaseObject implements Serializable {
    
	private static final long serialVersionUID = -1607714235988821547L;
	private String id;
	private String deptC;
    private String ptC;
    private String nameCn;
    private String discription;
    private String crtByC;
    private Date crtByDate;
    private String billType;
    private String ptEnable;
    private String url;    
    private String temp1;
    private String temp2;
    private String temp3;
    private String temp4;
    private String temp5;
    
    private List<PmActive> pas;

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
    
    @Column(name="NAME_CN", length=100)
    public String getNameCn() {
        return this.nameCn;
    }
    
    public void setNameCn(String nameCn) {
        this.nameCn = nameCn;
    }
    
    @Column(name="DISCRIPTION", length=1000)
    public String getDiscription() {
        return this.discription;
    }
    
    public void setDiscription(String discription) {
        this.discription = discription;
    }
    
    @Column(name="DEPT_C", length=30)
	public String getDeptC() {
		return deptC;
	}

	public void setDeptC(String deptC) {
		this.deptC = deptC;
	}
    
    @Column(name="CRT_BY_C", length=50)
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
    
    @Column(name="BILL_TYPE", length=50)
    public String getBillType() {
        return this.billType;
    }
    
    public void setBillType(String billType) {
        this.billType = billType;
    }
    
    @Column(name="PT_ENABLE", length=30)
    public String getPtEnable() {
        return this.ptEnable;
    }
    
    public void setPtEnable(String ptEnable) {
        this.ptEnable = ptEnable;
    }   
    
    @Column(name="URL", length=1000)
    public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
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

    @Transient
    public List<PmActive> getPmActives() {
		return pas;
	}

	public void setPaActives( List<PmActive> pas ) {
		this.pas = pas;
	}

	
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmTemplate pojo = (PmTemplate) o;

        if (ptC != null ? !ptC.equals(pojo.ptC) : pojo.ptC != null) return false;
        if (nameCn != null ? !nameCn.equals(pojo.nameCn) : pojo.nameCn != null) return false;
        if (discription != null ? !discription.equals(pojo.discription) : pojo.discription != null) return false;
        if (crtByC != null ? !crtByC.equals(pojo.crtByC) : pojo.crtByC != null) return false;
        if (crtByDate != null ? !crtByDate.equals(pojo.crtByDate) : pojo.crtByDate != null) return false;
        if (billType != null ? !billType.equals(pojo.billType) : pojo.billType != null) return false;
        if (ptEnable != null ? !ptEnable.equals(pojo.ptEnable) : pojo.ptEnable != null) return false;
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
        result = 31 * result + (nameCn != null ? nameCn.hashCode() : 0);
        result = 31 * result + (discription != null ? discription.hashCode() : 0);
        result = 31 * result + (crtByC != null ? crtByC.hashCode() : 0);
        result = 31 * result + (crtByDate != null ? crtByDate.hashCode() : 0);
        result = 31 * result + (billType != null ? billType.hashCode() : 0);
        result = 31 * result + (ptEnable != null ? ptEnable.hashCode() : 0);
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
        sb.append("nameCn").append("='").append(getNameCn()).append("', ");
        sb.append("discription").append("='").append(getDiscription()).append("', ");
        sb.append("crtByC").append("='").append(getCrtByC()).append("', ");
        sb.append("crtByDate").append("='").append(getCrtByDate()).append("', ");
        sb.append("billType").append("='").append(getBillType()).append("', ");
        sb.append("ptEnable").append("='").append(getPtEnable()).append("', ");
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("'");
        sb.append("]");
      
        return sb.toString();
    }

}
