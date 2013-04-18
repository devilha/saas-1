package com.bfuture.app.basic.util.xml;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import com.bfuture.app.basic.model.BaseObject;




public class ConversionUtils {
	public static final short GOAL = 1;
	public static final short SOURCE = 2;
	private static final String GET = "get", SET = "set";
	private static final String DBGET = "dbget", DBSET = "dbset";
	private static final String BEANFLAG = "Object",
		VECTORFLAG = "Vector",
		SETFLAG = "Set",
		SIGNFLAG = "&";
	private static final String LISTFLAG = "List_";
	private static final String NULLFLAG = "0xde0xle0xte";
	private static final String DoubleNullFlag = "999999999999";
	private static final String BigDecimalNullFlag = "999999999999";
	/**
	 * ConversionUtils 构造子注解。
	 */
	private ConversionUtils() {
		super();
	}
	

	public static Vector convertArrayToVector(Object[] objs) {
		Vector vec = null;
		if (objs != null)
			vec = new Vector();
		for (int i = 0; i < objs.length; i++) {
			vec.addElement(objs[i]);
		}
		return vec;
	}
	
	
	
	
	

	public static Object[] unionArray(Object[] aobjs, Object[] bobjs) {
		Vector vec = null;
		if ((aobjs != null) || (bobjs != null))
			vec = new Vector();
		if (aobjs != null)
			for (int i = 0; i < aobjs.length; i++) {
				vec.addElement(aobjs[i]);
			}
		if (bobjs != null)
			for (int i = 0; i < bobjs.length; i++) {
				vec.addElement(bobjs[i]);
			}
		return vec.toArray();
	}

