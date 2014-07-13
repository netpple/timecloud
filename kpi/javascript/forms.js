/**
 * Form check framework

 * 
 * history:
 * 	setRule, setExRule 룰데이터 확장.
 * interface:
 *  disabled(nm, bool): 필드명의 필드 disable여부
 *  get(nm, defVal): 필드명의 값반환(nm:콤마구분으로 여러값을 사용하거나 value가 여럿이라면 콤마구분으로 반환)
 *  set(nm, newVal): 필드명에 값셋팅(nm:콤마구분의 여러값가능)
 *  reset(): 화면값 재설정.
 *  focus(nm): 필드에 포커스이동
 *  select(nm, idx, bool): 필드명에 해당하는 인덱스값 선택여부(radio/checkbox/select)
 *  setRule(nms, rule, errmsg, alertmsg): 필드명에 해당하는 룰을 셋팅.
 *  setExRule(nms, rule, label, errmsgs, alertmsg): 필드명에 해당하는 룰을 셋팅하며 errmsgs는 배열이다.
 * 	check(errseq): 룰에 기반한 검증을 수행.
 *  submit(url, mth, bool): 화명값을 서버로 전송(fg:값에 따라 검증여부처리)
 *  toString(): 화면값을 name=value기반으로 & 구분으로 문자를 반환.
 *  exists(): 필드 존재여부 를 반환.
 */
 
 
var IS_DEBUG = false;
var LAST_FUN = null;
 
/**
 * Form 생성자
 * frm: 폼의 객체
 * 
 * var f = new Forms(document.forms[0]);
 * f.set("fieldname1", "value");
 * f.setRule("fieldname2, "min=1, max=100", "에러발생");
 * if(f.checked()){
 * 	f.submit("url");
 * }
 */
function Forms(frm){
	
	if(!frm || typeof(frm) != "object"){
		return _ErrMsg("invalid form object");
	}
	
	this.frm = frm;
	this.flds = new Array();
	this.idx = 0;
	this.errobj = null;
}

/**
 * nms: 폼필드명(콤마구분으로 여러필드를 사용할수 있다)
 * rule: 콤마로 구분된 룰
 * errmsg: 룰을 통과 못하면 보여질 메세지.(${룰명} 룰의 값으로 치환가능)
 */
Forms.prototype.setRule = function(nms, rule, errmsg, alertmsg){
	var obj = new Object();
	obj.name = nms;
	obj.rule = rule;
	obj.errmsg = errmsg;
	obj.alertmsg = alertmsg;

	this.flds[this.idx++] = obj;
}

//이성우 차장님때문에 억지로 추가한다.
Forms.prototype.setExRule = function(nms, rule, lbl, errmsgs, alertmsg){
	this.setRule(nms, rule, lbl+":\n"+errmsgs.join("\n"), alertmsg);
}

Forms.prototype.clearRule = function(){
	this.flds = new Array();
	this.idx = 0;
}
	

/**
 * 주어지는 룰기반으로 폼검증작업처리
 * errseq:true - 에러가 나도 끝까지 모두 검증후 모든 메세지 모아서 출력.
 *        false - 에러가 나면 바로 멈추고 에러난 폼에 포커스 이동후 메세지 출력
 * return: 에러검증이 성공하면여부 반환(true/false)
 */
Forms.prototype.check = function(isErrSeq){
	
	var errmsg = "";
	var errobj = null;
	var fldobj = null;
	var fldnms = null;
	var errCnt = 0;
	var rules = null;
	var isOr = false;
	var operation = null;
	
	//전역object초기화.
	this.errobj = null;
	
	try{
		for(var i=0;i<this.flds.length;i++){
			fldnms = this.flds[i].name.split(",");
			rules = _ParseRule(this.flds[i].rule);
			if(!rules){
				throw "invalid rule : "+this.flds[i].rule;
			}
			
			isOr = false;//reset
			operation = null;
			//input이 여러개인경우 or처리인지 and처리인지 확인먼저.
			if(fldnms.length > 1){
				for(var n=0;n<rules.length;n++){
					if("opr" == rules[n].nm){
						if("||" == rules[n].val || "&&" == rules[n].val){
							isOr = ("||" == rules[n].val);
						} else {
							operation = rules[n].val;
						}
						
						//checkRule에서 에러안나도록 opr룰삭제
						rules[n].nm = "noop";
						break;
					}
				}//endfor
			}
			
			//필드가 n개일수 있다.
			var locErrCnt = 0;
			for(var j=0;j<fldnms.length;j++){
				fldobj = this.object(toTrim(fldnms[j]));
				if(fldobj && typeof(fldobj) == "object"){
					if(!_CheckRule(this.frm, fldobj, rules)){
						locErrCnt += 1;//err갯수증가.
						
						if(!this.errobj){
							this.errobj = fldobj;
						}
					}
				} else {
					throw "not founds object : "+fldnms[j];
				}
			}//sub for
			
			
			//operation
			if(operation){
				if(fldnms.length > 2){
					throw "elements count over for opr : "+(fldnms.length);
				}
				
				var v1 =_GetFieldValue(this.object(toTrim(fldnms[0])));
				var v2 =_GetFieldValue(this.object(toTrim(fldnms[1])));
				eval("var oprErr=(v1"+operation+"v2);");
				if(oprErr){
					//에러 있다고 간주.
					locErrCnt = locErrCnt + 1;
				}
				
				if(!this.errobj){
					this.errobj = this.object(toTrim(fldnms[0]));
				}
			}
			
			//or룰이라면 하나라도 성공이라면 모두성공으로간주
			if(isOr && locErrCnt > 0 && (locErrCnt != fldnms.length)){
				locErrCnt = 0;
			}
			
			
			//error
			if(locErrCnt > 0){
				if(errmsg.length > 0){
					errmsg += "\n";
				}
				errmsg += "- "+_TransMessage(this.flds[i].rule, this.flds[i].errmsg);
				//전체에러갯수 계산.
				errCnt = errCnt + locErrCnt;
				
				if(!isErrSeq){
					break;
				}
			} else if(this.flds[i].alertmsg){
				_AlertMsg(this.flds[i].alertmsg);
			}
		}//end for
		
		
		if(errCnt > 0) {
			var ret = _ErrMsg(errmsg);
			if(this.errobj){
				_FocusField(this.errobj);
			}
			
			return ret;
		} else {
			return true;	
		}
		
	}catch(ex){
		
		this.clearRule();
		try{
			if(ex.description){
				_ErrMsg("catch : "+ex.description);
			} else {
				_ErrMsg("catch : "+ex);
			}
		}catch(e1){}
		return false;
	}
};//end function

