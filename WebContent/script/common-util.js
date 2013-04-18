function obj2str(o){
		   var r = [];
		   if(typeof o == "string" || o == null) {
		   	if( o == '' ) return '""';
		     return '"' + encodeURI(o) + '"';
		   }
		   if(typeof o == "object"){
		     if(!$.isArray(o)){
		       r[0]="{";
		       for(var i in o){
		         r[r.length]=i;
		         r[r.length]=":";
		         r[r.length]=obj2str(o[i]);
		         r[r.length]=",";
		       }
		       r[r.length-1]="}";
		     }else{
		       r[0]="[";
		       for(var i =0;i<o.length;i++){
		         r[r.length]=obj2str(o[i]);
		         r[r.length]=",";
		       }
		       r[r.length-1]="]";
		     }
		     return r.join("");
		   }
		   return o.toString();
		}

function getParamString( params ){
	paraStr = '';
	if( params ){			
		for( var name in params ){
			if( paraStr != '' )  paraStr += '&';
			paraStr += name + '=' + params[name];
		}
		paraStr = encodeURI(paraStr);
		paraStr = encodeURI(paraStr);
	}
}	

function clearObject( obj ){
	for( var v in obj ){
		if( obj[v] == null || obj[v].length != undefined && obj[v].length == 0  ){
			delete obj[v];
		}
	}
}

function getFormData( formId ){
	var dataObj = {};
	
	if( formId ){
		$( '#' + formId + ' :input' ).each(function () {
		    if ( $(this).attr('name') ) {		    	
		    	if( $(this).attr('type') == 'checkbox' ){
		    		dataObj[ $(this).attr('name') ] = $(this).attr('checked') ? 'Y' : 'N';
		    	}
		    	else{
		    		dataObj[ $(this).attr('name') ] = $(this).val();
		    	}
		    }
		});
	}
	
	return dataObj;
}

function getFormsData( forms, obj ){
	var dataObj = {};
	if( obj != undefined ){
		for( var name in obj ){
			dataObj[name] = obj[name];
		}
	}
	
	if( forms.length !== undefined && forms.length > 0 ){
		for( var i = 0; i < forms.length; i ++ ){
			var formId = forms[i];
			if( formId ){
				$( '#' + formId + ' :input' ).each(function () {
				    if ( $(this).attr('name') ) {		    	
				    	if( $(this).attr('type') == 'checkbox' ){
				    		dataObj[ $(this).attr('name') ] = $(this).attr('checked') ? 'Y' : 'N';
				    	}
				    	else{
				    		dataObj[ $(this).attr('name') ] = $(this).val();
				    	}
				    }
				});
			}
		}
	}
	
	return dataObj;
}

function clearForm( formId ){
	var valid = true;
	if( formId ){
		$( '#' + formId + ' :input' ).each(function () {
		    if ( $(this).attr('name') ) {
				if( $(this).attr('type') == 'checkbox' ){
		    		$(this).attr('checked', '');
				}				
		    	else{
		    		$(this).val('');
		    	}
		    }
		});
	}
	
	return valid;
}

function fillForm( formId, data ){
	
	if( formId ){
		$( '#' + formId + ' :input' ).each(function () {
		    if ( $(this).attr('name') ) {
		    	if( $(this).attr('type') == 'checkbox' ){
		    		$(this).attr('checked', data[ $(this).attr('name') ] == 'Y' ? 'checked' : '' );
		    	}
		    	else if( $(this).attr('type') == 'radio' ){
		    		$(this).attr('checked', data[ $(this).attr('name') ] == $(this).val() );
		    	}
		    	else{
		    		$(this).val( data[ $(this).attr('name') ] ? data[ $(this).attr('name') ] : '' );
		    	}
		    }
		});
	}
}

