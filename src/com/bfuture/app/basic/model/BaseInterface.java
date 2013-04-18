package com.bfuture.app.basic.model;

import java.sql.Timestamp;
import java.util.Date;
import java.sql.Time;

public interface BaseInterface {
	
	/**
	 * 初始化当前用户编码
	 * @param userCode	当前用户编码
	 * @param actionType	操作方式
	 */
	public void initCurrentUser( String userCode, String actionType );
	
	/**
	 * 初始化当前实例编码
	 * @param insC	当前实例编码
	 * @param actionType	操作方式
	 */
	public void initCurrentIns( String insC, String actionType );
	
	/**
	 * 初始化部门编码
	 * @param orgC	部门编码	
	 * @param actionType	操作方式
	 */
	public void initCurrentOrg( String orgC, String actionType );
	
	/**
	 * 初始化企业编码
	 * @param entC	企业编码
	 * @param actionType	操作方式
	 */
	public void initCurrentEnt( String entC, String actionType );
	
	/**
	 * 初始化当前时间
	 * @param timestamp		当前时间
	 * @param actionType	操作方式 
	 */
	public void initCurrentTime( Time time, String actionType );
	
	/**
	 * 初始化当前日期
	 * @param date	当前日期
	 * @param actionType	操作方式 
	 */
	public void initCurrentDate( Date date, String actionType );
	
	/**
	 * 初始化当前时间
	 * @param timestamp	当前时间
	 * @param actionType	操作方式 
	 */
	public void initCurrentTimestamp( Timestamp timestamp, String actionType );
	
	/**
	 * 初始化自动增长/序列ID
	 * @param lid	序列ID
	 * @param actionType	操作方式 
	 */
	public void initAuto( Integer lid, String actionType );
	
	/**
	 * 初始化随机数
	 * @param random	随机数
	 * @param actionType	操作方式 
	 */
	public void initRandomNum( String random, String actionType );
	
	/**
	 * 初始化单据编码
	 * @param build		单据编码
	 * @param actionType	操作方式
	 */
	public void initBuild( String build, String actionType );
	
	/**
	 * 获取单据类型，非单据的商业对象返回NULL
	 * @return		单据类型
	 */
	public String getBillType();
	
	/**
	 * 获取是否先保存，
	 * @return	返回值为TRUE，表示由数据库获取ID，返回值为FALSE，表示由JAVA程序获取ID
	 */
	public boolean getFirstSave();
	
	/**
	 * 获取生成的自动序号
	 * @return	自动序号
	 */
	public Integer getAuto();
	
	/**
	 * 获取随机数
	 * @return	随机数
	 */
	public String getRandomNum();
	
	/**
	 * 获取单据编码
	 * @return	单据编码
	 */
	public String getBuild();
	
	/**
	 * 初始化表头自动序号
	 * @param lid	表头自动序号
	 * @param actionType	操作类型
	 */
	public void initSupAuto( Integer lid, String actionType  );
	
	/**
	 * 初始化表头随机数
	 * @param random	表头随机数
	 * @param actionType	操作类型
	 */
	public void initSupRandom( String random, String actionType );
	
	/**
	 * 初始化表头单据编码
	 * @param build		表头单据编码
	 * @param actionType	操作类型
	 */
	public void initSupBuild( String build, String actionType );
	
	/**
	 * 获取对象的ID的值
	 * @return	对象的ID的值
	 */
	public Object getObjectId();
}
