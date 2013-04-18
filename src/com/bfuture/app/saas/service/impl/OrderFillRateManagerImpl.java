package com.bfuture.app.saas.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.YwBorderhead;
import com.bfuture.app.saas.service.OrderFillRateManager;

/**
 * 订单满足率Manager实现类
 * 
 * @author zhouyu
 * 
 */
public class OrderFillRateManagerImpl extends BaseManagerImpl implements OrderFillRateManager {
	protected final Log log = LogFactory.getLog(YwBorderdetManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public OrderFillRateManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();

		if ("SearchYwBorderhead".equals(actionType)) {
			result = getOrderFillRate(o);
		} else if ("actionType2".equals(actionType)) {

		}

		return result;
	}

	@SuppressWarnings("unchecked")
	public ReturnObject getOrderFillRate(Object[] o) {
		java.text.NumberFormat nf = java.text.NumberFormat.getPercentInstance();
		nf.setMaximumIntegerDigits(100);// 小数点前保留几位
		nf.setMinimumFractionDigits(2);// 小数点后保留几位
		ReturnObject result = new ReturnObject();
		List<Object> dataList = new ArrayList<Object>();
		Map<String, Object> dataMap = new HashMap<String, Object>();
		Float borderTotal = 0F;// 订单张数
		Float binstrTotal = 0F;// 订单张数
		Float execBorderRate = 0F;// 订单执行率=执行订单数/订单张数
		Float execBorder = 0F;// 执行订单数（已经生成了入库单的订单就执行了）
		Float borderFillRate = 0F;// 订单满足率=执行订单商品和数目送货订单/订单张数
		// Float execBorder = 0L;// 执行订单商品和数目送货订单
		// -----------------------------------
		Float borderExactRate = 0F;// 订单准确率=完全执行订单商品和数目送货订单/订单张数
		Float fullExecBorder = 0F;// 完全执行订单商品和数目的送货订单
		// -----------------------------------
		Float borderOnTimeRate = 0F;// 订单准时率=准时执行的订单/订单张数
		Float onTimeBorder = 0F;// 准时执行的订单（按规定的送货时间送货的订单：入库的日期（交货日期）小于订单上的送货日期就是准时执行订单）
		Float borderGoodsTotal = 0F;// 订单商品总数（订单明细中的商品数量汇总）
		Float goodsFillRate = 0F;// 订货数满足率=到货商品总数/订单商品总数
		Float arrivalGoodsTotal = 0F;// 到货商品总数（按时送货的到货商品总数：根据订单号去查相关的入库单明细商品数量）
		Float goodsExactRate = 0F;// 订货数准确率=完全执行订单商品数目的送货数/订单商品总数
		Float fullExecGoods = 0F;// 完全执行订单商品数目的送货数（完全送货的订单里的商品数量，就是订单相应的入库单明细的商品数量）
		Float turnoverDays = 0F;// 周转天数（所有订单的送货时间减去订货时间之和然后除以所有订单数）
		Float totaldays = 0F;// 总天数

		StringBuilder sql = new StringBuilder();
		YwBorderhead yb = (YwBorderhead) o[0];
		try {
			// -----------------------------------------
			// 订单张数
			sql.delete(0, sql.length());
			sql = sql.append("select count(*) from YW_BORDERHEAD yw_borderhead where 1 = 1 ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			List lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t1 :" + lstResult);
			log.info("lstResult.size() t1 :" + lstResult.size());
			if (lstResult != null) {
				borderTotal = Float.parseFloat(((Map) lstResult.get(0)).get("COUNT(*)").toString());
			}
			dataMap.put("borderTotal", borderTotal);
			// 入库单张数
			sql.delete(0, sql.length());
			sql = sql.append("select count(*) from YW_BINSTRHEAD yw_binstrhead where 1 = 1 ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_binstrhead.BIHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd hh24:mi:ss')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_binstrhead.BIHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd hh24:mi:ss')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_binstrhead.BIHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_binstrhead.BIHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t1 :" + lstResult);
			log.info("lstResult.size() t1 :" + lstResult.size());
			if (lstResult != null) {
				binstrTotal = Float.parseFloat(((Map) lstResult.get(0)).get("COUNT(*)").toString());
			}
			dataMap.put("binstrTotal", binstrTotal);
			// 执行订单数
			sql.delete(0, sql.length());
			sql = sql.append("select count(*) from YW_BORDERHEAD yw_borderhead , YW_BINSTRHEAD yw_binstrhead where yw_borderhead.BOHBILLNO = yw_binstrhead.BIHORDERNO ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t2 :" + lstResult);
			log.info("lstResult.size() t2 :" + lstResult.size());
			if (lstResult != null) {
				execBorder = Float.parseFloat(((Map) lstResult.get(0)).get("COUNT(*)").toString());
			}
			dataMap.put("execBorder", execBorder);
			// 计算订单执行率
			if (borderTotal > 0) {
				execBorderRate = Float.parseFloat(String.valueOf(execBorder / borderTotal));
			}
			dataMap.put("execBorderRate", nf.format(execBorderRate));
			// -----------------------------------------
			// 计算订单满足率
			// borderFillRate = execBorderRate;
			// dataMap.put("borderFillRate", nf.format(execBorderRate));
			// -----------------------------------------
			// 完全执行订单商品和数目送货订单
			sql.delete(0, sql.length());
			sql = sql.append("select count(distinct(yw_borderhead.BOHBILLNO)) from YW_BORDERDET yw_borderdet , YW_BINSTRDETAIL yw_binstrdet , YW_BINSTRHEAD yw_binstrhead , YW_BORDERHEAD yw_borderhead where yw_binstrhead.BIHBILLNO = yw_binstrdet.BIDBILLNO and yw_binstrhead.BIHORDERNO = yw_borderhead.BOHBILLNO and yw_borderhead.BOHBILLNO = yw_borderdet.BODBILLNO and yw_borderdet.BODGDID = yw_binstrdet.BIDGDID and yw_borderdet.BODSL = yw_binstrdet.BIDSL ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t3 :" + lstResult);
			log.info("lstResult.size() t3 :" + lstResult.size());
			if (lstResult != null) {
				fullExecBorder = Float.parseFloat(((Map) lstResult.get(0)).get("COUNT(DISTINCT(YW_BORDERHEAD.BOHBILLNO))").toString());
			}
			dataMap.put("fullExecBorder", fullExecBorder);
			// 计算订单准确率
			// borderExactRate = Float.parseFloat(String.valueOf(fullExecBorder / borderTotal));
			// dataMap.put("borderExactRate", nf.format(borderExactRate));
			// 计算订单满足率
			if (borderTotal > 0) {
				borderFillRate = Float.parseFloat(String.valueOf(fullExecBorder / borderTotal));
			}
			dataMap.put("borderFillRate", nf.format(borderFillRate));
			// -----------------------------------------
			// 准时执行的订单数
			sql.delete(0, sql.length());
			sql = sql.append("select count(*) from YW_BORDERHEAD yw_borderhead , YW_BINSTRHEAD yw_binstrhead where yw_borderhead.BOHBILLNO = yw_binstrhead.BIHORDERNO and yw_borderhead.BOHJHRQ >= yw_binstrhead.BIHJHRQ ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t4 :" + lstResult);
			log.info("lstResult.size() t4 :" + lstResult.size());
			if (lstResult != null) {
				onTimeBorder = Float.parseFloat(((Map) lstResult.get(0)).get("COUNT(*)").toString());
			}
			dataMap.put("onTimeBorder", onTimeBorder);
			// 计算订单准时率
			if (borderTotal > 0) {
				borderOnTimeRate = Float.parseFloat(String.valueOf(onTimeBorder / borderTotal));
			}
			dataMap.put("borderOnTimeRate", nf.format(borderOnTimeRate));
			// -----------------------------------------
			// 订单商品总数
			sql.delete(0, sql.length());
			sql = sql.append("select nvl(sum(yw_borderdet.BODSL),0) from YW_BORDERHEAD yw_borderhead , YW_BORDERDET yw_borderdet where yw_borderhead.BOHBILLNO = yw_borderdet.BODBILLNO ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t5 :" + lstResult);
			log.info("lstResult.size() t5 :" + lstResult.size());
			if (lstResult != null) {
				borderGoodsTotal = Float.parseFloat(((Map) lstResult.get(0)).get("NVL(SUM(YW_BORDERDET.BODSL),0)").toString());
			}
			dataMap.put("borderGoodsTotal", borderGoodsTotal);
			// 到货商品总数
			sql.delete(0, sql.length());
			sql = sql.append("select nvl(sum(yw_binstrdet.BIDSL),0) from YW_BINSTRHEAD yw_binstrhead , YW_BINSTRDETAIL yw_binstrdet , YW_BORDERHEAD yw_borderhead where yw_binstrhead.BIHBILLNO = yw_binstrdet.BIDBILLNO and yw_binstrhead.BIHORDERNO = yw_borderhead.BOHBILLNO ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t6 :" + lstResult);
			log.info("lstResult.size() t6 :" + lstResult.size());
			if (lstResult != null) {
				arrivalGoodsTotal = Float.parseFloat(((Map) lstResult.get(0)).get("NVL(SUM(YW_BINSTRDET.BIDSL),0)").toString());
			}
			dataMap.put("arrivalGoodsTotal", arrivalGoodsTotal);
			// 计算订货数满足率
			if (borderGoodsTotal > 0) {
				goodsFillRate = Float.parseFloat(String.valueOf(arrivalGoodsTotal / borderGoodsTotal));
			}
			dataMap.put("goodsFillRate", nf.format(goodsFillRate));
			// -----------------------------------------
			// 完全执行订单商品数目的送货数
			sql.delete(0, sql.length());
			sql = sql.append("select nvl(sum(yw_binstrdet.BIDSL),0) from YW_BINSTRHEAD yw_binstrhead, YW_BINSTRDETAIL yw_binstrdet , YW_BORDERDET yw_borderdet , YW_BORDERHEAD yw_borderhead where yw_binstrhead.BIHBILLNO = yw_binstrdet.BIDBILLNO and yw_binstrhead.BIHORDERNO = yw_borderhead.BOHBILLNO and yw_borderhead.BOHBILLNO = yw_borderdet.BODBILLNO and yw_borderdet.BODGDID = yw_binstrdet.BIDGDID and yw_borderdet.BODSL = yw_binstrdet.BIDSL ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t7 :" + lstResult);
			log.info("lstResult.size() t7 :" + lstResult.size());
			if (lstResult != null) {
				fullExecGoods = Float.parseFloat(((Map) lstResult.get(0)).get("NVL(SUM(YW_BINSTRDET.BIDSL),0)").toString());
			}
			dataMap.put("fullExecGoods", fullExecGoods);
			// 计算订货数准确率
			if (borderGoodsTotal > 0) {
				goodsExactRate = Float.parseFloat(String.valueOf(fullExecGoods / borderGoodsTotal));
			}
			dataMap.put("goodsExactRate", nf.format(goodsExactRate));
			// -----------------------------------------
			// 计算周转天数
			sql.delete(0, sql.length());
			sql = sql.append("select nvl(sum(yw_binstrhead.BIHJHRQ - yw_borderhead.BOHDHRQ),0) totaldays from YW_BINSTRHEAD yw_binstrhead , YW_BORDERHEAD yw_borderhead where yw_binstrhead.BIHORDERNO = yw_borderhead.BOHBILLNO ");
			if (!StringUtil.isBlank(yb.getStartDate())) { // 开始时间
				sql.append(" and yw_borderhead.BOHSHTIME >= to_date('").append(yb.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getEndDate())) { // 结束时间
				sql.append(" and yw_borderhead.BOHSHTIME <= to_date('").append(yb.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(yb.getBohsupid())) { // 供应商编号
				sql.append(" and yw_borderhead.BOHSUPID = '").append(yb.getBohsupid()).append("'");
			}
			if (!StringUtil.isBlank(yb.getBohsgcode())) { // 实例编码
				sql.append(" and yw_borderhead.BOHSGCODE = '").append(yb.getBohsgcode()).append("'");
			}
			lstResult = dao.executeSql(sql.toString());
			log.info("lstResult t8 :" + lstResult);
			log.info("lstResult.size() t8 :" + lstResult.size());
			if (lstResult != null) {
				totaldays = Float.parseFloat(((Map) lstResult.get(0)).get("TOTALDAYS").toString());
			}
			if (execBorder > 0) {
				turnoverDays = totaldays / execBorder;
			}
			dataMap.put("turnoverDays", turnoverDays);
			dataList.add(dataMap);
			result.setRows(dataList);
		} catch (Exception ex) {
			log.error("OrderFillRateManagerImpl.getOrderFillRate() error:" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
}