function fillText( divId, data ){
	
	if( divId ){
		$( '#' + divId + ' .autofill'  ).each(function () {
		    if ( $(this).attr('id') ) {
			    if( $(this).attr('dataType') == 'date' ){
			    	var dateFormat = 'yyyy-MM-dd';
			    	if( $(this).attr('format') != undefined ){
			    		dataFormat = $(this).attr('format');
			    	}
			    	
			    	var val = data[ $(this).attr('id') ];
			    	if( val != undefined && val != null ){
			    		$(this).text( Date.parseString( val ).format('yyyy-MM-dd') );
			    	}
			    }
			    else if( $(this).attr('dataType') == 'dict' ){
			    	var val = data[ $(this).attr('id') ];
			    	if( val != undefined && val != null && $(this).attr('dictName') ){
			    		$(this).text( getDictMapping( $(this).attr('dictName'), val ) );
			    	}
			    }
			    else if( $(this).attr('dataType') == 'number' ){
			    	var val = data[ $(this).attr('id') ];
			    	var dp = 2;
			    	if( $(this).attr('decimalPlaces') != undefined ){
			    		dp = parseInt( $(this).attr('decimalPlaces') );
			    	}
			    	var exp = { decimalPlaces : dp, thousandsSeparator : ',' };			    	
			    	if( val != undefined && val != null ){
			    		$(this).text( formatNumber(	val, exp ) );
			    	}
			    }
			    else if( $(this).attr('dataType') == 'combo' ){
			    	var val = data[ $(this).attr('id') ];			    	
			    	if( val != undefined && val != null ){
			    		$(this).val( val );
			    	}
			    }
			    else{
			    	$(this).text( data[ $(this).attr('id') ] ? data[ $(this).attr('id') ] : '' );
			    }
		    }
		});
	}
} 

function checkForm( formId ){
	var valid = true;
	if( formId ){
		$( '#' + formId + ' :input' ).each(function () {
		    if ($(this).attr('required') || $(this).attr('validType')) {
			    if (!$(this).validatebox('isValid')) {
			        valid = false;
			        return;
			    }
		    }
		});
	}
	
	return valid;
}

function checkCustomForm( exp ){
	var valid = true;
	if( exp ){
		$( exp ).each(function () {
		    if ($(this).attr('required') || $(this).attr('validType')) {
			    if (!$(this).validatebox('isValid')) {
			        valid = false;
			        return;
			    }
		    }
		});
	}
	
	return valid;
}

function copyObject( src, tar ){
	if( src != undefined && tar != undefined ){
		for( var o in src ){
			tar[o] = src[o];
		}
	}
}

function createColumnMenu(datagrid_id){
			var tmenu = $('<div id="tmenu" style="width:100px;"></div>').appendTo('body');
			var fields = $(datagrid_id).datagrid('getColumnFields');
			for(var i=0; i<fields.length; i++){
				$('<div iconCls="icon-ok"/>').html(fields[i]).appendTo(tmenu);
			}
			tmenu.menu({
				onClick: function(item){
					if (item.iconCls=='icon-ok'){
						$(datagrid_id).datagrid('hideColumn', item.text);
						tmenu.menu('setIcon', {
							target: item.target,
							iconCls: 'icon-empty'
						});
					} else {
						$(datagrid_id).datagrid('showColumn', item.text);
						tmenu.menu('setIcon', {
							target: item.target,
							iconCls: 'icon-ok'
						});
					}
				}
			});
		}
		
$.extend($.fn.validatebox.defaults.rules, {
    CHS: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5]+$/.test(value);
        },
        message: '请输入汉字'
    },
    ZIP: {
        validator: function (value, param) {
            return /^[1-9]\d{5}$/.test(value);
        },
        message: '邮政编码不存在'
    },
    QQ: {
        validator: function (value, param) {
            return /^[1-9]\d{4,10}$/.test(value);
        },
        message: 'QQ号码不正确'
    },
    mobile: {
        validator: function (value, param) {
            return /^(13[0-9]{9})|(15[0-9]{9})|(18[0-9]{9})$/.test(value);
        },
        message: '手机号码不正确'
    },
    email: {
        validator: function (value, param) {
            return /\w@\w*\.\w/.test(value);
        },
        message: 'E-mail地址不正确'
    },
    loginName: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5\w]+$/.test(value);
        },
        message: '登录名称只允许汉字、英文字母、数字及下划线。'
    },
    safepass: {
        validator: function (value, param) {
            return safePassword(value);
        },
        message: '密码由字母和数字组成，至少6位'
    },
    equalTo: {
        validator: function (value, param) {
            return value == $(param[0]).val();
        },
        message: '两次输入的字符不一至'
    },
    requiredTo: {
        validator: function (value, param) {
        	var flag  = true;
        	if( ( $(param[0]).val() == null || $(param[0]).val() == '') && value != '' ){
        		flag = false;
        	}
            return flag;
        },
        message: '必须输入相关信息'
    },
    number: {
        validator: function (value, param) {
            return /^\d+$/.test(value);
        },
        message: '请输入数字'
    },
    idcard: {
        validator: function (value, param) {
            return idCard(value);
        },
        message:'请输入正确的身份证号码'
    }
});