Forms.prototype.equals = function(nm, val){
	return val == this.get(nm);
}

/**
 * 주어진 필드명에 해당하는값을 반환.
 * nm: 폼의 필드명(콤마구분으로 여러필드명을 사용가능)
 * def: 필드에 값이 없는경우 대체 사용할 기본값
 * return: 필드명으로 주어진 값을 반환(배열명의 필드나 여러값일 경우 콤마구분으로 반환)
 */	
Forms.prototype.get = function(nm, def, idx){
	
	var nms = nm.split(",");
	var vals = new Array();
	var obj = null;
	
	for(var i=0;i<nms.length;i++){
		obj = this.object(toTrim(nms[i]), idx);
		vals[i] = _GetFieldValue(obj, def, nms[i]);
	}
	
	return vals.join(",");
}


/**
 * select box에 option값추가.
 */
Forms.prototype.addOpt = function(nm, txt, val){
	var nms = nm.split(",");
	var isOk = false;	
	for(var i=0;i<nms.length;i++){
		isOk = _AddOption(this.object(toTrim(nms[i])), txt, val, nms[i]);
	}
	
	return isOk;
}


Forms.prototype.delOpt = function(nm, txt){
	var nms = nm.split(",");
	var isOk = false;	
	for(var i=0;i<nms.length;i++){
		isOk = _DeleteOption(this.object(toTrim(nms[i])), txt, nms[i]);
	}
	
	return isOk;
}

/**
 * 주어지는 필드명에 값을 셋팅.
 * nm: 값을 등록할 필드명(콤마로 구분된 여러필드명 사용가능)
 * val: 필드에 셋팅할 값.
 * return: 필드에 값셋팅성공여부(true/false)
 */
Forms.prototype.set = function(nm, val, idx){
	
	var nms = nm.split(",");
	var isOk = false;	
	for(var i=0;i<nms.length;i++){
		isOk = _SetFieldValue(this.object(toTrim(nms[i]), idx), val, nms[i]);
	}
	
	return isOk;
}

Forms.prototype.exists = function(nm){
	var nms = nm.split(",");
	var obj = null;
	var isExists = false;
	
	for(var i=0;i<nms.length;i++){
		obj = this.object(toTrim(nms[i]));
		if(!_IsSetVar(obj)){
			return false;
		}
		
		isExists = true;
	}
	
	return isExists;
}

/**
 * 
 */
Forms.prototype.select = function(nm, idx, fg){
		
	//default setting
	if(!_IsSetVar(idx)){
		idx = 0;
	}
	
	//default setting
	if(!_IsSetVar(fg)){
		fg = true;
	}
	
	var nms = nm.split(",");
	var isOk = false;
	
	for(var i=0;i<nms.length;i++){
		isOk = _SelectField(this.object(toTrim(nms[i])), idx, fg, nms[i]);
	}
	
	return isOk;
}

Forms.prototype.focus = function(nm, idx){
	var obj = this.object(toTrim(nm));
	if(idx >= 0 && obj[0]){
		return _FocusField(obj[idx]);	
	} else {
		return _FocusField(obj);
	}
}


/**
 * 
 */
Forms.prototype.disabled = function(nm, fg){
	
	if(!_IsSetVar(fg)){
		fg  = true;
	}
	
	var nms = nm.split(",");
	var isOk = false;
	
	for(var i=0;i<nms.length;i++){
		isOk = _DisableField(this.object(toTrim(nms[i])), fg, nms[i]);
	}
	
	return isOk;
}

/**
 * 호환성을위해 존재.
 */