	public static void copyAttribute(Object goal, Object source)
		throws
			NoSuchMethodException,
			IllegalAccessException,
			InvocationTargetException,
			Exception {

        PropertyDescriptor[] props = null;
        try {
            props = Introspector.getBeanInfo(goal.getClass(), Object.class).getPropertyDescriptors();
        } catch (IntrospectionException e) {
        }
        if (props != null) {
            for (int i = 0; i < props.length; i++) {
            		//try {
                        String name = props[i].getName();
                        Object value = props[i].getReadMethod().invoke(source);
                        
        				if (value == null)
        					continue;
        				

        				value=convertNullFlagToNull(value);
                        try {
							props[i].getWriteMethod().invoke(goal, value);
						} catch (RuntimeException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

                   // } catch (Exception e) {
                   // }
            	
                
            }
         
        }		
		
		
	
	}

	public static void convertAttribute(Object goal, Object source, short type)
		throws
			NoSuchMethodException,
			IllegalAccessException,
			InvocationTargetException,
			Exception {

		String methodName = null;
		Method goalMethod = null;
		Method sourceMethod = null;
		Object result = null;

		Class goalClass = goal.getClass();
		Class sourceClass = source.getClass();

		Method[] methods = null;
		switch (type) {
			case GOAL :
				methods = goalClass.getMethods();
				break;
			case SOURCE :
			default :
				methods = sourceClass.getMethods();
				break;
		}

		for (int i = 0; i < methods.length; i++) {
			methodName = methods[i].getName();
			if (methodName.startsWith(SET) ) {
				 sourceMethod = null;
				 result = null;				
				
				try {
					sourceMethod =
						sourceClass.getMethod(GET + methodName.substring(3), null);
					result = sourceMethod.invoke(source, null);
				} catch (RuntimeException e) {
					
					e.printStackTrace();
				}
				
				if (result == null)
					continue;
				
				//liyj update substring(0, 1).toLowerCase()
				result=convertNullFlagToNull(result);
				
				//BeanUtils.copyProperty(goal, methodName.substring(3, 4).toLowerCase()+methodName.substring(4), result);
				
				try {
					goalMethod =
						goalClass.getMethod(
							methodName,
							convertToNeedType(new Class[] { result.getClass()}));
					goalMethod.invoke(goal, new Object[] { result });
				} catch (RuntimeException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}



		}
	}

	public static Vector convertBeanToVector(Object bean)
		throws
			NoSuchMethodException,
			IllegalAccessException,
			InvocationTargetException,
			Exception {
		if (bean == null)
			return null;

		Vector vecColumn = new Vector();

		String methodName = null;
		Method method = null;
		String fieldName = null;
		String listName = null;
		Object fieldValue = null;

		Class beanClass = bean.getClass();
		Method[] methods = beanClass.getMethods();

		for (int i = 0; i < methods.length; i++) {
			methodName = methods[i].getName();
			if (methodName.startsWith(SET)) {

				fieldName = methodName.substring(3);
				try {
					method = beanClass.getMethod(GET + fieldName, null);
				} catch (NoSuchMethodException e) {
					throw new NoSuchMethodException(GET + fieldName);
				}

				fieldValue = method.invoke(bean, null);
				if (fieldValue == null)
					continue;

				if (methodName.endsWith(SETFLAG)) {
					Iterator it = ((Set) fieldValue).iterator();
					while(it.hasNext()){
						vecColumn.addElement(fieldName);
						vecColumn.addElement(convertBeanToVector(it.next()));
					}
				} else {
					vecColumn.addElement(fieldName);
					try {
						method = beanClass.getMethod(GET + fieldName, null);
					} catch (NoSuchMethodException e) {
						throw new NoSuchMethodException(GET + fieldName);
					}
					Object temp = method.invoke(bean, null);
					if (Date.class.isInstance(temp)){
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						vecColumn.addElement(sdf.format(temp));
					}
					if( String.class.isInstance( temp ) ){
						vecColumn.addElement(  (String)temp );
					}
					else
					{
						vecColumn.addElement(method.invoke(bean, null));
					}
				}
			}

		}

		return vecColumn.size() == 0 ? null : vecColumn;
	}

	public static Vector convertBeanTypeToVector(Object bean)
		throws
			InvocationTargetException,
			IllegalAccessException,
			NoSuchMethodException,
			NoSuchFieldException,
			Exception {
		if (bean == null)
			return null;

		Vector vecColumn = new Vector();

		String methodName = null;
		Method method = null;
		String fieldName = null;
		String fieldType = null;
		Object fieldValue = null;

		Class beanClass = bean.getClass();
		Method[] methods = beanClass.getMethods();
		Class superClass = beanClass.getSuperclass();

		for (int i = 0; i < methods.length; i++) {
			methodName = methods[i].getName();
			if (methodName.startsWith(SET)) {

				fieldName = methodName.substring(3);
				method = beanClass.getMethod(GET + fieldName, null);
				fieldValue = method.invoke(bean, null);
				if (fieldValue == null)
					continue;

				vecColumn.addElement(fieldName);
				//1.尾bean
				//2.尾Vector
				//3.其余基本属性
				if (methodName.endsWith(BEANFLAG)) {
					vecColumn.addElement(convertBeanTypeToVector(fieldValue));
				} else if (methodName.endsWith(VECTORFLAG)) {
					for (int j = 0; j < ((Vector) fieldValue).size(); j++) {
						vecColumn.addElement(
							convertBeanTypeToVector(
								((Vector) fieldValue).elementAt(j)));
						if (j < ((Vector) fieldValue).size() - 1)
							vecColumn.addElement(fieldName);
					}
				} else {
					method = beanClass.getMethod(GET + fieldName, null);
					vecColumn.addElement(method.invoke(bean, null));
					fieldType =
						superClass
							.getDeclaredField(
								fieldName.substring(0, 1).toLowerCase()
									+ fieldName.substring(1))
							.getType()
							.getName();
					vecColumn.addElement(fieldType);
				}
			}

			// 针对数据库字段的取值和赋值

			if (methodName.startsWith(DBSET)) {
				fieldName = methodName.substring(5);
				try {
					method = beanClass.getMethod(DBGET + fieldName, null);
				} catch (NoSuchMethodException e) {
					throw new NoSuchMethodException(DBGET + fieldName);
				}

				fieldValue = method.invoke(bean, null);
				if (fieldValue == null)
					continue;

				vecColumn.addElement(fieldName);

				if (methodName.endsWith(BEANFLAG)) {
					vecColumn.addElement(convertBeanToVector(fieldValue));
				} else if (methodName.endsWith(VECTORFLAG)) {
					for (int j = 0; j < ((Vector) fieldValue).size(); j++) {
						vecColumn.addElement(
							convertBeanToVector(
								((Vector) fieldValue).elementAt(j)));
						if (j < ((Vector) fieldValue).size() - 1)
							vecColumn.addElement(fieldName);
					}
				} else {
					try {
						method = beanClass.getMethod(DBGET + fieldName, null);
					} catch (NoSuchMethodException e) {
						throw new NoSuchMethodException(DBGET + fieldName);
					}
					vecColumn.addElement(method.invoke(bean, null));
				}
			}
		}

		return vecColumn.size() == 0 ? null : vecColumn;
	}

	private static Object convertNullFlagToNull(Object object) {
		Object resultObj = null;
		resultObj = object;
		if (object == null)
			return resultObj;
		Class cls = object.getClass();
		if (cls.equals(int.class)
			&& ((java.lang.Integer) object).equals(
				new java.lang.Integer(java.lang.Integer.MIN_VALUE))) {
			resultObj = null;
		}else if (
			cls.equals(String.class)
				&& (object.toString().equalsIgnoreCase(NULLFLAG))) {
			resultObj = null;
		}
		else if (
			cls.equals(Integer.class)
				&& ((java.lang.Integer) object).equals(
					new java.lang.Integer(java.lang.Integer.MIN_VALUE))) {
			resultObj = null;
		} else if (
			cls.equals(double.class)
				&& ((java.lang.Double) object).equals(
					new java.lang.Double(DoubleNullFlag))) {
			resultObj = null;
		} else if (
			cls.equals(short.class)
				&& ((java.lang.Short) object).equals(
					new java.lang.Short(java.lang.Short.MIN_VALUE))) {
			resultObj = null;
		} else if (
			cls.equals(BigDecimal.class)
				&& ((java.math.BigDecimal) object).equals(
					new java.math.BigDecimal(BigDecimalNullFlag))) {
			resultObj = null;
		} else if (
			cls.equals(Date.class)
				&& ((java.util.Date) object).equals(new java.util.Date(0))) {
			resultObj = null;
		} else if (
			cls.equals(Time.class)
				&& ((java.sql.Time) object).equals(
					new java.sql.Time(java.lang.Long.MIN_VALUE))) {
			resultObj = null;
		} else if (
			cls.equals(Timestamp.class)
				&& ((java.sql.Timestamp) object).equals(
					new java.sql.Timestamp(0))) {
			resultObj = null;
		} 
		return resultObj;
	}


	public static boolean ifNull(Object object) {
		return convertNullFlagToNull(object)== null;
	}

	
	public static Object[] convertResultSetToVectorArry(ResultSet rs)
		throws SQLException, Exception {

		if (rs == null)
			return null;

		Vector allRowVec = new Vector();
		String fieldName = null;
		String fieldValue = null;

		ResultSetMetaData meta = rs.getMetaData();
		int count = meta.getColumnCount();

		while (rs.next()) {
			Vector oneRowVec = new Vector();
			for (int i = 1; i <= count; i++) {
				fieldName = meta.getColumnName(i).toLowerCase();
				fieldName =
					fieldName.substring(0, 1).toUpperCase()
						+ fieldName.substring(1).toLowerCase();
				fieldValue = rs.getString(i);
				if (fieldValue != null) {
					oneRowVec.addElement(fieldName);
					oneRowVec.addElement(fieldValue);
				}
			}
			allRowVec.addElement(oneRowVec);
			oneRowVec = null;
		}

		return allRowVec.size() == 0 ? null : allRowVec.toArray();
	}
	
	public static Class[] convertToNeedType(Class[] argsType) {
		if (argsType == null)
			return null;

		int needLength = argsType.length;
		Class[] convertType = new Class[needLength];

		for (int i = 0; i < needLength; i++) {
			if (argsType[i].equals(Boolean.class))
				convertType[i] = boolean.class;
			else if (argsType[i].equals(Byte.class))
				convertType[i] = byte.class;
			else if (argsType[i].equals(Double.class))
				convertType[i] = double.class;
			else if (argsType[i].equals(Integer.class))
				convertType[i] = Integer.class;
			else if (argsType[i].equals(Short.class))
				convertType[i] = short.class;
			else if (argsType[i].equals(HashSet.class))
				convertType[i] = Set.class;
			else if (argsType[i].equals(java.sql.Time.class))
				convertType[i] = java.util.Date.class;
			else if (argsType[i].equals(java.sql.Timestamp.class))
				convertType[i] = java.util.Date.class;

			else
				convertType[i] = argsType[i];
		}

		return convertType;
	}
	
	private static Object[] convertToNeedTypeNullValue(Class argsType) {
		if (argsType == null)
			return null;

		Object[] convertTypeValue = new Object[1];

		if (argsType.equals(int.class))
			convertTypeValue[0] =
				new java.lang.Integer(java.lang.Integer.MIN_VALUE);
		else if (argsType.equals(Integer.class))
			convertTypeValue[0] =
				new java.lang.Integer(java.lang.Integer.MIN_VALUE);
		else if (argsType.equals(double.class))
			convertTypeValue[0] = new java.lang.Double(DoubleNullFlag);
		else if (argsType.equals(short.class))
			convertTypeValue[0] =
				new java.lang.Short(java.lang.Short.MIN_VALUE);
		else if (argsType.equals(BigDecimal.class))
			convertTypeValue[0] = new java.math.BigDecimal(BigDecimalNullFlag);
		else if (argsType.equals(Date.class))
			convertTypeValue[0] = new java.util.Date(0);
		else if (argsType.equals(Time.class))
			convertTypeValue[0] = new java.sql.Time(java.lang.Long.MIN_VALUE);
		else if (argsType.equals(Timestamp.class))
			convertTypeValue[0] = new java.sql.Timestamp(0);
		else
			convertTypeValue[0] = NULLFLAG;

		return convertTypeValue;
	}
	
	private static Object[] convertToNeedTypeValue(
		Class argsType,
		String argsValue) {
		if (argsType == null || argsValue == null)
			return null;

		Object[] convertTypeValue = new Object[1];

		if (argsType.equals(int.class))
			convertTypeValue[0] = Integer.valueOf(argsValue);
		else if (argsType.equals(String.class)){
			
			convertTypeValue[0] = argsValue;
			
		}
		else if (argsType.equals(Integer.class))
			convertTypeValue[0] = new Integer(new Float(argsValue).intValue());
		else if (argsType.equals(Double.class))
			convertTypeValue[0] = Double.valueOf(argsValue);
		else if (argsType.equals(short.class))
			convertTypeValue[0] = Short.valueOf(argsValue);
		else if (argsType.equals(Long.class))
			convertTypeValue[0] = new Long(argsValue);
		else if (argsType.equals(BigDecimal.class))
			convertTypeValue[0] = new BigDecimal(argsValue);
		//sql.Date
		else if (argsType.equals(java.sql.Date.class))
			convertTypeValue[0] = java.sql.Date.valueOf(argsValue);
		else if (argsType.equals(java.util.Date.class)){
			if (argsValue.indexOf("/") != -1){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
				try {
					convertTypeValue[0] = sdf.parse(argsValue);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					System.err.println("--------------转换为util.date时 发生错误 ：  "+argsValue);
					e.printStackTrace();
				}
			}else{
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				try {
					convertTypeValue[0] = sdf.parse(argsValue);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					System.err.println("--------------转换为'/'型斜杠型util.date时 发生错误 ：  "+argsValue);
					e.printStackTrace();
				}
			}
			
		
		}
		else if (argsType.equals(Time.class))
			convertTypeValue[0] = Time.valueOf(argsValue);
		else if (argsType.equals(Timestamp.class))
			convertTypeValue[0] = Timestamp.valueOf(argsValue);
		else
			convertTypeValue[0] = argsValue;

		return convertTypeValue;
	}
	
	@Deprecated
	public static BaseObject convertVectorToBean(
		String beanName,
		Vector vecBean)
		throws
			ClassNotFoundException,
			InstantiationException,
			InvocationTargetException,
			IllegalAccessException,
			NoSuchMethodException,
			NoSuchFieldException,
			Exception {

		if (beanName == null || vecBean == null || vecBean.size() == 0)
			return null;

		Class beanClass = Class.forName(beanName);
		BaseObject bean = (BaseObject) beanClass.newInstance();
		String fieldName = null;
		Method method = null;
		Field field = null;

		String methodName = "";
		String setMethodName = "";
		String dbSetMethodName = "";

		Object fieldBeanValue = null;

		Vector vectorBean = null;
		String vectorBeanType = null;
		Method vectorMethod = null;
		String vectorBeanName = "";
		Vector updateFields = null;

		for (int i = 0; i < vecBean.size(); i += 2) {
			//字段名
			fieldName = (String) vecBean.elementAt(i);

			if (fieldName.indexOf("Keys") == -1) {

				//若字段为bean 或 vector
				if (fieldName.endsWith(BEANFLAG)
					|| fieldName.endsWith(VECTORFLAG)) {
					//形如：com.efuture.vdrp.bo.inv.item.catalog.bean.ItemCatalogValueBean&valueVector
					//packName&nodeName
					if (fieldName.indexOf(SIGNFLAG) > 0) {
						//vector元素的类型
						vectorBeanType =
							fieldName.substring(0, fieldName.indexOf(SIGNFLAG));
						//vector字段名
						fieldName =
							fieldName.substring(
								fieldName.indexOf(SIGNFLAG) + 1);
					}
				}

				//取字段类型
				field = getField(beanClass, fieldName);

				//字段名首字母大写，在方法中调用。
				fieldName =
					fieldName.substring(0, 1).toUpperCase()
						+ fieldName.substring(1);

				//根据字段名，找到匹配的SET方法名，并得到方法返回类型        
				Method[] methods = beanClass.getMethods();
				for (int j = 0; j < methods.length; j++) {
					methodName = methods[j].getName();
					setMethodName = SET + fieldName;
					dbSetMethodName = DBSET + fieldName;
					if (methodName.equals(setMethodName)) {
						method =
							beanClass.getMethod(
								SET + fieldName,
								new Class[] { field.getType()});
						break;
					}
					if (methodName.equals(dbSetMethodName)) {
						//将数据库字段增加到要更新的vector中
						if (updateFields == null)
							updateFields = new Vector();
						updateFields.addElement(fieldName.toLowerCase());
						method =
							beanClass.getMethod(
								DBSET + fieldName,
								new Class[] { field.getType()});
						break;
					}
				}

				//如果字段为vector类型
				if (fieldName.endsWith(VECTORFLAG)) {

					if (vectorBean == null) {
						vectorBean = new Vector();
						vectorMethod = method;
						vectorBeanName = fieldName;
					}
					if (vectorBeanName.equals(fieldName)) {
						fieldBeanValue =
							convertVectorToBean(
								vectorBeanType,
								(Vector) vecBean.elementAt(i + 1));
						vectorBean.addElement(fieldBeanValue);
					} else {
						vectorMethod.invoke(bean, new Object[] { vectorBean });
						//当连续的不同Vector
						//重置
						vectorBean = new Vector();
						vectorMethod = method;
						vectorBeanName = fieldName;

						fieldBeanValue =
							convertVectorToBean(
								vectorBeanType,
								(Vector) vecBean.elementAt(i + 1));
						vectorBean.addElement(fieldBeanValue);
					}
				} else {

					if (vectorBean != null) {
						vectorMethod.invoke(bean, new Object[] { vectorBean });
						vectorBean = null;
					}

					if (fieldName.endsWith(BEANFLAG)) {
						fieldBeanValue =
							convertVectorToBean(
								field.getType().getName(),
								(Vector) vecBean.elementAt(i + 1));
						method.invoke(bean, new Object[] { fieldBeanValue });
					} else
						try {
							if (vecBean.elementAt(i + 1) != null) {
								method.invoke(
									bean,
									convertToNeedTypeValue(
										field.getType(),
										(String) vecBean.elementAt(i + 1)));
							}
						} catch (Exception e) {
							throw new Exception("Type of " + field + " convert Error");
							//System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~Type of " + field + "Is Error");
							//e.printStackTrace();
						}
				}

			}
		}

		if (vectorBean != null)
			vectorMethod.invoke(bean, new Object[] { vectorBean });
		//if (updateFields != null) {
		//	bean.setUpdateField(updateFields);
		//}

		return bean;
	}

	
	public static BaseObject convertVectorToBeanFlagNull(
		String beanName,
		Vector vecBean)
		throws
			ClassNotFoundException,
			InstantiationException,
			InvocationTargetException,
			IllegalAccessException,
			NoSuchMethodException,
			NoSuchFieldException,
			Exception {

		if (beanName == null || vecBean == null || vecBean.size() == 0)
			return null;
		
		

		Class beanClass = Class.forName(beanName);
		BaseObject bean = (BaseObject) beanClass.newInstance();
		String fieldName = null;
		Method method = null;
		Field field = null;

		String methodName = "";
		String setMethodName = "";
		String dbSetMethodName = "";

		Object fieldBeanValue = null;

		Set setBean = null;
		String vectorBeanType = null;
		Method vectorMethod = null;
		String vectorBeanName = "";
		//Vector updateFields = null;
		boolean isSet=false;

		for (int i = 0; i < vecBean.size(); i += 2) {
			isSet=false;
			//字段名
			fieldName = (String) vecBean.elementAt(i);

			if (fieldName.indexOf("Keys") == -1) {

				//若字段为bean 或 vector
				if (fieldName.endsWith(BEANFLAG)
					|| fieldName.endsWith(SETFLAG)) {
					//形如：com.efuture.vdrp.bo.inv.item.catalog.bean.ItemCatalogValueBean&valueVector
					//packName&nodeName
					if (fieldName.indexOf(SIGNFLAG) > 0) {
						//vector元素的类型
						vectorBeanType =
							fieldName.substring(0, fieldName.indexOf(SIGNFLAG));
						//vector字段名
						fieldName =
							fieldName.substring(
								fieldName.indexOf(SIGNFLAG) + 1,fieldName.length());
					}
				
					isSet=true;
				}

				//取字段类型
				try {
					field = getField(beanClass, fieldName);
				} catch (Exception e) {
				System.out.println("没有这个方法名"+fieldName);
				throw e;
					// TODO: handle exception
				}
				

				//字段名首字母大写，在方法中调用。
				fieldName =
					fieldName.substring(0, 1).toUpperCase()
						+ fieldName.substring(1);

				//根据字段名，找到匹配的SET方法名，并得到方法返回类型        
				Method[] methods = beanClass.getMethods();
				for (int j = 0; j < methods.length; j++) {
					methodName = methods[j].getName();
					setMethodName = SET + fieldName;
					dbSetMethodName = DBSET + fieldName;
					if (methodName.equals(setMethodName)) {
						method =
							beanClass.getMethod(
								SET + fieldName,
								new Class[] { field.getType()});
						break;
					}

				}

				//如果字段为vector类型
				if (isSet) {

					if (setBean == null) {
						setBean = new HashSet();
						vectorMethod = method;
						vectorBeanName = fieldName;
					}
					if (vectorBeanName.equals(fieldName)) {
						fieldBeanValue =
							convertVectorToBeanFlagNull(
								vectorBeanType,
								(Vector) vecBean.elementAt(i + 1));
						setBean.add(fieldBeanValue);
					} else {
						vectorMethod.invoke(bean, new Object[] { setBean });
						//当连续的不同Vector
						//重置
						setBean = new HashSet();
						vectorMethod = method;
						vectorBeanName = fieldName;

						fieldBeanValue =
							convertVectorToBeanFlagNull(
								vectorBeanType,
								(Vector) vecBean.elementAt(i + 1));
						setBean.add(fieldBeanValue);
					}
				} else {

					if (setBean != null) {
						vectorMethod.invoke(bean, new Object[] { setBean });
						setBean = null;
					}

					if (fieldName.endsWith(BEANFLAG)) {
						fieldBeanValue =
							convertVectorToBeanFlagNull(
								field.getType().getName(),
								(Vector) vecBean.elementAt(i + 1));
						method.invoke(bean, new Object[] { fieldBeanValue });
					} else
						try {
							if (vecBean.elementAt(i + 1) != null) {
								if (vecBean
									.elementAt(i + 1)
									.toString()
									.equalsIgnoreCase(NULLFLAG)) {
									method.invoke(
										bean,
										convertToNeedTypeNullValue(
											field.getType()));
								} else {
									method.invoke(
										bean,
										convertToNeedTypeValue(
											field.getType(),
											(String) vecBean.elementAt(i + 1)));
								}
							}
						} catch (Exception e) {
							throw new Exception("Type of " + field + " convert Error");
							//System.out.println("Type of " + field + " Is Error");
							//e.printStackTrace();
						}
				}

			}
		}

		if (setBean != null)
			vectorMethod.invoke(bean, new Object[] { setBean });


		return bean;
	}
	

	public static Field getField(Class beanClass, String fieldName)
		throws NoSuchFieldException, Exception {
		//取bean中的属性
		fieldName =
			fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1);
		Field field = null;
		Class superBeanClass = null;
		try {
			field = beanClass.getDeclaredField(fieldName);
		} catch (NoSuchFieldException e) {

			//父类的属性
			superBeanClass = getParentBeanClass(beanClass);

			while (superBeanClass != null)
				try {
					field = superBeanClass.getDeclaredField(fieldName);
					break;
				} catch (NoSuchFieldException ex) {
					//throw new NoSuchFieldException(fieldName);
					beanClass = superBeanClass;
					superBeanClass = getParentBeanClass(beanClass);
					continue;

				}
		}
		if (field == null)
			throw new NoSuchFieldException("no such field " + fieldName);
		else
			return field;
	}

	private static Class getParentBeanClass(Class beanClass) {
		Class superBeanClass = null;
		superBeanClass = beanClass.getSuperclass();
		if (superBeanClass.getName().endsWith(BEANFLAG)) {
			return superBeanClass;
		} else
			return null;

	}
	
	public static List<Object> convertPOJOList( List lstMap ){
		List lstResult = null;
		
		if( lstMap != null && lstMap.size() > 0 ){
			lstResult = new ArrayList();
			for( Iterator<HashMap> itMap = lstMap.iterator(); itMap.hasNext(); ){
				lstResult.add( convertDBMap( itMap.next() ) );
			}
		}
		
		return lstResult;		
	}
	
	public static Map convertDBMap( Map srcMap ){
		Map map = null;
		
		if( srcMap != null ){
			
			SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );
			map = new HashMap<String, Object>();
			for( Iterator<Object> it = srcMap.keySet().iterator(); it.hasNext(); ){
			
				String key = it.next().toString();
				String[] elems = StringUtil.Split( key, "_");
				
				if( elems != null && elems.length > 0 ){
					StringBuffer sb = new StringBuffer();
					for( int i = 0; i < elems.length; i++ ){
						if( i > 0 ){
							sb.append( elems[i].substring( 0, 1 ).toUpperCase() );
							if( elems[i].length() > 1 ){
								sb.append( elems[i].substring( 1 ).toLowerCase() );
							}
						}
						else{
							sb.append( elems[i].toLowerCase() );
						}
					}
					if( sb.length() > 0 ){
						Object obj = srcMap.get( key );
						if( obj != null && obj instanceof Date ) {
							obj = sdf.format( (Date)obj ); 
						}
						map.put( sb.toString(), obj );
					}
				}
			}
		}
		
		return map;
	}
}