/* 密码由字母和数字组成，至少6位 */
var safePassword = function (value) {
    return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/.test(value));
}

var idCard = function (value) {
    if (value.length == 18 && 18 != value.length) return false;
    var number = value.toLowerCase();
    var d, sum = 0, v = '10x98765432', w = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2], a = '11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91';
    var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/);
    if (re == null || a.indexOf(re[1]) < 0) return false;
    if (re[2].length == 9) {
        number = number.substr(0, 6) + '19' + number.substr(6);
        d = ['19' + re[4], re[5], re[6]].join('-');
    } else d = [re[9], re[10], re[11]].join('-');
    if (!isDateTime.call(d, 'yyyy-MM-dd')) return false;
    for (var i = 0; i < 17; i++) sum += number.charAt(i) * w[i];
    return (re[2].length == 9 || number.charAt(17) == v.charAt(sum % 11));
}

var isDateTime = function (format, reObj) {
    format = format || 'yyyy-MM-dd';
    var input = this, o = {}, d = new Date();
    var f1 = format.split(/[^a-z]+/gi), f2 = input.split(/\D+/g), f3 = format.split(/[a-z]+/gi), f4 = input.split(/\d+/g);
    var len = f1.length, len1 = f3.length;
    if (len != f2.length || len1 != f4.length) return false;
    for (var i = 0; i < len1; i++) if (f3[i] != f4[i]) return false;
    for (var i = 0; i < len; i++) o[f1[i]] = f2[i];
    o.yyyy = s(o.yyyy, o.yy, d.getFullYear(), 9999, 4);
    o.MM = s(o.MM, o.M, d.getMonth() + 1, 12);
    o.dd = s(o.dd, o.d, d.getDate(), 31);
    o.hh = s(o.hh, o.h, d.getHours(), 24);
    o.mm = s(o.mm, o.m, d.getMinutes());
    o.ss = s(o.ss, o.s, d.getSeconds());
    o.ms = s(o.ms, o.ms, d.getMilliseconds(), 999, 3);
    if (o.yyyy + o.MM + o.dd + o.hh + o.mm + o.ss + o.ms < 0) return false;
    if (o.yyyy < 100) o.yyyy += (o.yyyy > 30 ? 1900 : 2000);
    d = new Date(o.yyyy, o.MM - 1, o.dd, o.hh, o.mm, o.ss, o.ms);
    var reVal = d.getFullYear() == o.yyyy && d.getMonth() + 1 == o.MM && d.getDate() == o.dd && d.getHours() == o.hh && d.getMinutes() == o.mm && d.getSeconds() == o.ss && d.getMilliseconds() == o.ms;
    return reVal && reObj ? d : reVal;
    function s(s1, s2, s3, s4, s5) {
        s4 = s4 || 60, s5 = s5 || 2;
        var reVal = s3;
        if (s1 != undefined && s1 != '' || !isNaN(s1)) reVal = s1 * 1;
        if (s2 != undefined && s2 != '' && !isNaN(s2)) reVal = s2 * 1;
        return (reVal == s1 && s1.length != s5 || reVal > s4) ? -10000 : reVal;
    }
};

