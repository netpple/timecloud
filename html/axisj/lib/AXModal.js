/*!
 * axisJ Javascript Library Version 1.0
 * http://axisJ.com
 * 
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용시 예상치 못한 피해가 발생 하실 수 있습니다.
 */

var AXModal = Class.create(AXJ, {
	version: "AXModal V1.32",
	author: "tom@axisj.com",
	logs: [
		"2013-02-13 오전 10:39:17 - axmods 에서 컨버트 : tom ",
		"2013-04-08 오전 12:15:17 - resize 메소스 추가 및 버그 픽스 : tom ",
		"2013-06-20 오후 5:21:24 - open 메소드 속성에 width 조건 추가 : tom ",
		"2013-07-09 오후 4:41:48 - animateDuration 속성 추가  : tom ",
		"2013-08-21 오후 4:46:51 - openNew 버그 픽스 : tom ",
		"2013-08-22 오전 10:56:20 - resize 버그 픽스 : tom ",
		"2013-08-24 - openNew 메소드 기능 확장 : tom ",
		"2013-10-14 오전 6:54:40 - resize 기능 보강 : tom "
	],
	initialize: function (AXJ_super) {
		AXJ_super();
		this.config.maskCss = "AXMask";
		this.config.windowBoxCss = "AXModalBox";
		this.config.padding = "0";
		this.config.defaultTop = 10;
		this.config.animateDuration = 300;
		this.config.autoHide = false;
		this.config.windowID = "AXModal" + AXUtil.timekey();
		this.config.contentDivClass = (AXConfig.AXModal) ? AXConfig.AXModal.contentDivClass : "bodyHeightDiv";
		this.config.displayLoading = true;
	},
	init: function () {
		var cfg = this.config;
		this.mask = jQuery("<div class=\"" + cfg.maskCss + "\"></div>");
		jQuery(window).unbind("resize.AXModal").bind("resize.AXModal", this.onDocResize.bind(this));
	},
	setWidth: function (width) {
		var cfg = this.config;
		if (width) {
			cfg.width = width;
		} else {
			cfg.width = undefined;
		}
		
		jQuery("#" + cfg.windowID).css({ width: width });
		var maskWidth = jQuery("#" + cfg.windowID).outerWidth();
		var maskLeft = (jQuery(document.body).width() / 2) - (maskWidth / 2);
		if (maskLeft < 0) maskLeft = 0;
		jQuery("#" + cfg.windowID).css({ left: maskLeft });
		
		jQuery(window).unbind("resize.AXModal").bind("resize.AXModal", this.onDocResize.bind(this));
	},
	open: function (http) {
		var cfg = this.config;

		if (this._windowOpend) return;

		mask.open();
		this.winID = "mdw" + AXUtil.timekey();
		this.frmID = "frm" + AXUtil.timekey();

		if (this.config.width) {
			var maskWidth = this.config.width;
			var maskLeft = (jQuery(document.body).width() / 2) - (this.config.width / 2);
		} else {
			var maskWidth = jQuery(document.body).width() - 50;
			var maskLeft = 10;
		}

		if (http.width) {
			maskWidth = http.width;
			maskLeft = (jQuery(document.body).width() / 2) - (http.width / 2);
		}

		var maskTop = this.config.defaultTop;
		if (http.top != undefined) {
			maskTop = http.top;
		} else {
			maskTop = jQuery(window).scrollTop() + 100;
		}
		if (maskLeft < 0) maskLeft = 0;

		var po = [];
		po.push("<div id='" + this.config.windowID + "' class='" + this.config.windowBoxCss + "' style='top:" + maskTop + "px;left:" + maskLeft + "px;width:" + maskWidth + "px;'>");
		po.push("	<div class='windowbox' id='" + this.winID + "_box' style='padding:" + this.config.padding + "px'>");
		if(cfg.displayLoading){
			po.push("		<div id='" + this.config.windowID + "_loading' style='position:absolute;left:0px;top:0px;width:" + maskWidth + "px;padding:50px 0px 0px 0px;' align='center'>");
			po.push("		<div class=\"AXLoading\"></div>");
			po.push("		<br/><br><font class='blue'>페이지를 로딩 중입니다. 잠시만 기다려 주세요.</font></div>");
		}
		po.push("		<a href='#modsExecption' id='" + this.config.windowID + "_close' class='closeBtn'>닫기</a>");

		po.push("		<form name='" + this.frmID + "' method='"+ (http.method||"post") +"' target='" + this.winID + "' action='" + http.url + "'>");
		po.push("		<input type='hidden' name='winID' value='" + this.winID + "' />");

		if (isNaN(http.pars.length)) {
			jQuery.each(http.pars, function (key, val) {
				po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
			});
		} else {
			jQuery.each(http.pars, function () {
				jQuery.each(this, function (key, val) {
					po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
				});
			});
		}
		po.push("		</form>");
		po.push("		<iframe src='' name='" + this.winID + "' id='" + this.winID + "' frameborder='0' class='windowboxFrame' style='width:100%;overflow:-y:hidden;' scrolling='no'></iframe>");
		po.push("	</div>");
		po.push("</div>");

		if (this.config.appendTargetID) {
			jQuery("#" + this.config.appendTargetID).append(po.join(''));
		} else {
			jQuery(document.body).append(po.join(''));
		}

		var loadingID = this.config.windowID + "_loading";
		var _winID = this.winID;
		var _frmID = this.frmID;

		document[_frmID].submit();
		var keydown = this.keydown.bind(this);
		jQuery("#" + this.winID).bind("load", function () {
			var myIframe = window[_winID];

			var bodyHeight = jQuery(myIframe.document).innerHeight();
			if (jQuery(myIframe.document.body).find("."+cfg.contentDivClass).get(0)) {
				bodyHeight = jQuery(myIframe.document.body).find("."+cfg.contentDivClass).outerHeight();
			}
			jQuery(this).animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");
			jQuery("#" + _winID + "_box").animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");
			if(cfg.displayLoading) jQuery("#" + loadingID).fadeOut("slow");
			jQuery("#" + _winID).addClass("loaded");
			
			if(http.closeByEscKey){
				jQuery(myIframe.document.body).bind("keydown.AXModal", keydown);
			}
		});
		jQuery("#" + this.config.windowID + "_close").bind("click", this.close.bind(this));

		if(http.closeByEscKey){
			jQuery(document.body).bind("keydown.AXModal", keydown);
		}

		this._windowOpend = true;
	},
	openI: function (http) {
		var cfg = this.config;

		if (this._windowOpend) return;

		mask.open();
		this.winID = "mdw" + AXUtil.timekey();
		this.frmID = "frm" + AXUtil.timekey();

		if (this.config.width) {
			var maskWidth = this.config.width;
			var maskLeft = (jQuery(document.body).width() / 2) - (this.config.width / 2);
		} else {
			var maskWidth = jQuery(document.body).width() - 50;
			var maskLeft = 10;
		}

		if (http.width) {
			maskWidth = http.width;
			maskLeft = (jQuery(document.body).width() / 2) - (http.width / 2);
		}

		var maskTop = this.config.defaultTop;
		if (http.top != undefined) {
			maskTop = http.top;
		} else {
			maskTop = jQuery(window).scrollTop() + 100;
		}

		if (maskLeft < 0) maskLeft = 0;

		var po = [];
		po.push("<div id='" + this.config.windowID + "' class='" + this.config.windowBoxCss + "' style='top:" + maskTop + "px;left:" + maskLeft + "px;width:" + maskWidth + "px;'>");
		po.push("	<div class='windowbox' id='" + this.winID + "_box' style='padding:" + this.config.padding + "px'>");
		po.push("		<div id='" + this.config.windowID + "_loading' style='position:absolute;left:0px;top:0px;width:" + maskWidth + "px;padding:50px 0px 0px 0px;' align='center'>");
		po.push("		<div class=\"AXLoading\"></div>");
		po.push("		<br/><br><font class='blue'>페이지를 로딩 중입니다. 잠시만 기다려 주세요.</font></div>");
		po.push("		<a href='#modsExecption' id='" + this.config.windowID + "_close' class='closeBtn'>닫기</a>");

		po.push("		<form name='" + this.frmID + "' method='post' target='" + this.winID + "' action='" + http.url + "'>");
		po.push("		<input type='hidden' name='winID' value='" + this.winID + "' />");

		if (isNaN(http.pars.length)) {
			jQuery.each(http.pars, function (key, val) {
				po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
			});
		} else {
			jQuery.each(http.pars, function () {
				jQuery.each(this, function (key, val) {
					po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
				});
			});
		}
		po.push("		</form>");
		
		if(http.maxHeight){
			po.push("		<iframe src='' name='" + this.winID + "' id='" + this.winID + "' frameborder='0' class='windowboxFrame' style='width:100%;overflow:-y:hidden;' scrolling='auto'></iframe>");
		}else{
			po.push("		<iframe src='' name='" + this.winID + "' id='" + this.winID + "' frameborder='0' class='windowboxFrame' style='width:100%;overflow:-y:hidden;' scrolling='no'></iframe>");
		}

		po.push("	</div>");
		po.push("</div>");


		if (this.config.appendTargetID) {
			jQuery("#" + this.config.appendTargetID).append(po.join(''));
		} else {
			jQuery(document.body).append(po.join(''));
		}

		var loadingID = this.config.windowID + "_loading";
		var _winID = this.winID;
		var _frmID = this.frmID;

		document[_frmID].submit();

		jQuery("#" + this.winID).bind("load", function () {
			var myIframe = window[_winID];

			var bodyHeight = jQuery(myIframe.document).innerHeight();
			if (jQuery(myIframe.document.body).find("."+cfg.contentDivClass).get(0)) {
				bodyHeight = jQuery(myIframe.document.body).find("."+cfg.contentDivClass).outerHeight();
			}
			if(http.maxHeight){
				if(http.maxHeight < (bodyHeight.number() + maskTop.number() + 10)){
					bodyHeight = http.maxHeight - maskTop.number() - 10;
				}
			}
			
			jQuery(this).animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");
			jQuery("#" + _winID + "_box").animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");
			jQuery("#" + loadingID).fadeOut("slow");
			jQuery("#" + _winID).addClass("loaded");
		});
		jQuery("#" + this.config.windowID + "_close").bind("click", this.close.bind(this));

		/*
        if (this.mask) {
            if (this.config.autoHide) this.mask.bind("click", this.close.bind(this));
        }
        */
		//window.scroll(0, 0);
		this._windowOpend = true;
	},
	openDiv: function (args) {
		mask.open();

		var modalID = args.modalID;

		if (AXgetId(modalID)) {
			jQuery("#" + modalID).show();

			/* div modal인  경우 windowID 에 modalID를 넣어준다. */
			this.config.windowID = modalID;
			
			if(args.closeByEscKey){
				var keydown = this.keydown.bind(this);
				var keydownBind = function(){
					keydown(event, modalID);
				};
				jQuery(document.body).bind("keydown.AXModal", keydownBind);
			}
			
			return;
		}

		var maskWidth, maskLeft;
		if (this.config.width) {
			maskWidth = this.config.width;
			maskLeft = (jQuery(document.body).width() / 2) - (this.config.width / 2);
		} else {
			maskWidth = jQuery(document.body).width() - 50;
			maskLeft = 10;
		}

		if (args.width) {
			maskWidth = args.width;
			maskLeft = (jQuery(document.body).width() / 2) - (args.width / 2);
		}

		var maskTop = this.config.defaultTop;
		if (args.top != undefined) {
			maskTop = args.top;
		}

		if (maskLeft < 0) maskLeft = 0;

		var po = [];
		po.push("<div id='" + modalID + "' class='" + this.config.windowBoxCss + "' style='top:" + maskTop + "px;left:" + maskLeft + "px;width:" + maskWidth + "px;'>");
		po.push("	<div class='windowbox' style='padding:" + this.config.padding + "px'>");
		po.push("		<a href='#modsExecption' id='" + modalID + "_close' class='closeBtn'>닫기</a>");
		po.push("		<div id='" + modalID + "_content'></div>");
		po.push("	</div>");
		po.push("</div>");

		jQuery(document.body).append(po.join(''));

		jQuery("#" + modalID + "_content").append(jQuery("#" + args.targetID));

		var loadingID = modalID + "_loading";

		var closeBind = this.close.bind(this);
		var closeModal = function (event) {
			closeBind(event, modalID);
		};
		jQuery("#" + modalID + "_close").bind("click", closeModal);

		if(args.closeByEscKey){
			var keydown = this.keydown.bind(this);
			var keydownBind = function(){
				keydown(event, modalID);
			};
			jQuery(document.body).bind("keydown.AXModal", keydownBind);
		}
		
		/*
        if (this.mask) {
            if (this.config.autoHide) this.mask.bind("click", close);
        }
        */
	},
	openNew: function (http) {
		this.winID = "mdw" + AXUtil.timekey();
		this.frmID = "frm" + AXUtil.timekey();


		if (this.openWindow) {
			//top.mask.close();
			this.openWindow.close();
		}

		this.openWindow = window.open("", (http.name||this.winID), http.options);
		this.openWindow.focus();
		
		if (AXgetId(this.config.windowID)) jQuery("#" + this.config.windowID).remove();

		var po = [];
		po.push("<div id='" + this.config.windowID + "'>");
		po.push("		<form name='" + this.frmID + "' method='" + (http.method || "post") + "' target='" + (http.name||this.winID) + "' action='" + http.url + "'>");
		po.push("		<input type='hidden' name='winID' value='" + this.winID + "' />");

		if (isNaN(http.pars.length)) {
			jQuery.each(http.pars, function (key, val) {
				po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
			});
		} else {
			jQuery.each(http.pars, function () {
				jQuery.each(this, function (key, val) {
					po.push("		<input type='hidden' name='" + key + "' value='" + val + "' />");
				});
			});
		}
		po.push("		</form>");
		po.push("</div>");
		jQuery(document.body).append(po.join(''));
		document[this.frmID].submit();
		jQuery("#" + this.config.windowID).remove();
	},
	keydown: function(event, modalID){
		if(event.keyCode == AXUtil.Event.KEY_ESC){
			this.close(event, modalID);
		}
	},
	close: function (event, modalID) {
		if (this.openWindow) {
			this.openWindow.close();
		}

		if (event) {
			if (event.type == undefined) {
				modalID = event;
			}
		}

		if (modalID) {
			jQuery("#" + modalID).hide();
			mask.close();
		} else {

			if(window[this.winID]){
				window[this.winID].location.href = "about:blank";
				var windowID = this.config.windowID;
				
				
				setTimeout(function () {
					jQuery("#" + windowID).remove();
				}, 1);
				
				mask.close();
				this._windowOpend = false;
			}
		}

		jQuery(document.body).unbind("keydown.AXModal");

		try {
			parent.fcObj.contentResetHeight();
		} catch (e) {

		}

		try {
			parent.fns.contentResetHeight();
		} catch (e) {

		}
	},
	remove: function (event) {
		var windowID = this.config.windowID;
		setTimeout(function () {
			jQuery("#" + windowID).remove();
		}, 1);
		mask.close();
		this._windowOpend = false;
		/*
        try {
            this.mask.remove();
        } catch (e) { }
        */
	},
	resize: function (event) {
		var cfg = this.config;
		var _winID = this.winID;
		setTimeout(function () {
			var myIframe = window[_winID];
			var bodyHeight = jQuery(myIframe.document).innerHeight();
			if (jQuery(myIframe.document.body).find("."+cfg.contentDivClass).get(0)) {
				bodyHeight = jQuery(myIframe.document.body).find("."+cfg.contentDivClass).outerHeight();
			}
			jQuery("#" + _winID).animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");
			jQuery("#" + _winID + "_box").animate({ height: (bodyHeight) }, cfg.animateDuration, "cubicInOut");

			trace({ h: jQuery(myIframe.document.body).find("."+cfg.contentDivClass).height() });
			//trace(bodyHeight);
			try {
				parent.fcObj.contentResetHeight();
			} catch (e) {
				//trace(e);	
			}

			try {
				parent.fnObj.contentResetHeight(null, bodyHeight + 100);
			} catch (e) {
				//trace(e);	
			}
		}, 50);
	},
	onDocResize: function () {
		var cfg = this.config;
		try{
			if (cfg.width) {
				var maskWidth = jQuery("#" + cfg.windowID).outerWidth();
				var maskLeft = (jQuery(document.body).width() / 2) - (maskWidth / 2);
				if (maskLeft < 0) maskLeft = 0;
				jQuery("#" + cfg.windowID).css({ left: maskLeft });
			} else {
				var maskWidth = jQuery(".container").width() - 50;
				jQuery("#" + cfg.windowID).css({ width: maskWidth });
			}
		} catch (e) {

		}
	}
});