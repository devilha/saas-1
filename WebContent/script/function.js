$(document).ready(function(){      
    //A�ļ��ϴ�   
        $("#uploadFile").uploadify({   
        'uploader'       : 'images/uploadify.swf',//ָ���ϴ��ؼ��������ļ���Ĭ�ϡ�uploader.swf��   
        'script'         : 'UploadServlet', //ָ�����������ϴ������ļ�   
        'scriptData'     : {'uploadFile':$('#uploadFile').val()},   
        'cancelImg'      : 'images/cancel.png',   
        'fileDataName'   : 'uploadFile',   
        'fileDesc'       : 'jpg�ļ���jpeg�ļ���gif�ļ�',  //�������ϴ��Ի����е��ļ���������   
        'fileExt'        : '*.jpg;*.jpeg;*.gif',      //���ƿ��ϴ��ļ�����չ�������ñ���ʱ��ͬʱ����fileDesc   
        'sizeLimit'      : 512000,           //�����ϴ��ļ��Ĵ�С����λbyte                
        'folder'         : '/uploadImages',   
        'queueID'        : 'fileQueueA',   
        'auto'           : false,   
        'multi'          : true  
    });   
});