package com.bfuture.app.pm.dao.hibernate;

import java.util.List;

import com.bfuture.app.basic.dao.hibernate.GenericDaoHibernate;
import com.bfuture.app.pm.dao.PmActiveDao;
import com.bfuture.app.pm.model.PmActive;


public class PmActiveDaoHibernate extends GenericDaoHibernate<PmActive, Long> implements PmActiveDao {


    public PmActiveDaoHibernate() {
        super(PmActive.class);
    }

    public List<PmActive> getActList(String ptC) {
    	log.debug("getActList: " + ptC);
    	List<PmActive> list = getHibernateTemplate().find("from PmActive p where p.ptC=?  order by upper(p.paC)", ptC);
        return list;
    }
    
}