Date.prototype.format = function(mask) {     
    
    var d = this;     
    
    var zeroize = function (value, length) {     
    
        if (!length) length = 2;     
    
        value = String(value);     
    
        for (var i = 0, zeros = ''; i < (length - value.length); i++) {     
    
            zeros += '0';     
    
        }     
    
        return zeros + value;     
    
    };       
    
    return mask.replace(/"[^"]*"|'[^']*'|\b(?:d{1,4}|m{1,4}|yy(?:yy)?|([hHMstT])\1?|[lLZ])\b/g, function($0) {     
    
        switch($0) {     
    
            case 'd':   return d.getDate();     
    
            case 'dd':  return zeroize(d.getDate());     
    
            case 'ddd': return ['Sun','Mon','Tue','Wed','Thr','Fri','Sat'][d.getDay()];     
    
            case 'dddd':    return ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][d.getDay()];     
    
            case 'M':   return d.getMonth() + 1;     
    
            case 'MM':  return zeroize(d.getMonth() + 1);     
    
            case 'MMM': return ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][d.getMonth()];     
    
            case 'MMMM':    return ['January','February','March','April','May','June','July','August','September','October','November','December'][d.getMonth()];     
    
            case 'yy':  return String(d.getFullYear()).substr(2);     
    
            case 'yyyy':    return d.getFullYear();     
    
            case 'h':   return d.getHours() % 12 || 12;     
    
            case 'hh':  return zeroize(d.getHours() % 12 || 12);     
    
            case 'H':   return d.getHours();     
    
            case 'HH':  return zeroize(d.getHours());     
    
            case 'm':   return d.getMinutes();     
    
            case 'mm':  return zeroize(d.getMinutes());     
    
            case 's':   return d.getSeconds();     
    
            case 'ss':  return zeroize(d.getSeconds());     
    
            case 'l':   return zeroize(d.getMilliseconds(), 3);     
    
            case 'L':   var m = d.getMilliseconds();     
    
                    if (m > 99) m = Math.round(m / 10);     
    
                    return zeroize(m);     
    
            case 'tt':  return d.getHours() < 12 ? 'am' : 'pm';     
    
            case 'TT':  return d.getHours() < 12 ? 'AM' : 'PM';     
    
            case 'Z':   return d.toUTCString().match(/[A-Z]+$/);     
    
            // Return quoted strings with the surrounding quotes removed     
    
            default:    return $0.substr(1, $0.length - 2);     
    
        }     
    
    });     
    
};

Date.parseString = function( dateString ){
	if( dateString )
		return new Date( dateString.replace(/-/g,"/"));
	else
		return null;
};

String.prototype.Trim = function()
{
        return this.replace(/(^\s*)|(\s*$)/g, "");
}

function checkIsEmpty(id,message)
{
          var flag = true;
          if(document.getElementById(id).value=="")
          {
          	 $.messager.alert('提示', message+'不能为空', 'warning');
             //alert(message+"不能为空");
             document.getElementById(id).focus();
             document.getElementById(id).style.backgroundColor="yellow";
             flag = false;
          }else{
             document.getElementById(id).style.backgroundColor="white";
          }
          return flag;
}


function checkIsNumber(id,message)
{
    //正则表达式
    var EL = /^[0-9]{1,7}\.{0,1}[0-9]{0,2}$/;
    var flag = true;
    if(!EL.test(document.getElementById(id).value))
    {
    	$.messager.alert('提示', message+'必须是数字', 'warning');
        //alert(message+"必须是数字");
        flag = false;
        document.getElementById(id).focus();
        document.getElementById(id).style.backgroundColor="yellow";
    }else{
        document.getElementById(id).style.backgroundColor="white";
    }
    return flag;
}

function isNumber(value){
	return /^[0-9]+.?[0-9]*$/.test(value);
}

function formatNumber(B,E){E=E||{};if(!isNumber(B)){B*=1;}if(isNumber(B)){var I=B+"";var F=(E.decimalSeparator)?E.decimalSeparator:".";var G;if(isNumber(E.decimalPlaces)){var H=E.decimalPlaces;var C=Math.pow(10,H);I=Math.round(B*C)/C+"";G=I.lastIndexOf(".");if(H>0){if(G<0){I+=F;G=I.length-1;}else{if(F!=="."){I=I.replace(".",F);}}while((I.length-1-G)<H){I+="0";}}}if(E.thousandsSeparator){var K=E.thousandsSeparator;G=I.lastIndexOf(F);G=(G>-1)?G:I.length;var J=I.substring(G);var A=-1;for(var D=G;D>0;D--){A++;if((A%3===0)&&(D!==G)){J=K+J;}J=I.charAt(D-1)+J;}I=J;}I=(E.prefix)?E.prefix+I:I;I=(E.suffix)?I+E.suffix:I;return I;}else{return B;}};

function isNotNull( value ){
	return value != undefined && value != 'undefined' && value != '' && value != 'null' && value != null;
}

function getDictMapping( name, key ){
	var result = null;	
	if( name != undefined && name != null && name != '' ){
		if( window.DictMapping ){
			result = window.DictMapping[ name ];
			
			if( key ){
				result = result[ key ];
				if( result == undefined ){
					return key;
				}
			}			
		}
	}
	return result;
}

