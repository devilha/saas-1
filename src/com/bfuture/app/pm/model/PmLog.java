package com.bfuture.app.pm.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.bfuture.app.basic.model.BaseObject;

@Entity
@Table(name="pm_ps_log")
public class PmLog extends BaseObject implements Serializable {

	private static final long serialVersionUID = -5421246202532828513L;
	private String id;
    private String ptC;
    private String paC;
    private String ppiC;
    private String paiC;
    private Date crtDate;
    private String operC;    
    private String statusC;
    private String billC;
    private String billTypeC;
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
        
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="CRT_DATE", length=0)
    public Date getCrtDate() {
        return this.crtDate;
    }
    
    public void setCrtDate(Date crtDate) {
        this.crtDate = crtDate;
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

	@Column(name="MEMO", length=2000)
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	@Column(name="OPER_C", length=30)
	public String getOperC() {
		return operC;
	}

	public void setOperC(String operC) {
		this.operC = operC;
	}

	@Column(name="STATUS_C", length=30)
	public String getStatusC() {
		return statusC;
	}

	public void setStatusC(String statusC) {
		this.statusC = statusC;
	}

	@Column(name="BILL_TYPE_C", length=2000)
	public String getBillTypeC() {
		return billTypeC;
	}

	public void setBillTypeC(String billTypeC) {
		this.billTypeC = billTypeC;
	}

	
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmLog pojo = (PmLog) o;

        if (ptC != null ? !ptC.equals(pojo.ptC) : pojo.ptC != null) return false;
        if (paC != null ? !paC.equals(pojo.paC) : pojo.paC != null) return false;
        if (ppiC != null ? !ppiC.equals(pojo.ppiC) : pojo.ppiC != null) return false;
        if (paiC != null ? !paiC.equals(pojo.paiC) : pojo.paiC != null) return false;
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
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("'");
        sb.append("]");
      
        return sb.toString();
    }

}
