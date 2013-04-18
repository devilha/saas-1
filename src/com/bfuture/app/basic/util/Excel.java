package com.bfuture.app.basic.util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

public class Excel {

	public static boolean createExcel(List date, String path,
			String[] enTitle, String[] cnTitle,String sheetTitle) {
		WritableWorkbook wwb = null;
		OutputStream os = null;
		try {
			os = new FileOutputStream(path);
			wwb = Workbook.createWorkbook(os);
			WritableSheet ws = wwb.createSheet(sheetTitle==null?"Sheet1":sheetTitle, 0);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	

			for (int i = 0; i < cnTitle.length; i++) {
				ws.addCell(new Label(i, 0, cnTitle[i]));
			}
			for (int li = 0; li < date.size(); li++) {
				int col = 0;
				Map m = (Map) date.get(li);
				for (int im = 0; im < enTitle.length; im++) {
					Object o = m.get(enTitle[im]);
					if (o != null
							&& (o instanceof Integer || o instanceof Float || o instanceof Double)) {
						ws.addCell(new Number(col,li+1,Double.parseDouble(o.toString())));
					}
					else if (o != null
							&& (o instanceof Date )) {
						ws.addCell(new Label(col,li+1,sdf.format( o ) ) );											
					}
					else {
						ws.addCell(new Label(col, li+1, o != null ? o.toString()
								: ""));
					}
					col++;
				}
			}
			wwb.write();
	        return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}finally{
			try {
				wwb.close();
				os.close();
			} catch (WriteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static boolean createExcelQG(List date, String path,
			String[] enTitle, String[] cnTitle,String sheetTitle) {
		WritableWorkbook wwb = null;
		OutputStream os = null;
		try {
			os = new FileOutputStream(path);
			wwb = Workbook.createWorkbook(os);
			WritableSheet ws = wwb.createSheet(sheetTitle==null?"Sheet1":sheetTitle, 0);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
			//合并单元格
			ws.mergeCells(0, 0, (0+cnTitle.length-1),0);
			//给单元格赋值
			Label lab = new Label(0,0,"供应商供应链票据汇总");
			ws.addCell(lab);
			
			for (int i = 0; i < cnTitle.length; i++) {
				ws.addCell(new Label(i, 1, cnTitle[i]));
			}
			for (int li = 0; li < date.size(); li++) {
				int col = 0;
				Map m = (Map) date.get(li);
				for (int im = 0; im < enTitle.length; im++) {
					Object o = m.get(enTitle[im]);
					if (o != null
							&& (o instanceof Integer || o instanceof Float || o instanceof Double)) {
						ws.addCell(new Number(col,li+2,Double.parseDouble(o.toString())));
					}
					else if (o != null
							&& (o instanceof Date )) {
						ws.addCell(new Label(col,li+2,sdf.format( o ) ) );											
					}
					else {
						ws.addCell(new Label(col, li+2, o != null ? o.toString()
								: ""));
					}
					col++;
				}
			}
			wwb.write();
	        return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}finally{
			try {
				wwb.close();
				os.close();
			} catch (WriteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	public static void main(String args[]){
		List date = new ArrayList();
		for(int i = 0; i<10000;i++){
			Map map = new HashMap();
			map.put("1-key", i+"value");
			map.put("2-key", i+"-value-"+i);
			map.put("3-key", i+"-value-value-"+i);
			date.add(map);
		}
		String [] enTitle = {"1-key","2-key","3-key"};
		String [] cnTitle = {"aaaa","bbbb","cccc"};
		System.out.println(createExcel(date,"d:\\test.xls",enTitle,cnTitle,"MLGBD"));
	}
}