Forms.prototype.reset = function(nm){
	if(_IsSetVar(nm)){
		var nms = nm.split(",");
		for(var i=0;i<nms.length;i++){
			_ResetField(this.object(toTrim(nms[i])));
		}
	} else {
		this.frm.reset();
	}
}

/**
 * 
 */
Forms.prototype.submit = function(url, mth, tgt, chk){
	
	if(_IsSetVar(url)){
		this.frm.action = url;
	} else if(this.action){
		this.frm.action = this.action;
	}
	
	if(_IsSetVar(mth)){
		this.frm.method = mth;
	} else if(this.method){
		this.frm.method = this.method;
	}
	
	if(_IsSetVar(tgt)){
		this.frm.target = tgt;
	} else if(this.target){
		this.frm.target = this.target;
	}
	
	//if wanna checked..
	var isGo = false;
	
	if(_IsSetVar(chk) && chk){
		isGo = this.checked();
	} else {
		isGo = true;
	}

	if(isGo){
		this.frm.submit();
	}
}

Forms.prototype.object = _object;
	
function _object(nm, idx){
	var obj = this.frm.elements[toTrim(nm)];
	
	if(!obj){
		obj = document.getElementById(toTrim(nm));
	}
	
	//jquery
	if(!obj && jQuery){
		obj = jQuery(nm);
	}
	
	if(idx > -1 && obj && obj[0]){
		obj = obj[idx];
	}
	
	return obj;
}

/*=============================================================================
  Function : 화면의 폼필드값을 모두 name=value와 &구분으로 묶어서 출력한다.
  Return   : true/false
  Usage    :
=============================================================================*/
Forms.prototype.toString = function (){
	var buf = '';
	var obj = null;
	for(var i=0;i<this.frm.elements.length;i++){
		obj = this.frm.elements[i];
		if(obj[0]){
			for(var j=0;j<obj.length;j++){
				if(buf.length>0)buf += '&';
				buf += obj[j].name;
				buf += '=';
				buf += obj[j].value;
			}
		} else {
			if(buf.length>0)buf += '&';
			buf += obj.name;
			buf += '=';
			buf += obj.value;
		}
	}
	return buf;
}


/*=============================================================================
  Function : toCurrency() - 통화포맷으로 변환한다.
  Return   : string
  Usage    : 예)1,234,100.013 = toCurrency('1234100.013');
=============================================================================*/
function toCurrency(val){
	var ch,i=0,a='',t='',ck=0,tStr='';

	if(!val) return '';

	val = String(val);


	//'-' 여부를 판단해 보관한다.
	if(val.charAt(0) == '-'){
		a = '-';
		val = val.substring(1);
	}

	// '.' 존재여부를 판단해 소수점이후부터는 포맷되지 않도록 보관하다.
	if((i=val.lastIndexOf('.')) != -1){
		t = val.substring(i);//소숫점이후보관.
		val = val.substring(0,i);
	}

	//number형에 맞지 않는 문자 필터.
	val = Number(val).toString();

	for(i=val.length-1;i>=0; i--) {
		ch = val.charAt(i);
		if(ch>=0 && ch<=9) {
			if((++ck % 4) == 0) {
				tStr = ',' + tStr;
				ck = 1;
			}
			tStr = ch + tStr;
		}
	}
	return a+tStr+t;
}

/*=============================================================================
  Function : toMask() - val로 주어지는 문자를 mask로 필터를 한다.
  Return   : string
  Usage    : 9 == number type
	         # == any type
       예) '2002/01/01' = toMask('20020101', '####/##/##');
	       '우편)주소내용-동호수' = toMask('우편주소내용동호수','##)####-###');
=============================================================================*/
function toMask(val, mask){
	var C_MSK = "#";
	var N_MSK = "9";
	
	var c,m, j=0;
	var buf = "";
	for(var i=0; i < mask.length; i++) {
		
		if(val.length < j){
			break;
		} 
		
		m = mask.charAt(i);
		if(m != C_MSK && m != N_MSK){
			buf += m;
		} else if(m == ' '){
			buf += ' ';
		} else {
			c = val.charAt(j++);
			if(m == N_MSK){
				if('9' >= c && c >= '0'){
					buf += c;
				}
			} else {
				buf += c;
			}
		}
	}
	return buf;
}


function toTrim(val){
	return val?val.replace(/(^\s*)|(\s*$)/g, ""):val;
}


/*=============================================================================
  Function : dt로 주어지는 날짜형 문자를 Date형으로 리턴.
  Return   : Date
  Usage    :
=============================================================================*/
function toDate(dt){
	if(!dt)return dt;

	dt = dt.replace(/(\/|\,|\.|\-)/g,"");//filter

	var y = dt.substring(0,4);
	var m = dt.substring(4,6)-1 ;
	var d = dt.substring(6,8);
	return new Date(y,m,d);
}


