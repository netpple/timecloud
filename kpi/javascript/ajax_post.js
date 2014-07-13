//Author : 김삼영

var request;
var queryString;
var userFunction="ajaxOut"; //default

function userDefineFunction(results){
	if(!results){
		/*alert('결과값을 받지 못함');*/
		return;
	}
	eval(userFunction+"(results)");
}

function ajaxSubmit(tarFrm,tarFunc){
	userFunction = tarFunc;
	setQueryString(tarFrm);
	if(tarFrm.pAjaxResponseType)
	{
		if(tarFrm.pAjaxResponseType.value == "XML")
			httpRequest(tarFrm.method,tarFrm.action,true, true);
		else
			httpRequest(tarFrm.method,tarFrm.action,true, false);
	}
	else
		httpRequest(tarFrm.method,tarFrm.action,true, false);
}

function setQueryString(tarFrm){
	queryString = "";
	var frm = tarFrm;
	var numberElements = frm.elements.length;

	for(var i=0;i<numberElements; i++){
		
		if(frm.elements[i].type != 'submit' && frm.elements[i].type != 'reset' && frm.elements[i].type != 'button'){
			if(!frm.elements[i].disabled){
				if(frm.elements[i].type == 'checkbox' || frm.elements[i].type == 'radio')
				{
					if(frm.elements[i].checked){
					queryString += frm.elements[i].name +"="+encodeURIComponent(frm.elements[i].value);
					if(i<numberElements-1)queryString += "&";					
					}		
				}
				else
				{
					queryString += frm.elements[i].name +"="+encodeURIComponent(frm.elements[i].value);
					if(i<numberElements-1)queryString += "&";
				}
			}
		}
	}
	
	//alert(queryString);
}

function httpRequest(reqType, url, isAsync, isResponseType){
	request = null;
	try{
		request = new ActiveXObject("Msxml12.XMLHTTP");
	}catch(othermicrosoft){
		try{
			request = new ActiveXObject("Microsoft.XMLHTTP");
		}catch(failed){
			request = null;
		}
	}
	
	if(!request && typeof XMLHttpRequest != 'undefined')
	{	
		request = new XMLHttpRequest();
	}
		
	if(request == null){
		alert("REQUEST 객체가 생성되지 않았습니다.");
	}else{
		initReq(reqType,url,isAsync,isResponseType);
	}
}

function initReq(reqType,url,isAsync,isResponseType){
	if (window.netscape && window.netscape.security.PrivilegeManager.enablePrivilege)
	{
		try{
			netscape.security.PrivilegeManager.enablePrivilege('UniversalBrowserRead');	
		}
		catch(e)
		{
			//alert(e);
		}
	}
	/*onreadystatechange 대소문자 구분 -firefox*/
	/*eval을 이용함으로써 응답처리를 다양하게 분기화 시킬 수 있다.*/
	if(isResponseType)
		request.onreadystatechange = eval("handleXMLResponse"); 
	else
		request.onreadystatechange = eval("handleResponse");
	
	request.open(reqType,url,isAsync);
	request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	//alert("queryString : "+queryString+"url:"+url);
    request.setRequestHeader("Content-length",queryString.length);
    request.setRequestHeader("Connection", "close");	
	request.send(queryString); 
}

function handleResponse(){
	var outObj;
	if(request.readyState == 4){
		if(request.status == 200){
			userDefineFunction(request.responseText);
		}else{
			alert("STATUS:"+request.status);
		}
	}
}

function handleXMLResponse(){
	var outObj;
	if(request.readyState == 4){
		if(request.status == 200){
			if(!window.DOMParser) {
				// -- alert("IE")
				userDefineFunction( createXMLFromString(request.responseText) )	 ;				
			}
			else
				userDefineFunction(request.responseXML);	// -- IE의 경우 request.responseXML이 정상동작 하지 않음.
			
		}else{
			alert("STATUS:"+request.status);
		}
	}
}

function createXMLFromString(string) {
   var xmlDocument;
   var xmlParser;
   if(window.ActiveXObject){   //IE일 경우
      xmlDocument = new ActiveXObject('Microsoft.XMLDOM');
      xmlDocument.async = false;
      xmlDocument.loadXML(string);
   } else if (window.XMLHttpRequest) {   //Firefox, Netscape일 경우
      xmlParser = new DOMParser();
      xmlDocument = xmlParser.parseFromString(string, 'text/xml');
   } else {
      return null;
   }
   return xmlDocument;
}