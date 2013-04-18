package com.bfuture.app.pm.dao.hibernate;

import com.bfuture.app.basic.dao.hibernate.GenericDaoHibernate;
import com.bfuture.app.pm.dao.PmProInsDao;
import com.bfuture.app.pm.model.PmProIns;


public class PmProInsDaoHibernate extends GenericDaoHibernate<PmProIns, Long> implements PmProInsDao {


    public PmProInsDaoHibernate() {
        super(PmProIns.class);
    }


    
}
