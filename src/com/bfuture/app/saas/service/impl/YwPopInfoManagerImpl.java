package com.bfuture.app.saas.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.InfGoods;
import com.bfuture.app.saas.model.MsgMessage;
import com.bfuture.app.saas.model.YwPopinfoNew;
import com.bfuture.app.saas.model.report.POPQuery;
import com.bfuture.app.saas.model.report.YwPopinfoForm;
import com.bfuture.app.saas.service.YwPopInfoManager;

/**
 * 促销信息表Manager实现类
 * 
 * @author zhouyu
 * 
 */

@SuppressWarnings("unused")
public class YwPopInfoManagerImpl extends BaseManagerImpl implements YwPopInfoManager {
	protected final Log log = LogFactory.getLog(YwBorderdetManagerImpl.class);

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public YwPopInfoManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if ("YwPopInfoList".equals(actionType)) {
			result = popInfoList(o);
		} else if ("YwPopInfoApply".equals(actionType)) {
			result = popInfoApply(o);
		} else if ("remove".equals(actionType)) {
			result = popInfoDelete(o);
		} else if ("YwPopInfoDet".equals(actionType)) {
			result = popInfoDet(o);
		} else if ("getGoodInfo".equals(actionType)) {
			result = getGoodInfo(o);
		} else if ("YwPopInfoListLSS".equals(actionType)) {
			result = popInfoListLSS(o);
		} else if ("YwPopInfoApplyLSS".equals(actionType)) {
			result = popInfoApplyLSS(o);
		}
		return result;
	}

	// 零售商审批促销信息
	private ReturnObject popInfoApplyLSS(Object[] o) {
		ReturnObject result = new ReturnObject();
		YwPopinfoForm ywPopinfoForm = (YwPopinfoForm) o[0]; // 查询条件
		StringBuilder sql = new StringBuilder();
		try {
			sql = sql.append("UPDATE yw_popinfo_new SET pphfyj = '" + ywPopinfoForm.getPphfyj() + "',ppcgyj = '" + ywPopinfoForm.getPpcgyj() + "' WHERE popsequece = " + ywPopinfoForm.getPopsequece());
			dao.updateSql(sql.toString());
		} catch (Exception ex) {
			log.error("YwPopInfoManagerImpl.popInfoApplyLSS error:" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	// 零售商促销信息列表查询
	private ReturnObject popInfoListLSS(Object[] o) {
		ReturnObject result = new ReturnObject();
		POPQuery popQuery = (POPQuery) o[0]; // 查询条件
		StringBuilder sql = new StringBuilder();
		try {
			// 查询总数
			sql = sql.append("select count(*) from YW_POPINFO_NEW yw_popinfo where 1 = 1 ");
			if (!StringUtil.isBlank(popQuery.getStartDate())) { // 开始时间
				sql.append(" and yw_popinfo.PPGXTIME >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getEndDate())) { // 结束时间
				sql.append(" and yw_popinfo.PPGXTIME <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdname())) {// 供应商名称模糊查询
				sql.append(" and yw_popinfo.PPSUPNAME like '%" + popQuery.getPpsupname() + "%' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopmarket())) {// 门店代码
				sql.append(" and yw_popinfo.PPMARKET='" + popQuery.getPopmarket() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPphfyj())) {// 回复意见
				sql.append(" and yw_popinfo.PPHFYJ='" + popQuery.getPphfyj() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdbarcode())) {// 商品条码
				sql.append(" and yw_popinfo.PPGDBARCODE='" + popQuery.getPopgdbarcode() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getSgcode())) { // 实例编码
				sql.append(" and yw_popinfo.PPSGCODE = '").append(popQuery.getSgcode()).append("'");
			}
			List lstSumResult = dao.executeSql(sql.toString());
			log.info("lstResult t1 :" + lstSumResult);
			log.info("lstResult.size() t1 :" + lstSumResult.size());
			int totalCount = 0;
			if (lstSumResult != null) {
				totalCount = Integer.parseInt(((Map) lstSumResult.get(0)).get("COUNT(*)").toString());
			}
			// 查询结果集
			sql.delete(0, sql.length());
			sql = sql.append("select yw_popinfo.POPSEQUECE,yw_popinfo.PPSUPNAME,yw_popinfo.PPGDBARCODE,yw_popinfo.PPGDNAME,yw_popinfo.PPGXTIME,yw_popinfo.PPHFYJ,yw_popinfo.PPCGYJ,yw_popinfo.PPFILE,inf_shop.SHPNAME from INF_SHOP inf_shop,YW_POPINFO_NEW yw_popinfo where inf_shop.SHPCODE = yw_popinfo.PPMARKET and inf_shop.SGCODE = yw_popinfo.PPSGCODE ");
			if (!StringUtil.isBlank(popQuery.getStartDate())) { // 开始时间
				sql.append(" and yw_popinfo.PPGXTIME >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getEndDate())) { // 结束时间
				sql.append(" and yw_popinfo.PPGXTIME <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdname())) {// 供应商名称模糊查询
				sql.append(" and yw_popinfo.PPSUPNAME like '%" + popQuery.getPpsupname() + "%' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopmarket())) {// 门店代码
				sql.append(" and yw_popinfo.PPMARKET='" + popQuery.getPopmarket() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPphfyj())) {// 回复意见
				sql.append(" and yw_popinfo.PPHFYJ='" + popQuery.getPphfyj() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdbarcode())) {// 商品条码
				sql.append(" and yw_popinfo.PPGDBARCODE='" + popQuery.getPopgdbarcode() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getSgcode())) { // 实例编码
				sql.append(" and yw_popinfo.PPSGCODE = '").append(popQuery.getSgcode()).append("'");
			}
			sql.append(" order by yw_popinfo.PPGXTIME desc");
			int limit = popQuery.getRows();
			int start = (popQuery.getPage() - 1) * popQuery.getRows();
			List lstResult = dao.executeSql(sql.toString(), start, limit);
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
				result.setTotal(totalCount);
			}
			log.info("lstResult t2 :" + lstResult);
			log.info("lstResult.size() t2 :" + lstResult.size());
		} catch (Exception ex) {
			log.error("YwPopInfoManagerImpl.popInfoListLSS error:" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	// 根据商品条码获取商品信息
	private ReturnObject getGoodInfo(Object[] o) {
		ReturnObject result = new ReturnObject();
		try {
			InfGoods infGood = (InfGoods) o[0]; // 查询条件
			StringBuilder sql = new StringBuilder("select gd.GDNAME,gd.GDID from inf_goods gd ,inf_goodsuply gs where gd.gdsgcode = gs.gssgcode and gd.gdid = gs.gsid and gd.gdsgcode='"+user.getSgcode()+"' and gs.gssupid='"+user.getSupcode()+"'");
			if (!StringUtil.isBlank(infGood.getGdbarcode())) {
				sql.append(" and gd.GDBARCODE = '").append(infGood.getGdbarcode()).append("'");
				List lstResult = dao.executeSql(sql.toString());
				if (lstResult != null) {
					result.setRows(lstResult);
					log.info("lstResult t1 :" + lstResult);
					log.info("lstResult.size() t1 :" + lstResult.size());
				}
			}
			result.setReturnCode(Constants.SUCCESS_FLAG);

		} catch (Exception ex) {
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	// 供应商删除促销申请操作
	@SuppressWarnings("unchecked")
	private ReturnObject popInfoDelete(Object[] o) {
		ReturnObject result = new ReturnObject();
		String uploadAbsolutePath = "";
		try {
			if (o != null && o.length > 0) {
				for (Object obj : o) {
					YwPopinfoNew popinfo = (YwPopinfoNew) obj; // 查询条件
					uploadAbsolutePath = popinfo.getPpfile();
					StringBuilder sql = new StringBuilder("from YwPopinfoNew yw_popinfo where 1 = 1");
					if (popinfo.getPopsequece() != null) {
						sql.append(" and yw_popinfo.popsequece = '").append(popinfo.getPopsequece()).append("'");
						List lstResult = dao.executeHql(sql.toString());
						popinfo = (YwPopinfoNew) lstResult.get(0);
						// 删除附件
						if (popinfo.getPpfile() != null) {
							File file = new File(uploadAbsolutePath + File.separator + popinfo.getPpsgcode() + "_" + popinfo.getPpfile());
							if (file.exists()) {
								file.delete();
							}
						}
						remove(lstResult.toArray());
					}
				}
			}
		} catch (Exception ex) {
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	// 供应商促销信息列表查询
	public ReturnObject popInfoList(Object[] o) {
		ReturnObject result = new ReturnObject();
		POPQuery popQuery = (POPQuery) o[0]; // 查询条件
		StringBuilder sql = new StringBuilder();
		try {
			// 查询总数
			sql = sql.append("select count(*) from YW_POPINFO_NEW yw_popinfo where 1 = 1 ");
			if (!StringUtil.isBlank(popQuery.getStartDate())) { // 开始时间
				sql.append(" and yw_popinfo.PPGXTIME >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getEndDate())) { // 结束时间
				sql.append(" and yw_popinfo.PPGXTIME <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdname())) {// 商品名称模糊查询
				sql.append(" and yw_popinfo.PPGDNAME like '%" + popQuery.getPopgdname() + "%' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopmarket())) {// 门店代码
				sql.append(" and yw_popinfo.PPMARKET='" + popQuery.getPopmarket() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPphfyj())) {// 回复意见
				sql.append(" and yw_popinfo.PPHFYJ in (" + popQuery.getPphfyj() + ") ");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdbarcode())) {// 商品条码
				sql.append(" and yw_popinfo.PPGDBARCODE='" + popQuery.getPopgdbarcode() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPpsupid())) { // 供应商编号
				sql.append(" and yw_popinfo.PPSUPID = '").append(popQuery.getPpsupid()).append("'");
			}
			if (!StringUtil.isBlank(popQuery.getSgcode())) { // 实例编码
				sql.append(" and yw_popinfo.PPSGCODE = '").append(popQuery.getSgcode()).append("'");
			}
			if (!StringUtil.isBlank(popQuery.getPpviewstatus())) { // 查看状态
				sql.append(" and yw_popinfo.PPVIEWSTATUS  is  null ");
			}
			List lstSumResult = dao.executeSql(sql.toString());
			log.info("lstResult t111111 :" + lstSumResult);
			log.info("lstResult.size() t1111111 :" + lstSumResult.size());
			int totalCount = 0;
			if (lstSumResult != null) {
				totalCount = Integer.parseInt(((Map) lstSumResult.get(0)).get("COUNT(*)").toString());
			}
			// 查询结果集
			sql.delete(0, sql.length());
			sql = sql.append("select yw_popinfo.POPSEQUECE,yw_popinfo.PPGDID,yw_popinfo.PPGDBARCODE,yw_popinfo.PPGDNAME,yw_popinfo.PPGXTIME,yw_popinfo.PPHFYJ,yw_popinfo.PPCGYJ,yw_popinfo.PPFILE,inf_shop.SHPNAME from INF_SHOP inf_shop,YW_POPINFO_NEW yw_popinfo where inf_shop.SHPCODE = yw_popinfo.PPMARKET and inf_shop.SGCODE = yw_popinfo.PPSGCODE ");
			if (!StringUtil.isBlank(popQuery.getStartDate())) { // 开始时间
				sql.append(" and yw_popinfo.PPGXTIME >= to_date('").append(popQuery.getStartDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getEndDate())) { // 结束时间
				sql.append(" and yw_popinfo.PPGXTIME <= to_date('").append(popQuery.getEndDate()).append("','yyyy-MM-dd')");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdname())) {// 商品名称模糊查询
				sql.append(" and yw_popinfo.PPGDNAME like '%" + popQuery.getPopgdname() + "%' ");
			}
			if (!StringUtil.isBlank(popQuery.getPopmarket())) {// 门店代码
				sql.append(" and yw_popinfo.PPMARKET='" + popQuery.getPopmarket() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPphfyj())) {// 回复意见
				sql.append(" and yw_popinfo.PPHFYJ in (" + popQuery.getPphfyj() + ") ");
			}
			if (!StringUtil.isBlank(popQuery.getPopgdbarcode())) {// 商品条码
				sql.append(" and yw_popinfo.PPGDBARCODE='" + popQuery.getPopgdbarcode() + "' ");
			}
			if (!StringUtil.isBlank(popQuery.getPpsupid())) { // 供应商编号
				sql.append(" and yw_popinfo.PPSUPID = '").append(popQuery.getPpsupid()).append("'");
			}
			if (!StringUtil.isBlank(popQuery.getSgcode())) { // 实例编码
				sql.append(" and yw_popinfo.PPSGCODE = '").append(popQuery.getSgcode()).append("'");
			}
			if (!StringUtil.isBlank(popQuery.getPpviewstatus())) { // 查看状态
				sql.append(" and yw_popinfo.PPVIEWSTATUS is null ");
			}
			sql.append(" order by yw_popinfo.PPGXTIME desc");
			int limit = popQuery.getRows();
			int start = (popQuery.getPage() - 1) * popQuery.getRows();
			List lstResult = dao.executeSql(sql.toString(), start, limit);
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
				result.setTotal(totalCount);
			}
			log.info("lstResult t222222222 :" + lstResult);
			log.info("lstResult.size() t222222222 :" + lstResult.size());
		} catch (Exception ex) {
			log.error("YwPopInfoManagerImpl.popinfoList error:" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	// 供应商递交促销信息申请
	public ReturnObject popInfoApply(Object[] o) {
		ReturnObject result = new ReturnObject();
		StringBuilder sql = new StringBuilder();
		YwPopinfoForm ywPopinfoForm = (YwPopinfoForm) o[0];
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			sql = sql.append("select supinfo.SUPNAME from INF_SUPINFO supinfo where 1 = 1 ");
			if (!StringUtil.isBlank(ywPopinfoForm.getPpsupid())) { // 供应商编号
				sql.append(" and supinfo.SUPID = '").append(ywPopinfoForm.getPpsupid()).append("'");
			}
			if (!StringUtil.isBlank(ywPopinfoForm.getPpsgcode())) { // 实例编码
				sql.append(" and supinfo.SUPSGCODE = '").append(ywPopinfoForm.getPpsgcode()).append("'");
			}
			List lstResult = dao.executeSql(sql.toString());
			String name = null;
			if (lstResult != null) {
				name = ((Map) lstResult.get(0)).get("SUPNAME").toString();
			}
			YwPopinfoNew ywPopinfo = new YwPopinfoNew();
			ywPopinfo.setPpfile(ywPopinfoForm.getPpfile().substring(ywPopinfoForm.getPpfile().lastIndexOf("\\") + 1));
			ywPopinfo.setPpsgcode(ywPopinfoForm.getPpsgcode());// 实例编码
			ywPopinfo.setPpsupid(ywPopinfoForm.getPpsupid());// 供应商编码
			ywPopinfo.setPpgxtime(sdf.parse(sdf.format(new Date())));// 创建日期(timestamp)
			ywPopinfo.setPpgdbarcode(ywPopinfoForm.getPpgdbarcode());// 商品条码
			ywPopinfo.setPpgdname(ywPopinfoForm.getPpgdname());// 商品名称
			ywPopinfo.setPpgdid(ywPopinfoForm.getPpgdid());// 商品编码
			ywPopinfo.setPpmarket(ywPopinfoForm.getPpmarket());// 门店名称
			ywPopinfo.setPpbjrq(sdf.parse(ywPopinfoForm.getPpbjrq()));// 变价日期(date类型)
			ywPopinfo.setPpbjyy(ywPopinfoForm.getPpbjyy());// 促销或变价原因
			ywPopinfo.setPpksrq(sdf.parse(ywPopinfoForm.getPpksrq()));// 变价日期
			ywPopinfo.setPpjsrq(sdf.parse(ywPopinfoForm.getPpjsrq()));// 变价日期
			ywPopinfo.setPpcxsj(ywPopinfoForm.getPpcxsj());// 执行价格
			ywPopinfo.setPpgdyj(ywPopinfoForm.getPpgdyj());// 原价
			ywPopinfo.setPpfile(ywPopinfoForm.getPpfile());// 附件名称
			ywPopinfo.setPphfyj("0");// 0未审核，1审核通过，2审核未通过
			ywPopinfo.setPpsupname(name);
			dao.saveEntity(ywPopinfo); // 添加操作
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception ex) {
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
			log.error("ShopInfoManagerImpl.popInfoApply() error:" + ex.getMessage());
		}
		return result;
	}

	// 供应商查看促销信息详细情况
	public ReturnObject popInfoDet(Object[] o) {
		ReturnObject result = new ReturnObject();
		YwPopinfoForm popinfoDet = (YwPopinfoForm) o[0]; // 查询条件
		StringBuilder sql = new StringBuilder();
		try {
			sql = sql.append("select yw_popinfo.POPSEQUECE,yw_popinfo.PPSUPNAME,yw_popinfo.PPBJRQ,yw_popinfo.PPGDNAME,yw_popinfo.PPKSRQ,yw_popinfo.PPGDID,yw_popinfo.PPJSRQ,yw_popinfo.PPGDBARCODE,yw_popinfo.PPBJYY,inf_shop.SHPNAME,yw_popinfo.PPCXSJ,yw_popinfo.PPGXTIME,yw_popinfo.PPGDYJ,yw_popinfo.PPFILE,yw_popinfo.PPHFYJ,yw_popinfo.PPCGYJ from INF_SHOP inf_shop,YW_POPINFO_NEW yw_popinfo,INF_SUPINFO inf_supinfo where inf_shop.SHPCODE = yw_popinfo.PPMARKET and inf_supinfo.SUPID = yw_popinfo.PPSUPID ");
			if (!StringUtil.isBlank(popinfoDet.getId())) {// 商品序号
				sql.append(" and yw_popinfo.POPSEQUECE='" + popinfoDet.getId() + "' ");
			}
			List lstResult = dao.executeSql(sql.toString());
			if (lstResult != null) {
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
			}
			log.info("lstResult t1 :" + lstResult);
			log.info("lstResult.size() t1 :" + lstResult.size());
			
			if(user.getSutype()=='S'){
			StringBuffer stusql=new StringBuffer("UPDATE YW_POPINFO_NEW SET PPVIEWSTATUS = 'readed' where 1=1 ");
			if (!StringUtil.isBlank(popinfoDet.getId())) {// 商品序号
				stusql.append(" and POPSEQUECE='" + popinfoDet.getId() + "' ");
			}
			stusql.append(" AND PPHFYJ IN (1,2)");
			log.info("修改供应商变价申请状态："+stusql.toString());
			dao.updateSql(stusql.toString());
			}else 	if(user.getSutype()=='L'){	
				StringBuffer stusql=new StringBuffer("UPDATE YW_POPINFO_NEW SET PPVIEWSTATUS = 'readed' where 1=1 ");
			if (!StringUtil.isBlank(popinfoDet.getId())) {// 商品序号
				stusql.append(" and POPSEQUECE='" + popinfoDet.getId() + "' ");
			}
			stusql.append(" AND PPHFYJ IN (0)");
			log.info("修改零售商变价申请状态："+stusql.toString());
			dao.updateSql(stusql.toString());
			}		

		} catch (Exception ex) {
			log.error("YwPopInfoManagerImpl.popInfoDet error:" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}
 
}
