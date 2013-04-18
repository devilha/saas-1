package com.bfuture.app.saas.service;

import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
/**
 * 订单明细Manager接口
 * @author chenjw
 *
 */
public interface YwBorderdetManager extends BaseManager {
	public ReturnObject SearchYwBorderdet(Object[] o);
	
}
