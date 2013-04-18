package com.bfuture.app.saas.util;

import java.io.File;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import jxl.Cell;
import jxl.Workbook;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;

public class FileUtil {
	
	public static List parseExcel(FileInputStream fileInputStream,int columnCount)
	{
		List excel = null;
		Object object[] = new Object[columnCount];
		try
		{
			jxl.Workbook wb = Workbook.getWorkbook(fileInputStream);
			jxl.Sheet st = wb.getSheet(0);
			int rsRows = st.getRows(); 
			if(st.getColumns() == columnCount)
		    {
				excel = new ArrayList();
				for (int i = 1; i < rsRows; i++)
				{
					for (int j=0;j<columnCount;j++)
					{
						Cell cell = st.getCell(i, j);
						if (cell != null)
						{
							object[j] = cell.getContents();
						}
						else
						{
							object[j] = null;							
						}						
					}
					excel.add(object);
				}
		    }
		}
		catch (Exception exception)
		{
			exception.printStackTrace();
		}	    
	    finally
	    {
	    	return excel;
	    }
	}
	
	public static boolean unZipFile(String targetPath,String sourceFile)
	{
		boolean flag = false;
		InputStream inputStream;
		FileOutputStream fileOutputStream;			
		File zFile;
		File fPath;
		byte[] buf = new byte[256];
		int readedBytes = 0;
		try 
		{
			ZipFile zipFile = new ZipFile(sourceFile,"GBK");
			for(Enumeration entries = zipFile.getEntries();entries.hasMoreElements();)
			{
				ZipEntry entry = (ZipEntry)entries.nextElement();			
				zFile = new File(targetPath + entry.getName());
				fPath = new File(zFile.getParentFile().getPath());
	            if(entry.isDirectory()){//��Ŀ¼���򴴽�֮
	            	if (!zFile.exists())
	            	{
	            		zFile.mkdirs();
	            	}
	            }
            	else
            	{
					if (!fPath.exists())
						fPath.mkdirs();
					inputStream = zipFile.getInputStream(entry);
					fileOutputStream = new FileOutputStream(zFile);
					while((readedBytes = inputStream.read(buf) ) > 0)
					{
						fileOutputStream.write(buf , 0 ,readedBytes );
                    }
					fileOutputStream.close();
					inputStream.close();
            	}	            
			}
			zipFile.close();
			flag = true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			flag = false;
		}		
		return flag;
	}
}
