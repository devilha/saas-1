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
@Table(name="pm_active")
public class PmActive extends BaseObject implements Serializable {
 	private static final long serialVersionUID = -2253119240480095012L;
	private String id;
    private String ptC;
    private String paC;
    private String nameCn;
    private String discription;
    private String url;    
    private String supC;
    private String subC;
    private String backC;
    private String pointX;
    private String pointY;
    private String crtByC;
    private Date crtByDate;
    private String type;
    private String exeByType;
    private String exeByCode;
    private String deptC;
    private String temp1;
    private String temp2;
    private String temp3;
    private String temp4;
    private String temp5;
    private Long timeout;
    private String logicC;
    private String rLogicC;

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
    
    
	@Column(name="PA_C", nullable=false, length=50)
    public String getPaC() {
        return this.paC;
    }
    
    
	public void setPaC(String paC) {
        this.paC = paC;
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
    
    @Column(name="URL", length=100)
    public String getUrl() {
        return this.url;
    }
    
    public void setUrl(String url) {
        this.url = url;
    }
    
    @Column(name="SUP_C", length=50)
    public String getSupC() {
        return this.supC;
    }
    
    public void setSupC(String supC) {
        this.supC = supC;
    }

	@Column(name="SUB_C", length=50)
    public String getSubC() {
        return this.subC;
    }
    
    public void setSubC(String subC) {
        this.subC = subC;
    }    
    
    @Column(name="BACK_C", length=32)
    public String getBackC() {
		return backC;
	}

	public void setBackC(String backC) {
		this.backC = backC;
	}

	@Column(name="POINT_X", length=30)
    public String getPointX() {
        return this.pointX;
    }
    
    public void setPointX(String pointX) {
        this.pointX = pointX;
    }
    
    @Column(name="POINT_Y", length=30)
    public String getPointY() {
        return this.pointY;
    }
    
    public void setPointY(String pointY) {
        this.pointY = pointY;
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
    
    @Column(name="TYPE", nullable=false, length=30)
    public String getType() {
        return this.type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    @Column(name="EXE_BY_TYPE", length=30)
    public String getExeByType() {
        return this.exeByType;
    }
    
    public void setExeByType(String exeByType) {
        this.exeByType = exeByType;
    }
    
    @Column(name="EXE_BY_CODE", length=30)
    public String getExeByCode() {
        return this.exeByCode;
    }
    
    public void setExeByCode(String exeByCode) {
        this.exeByCode = exeByCode;
    }   
    
    @Column(name="LOGIC_C", length=30)
    public String getLogicC() {
		return logicC;
	}
    
	public void setLogicC(String logicC) {
		this.logicC = logicC;
	}

	@Column(name="R_LOGIC_C", length=30)
	public String getRLogicC() {
		return rLogicC;
	}

	public void setRLogicC(String logicC) {
		rLogicC = logicC;
	}
	
	@Column(name="DEPT_C", length=30)
	public String getDeptC() {
		return deptC;
	}

	public void setDeptC(String deptC) {
		this.deptC = deptC;
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

	@Column(name="TIMEOUT")
	public Long getTimeout() {
		return timeout;
	}

	public void setTimeout(Long timeout) {
		this.timeout = timeout;
	}
	
	
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmActive pojo = (PmActive) o;

        if (ptC != null ? !ptC.equals(pojo.ptC) : pojo.ptC != null) return false;
        if (paC != null ? !paC.equals(pojo.paC) : pojo.paC != null) return false;
        if (nameCn != null ? !nameCn.equals(pojo.nameCn) : pojo.nameCn != null) return false;
        if (discription != null ? !discription.equals(pojo.discription) : pojo.discription != null) return false;
        if (url != null ? !url.equals(pojo.url) : pojo.url != null) return false;
        if (supC != null ? !supC.equals(pojo.supC) : pojo.supC != null) return false;
        if (subC != null ? !subC.equals(pojo.subC) : pojo.subC != null) return false;
        if (pointX != null ? !pointX.equals(pojo.pointX) : pojo.pointX != null) return false;
        if (pointY != null ? !pointY.equals(pojo.pointY) : pojo.pointY != null) return false;
        if (crtByC != null ? !crtByC.equals(pojo.crtByC) : pojo.crtByC != null) return false;
        if (crtByDate != null ? !crtByDate.equals(pojo.crtByDate) : pojo.crtByDate != null) return false;
        if (type != null ? !type.equals(pojo.type) : pojo.type != null) return false;
        if (exeByType != null ? !exeByType.equals(pojo.exeByType) : pojo.exeByType != null) return false;
        if (exeByCode != null ? !exeByCode.equals(pojo.exeByCode) : pojo.exeByCode != null) return false;
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
        result = 31 * result + (nameCn != null ? nameCn.hashCode() : 0);
        result = 31 * result + (discription != null ? discription.hashCode() : 0);
        result = 31 * result + (url != null ? url.hashCode() : 0);
        result = 31 * result + (supC != null ? supC.hashCode() : 0);
        result = 31 * result + (subC != null ? subC.hashCode() : 0);
        result = 31 * result + (pointX != null ? pointX.hashCode() : 0);
        result = 31 * result + (pointY != null ? pointY.hashCode() : 0);
        result = 31 * result + (crtByC != null ? crtByC.hashCode() : 0);
        result = 31 * result + (crtByDate != null ? crtByDate.hashCode() : 0);
        result = 31 * result + (type != null ? type.hashCode() : 0);
        result = 31 * result + (exeByType != null ? exeByType.hashCode() : 0);
        result = 31 * result + (exeByCode != null ? exeByCode.hashCode() : 0);
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
        sb.append("nameCn").append("='").append(getNameCn()).append("', ");
        sb.append("discription").append("='").append(getDiscription()).append("', ");
        sb.append("url").append("='").append(getUrl()).append("', ");
        sb.append("supC").append("='").append(getSupC()).append("', ");
        sb.append("subC").append("='").append(getSubC()).append("', ");
        sb.append("pointX").append("='").append(getPointX()).append("', ");
        sb.append("pointY").append("='").append(getPointY()).append("', ");
        sb.append("crtByC").append("='").append(getCrtByC()).append("', ");
        sb.append("crtByDate").append("='").append(getCrtByDate()).append("', ");
        sb.append("type").append("='").append(getType()).append("', ");
        sb.append("exeByType").append("='").append(getExeByType()).append("', ");
        sb.append("exeByCode").append("='").append(getExeByCode()).append("', ");
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("', ");

        sb.append("]");
      
        return sb.toString();
    }   

}