/*=============================================================================
  Function : dt로 주어지는 날짜가 날짜형식에 맞는지 점검.
  Return   : true/false
  Usage    :
=============================================================================*/
function isDate(dt){
	var y,m,d,dt2;
	if(!dt) return false;

	dt = dt.replace(/(\/|\,|\.|\-)/g,"");//filter
	if(dt.length != 8) return false;

	y = dt.substring(0,4);
	m = dt.substring(4,6)-1 ;
	d= dt.substring(6,8);
	dt2 = new Date(y,m,d);
	return (dt2.getFullYear() == y && dt2.getMonth() == m && dt2.getDate() == d)
}

/*=============================================================================
  Function : 날짜의 일수를 반환한다. (n일간)
  Return   : true/false
  Usage    : 양편놓기 함수입니다.(강팀장님주석) - 수수료 계산시 사용(김진희 주석추가)
			  flag : true or undefined 이면 큰날짜-작은날짜
			         false 이면 stfr-stto
=============================================================================*/
function diffDate(stfr,stto,flag){
	if(!stfr || !stto) return 0;
  if(!isDate(stfr) || !isDate(stto)) return 0;

	var dtfr = toDate(stfr);
	var dtto = toDate(stto);

	var stm = dtfr.getTime();
	var etm = dtto.getTime();
	var re = 0;
	if(typeof(flag)=='undefined' || flag) {
		if(stm>etm){
			re = stm - etm;
		} else {
			re = etm - stm;
		}
	} else {
		re = stm - etm;
	}
	return (re / (1000 * 60 * 60 * 24)) + 1;
}

/*=============================================================================
  Function : dt에 주어지는 날짜에 dy일의 기간을 더한 새로운 날짜를 리턴한다.
  Return   : string
  Usage    :
=============================================================================*/
function addDate(dt, dy, fmt){
	if(!isDate(dt) || !dy) return dt;

	var df = toDate(dt);
	df.setDate(df.getDate()+dy);

	var y = df.getFullYear();
	var m = df.getMonth()+1;
	var d = df.getDate();
	return toMask(""+y+(m>9?m:'0'+m)+(d>9?d:'0'+d), fmt);
}
/*=============================================================================
  Function : 주어지는 날짜에 n개월수 만큼 기간을 더한 새로운 날짜를 리턴한다.
  Return   : string
  Usage    :
=============================================================================*/
function addMonth(obj,n){

	var dt,y,m,d;
	var dt2 = new Date();

	dt = obj.value.replace(/(\/|\,|\.|\-)/g,"");
	y = dt.substring(0,4);
	m = Number(dt.substring(4,6)) - 1;
	d = dt.substring(6,8);

	dt2.setYear(y);
	dt2.setMonth(Number(m)+Number(n));
	dt2.setDate(d);

	y = dt2.getYear();
	m = Number(dt2.getMonth()) + 1;
	d = dt2.getDate();
	switch(Number(m)){
	case	2 :
			if(d > 28){
				d = 29;
				if(!isDate(y+""+(Number(m)>9?m:'0'+m)+(d>9?d:'0'+d))) d = 28;
			}
			break;
	case	4 :
			if(d > 30) d = 30;
			break;
	case	6 :
			if(d > 30) d = 30;
			break;
	case	9 :
			if(d > 30) d = 30;
			break;
	case	11 :
			if(d > 30) d = 30;
			break;
	}// end switch()

	return ""+y+"/"+(Number(m)>9?m:'0'+m)+"/"+(d>9?d:'0'+d);
}//end function addMonth(obj)

var _PRE_OBJ;
function focusRow(id, clr){
	if(id){
		var obj = document.getElementById(id);
		if(!obj){
			obj = id;//object로 인식.
		}
		
		if(_PRE_OBJ){
			_PRE_OBJ.style.background = '';
		}
		_PRE_OBJ = obj;
		
		if(!clr){
			clr = '#C7EEFE';
		}
		obj.style.background = clr;
		return obj;
	} else {
		return _PRE_OBJ;//파라메터없이 호출은 이전객체 반환.
	}
}

function blurRow(){
	if(_PRE_OBJ){
		_PRE_OBJ.style.background = '';
		_PRE_OBJ = null;
	}
}

/** inner util function ********************************************************/

/**
 * 필드에 대해서 룰을 파싱한다.
 * fldobj: 필드해당 객체
 * rule: 문자기반의 룰
 * return: 룰을 통과여부 반환(true/false)
 */
function _CheckRule(frm, fldobj, rules){
	
	var isTypePass = false;
	switch(_FieldType(fldobj)){
		case "radio": 
		case "checkbox": 
			isTypePass = _MultiBoxRule(frm, fldobj, rules);
			break;
			
		case "select-one":
		case "select-multiple":
			isTypePass = _SelectRule(frm, fldobj, rules);
			break;
			
		case "file": 
		case "text": 
		case "password": 
		case "textarea": 
		case "hidden": 
			isTypePass =  _InputRule(frm, fldobj, rules);
			break;
			
		default: 
			return _ErrMsg("unsupported field type:"+_FieldType(fldobj));
	}//end switch
	
	return isTypePass;
};//end function