//金额小写转大写
function DoNumberCurrencyToChineseCurrency(Num){
		        	if(isNaN(Num)) { //验证输入的字符是否为数字
					  alert("请检查小写金额是否正确");
					  return;
					 }
		        	 var part = String(Num).split(".");
		        	 var newchar = ""; 
		        	 for(var i=part[0].length-1;i>=0;i--){
						 if(part[0].length > 10){ alert("位数过大，无法计算");return "";}//若数量超过拾亿单位，提示
						  var tmpnewchar = ""
						  var perchar = part[0].charAt(i);
						  switch(perchar){
						    case "0": tmpnewchar="零" + tmpnewchar ;break;
						    case "1": tmpnewchar="壹" + tmpnewchar ;break;
						    case "2": tmpnewchar="贰" + tmpnewchar ;break;
						    case "3": tmpnewchar="叁" + tmpnewchar ;break;
						    case "4": tmpnewchar="肆" + tmpnewchar ;break;
						    case "5": tmpnewchar="伍" + tmpnewchar ;break;
						    case "6": tmpnewchar="陆" + tmpnewchar ;break;
						    case "7": tmpnewchar="柒" + tmpnewchar ;break;
						    case "8": tmpnewchar="捌" + tmpnewchar ;break;
						    case "9": tmpnewchar="玖" + tmpnewchar ;break;
						  }
						  switch(part[0].length-i-1){
						    case 0: tmpnewchar = tmpnewchar +"元" ;break;
						    case 1: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
						    case 2: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
						    case 3: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;
						    case 4: tmpnewchar= tmpnewchar +"万" ;break;
						    case 5: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
						    case 6: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
						    case 7: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;
						    case 8: tmpnewchar= tmpnewchar +"亿" ;break;
						    case 9: tmpnewchar= tmpnewchar +"拾" ;break;
						  }
						  newchar = tmpnewchar + newchar;
						 }
						 //小数点之后进行转化
						 if(part.length>1){
							 if(part[1].length > 2) {
							  //alert("小数点之后只能保留两位,系统将自动截段");
							  part[1] = part[1].substr(0,2)
							  }
							 for(i=0;i<part[1].length;i++){
							  tmpnewchar = ""
							  perchar = part[1].charAt(i)
								  switch(perchar){
								    case "0": tmpnewchar="零" + tmpnewchar ;break;
								    case "1": tmpnewchar="壹" + tmpnewchar ;break;
								    case "2": tmpnewchar="贰" + tmpnewchar ;break;
								    case "3": tmpnewchar="叁" + tmpnewchar ;break;
								    case "4": tmpnewchar="肆" + tmpnewchar ;break;
								    case "5": tmpnewchar="伍" + tmpnewchar ;break;
								    case "6": tmpnewchar="陆" + tmpnewchar ;break;
								    case "7": tmpnewchar="柒" + tmpnewchar ;break;
								    case "8": tmpnewchar="捌" + tmpnewchar ;break;
								    case "9": tmpnewchar="玖" + tmpnewchar ;break;
								  }
							  if(i==0)tmpnewchar =tmpnewchar + "角";
							  if(i==1)tmpnewchar = tmpnewchar + "分";
							  newchar = newchar + tmpnewchar;
							 }
							 }
						 //替换所有无用汉字
						 while(newchar.search("零零") != -1)
						  newchar = newchar.replace("零零", "零");
						 newchar = newchar.replace("零亿", "亿");
						 newchar = newchar.replace("亿万", "亿");
						 newchar = newchar.replace("零万", "万");
						 newchar = newchar.replace("零元", "元");
						 newchar = newchar.replace("零角", "");
						 newchar = newchar.replace("零分", "");
						
						 if (newchar.charAt(newchar.length-1) == "元" || newchar.charAt(newchar.length-1) == "角")
						  newchar = newchar+"整"
						 return newchar;
			}
 function asCurrency(f1) {  
    var f2 = (Math.round((f1-0) * 100)) / 100;  
    f2 = Math.floor(f2) == f2 ? f2 + ".00" : (Math.floor(f2 * 10) == f2 * 10) ? f2 + '0' : f2;  
    f2 = String(f2);  
    r = /(\d+)(\d{3})/;  
    fs = String(f2);  
    while (r.test(f2)) {  
          f2 = f2.replace(r, '$1' + ',' + '$2');  
    }  
    return (f2); // TODO 没考虑金额为负的情况  
}