package com.bfuture.app.saas.clientapp.servlet;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Cell;
import jxl.Workbook;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.bfuture.app.basic.clientapp.servlet.BasicServlet;
import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.saas.model.MsgChat;
import com.bfuture.app.saas.model.SysScmuser;
import com.bfuture.app.saas.service.MsgChatManager;
import com.bfuture.app.saas.util.Constants;
import com.bfuture.app.saas.util.StringUtil;

/**  
 * Servlet implementation class UploadServlet  
 * 用于采购洽谈批量添加和附件上传
 */  
public class NoticeServlet extends BasicServlet { 
	
	
//    String filePath = "E:\\zzzz\\";  
	String filePath = Constants.FileImgUrl; // 服务器端文件保存的路径
	FileItem file = null;
	FileItem attachment = null;

    
    /**  
     * Default constructor.   
     */  
    public NoticeServlet() {   

    }   
  
    /**  
     * @throws IOException 
     * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)  
     */  
    @Override  
	public void performTask(HttpServletRequest request,
			HttpServletResponse response)  { 
    	
    	// 获取当前登录用户信息
    	Object obj = request.getSession().getAttribute( "LoginUser" );
		if( obj == null ){
			try {
				response.sendRedirect( "login.jsp" );
			} catch (IOException e) {
				e.printStackTrace();
			}
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	      	
		MsgChatManager mcdao = (MsgChatManager)getSpringBean( "MsgChatManager" );
    	//System.out.println("mcdao: " + mcdao);
		UniversalAppDao uAppDao = (UniversalAppDao) getSpringBean("universalAppDao");
		System.out.println("uAppDao: " + uAppDao);
    	
    	this.getFileFromRequest(request);
    	
    	try
    	{
    		
    		//读取附件
    		
    		String attachmentName = "";
    		String attachmentPath = "";
    		
    	    if (attachment != null)
    	    {
    	    	String dir = filePath;		
    		    List fileType = new ArrayList();
    		    fileType.add("doc");
    		    fileType.add("xls");		    
    		    fileType.add("txt");
    		    fileType.add("ppt");
    		    fileType.add("zip");
//    	        if (!dir.endsWith("/"))
//    	           dir = dir.concat("/");
    			String fileName2 = attachment.getName(); 
    			
//    			String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\") + 1);
    			
    			//System.out.println("fileName2: " + fileName2);
    			if (!"".equals(fileName2) && fileName2 != null)
    			{
    		       long fsize2 = attachment.getSize();
    		       String ext = StringUtil.getFileEXTName(fileName2);	         
    		       if (!fileType.contains(ext)){
    		           //System.out.println("" + ext);	        
    		           request.setAttribute("error", "不支持的文件格式" + ext);
    		           request.getRequestDispatcher("send.jsp").forward(request, response); 		   
    		       }
    		       if (fsize2 > 1024 * 1024 * 100){         
    		
    		           request.setAttribute("error", "文件过大");
    		           request.getRequestDispatcher("send.jsp").forward(request, response);
    		       }
    		
    		       InputStream in = null;
    		       OutputStream out = null;
    		       try{
//    		    	   attachmentPath = dir + com.bfuture.app.saas.util.StringUtil.getFilePath(fileName2); // old
    		    	   attachmentPath = dir + fileName2.substring(fileName2.lastIndexOf("\\") + 1); // new  
//    		    	   attachmentPath = dir + new Date().getTime() + fileName2.substring(fileName2.lastIndexOf("\\") + 1); // new (这里要进行一下文件的重命名处理)
    		    	   
    		    	   attachmentName = fileName2;
//    		    	   boolean folderFlag = new File(attachmentPath).mkdir();// old
    		    	   
    		           in = attachment.getInputStream();
//    		           out = new FileOutputStream(attachmentPath + "/" + StringUtil.getFileName(fileName2)); // old
    		           out = new FileOutputStream(attachmentPath); // new
    		           int byteread = 0;
    		           byte[] bytes = new byte[8192];
    		           while ((byteread = in.read(bytes, 0, 8192)) != -1){
    		               out.write(bytes, 0, byteread);
    		           }
    		           if ("zip".equals(ext))
    		           {
    		        	   com.bfuture.app.saas.util.FileUtil.unZipFile(attachmentPath,attachmentPath + "/" + StringUtil.getFileName(attachmentName));
    		           }
    		     
    		       } catch (Exception e){
    		           System.out.println(e.getMessage());
    		           request.getRequestDispatcher("send.jsp").forward(request, response);
    		           //response.sendRedirect("/scmvip/send.jsp");
    		       } finally{
    		           try{
    		               in.close();
    		               out.close();
    		           } catch (Exception e){
    		               System.out.println(e.getMessage());
    		               request.getRequestDispatcher("send.jsp").forward(request, response);
    		           }
    		       }
    		    }
    	    }
    		
    		
    		
            //读取xls
    		int errorCount = 0;
    		int successCount = 0;
    		List errorInforms = new ArrayList();			
    	    if (file != null)
    	    {	    	
    		    String fileName = file.getName();// 获取文件名	 
    		    fileName = fileName.substring(0,fileName.indexOf("."));
    		    
    		    //System.out.println("导入的excel文件名称：" + fileName);
    		    //System.out.println("file = " + file);
    		    
    		    InputStream is = file.getInputStream();
    		    jxl.Workbook wb = Workbook.getWorkbook(is);  //得到工作薄 
    		    jxl.Sheet st = wb.getSheet(0);  //得到工作薄中的第一个工作表 
    		    int rsRows = st.getRows();  //得到excel的总行数
    		    if(st.getColumns()==6)
    		    {
    				    	Cell c0 = st.getCell(0, 0);  
    					    Cell c1 = st.getCell(1, 0);  
    					    Cell c2 = st.getCell(2, 0);
    					    Cell c3 = st.getCell(3, 0);
    					    Cell c4 = st.getCell(4, 0);
    					    Cell c5 = st.getCell(5, 0);
    				    	if(c0.getContents().equals("供应商编码")&&c1.getContents().equals("门店")&&c2.getContents().equals("品类")&&c3.getContents().equals("品牌")&&c4.getContents().equals("通知内容")&&c5.getContents().equals("电话"))
    				    {for (int i = 1; i < rsRows; i++) 
    				    { 
    					    Cell cell0 = st.getCell(0, i);  
    					    Cell cell1 = st.getCell(1, i);  
    					    Cell cell2 = st.getCell(2, i);
    					    Cell cell3 = st.getCell(3, i);
    					    Cell cell4 = st.getCell(4, i);
    					    Cell cell5 = st.getCell(5, i);
    					    // System.out.println("a" + cell0 + "a");    	    
    					    if(cell0.getContents().equals("")&&i!=1)
    					    {
    					    	String errorinfo="提交成功";
    					    	request.setAttribute("errorinfo",errorinfo);
    					    	response.sendRedirect("send.jsp");
    					    }
    					    if(cell0.getContents().equals(""))
    					    {
    					    	String errorinfo="XLS文件格式错误，请检查您的XLS文件格式是否与页面提供下载的“通知模板”格式一致";
    					    	request.setAttribute("errorinfo",errorinfo);
    					    	request.getRequestDispatcher("send.jsp").forward(request, response);
    					    }
    					    if ((cell0.getContents() == null && cell1.getContents() == null && cell2.getContents() == null && cell3.getContents() == null && cell4.getContents() == null && cell5.getContents() == null) ||
    					    	("".equals(cell0.getContents()) && "".equals(cell1.getContents()) && "".equals(cell2.getContents()) && "".equals(cell3.getContents()) && "".equals(cell4.getContents()) && "".equals(cell5.getContents())))
    					    {
    					    	break;
    					    }
    					    else
    					    {
    					    	if (cell0.getContents() != null && !"".equals(cell0.getContents()))
    						    {			
    					    		
//    					    		0供应商编码	1门店	2品类	3品牌	4通知内容	 5电话
    					    		
//    					    		System.out.println("cell0: " + cell0.getContents());
//    					    		System.out.println("cell1: " + cell1.getContents());
//    					    		System.out.println("cell2: " + cell2.getContents());
//    					    		System.out.println("cell3: " + cell3.getContents());
//    					    		System.out.println("cell4: " + cell4.getContents());
//    					    		System.out.println("cell5: " + cell5.getContents());
    					    		
    					    		
    					    		//System.out.println("attachmentName: " + attachmentName);
    					    		//System.out.println("attachmentPath: " + attachmentPath);
    					    		//System.out.println("=========" + attachmentName.substring(attachmentName.lastIndexOf("\\") + 1));
    					    		String titleName = attachmentName.substring(attachmentName.lastIndexOf("\\") + 1); // 标题名称(含后缀)
    					    		
    					    		String excelfileName = fileName.substring(fileName.lastIndexOf("\\") + 1); // excel文件标题
    					    		
    					    		// ============================================
    					    		MsgChat msgChat = new MsgChat();
    					    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    								
    								msgChat.setIns_c(currUser.getSgcode());		// 实例编码【系统】
    								msgChat.setTitle(excelfileName);		// 标题【excel名获取】
    								msgChat.setContent(cell4.getContents());  // 内容【excel获取】
    								msgChat.setCat_id(cell2.getContents());	   // 类别编码【excel获取】
    								msgChat.setCat_name(cell2.getContents());	// 类别名称【excel获取】
    								msgChat.setPp_id(cell3.getContents());		// 品牌编码【excel获取】
    								msgChat.setPp_name(cell3.getContents());	// 品牌名称【excel获取】
    								msgChat.setShop_id(cell1.getContents());	// 门店编码【excel获取】
    								msgChat.setShop_name(cell1.getContents());	// 门店名称【excel获取】
    								msgChat.setCrt_by_c(currUser.getSucode());	// 创建人【系统】
    								msgChat.setCrt_by_cn(currUser.getSuname());	// 创建人名称【系统】
    								msgChat.setCrt_by_time(sdf.parse(sdf.format(new Date())));// 创建时间
    								msgChat.setRe_by_c(cell0.getContents());	  // 接收人【excel获取】
    								msgChat.setRe_by_cn(cell1.getContents());		// 接收人名称【excel获取】
//    								msgChat.setRe_by_time(sdf.parse("2012-02-11"));// 回复时间
    								msgChat.setRe_flag("0");		// 回复标识 回复意见（0=未处理；1=同意；2=不同意）
//    								msgChat.setRe_memo("回复备注");	// 回复备注
    								msgChat.setEmail_flag("0");		// 邮件标识(0=未读取；1=已读取；2=已回复)
    								
    								msgChat.setEmail_url(titleName); // 邮件附件url[服务器端存放的文件名]
    								msgChat.setEmail_fjname( titleName );// 附件的名字(含后缀)
    								
    								
    								// 根据供应商登录编码查询供应商名称
    								List resultList = uAppDao.executeSql("select SUNAME from SYS_SCMUSER where SUCODE = 'gys'");
    								//System.out.println("resultList: " + resultList);
    								if(resultList != null && resultList.size() > 0){
    									//System.out.println("resultList.size(): " + resultList.size());
    									//System.out.println("接收人名称: " + ((Map)resultList.get(0)).get("SUNAME"));
    									msgChat.setRe_by_cn( ((Map)resultList.get(0)).get("SUNAME").toString() );// 接收人名称
    								}
    								
    								mcdao.InsertMsgChat(msgChat); 		// 添加操作
    								//System.out.println("=====添加一下成功： " + successCount);
    					    		// ============================================
    					    		
    							    successCount++;
    							    
    						    }
    						    else
    						    {
    						    	errorInforms.add(i);
    						    	errorCount++;
    						    }
    					    }
    				    }	    
    				    request.setAttribute("errorInforms", errorInforms);
    				    request.setAttribute("successCount", successCount);
    				    request.setAttribute("errorinfo","提交成功");
    				    request.getRequestDispatcher("send.jsp").forward(request, response);
    				    }
    				    else
    				    {
    				    	request.setAttribute("errorinfo","XLS文件格式错误，请检查您的XLS文件格式是否与页面提供下载的“通知模板”格式一致");
    				    	request.getRequestDispatcher("send.jsp").forward(request, response);
    				    }
    		    }
    		    else
    		    {
    		    	request.setAttribute("errorinfo","XLS文件格式错误，请检查您的XLS文件格式是否与页面提供下载的“通知模板”格式一致");
    		    	request.getRequestDispatcher("send.jsp").forward(request, response);
    		    }
    	    }
    	    else
    	    {
    	    	request.setAttribute("errorinfo","附件大于100M将不能发送");
    	    	request.getRequestDispatcher("send.jsp").forward(request, response);
    	    }
    	}
    	catch (Exception exception)
    	{
    		exception.printStackTrace();
    		request.setAttribute("errorinfo","批量添加通知失败");
	    	try {
				request.getRequestDispatcher("send.jsp").forward(request, response);
			} catch (ServletException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}    
	}		
	  
	@Override  
	public void init(ServletConfig config) throws ServletException {   
		//path = config.getServletContext().getRealPath("/uploadImages");   
	}
	
	public void getFileFromRequest(HttpServletRequest request)
	{
		try
		{
			//创建磁盘文件工厂   
			DiskFileItemFactory fac = new DiskFileItemFactory();       
			//创建servlet文件上传组件   
			ServletFileUpload upload = new ServletFileUpload(fac); 
			
			upload.setHeaderEncoding("GBK");
			
			List fileList = upload.parseRequest(request);   		
			
			Iterator<FileItem> it = fileList.iterator();      
			while(it.hasNext()){       
				FileItem item =  it.next();      
				//如果不是普通表单域，当做文件域来处理   
				if(!item.isFormField()){
					if ("file".equals(item.getFieldName()))
					{
						file = item;
					}
					else if ("attachment".equals(item.getFieldName()))
					{
						attachment = item;
					}
				}  
			}
		}
		catch (Exception exception)
		{
			exception.printStackTrace();
			log.error("Throw a exception in get file from request");
		}
	}
}  