/** checker input type rule */
function _InputRule(frm, fldObj, rules){

	var failCnt = 0;
	var isPass = true;
	var isIgnore = false;
	var isErrFocus = false;
	var isArr = fldObj[0]?true:false;
	var obj, mx = isArr?fldObj.length:1;

	for(var j=0;j<mx;j++){
		obj = isArr?fldObj[j]:fldObj;
		isIgnore = false;
		for(var i=0;i<rules.length;i++){
			switch(rules[i].nm){
				case "min":
					isPass = _StrByte(obj.value) >= Number(rules[i].val);
				break;
				
				case "max":
					isPass = _StrByte(obj.value) <= Number(rules[i].val);
				break;
				
				case "minnum":
					isPass = Number(obj.value) >= Number(rules[i].val);
				break;
				
				case "maxnum":
					isPass = Number(obj.value) <= Number(rules[i].val);
				break;
						
				case "mask":
					isPass = _ValidMask(obj.value, rules[i].val);
				break;
				
				case "type":
					isPass = _ValidType(obj.value, rules[i].val, this);
				break;
				
				//한글설정이 아닌데 한글이 입력된경우 찾아낸다.
				//이외는 다 맞다고 본다..^^
				//근데 사용안하는게 맞다.
				case "lang":
					isPass = (rules[i].val == "ko")?_IsKor(obj.value):true;
				break;
				
				case "ref":
					isPass = _RefCheck(rules[i].val);
				break;
				
				case "value":
					if(rules[i].val == "unique" && mx > 1 && j > 0){
						for(var k=j-1;k>=0;k--){
							if(fldObj[k].value == obj.value){
								isPass = false;
								break;
							}
						}
					}else if(rules[i].val.indexOf("!") == 0){
						isPass = (rules[i].val==("!"+obj.value));
					}else {
						isPass = !(rules[i].val==obj.value);
					}
				break;
				
				case "index":
					if(rules[i].val == "all" || Number(rules[i].val) == j){
						//nothing
					} else {
						isIgnore = true;
					}
				break;
				
				case "error":
					if(rules[i].val == "focus"){
						isErrFocus = true;
					}
				break;
				
				case "noop":
				break;
				
				default: 
					return _ErrMsg("unsupported (input) keyword:"+rules[i].nm);
			}
			
			if(!isPass){
				failCnt += 1;
			}
		}//end for
		
		if(isIgnore){
			failCnt = 0;
		}
		
		if(!isPass){
			if(isErrFocus && obj && obj.type != "hidden"){
				obj.focus();
				return false;
			}
		}
	}//end for
	
	return failCnt == 0;	
}


function _SelectRule(frm, fldObj, rules){
	
	
	var isPass = true;
	var failCnt = 0;
	var chk = 0;
	var isIgnore = false;
	var isArr = fldObj[0][0]?true:false;
	var obj, mx = isArr?fldObj.length:1;
	
	for(var j=0;j<mx;j++){
		obj = isArr?fldObj[j]:fldObj;
		isIgnore = false;
		
		for(var i=0;i<obj.options.length;i++){
			if(obj.options[i].selected && obj.options[i].value){
				chk += 1;
			}
		}
	
		for(var i=0;i<rules.length;i++){
			switch(rules[i].nm){
				case "min":
					isPass = chk >= Number(rules[i].val);
				break;
				
				case "max":
					isPass = chk <= Number(rules[i].val);
				break;	
				
				case "ref":
					isPass = _RefCheck(rules[i].val);
				break;
				case "index":
					if(rules[i].val == "all" || Number(rules[i].val) == j){
						//nothing
					} else {
						isIgnore = true;
					}
				break;
				
				case "error":
				break;
				
				case "noop":
				break;
				default: 
					return _ErrMsg("unsupported (select) keyword:"+rules[i].nm);
			}

			if(!isPass){
				failCnt += 1;	
			}
		}
		
		if(isIgnore){
			failCnt = 0;
		}
	}//end for
	
	return failCnt == 0;	
}

/** checker radio/checkbox type rule */
function _MultiBoxRule(frm, obj, rules){
	
	var isPass = true;
	var chk = 0;
	var failCnt = 0;
	
	if(obj[0]){
		for(var i=0;i<obj.length;i++){
			if(obj[i].checked){
				chk += 1;
			}
		}
	} else if(obj.checked){
			chk = 1;
	}
	
	var isIgnore = false;
	for(var i=0;i<rules.length;i++){
		
		switch(rules[i].nm){
			case "min":
				isPass = chk >= Number(rules[i].val);
			break;
			
			case "max":
				isPass = chk <= Number(rules[i].val);
			break;	
			
			//의존성있는 다른필드의 값이 거짓이면 현재의 필드도 거짓이다.
			case "ref":
				isPass = _RefCheck(rules[i].val);
			break;
			case "index":
				if(rules[i].val == "all"){
					isPass = (obj.length == chk);
				}else if(obj[rules[i].val].checked){
					isPass = true;
				}
			break;
			case "value":
				if((rules[i].val=="true" && chk > 0) 
						|| (rules[i].val=="false" && chk == 0)){
					isPass = false;
				}
				break;
				
			case "error":
				break;
				
			case "noop":
				break;
			default: 
				return _ErrMsg("unsupported (checkbox/radio) keyword:"+rules[i].nm);
		}
				
		if(!isPass){
			failCnt += 1;	
		}
	}
	
	return failCnt == 0;	
}

