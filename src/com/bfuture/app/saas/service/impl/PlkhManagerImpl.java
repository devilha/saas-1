package com.bfuture.app.saas.service.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.providers.encoding.PasswordEncoder;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.InfSupinfo;
import com.bfuture.app.saas.model.Plkh;
import com.bfuture.app.saas.model.report.SaleReport;
import com.bfuture.app.saas.model.report.Stock;
import com.bfuture.app.saas.service.PlkhManager;

/**
 * 批量开户
 * 
 * @author Chenjw
 * 
 */
public class PlkhManagerImpl extends BaseManagerImpl implements PlkhManager {

	protected final Log log = LogFactory.getLog(PlkhManagerImpl.class);

	private PasswordEncoder passwordEncoder;

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	public void setDao(UniversalAppDao dao) {
		this.dao = dao;
	}

	public PlkhManagerImpl() {
		if (this.dao == null) {
			this.dao = (UniversalAppDao) getSpringBean("universalAppDao");
		}
	}

	public ReturnObject ExecOther(String actionType, Object[] o) {

		ReturnObject result = new ReturnObject();
		// 查询角色信息
		if ("getRoleInfo".equals(actionType)) {
			InfSupinfo supinfo = (InfSupinfo) o[0]; // 查询条件
			try {
				StringBuffer sql = new StringBuffer(
						"SELECT RLCODE,RLNAME FROM sys_role WHERE RLTYPE='S' AND RLFLAG='Y' ");

				if (!StringUtil.isBlank(supinfo.getSupsgcode())) {
					log.debug("supinfo.getSupsgcode(): "
							+ supinfo.getSupsgcode());
					sql.append(" and sgcode = '")
							.append(supinfo.getSupsgcode()).append("'");
				}

				log.info(sql);
				List lstResult = dao.executeSql(sql.toString());
				log.debug("PlkhManagerImpl.getRoleInfo() lstResult 1 :"
						+ lstResult);
				if (lstResult != null) {
					log
							.debug("PlkhManagerImpl.getRoleInfo() lstResult.size() 1 :"
									+ lstResult.size());
					result.setReturnCode(Constants.SUCCESS_FLAG);
					result.setRows(lstResult);
				}
			} catch (Exception ex) {
				log.error("PlkhManagerImpl.getRoleInfo() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		} else if ("plkh".equals(actionType)) {
			Plkh plkh = (Plkh) o[0]; // 查询条件
			try {
				//开户
				StringBuffer openUserSql = new StringBuffer("INSERT INTO SYS_SCMUSER(SUCODE,SUNAME,SUPWD,SUTEL,SUTYPE,SUENABLE,SGCODE,SUPCODE,CRTTIME) SELECT SUPSGCODE||SUPID,SUPNAME");
				if (!StringUtil.isBlank(plkh.getPassword())) {
					log.debug("plkh.getPassword(): "
							+ plkh.getPassword());
					openUserSql.append(",'").append(encoder(plkh.getPassword())).append("'");
				}
				openUserSql.append(",supcontphone,'S','Y',supsgcode,supid,sysdate from inf_supinfo where 1=1 ");
				if(!StringUtil.isBlank(plkh.getSgcode())){
					log.debug("plkh.getSgcode():"+plkh.getSgcode());
					openUserSql.append(" and supsgcode='").append(plkh.getSgcode()).append("'");
				}
				if(!StringUtil.isBlank(plkh.getSupcodes())){
					log.debug("plkh.getSupcodes():"+plkh.getSupcodes());
					openUserSql.append(" and supid in(").append(plkh.getSupcodes()).append(")");
				}
				log.info("openUserSql:"+openUserSql.toString());
				dao.updateSql(openUserSql.toString());
				//用户到期时间区间
				StringBuffer dateUserSql = new StringBuffer("INSERT INTO SYS_SCMUSERDAYS(SGCODE,SUCODE,BEGINDDATE,ENDDATE,ISSETMD) SELECT SGCODE,SUCODE ");
				if(!StringUtil.isBlank(plkh.getStartDate())){
					log.debug("plkh.getStartDate():"+plkh.getStartDate());
					dateUserSql.append(",to_date('").append(plkh.getStartDate()).append("','yyyy-MM-dd')");
				}
				if(!StringUtil.isBlank(plkh.getEndDate())){
					log.debug("plkh.getEndDate():"+plkh.getEndDate());
					dateUserSql.append(",to_date('").append(plkh.getEndDate()).append("','yyyy-MM-dd')");
				}
				if(!StringUtil.isBlank(plkh.getIsSetMd())){
					log.debug("plkh.getIsSetMd():"+plkh.getIsSetMd());
					dateUserSql.append(",'").append(plkh.getIsSetMd()).append("'");
				}
				dateUserSql.append(" from SYS_SCMUSER where 1=1 ");
				if(!StringUtil.isBlank(plkh.getSgcode())){
					log.debug("plkh.getSgcode():"+plkh.getSgcode());
					dateUserSql.append(" and SGCODE='").append(plkh.getSgcode()).append("'");
				}
				if(!StringUtil.isBlank(plkh.getSupcodes())){
					log.debug("plkh.getSupcodes():"+plkh.getSupcodes());
					dateUserSql.append(" and SUPCODE in(").append(plkh.getSupcodes()).append(")");
				}
				log.info("dateUserSql:"+dateUserSql.toString());
				dao.updateSql(dateUserSql.toString());
				//用户挂角色
				StringBuffer userRoleSql = new StringBuffer("INSERT INTO sys_surl(SUCODE,SGCODE,RLCODE) SELECT SUCODE,SGCODE ");
				if(!StringUtil.isBlank(plkh.getRlcode())){
					log.debug("plkh.getRlcode():"+plkh.getRlcode());
					userRoleSql.append(",'").append(plkh.getRlcode()).append("'");
				}
				userRoleSql.append(" from sys_scmuser where 1=1 ");
				if(!StringUtil.isBlank(plkh.getSgcode())){
					userRoleSql.append(" and sgcode='").append(plkh.getSgcode()).append("'");
				}
				if(!StringUtil.isBlank(plkh.getSupcodes())){
					userRoleSql.append(" and supcode in(").append(plkh.getSupcodes()).append(")");
				}
				log.info("userRolesql:"+userRoleSql.toString());
				dao.updateSql(userRoleSql.toString());
				result.setReturnCode(Constants.SUCCESS_FLAG);
			} catch (Exception ex) {
				log.error("PlkhManagerImpl.plkh() error : "
						+ ex.getMessage());
				result.setReturnCode(Constants.ERROR_FLAG);
				result.setReturnInfo(ex.getMessage());
			}
		}
		return result;
	}

	// 查询未开户供应商信息
	@Override
	public ReturnObject getResult(Object o) {
		ReturnObject result = new ReturnObject();

		try {
			InfSupinfo supinfo = (InfSupinfo) o; // 查询条件

			StringBuffer countSql = new StringBuffer(
					"select count(*) from (select SUPID,SUPNAME,SUPCONT,SUPCONTPHONE,SUPCONTEMAIL,SUPDUTYNO,SUPFAX,SUPBANK,SUPZIP,SUPADD from inf_supinfo a where 1=1  ");

			if (!StringUtil.isBlank(supinfo.getSupsgcode())) {
				log.debug("supinfo.getSupsgcode(): " + supinfo.getSupsgcode());
				countSql
						.append(" and supsgcode='")
						.append(supinfo.getSupsgcode())
						.append("'")
						.append(
								" and not exists (select supcode from sys_scmuser b where a.supid=b.supcode and sgcode='")
						.append(supinfo.getSupsgcode()).append("') ");
			}
			if (!StringUtil.isBlank(supinfo.getSupid())) {
				log.debug("supinfo.getSupid(): " + supinfo.getSupid());
				countSql.append(" and SUPID = '").append(supinfo.getSupid())
						.append("'");
			}
			if (!StringUtil.isBlank(supinfo.getSupname())) {
				log.debug("supinfo.getSupname(): " + supinfo.getSupname());
				countSql.append(" and SUPNAME like '%").append(
						supinfo.getSupname()).append("%' ");
			}
			countSql.append(") COUNT");

			log.info("queryNoOpenUserSupinfoCountSql: " + countSql);
			List lstResult = dao.executeSqlCount(countSql.toString());
			log.debug("PlkhManagerImpl.getResult() lstResult : " + lstResult);

			if (lstResult != null) {
				log
						.debug("PlkhManagerImpl.getResult() lstResult.get(0).toString() : "
								+ lstResult.get(0).toString());
				result.setTotal(Integer.parseInt(lstResult.get(0).toString()));
			}

			StringBuffer sql = new StringBuffer(
					"select SUPID,SUPNAME,SUPCONT,SUPCONTPHONE,SUPCONTEMAIL,SUPDUTYNO,SUPFAX,SUPBANK,SUPZIP,SUPADD from inf_supinfo a where 1=1 ");
			int limit = supinfo.getRows();
			log.debug("limit: " + limit);
			int start = (supinfo.getPage() - 1) * supinfo.getRows();
			log.debug("start: " + start);
			if (!StringUtil.isBlank(supinfo.getSupsgcode())) {
				log.debug("supinfo.getSupsgcode(): " + supinfo.getSupsgcode());
				sql
						.append(" and supsgcode='")
						.append(supinfo.getSupsgcode())
						.append("'")
						.append(
								" and not exists (select supcode from sys_scmuser b where a.supid=b.supcode and sgcode='")
						.append(supinfo.getSupsgcode()).append("') ");
			}
			if (!StringUtil.isBlank(supinfo.getSupid())) {
				log.debug("supinfo.getSupid(): " + supinfo.getSupid());
				sql.append(" and SUPID = '").append(supinfo.getSupid()).append(
						"'");
			}
			if (!StringUtil.isBlank(supinfo.getSupname())) {
				log.debug("supinfo.getSupname(): " + supinfo.getSupname());
				sql.append(" and SUPNAME like '%").append(supinfo.getSupname())
						.append("%' ");
			}
			sql.append(" order by supid");
			log.info("queryNoOpenUserSupinfoSql: " + sql);
			lstResult = dao.executeSql(sql.toString(), start, limit);
			log.debug("PlkhManagerImpl.getResult() lstResult 1 :" + lstResult);
			if (lstResult != null) {
				log.debug("PlkhManagerImpl.getResult() lstResult.size() :"
						+ lstResult.size());
				result.setReturnCode(Constants.SUCCESS_FLAG);
				result.setRows(lstResult);
			}
		} catch (Exception ex) {
			log.error("PlkhManagerImpl.getResult() error :" + ex.getMessage());
			result.setReturnCode(Constants.ERROR_FLAG);
			result.setReturnInfo(ex.getMessage());
		}
		return result;
	}

	/**
	 * 密码加密
	 * 
	 * @param passWord
	 * @return
	 */
	public String encoder(String passWord) {
		return passwordEncoder.encodePassword(passWord, null);
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}
}
