package com.bfuture.app.pm.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.bfuture.app.basic.model.BaseObject;

@Entity
@Table(name="pm_rule")
public class PmRule extends BaseObject implements Serializable {

	private static final long serialVersionUID = 5722859792430836452L;
	private String id;
    private String prC;
    private String prCn;
    private String implClass;
    private String discription;
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
    
    @Column(name="PR_C", nullable=false, length=30)
    public String getPrC() {
        return this.prC;
    }
    
    public void setPrC(String prC) {
        this.prC = prC;
    }
    
    @Column(name="PR_CN", nullable=false, length=100)
    public String getPrCn() {
        return this.prCn;
    }
    
    public void setPrCn(String prCn) {
        this.prCn = prCn;
    }
    
    @Column(name="IMPL_CLASS", length=200)
    public String getImplClass() {
        return this.implClass;
    }
    
    public void setImplClass(String implClass) {
        this.implClass = implClass;
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
    
    @Column(name="DISCRIPTION", length=1000)
    public String getDiscription() {
        return this.discription;
    }
    
    public void setDiscription(String discription) {
        this.discription = discription;
    }

    @Override
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PmRule pojo = (PmRule) o;

        if (prC != null ? !prC.equals(pojo.prC) : pojo.prC != null) return false;
        if (prCn != null ? !prCn.equals(pojo.prCn) : pojo.prCn != null) return false;
        if (implClass != null ? !implClass.equals(pojo.implClass) : pojo.implClass != null) return false;

        if (temp1 != null ? !temp1.equals(pojo.temp1) : pojo.temp1 != null) return false;
        if (temp2 != null ? !temp2.equals(pojo.temp2) : pojo.temp2 != null) return false;
        if (temp3 != null ? !temp3.equals(pojo.temp3) : pojo.temp3 != null) return false;
        if (temp4 != null ? !temp4.equals(pojo.temp4) : pojo.temp4 != null) return false;
        if (temp5 != null ? !temp5.equals(pojo.temp5) : pojo.temp5 != null) return false;
        if (discription != null ? !discription.equals(pojo.discription) : pojo.discription != null) return false;

        return true;
    }

    @Override
	public int hashCode() {
        int result = 0;
        result = (prC != null ? prC.hashCode() : 0);
        result = 31 * result + (prCn != null ? prCn.hashCode() : 0);
        result = 31 * result + (implClass != null ? implClass.hashCode() : 0);
        result = 31 * result + (temp1 != null ? temp1.hashCode() : 0);
        result = 31 * result + (temp2 != null ? temp2.hashCode() : 0);
        result = 31 * result + (temp3 != null ? temp3.hashCode() : 0);
        result = 31 * result + (temp4 != null ? temp4.hashCode() : 0);
        result = 31 * result + (temp5 != null ? temp5.hashCode() : 0);
        result = 31 * result + (discription != null ? discription.hashCode() : 0);

        return result;
    }

    @Override
	public String toString() {
        StringBuffer sb = new StringBuffer(getClass().getSimpleName());

        sb.append(" [");
        sb.append("id").append("='").append(getId()).append("', ");
        sb.append("prC").append("='").append(getPrC()).append("', ");
        sb.append("prCn").append("='").append(getPrCn()).append("', ");
        sb.append("implClass").append("='").append(getImplClass()).append("', ");
        sb.append("temp1").append("='").append(getTemp1()).append("', ");
        sb.append("temp2").append("='").append(getTemp2()).append("', ");
        sb.append("temp3").append("='").append(getTemp3()).append("', ");
        sb.append("temp4").append("='").append(getTemp4()).append("', ");
        sb.append("temp5").append("='").append(getTemp5()).append("', ");
        sb.append("discription").append("='").append(getDiscription()).append("'");
        sb.append("]");
      
        return sb.toString();
    }

}
