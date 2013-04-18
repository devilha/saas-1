package com.bfuture.app.saas.util;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.bfuture.util.ini.BasicIniFile;
import com.bfuture.util.ini.IniFile;
import com.bfuture.util.ini.IniFileReader;
import com.bfuture.util.ini.IniSection;

public class DataConfigFactory {

	final static String configFileName = "dataUp.cfg";
	private static Collection<IniSection> dataConfig = null;
	static Logger log = Logger.getLogger(DataConfigFactory.class);

	static {

		if (dataConfig == null) {
			// 配置文件路径
			String filepath = DataConfigFactory.class.getClassLoader()
					.getResource("/").getPath().substring("\\".equals(File.separator) ? 1 : 0).replace("%20", " ")
					+ configFileName;
			log.info("配置文件路径：" + filepath);
			File configFile = new File(filepath);
			if (!configFile.exists())
				log.error("NewSaaS在当前目录下没有找到配置文件：" + configFileName);

			IniFile iniFile = new BasicIniFile();
			IniFileReader iniFileReader = new IniFileReader(iniFile, configFile);
			try {
				iniFileReader.read();
			} catch (IOException ioe) {
				log.error("NewSaaS读取配置文件(" + configFileName + ")时产生错误");
			}

			dataConfig = iniFile.getSections();
		}
	}

	public static Map<String, IniSection> getSectionsByName(String sectionName) {
		Map<String, IniSection> mapSections = null;

		if (dataConfig != null && dataConfig.size() > 0) {
			for (IniSection section : dataConfig) {
				if (sectionName.equals(section.getName())) {
					if (mapSections == null) {
						mapSections = new HashMap<String, IniSection>();
					}
					mapSections.put(section.getItemValue("Name", "name"),
							section);
				}
			}
		}

		return mapSections;
	}

	public static IniSection getSectionByName(List<IniSection> lstSections,
			String name) {
		IniSection section = null;

		if (lstSections != null) {
			for (IniSection sect : lstSections) {
				String sectName = sect.getItemValue("Name", "");
				if (name.equals(sectName)) {
					section = sect;
					break;
				}
			}
		}
		return section;
	}
}
