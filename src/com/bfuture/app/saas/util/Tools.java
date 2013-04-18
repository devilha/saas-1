package com.bfuture.app.saas.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

public class Tools {
	
	//复制对象属性
	public static void copyProperties( Object src, Object tar, boolean nullFlag ) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		if( src != null && tar != null ){
			Method[] srcMethods = src.getClass().getMethods();
			Class tarClass = tar.getClass();
			for( Method srcMethod : srcMethods ){
				String srcMethodName = srcMethod.getName();
				if( srcMethodName.startsWith( "get" ) ){
					Object srcMethodValue = srcMethod.invoke( src, null );
					if( srcMethodValue != null || srcMethodValue == null && nullFlag ){
						String tarSetMethodName = "set" + srcMethodName.substring( 3 );
						Method tarMethod = null;
						try {
							tarMethod = tar.getClass().getMethod( tarSetMethodName, srcMethod.getReturnType() );
						}
						catch (SecurityException e) {}
						catch (NoSuchMethodException e) {}
						if( tarMethod != null ){
							tarMethod.invoke( tar, new Object[]{ srcMethodValue } );
						}
					}
				}
			}
		}
	}
	
	public static void createFile( String filename, ArrayList<String> datas ) throws FileNotFoundException{
		FileOutputStream fos = null;
		OutputStreamWriter osw = null;
		PrintWriter pw = null;
		try{
			File file = new File( filename );
			if( !file.exists() ){
				file.createNewFile();
			}
			fos = new FileOutputStream( filename, false );
			osw = new OutputStreamWriter( fos ,"UTF-8");
			pw = new PrintWriter( osw );
			for( Iterator< String > itData = datas.iterator(); itData.hasNext(); ){
				pw.println( itData.next() );				
			}
			pw.flush();
		}catch( FileNotFoundException fnfe ){
			throw fnfe;
		} catch (UnsupportedEncodingException e) {			
		} catch (IOException e) {
		}
		finally{
			if( fos != null ){
				try{
					fos.close();
				}catch( Exception ioe ){}
			}
			if( osw != null ){
				try{
					osw.close();
				}catch( Exception ioe ){}
			}
			if( pw != null ){
				try{
					pw.close();
				}catch( Exception ioe ){}
			}
		}
	}
	
	/**
	 * 
	 * @param filename 文件名
	 * @param datas 文件内容
	 * @param charset 字符集，默认为utf-8
	 * @throws FileNotFoundException
	 */
	public static void createFile( String filename, String datas, String charset ) throws FileNotFoundException{
		FileOutputStream fos = null;
		OutputStreamWriter osw = null;
		PrintWriter pw = null;
		try{
			fos = new FileOutputStream( filename, false );
			osw = new OutputStreamWriter( fos, charset != null ? charset : "UTF-8" );
			pw = new PrintWriter( osw );
			
			pw.println( datas );
			pw.flush();
		}catch( FileNotFoundException fnfe ){
			throw fnfe;
		} catch (UnsupportedEncodingException e) {}
		finally{
			if( fos != null ){
				try{
					fos.close();
				}catch( Exception ioe ){}
			}
			if( osw != null ){
				try{
					osw.close();
				}catch( Exception ioe ){}
			}
			if( pw != null ){
				try{
					pw.close();
				}catch( Exception ioe ){}
			}
		}
	}
	
	public static void copyFile( String srcFile, String dstFile ) throws IOException {
		
		String dstDirpath = null;
		if( dstFile.lastIndexOf( "\\" ) > -1 )
			dstDirpath = dstFile.substring( 0 , dstFile.lastIndexOf( "\\" ) );
		else if( dstFile.lastIndexOf( "/" ) > -1 )
			dstDirpath = dstFile.substring( 0 , dstFile.lastIndexOf( "/" ) );
		
		File dstDir = new File( dstDirpath );
		if( !dstDir.exists() ){
			dstDir.mkdirs();
		}
		
		FileChannel srcChannel = new FileInputStream( srcFile ).getChannel();  
        FileChannel dstChannel = new FileOutputStream( dstFile ).getChannel();  
        
        dstChannel.transferFrom( srcChannel, 0, srcChannel.size() );  
  
        srcChannel.close();  
        dstChannel.close(); 
	}
	
	public static void moveFile( String srcFile, String dstFile ) throws IOException {
		copyFile( srcFile, dstFile );
		File file = new File( srcFile );
		if( file.exists() ){
			boolean deleteFlag = file.delete();
			if( !deleteFlag ) file.deleteOnExit();
		}
	}
	
	public static String join( Collection<Object> collection , String separator ){
		StringBuffer sb = new StringBuffer();
		
		for( Iterator<Object> it = collection.iterator(); it.hasNext(); ){
			
			Object obj = it.next();
			if( obj != null ){
				sb.append( obj.toString() );
			}
			
			if( it.hasNext() ){
				sb.append( separator );
			}
		}
		
		return sb.toString();
	}
}
