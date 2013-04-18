package com.bfuture.app.pm.dao;


import java.util.List;

import com.bfuture.app.basic.dao.GenericDao;
import com.bfuture.app.pm.model.PmActive;

/**
 * User Data Access Object (GenericDao) interface.
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 */
public interface PmActiveDao extends GenericDao<PmActive, Long> {

	public List<PmActive> getActList(String ptC) ;
	
}
