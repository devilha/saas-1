package com.bfuture.app.saas.util;

import java.util.MissingResourceException;
import java.util.Properties;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

public class ResourceProperties extends Properties {

	private static ResourceBundle resourceBundle = null;

	final Logger log = Logger.getLogger(ResourceProperties.class);

	public ResourceProperties(String proertiesFileName) { // 默认的构造函数
		try {
			resourceBundle = ResourceBundle.getBundle(proertiesFileName); // 绑定资源文件
		} catch (MissingResourceException exception) {
			log.error("Get " + proertiesFileName + " object failure");
			log.info(exception.getMessage());
		}
	}

	public String getProperty(String key, String defaultVal) {
		String val = getProperty(key); // 根据KEY值得到资源文件中的value值
		return (val == null) ? defaultVal : val; // 如果没有定义返回默认值
	}

	public String getProperty(String key) {
		String val = (String) super.get(key); // 根据KEY值得到资源文件中的value值
		return ((val == null) && (resourceBundle != null)) ? resourceBundle
				.getString(key) : val;
	}
}