function _ParseRule(rule){
	var ps = 0, idx = 0;
	var obj,rulNm,rulVal;
	var ruleToks = rule.split(",");
	var rules = new Array();
	for(var i=0;i<ruleToks.length;i++){
		ps = ruleToks[i].indexOf("=");
		if(ps != -1){
			obj = new Object();
			
			rulNm = toTrim(ruleToks[i].substring(0, ps))
			rulVal = toTrim(ruleToks[i].substring(ps+1))
			obj.nm = rulNm.toLowerCase();
			obj.val = rulVal;
			
			rules[idx++] = obj;
		} else {
			return null;
		}
	}
	
	return rules;
}

function _FocusField(obj){
	var o = null;
	
	if(obj[0]){
		o = obj[0];
	} else {
		o = obj;
	}
	
	if(o && o.type != "hidden" && !o.disabled){
		o.focus();
		return true;
	}
	
	return false;
}


function _TransMessage(rule, msg){
	//rule데이타 없으면 아무짓도 안한다.
	if(!rule) return msg;
	
	var pmsg = msg;
	var vals = rule.split(",");
	var ps = 0;
	var s,nm,val;
	
	for(var i=0;i<vals.length;i++){
		s = vals[i];
		if((ps = s.indexOf("=")) != -1){
			nm = toTrim(s.substring(0, ps));
			val = toTrim(s.substring(ps+1));
			
			pmsg = pmsg.replace("$["+nm+"]", val);
		}
	}
	
	return pmsg;
}

function _IsSetVar(v){
	return !(v == null || typeof(v) == "undefined");
}

function _ValidMask(val, msk){
	var c,m;
	
	if(val.length != msk.length) return false;
	
	for(var i=0; i < val.length; i++) {
		c = val.charAt(i);
		m = msk.charAt(i);
		if(m != "#" && c != m){
			return false;
		}
	}
	
	return true;
}

function _ValidType(val, ty, frm){
	if(ty == "number"){
		return _IsNumber(val);
	} else if(ty == "float"){
		return _IsFloat(val);
	} else if(ty == "date"){
		return _IsDate(val);
	} else if(ty == "currency"){
		return _IsCurrency(val);
	} else if(ty == "email"){
		return _IsEmail(val);
	} else if(ty == "passwd"){
		return validatePassword(val, frm.pwdOpt);
	} else {
		_ErrMsg("not supprted type:"+ty);	
	}
	
	return false;
}

function _GetFieldValue(obj, defval, msg){
	
	if(!obj){
		_ErrMsg("_GetFieldValue: object is invalid:"+msg);
		return defval;
	}
	
	switch(_FieldType(obj)) {
		case "radio":
			if(obj[0]){
				for(var i=0;i<obj.length;i++){
					if(obj[i].checked){
						return obj[i].value;
					}
				}
			} else {
				if(obj.checked){
					return obj.value;
				}
			}
		break;
		
		//다중건이라면 콤마구분자의 문자로 반환한다.
		case "checkbox":
			if(obj[0]){
				var a = new Array();
				var inc = 0;
				for(var i=0;i<obj.length;i++){
					if(obj[i].checked){
						a[inc++] = obj[i].value;
					}
				}
				
				return a.join(",");
			} else {
				if(obj.checked){
					return obj.value;
				}
			}
		break;
		
		//다중건이라면 콤마구분자의 문자로 반환한다.
		case "select-one":
		case "select-multiple":
			var a = new Array();
			var inc = 0;
			for(var i=0;i<obj.length;i++){
				if(obj.options[i].selected){
					a[inc++] = obj.options[i].value;
				}
			}
			return a.join(",");
		break;
		
		default:
			var cls = obj.className;
			if(cls) {//class라면 처리
				var d;
				if(cls == "number" || cls == "currency"){
					d = obj.value.replace(/(\/|\,)/g,"");
					return Number(d);
				} else {
					d = obj.value.replace(/(\-|\/|\:)/g,"");
					return d;
				}
			} else {
				return obj.value?obj.value:defval;
			}
	}//end switch
	
	return defval;
}


function _DisableField(obj, fg, msg){
	
	if(!obj){
		_ErrMsg("_DisableField: object is invalid:"+msg);
		return;
	}
	
	switch(_FieldType(obj)) {
	    case "hidden": break;
		case "radio":
		case "checkbox":
			if (obj[0]) {
				for(var i=0;i<obj.length;i++){
					obj[i].disabled = fg;
				}
			} else {
				obj.disabled = fg;
			}
			break;
		default:
			obj.disabled = fg;
			//배경색을 넣어준다...닝기리.
			if(obj.style){
				var col;
				if (fg) {
					col = "#E1EBF7";
				} else {
					col = "white" ;
				}
				obj.style.backgroundColor = col;
			}//end if
	
	}//end switch
}

/**
 * obj: element of form
 * idx: 0 base array
 */
