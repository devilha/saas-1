package com.bfuture.app.pm.dao.hibernate;

import com.bfuture.app.basic.dao.hibernate.GenericDaoHibernate;
import com.bfuture.app.pm.dao.PmActInsDao;
import com.bfuture.app.pm.model.PmActIns;


public class PmActInsDaoHibernate extends GenericDaoHibernate<PmActIns, Long> implements PmActInsDao {


    public PmActInsDaoHibernate() {
        super(PmActIns.class);
    }


    
}