function _SelectField(obj, idx, fg, msg){
	
	if(!obj){
		_ErrMsg("_SelectField: object is invalid:"+msg);
		return;
	}

	var isDone = false;
	switch(_FieldType(obj)) {
		case "checkbox":
		case "radio":
			for(var i=0;i<obj.length;i++){
				if(i == idx){
					obj[i].checked = fg;
					isDone = true;
				}
			}
			break;
			
		case "select-one":
		case "select-multiple":
			for(var i=0;i<obj.options.length;i++){
				if(i == idx){
					obj.options[i].selected = fg;
					isDone = true;
				}
			}
			break;
		default:
			if(obj[0]){
				for(var i=0;i<obj.length;i++){
					if(i == idx){
						obj[i].select();
						isDone = true;
					}
				}
			} else {
				obj.select();
			}
	}
	
	return isDone;
}


function _AddOption(obj, txt, val, msg) {
	
	if(!obj){
		_ErrMsg("_AddOption: object is invalid:"+msg);
		return false;
	}
	
	switch(_FieldType(obj)) {		
		case "select-multiple":
		case "select-one":
			var len = obj.options.length;
			obj.add(new Option(txt, val));
			return true;
			break;
		default: return _ErrMsg("undefined ("+_FieldType(obj)+") keyword:"+rulNm);
	}
	
	return false;
}


function _DeleteOption(obj, txt, msg) {
	
	if(!obj){
		_ErrMsg("_AddOption: object is invalid:"+msg);
		return false;
	}
	
	switch(_FieldType(obj)) {		
		case "select-multiple":
		case "select-one":
			var len = obj.options.length;
			for(var i=0;i<len;i++){
				if(obj.options[i].text == txt){
					obj.options[i] = null;
					return true;
				}
			}
			
			break;
		default: return _ErrMsg("undefined ("+_FieldType(obj)+") keyword:"+rulNm);
	}
	
	return false;
}
/**
 * obj: element of form
 * val: value for setting
 */
function _SetFieldValue(obj, newVal, msg) {
	
	if(!obj){
		_ErrMsg("_SetFieldValue: object is invalid:"+msg);
		return false;
	}
	
	switch(_FieldType(obj)) {
		case "checkbox":
		case "radio":
			if(obj[0]){
				for(var i=0;i<obj.length;i++){
					//newVal이 boolean형이면 현재 이름의 모든 box를 다른다고 전제.
					//전체 선택 및 해제를 위해추가.
					if(typeof(newVal) == "boolean"){
						obj[i].checked = newVal;
					} else if(obj[i].value == newVal){
						obj[i].checked = true;
						return true;
					}
				}
				
				if(typeof(newVal) == "boolean"){
					return true;
				}
			} else {
				obj.checked = (newVal == true)?newVal:(obj.value == newVal);
				return obj.checked;
			}
			break;
		
		case "select-multiple":
		case "select-one":
			for(var i=0;i<obj.options.length;i++){
				if(obj.options[i].value == newVal){
					obj.selectedIndex = i;
					return true;
				}
			}
			break;

		default:
			var cls = obj.className;//tag의 class명을 얻는다.

			if(cls == "date" && newVal) {//날짜클래스라면처리
				obj.value = toMask(newVal.replace(/(\/|\,|\.|\-)/g,""), "9999/99/99 99:99:99");
			} else if((cls == "currency" || cls == "number") && newVal != null) {
				if(newVal == '0') {
					obj.value = 0;//0은 길이 없는 string으로 치환한다.
				} else {
					if(cls == "currency"){
						var t = toCurrency((typeof(newVal) == "number")?""+newVal:newVal.replace(/(\,)/g, ""));
						obj.value = t;
					} else {
						obj.value = Number(newVal);
					}
				}
			} else if(cls == "rrno" && newVal) {
				obj.value = toMask(newVal, "999999-9999999");
			} else {
				obj.value = newVal;
			}
			return true;
	}
	
	return false;
}


function _RefCheck(val){
	var ret = false;
	var val = null;
	if(!val) return ret;
	
	var arr = val.split("+");
	for(var i=0;i<arr.length;i++){
		val = _GetFieldValue(_object(arr[i]));
		if(val){
			ret = true;
			break;
		}
	}//endfor
	
	return ret;
}

function _ResetField(obj){
	obj.value = obj.defaultValue;
}

/** return forms field type */
function _FieldType(obj){
	var t = obj.type;
	if(!_IsSetVar(t)){
		t = obj[0].type;
	}
	return t?t.toLowerCase():t;
}


/** return korean language type */
function _IsKor(s) {
	for(i=0;i<s.length;i++) {
		var a=s.charCodeAt(i);
		if (a > 128) {
			return true;
		}
	}
	return false;
}

/**
 * 한글 2byte 영문 1byte로 byte를 계산한다.
 */
function _StrByte(s){
	var len = 0;
	for(var i=0;i<s.length;i++){
		if (escape(s.charAt(i)).length > 4){
			len += 2;	
		} else {
			len += 1;	
		}
	}
	return len;
}

function _IsEmail(v){
	var p1 = v.indexOf('@');
	var p2 = v.indexOf('.', p1+1);
	if(p1 != -1 && p2 != -1){
		return true;
	} 
	return false;
}

/*
password options sample
pwdOpt = {
	length:   [8, Infinity],
	lower:    1,
	upper:    1,
	numeric:  1,
	special:  1,
	badWords: ["password", "steven", "levithan"],
	badSequenceLength: 4
};
var ret = validatePassword("1234", pwdOpt);
 */
function validatePassword (pw, options) {
	// default options (allows any password)
	var o = {
		lower:    0,
		upper:    0,
		alpha:    0, /* lower + upper */
		numeric:  0,
		special:  0,
		length:   [0, Infinity],
		custom:   [ /* regexes and/or functions */ ],
		badWords: [],
		badSequenceLength: 0,
		noQwertySequences: false,
		noSequential:      false
	};

	for (var property in options)
		o[property] = options[property];

	var	re = {
			lower:   /[a-z]/g,
			upper:   /[A-Z]/g,
			alpha:   /[A-Z]/gi,
			numeric: /[0-9]/g,
			special: /[\W_]/g
		},
		rule, i;

	// enforce min/max length
	if (pw.length < o.length[0] || pw.length > o.length[1])
		return false;

	// enforce lower/upper/alpha/numeric/special rules
	for (rule in re) {
		if ((pw.match(re[rule]) || []).length < o[rule])
			return false;
	}

	// enforce word ban (case insensitive)
	for (i = 0; i < o.badWords.length; i++) {
		if (pw.toLowerCase().indexOf(o.badWords[i].toLowerCase()) > -1)
			return false;
	}

	// enforce the no sequential, identical characters rule
	if (o.noSequential && /([\S\s])\1/.test(pw))
		return false;

	// enforce alphanumeric/qwerty sequence ban rules
	if (o.badSequenceLength) {
		var	lower   = "abcdefghijklmnopqrstuvwxyz",
			upper   = lower.toUpperCase(),
			numbers = "0123456789",
			qwerty  = "qwertyuiopasdfghjklzxcvbnm",
			start   = o.badSequenceLength - 1,
			seq     = "_" + pw.slice(0, start);
		for (i = start; i < pw.length; i++) {
			seq = seq.slice(1) + pw.charAt(i);
			if (
				lower.indexOf(seq)   > -1 ||
				upper.indexOf(seq)   > -1 ||
				numbers.indexOf(seq) > -1 ||
				(o.noQwertySequences && qwerty.indexOf(seq) > -1)
			) {
				return false;
			}
		}
	}

	// enforce custom regex/function rules
	for (i = 0; i < o.custom.length; i++) {
		rule = o.custom[i];
		if (rule instanceof RegExp) {
			if (!rule.test(pw))
				return false;
		} else if (rule instanceof Function) {
			if (!rule(pw))
				return false;
		}
	}

	// great success!
	return true;
}



//소숫점이하 입력제한.
function _IsNumber(n){
	return n == Math.ceil(Number(n));
}

function _IsFloat(n){
	return n == Number(n);
}

function _IsCurrency(n){
	n = n.replace(/(\,)/g,"");//filter
	return n == Number(n);
}

function _IsDate(dt){
	return isDate(dt);
}

/** output error message */
function _ErrMsg(msg){
	if(IS_DEBUG){
		if(confirm(msg+"\n\n\n Enter debug!!")){
			_debug(_ErrMsg.caller);
		}
	} else {
		alert(msg);
	}
	return false;	
}

/** output error message */
function _AlertMsg(msg){
	alert(msg);
	return true;	
}

//open source javascript 사용.
//AIM.submit([폼오브젝트], [옵션오브젝트]);
//[옵션오브젝트] = {'onStart' : [시작시콜백함수], 'onComplete' : [데이타가도착후콜백함수]}
//
//예) AIM.submit(document.forms[0], {'onStart' : startCallback, 'onComplete' : completeCallback})
//
//function startCallback() {
//	progress(true);
//  f.submit("?method=upload");
//  return true;   
//} 
//
//function completeCallback(response) {   
//	progress(false);
//	if(response){
//		alert(response);
//	}
//}  

/**
 * ajax에서 받아온 데이타를 json으로 처리작업을 위해 랩퍼.
 */
function transData(obj){
	//TODO 향후 데이타셋에 대한 작업필요시 이곳에서 확장.
	eval("var dataset="+toTrim(obj));
	return dataset;
}


var _dwin;
/** output debug message */
function _debug(msg){
	
	if(!_dwin){
		_dwin = window.open("","debug", "status=yes, resizable=yes, scrollbars=yes");
	}

	var m = msg.toString();
	if(_dwin){
		_dwin.document.open("text/text");
		_dwin.document.write("<pre>");
		_dwin.document.write(m.replace("<", "&lt;"));
		_dwin.document.write("</pre>");
		_dwin.document.close();
	}
}

function onCheckNum(){
    if ((event.keyCode<48)||(event.keyCode>57)){     
		event.returnValue = false;		
	}
}

function onCheckNotNum(){
    if(((event.keyCode >= 48 && event.keyCode <=57) )){    
		event.returnValue = false;		
	}
}

function onKorean(){
	if((event.keyCode < 12592) || (event.keyCode > 12687)){
		event.returnValue = false;
	}
}