/**
	the script only works on "input [type=text]"
**/

// don't declare anything out here in the global namespace
 
(function($) { // create private scope (inside you can use $ instead of jQuery)

    // functions and vars declared here are effectively 'singletons'.  there will be only a single
    // instance of them.  so this is a good place to declare any immutable items or stateless
    // functions.  for example:

	var today = new Date(); // used in defaults
    var months = 'January,February,March,April,May,June,July,August,September,October,November,December'.split(',');
	var monthlengths = '31,28,31,30,31,30,31,31,30,31,30,31'.split(',');
	//var dateRegEx = /^\d{1,2}\/\d{1,2}\/\d{2}|\d{4}$/;
	var dateRegEx = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	var yearRegEx = /^\d{4,4}$/;
	//var opts;
	
    // next, declare the plugin function
	/*
	$.fn.simpleDatepicker.setDefaults({
		//monthNames: ['년 1월','년 2월','년 3월','년 4월','년 5월','년 6월','년 7월','년 8월','년 9월','년 10월','년 11월','년 12월'],
		//dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		//showMonthAfterYear:true,
		dateFormat: 'yy-mm-dd',
		buttonImageOnly: true,
		buttonText: "달력",
		buttonImage: "/ui/images/calendar.gif"
	});
	*/

    $.fn.simpleDatepicker = function(options) {
        // functions and vars declared here are created each time your plugn function is invoked
        // you could probably refactor your 'build', 'load_month', etc, functions to be passed
        // the DOM element from below
		//var opts = jQuery.extend({}, jQuery.fn.simpleDatepicker.defaults, options);
    	var opts = jQuery.extend({}, jQuery.fn.simpleDatepicker.defaults, options);
		// replaces a date string with a date object in opts.startdate and opts.enddate, if one exists
		// populates two new properties with a ready-to-use year: opts.startyear and opts.endyear

		setupYearRange();

		/** extracts and setup a valid year range from the opts object **/
		function setupYearRange () {
			var startyear, endyear;  
			if(opts.startdate.constructor == Date) {
				startyear = opts.startdate.getFullYear();
			} else if(opts.startdate) {
				if(yearRegEx.test(opts.startdate)) {
					startyear = opts.startdate;
				}
				/*
				else if(dateRegEx.test(opts.startdate)) {
				*/
				else if(opts.startdate.length >= 8) {
					var year, month, day, parseDate;
					if(opts.startdate.length == 8) {
						year = opts.startdate.substring(0,4);
						month = opts.startdate.substring(4,6);
						day = opts.startdate.substring(6,8);
					} else {
						parseDate = Date.parse(opts.startdate, opts.df).toString("yyyyMMdd");
						year = parseDate.substring(0,4);
						month = parseDate.substring(4,6);
						day = parseDate.substring(6,8);						
					}
					
					opts.startdate = new Date(year, month-1, day);

					startyear = opts.startdate.getFullYear();
				} else {
					startyear = today.getFullYear();
				}
			} else {
				startyear = today.getFullYear();
			}
			opts.startyear = startyear;
			
			if(opts.enddate.constructor == Date) {
				endyear = opts.enddate.getFullYear();
			} else if(opts.enddate) {
				if(yearRegEx.test(opts.enddate)) {
					endyear = opts.enddate;
				}
				/*
				else if(dateRegEx.test(opts.enddate)) {
				*/
				else if(opts.enddate.length >= 8) {
					var year, month, day, parseDate;
					if(opts.enddate.length == 8) {
						year = opts.enddate.substring(0,4);
						month = opts.enddate.substring(4,6);
						day = opts.enddate.substring(6,8);
					} else {
						parseDate = Date.parse(opts.enddate, opts.df).toString("yyyyMMdd");
						year = parseDate.substring(0,4);
						month = parseDate.substring(4,6);
						day = parseDate.substring(6,8);							
					}
					
					opts.enddate = new Date(year, month-1, day);
					endyear = opts.enddate.getFullYear();
				}
				else {
					endyear = today.getFullYear();
				}
			} else {
				endyear = today.getFullYear();
			}
			opts.endyear = endyear;	
		}
		
		/** HTML factory for the actual datepicker table element **/
		// has to read the year range so it can setup the correct years in our HTML <select>
		function newDatepickerHTML () {
			
			var years = [];
			
			// process year range into an array
			for (var i=0; i<=opts.endyear-opts.startyear; i++) years[i] = opts.startyear + i;
	
			// build the table structure
			var table = jQuery('<table class="datepicker" cellpadding="0" cellspacing="0" style="z-index:999999"></table>');
			table.append('<thead></thead>');
			table.append('<tfoot></tfoot>');
			table.append('<tbody></tbody>');
			
				// month select field
				var monthselect = '<select name="month">';
				for (var i in months) monthselect += '<option value="'+i+'">'+months[i]+'</option>';
				monthselect += '</select>';
			
				// year select field
				var yearselect = '<select name="year">';
				for (var i in years) yearselect += '<option>'+years[i]+'</option>';
				yearselect += '</select>';
			
			jQuery("thead",table).append('<tr class="controls"><th colspan="7"><span class="prevMonth">&laquo;</span>&nbsp;'+monthselect+yearselect+'&nbsp;<span class="nextMonth">&raquo;</span></th></tr>');
			jQuery("thead",table).append('<tr class="days"><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr>');
			jQuery("tfoot",table).append('<tr><td colspan="2"><span class="today">today</span></td><td colspan="3">&nbsp;</td><td colspan="2"><span class="close">close</span></td></tr>');
			for (var i=0; i<6; i++) jQuery("tbody",table).append('<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>');	
			return table;
		}
		
		/** get the real position of the input (well, anything really) **/
		//http://www.quirksmode.org/js/findpos.html
		function findPosition (obj) {
			var curleft = curtop = 0;
			if(obj.offsetParent) {
				do { 
					curleft += obj.offsetLeft;
					curtop += obj.offsetTop;
				} while (obj = obj.offsetParent);
				return [curleft, curtop];
			} else {
				return false;
			}
		}
		
		/** load the initial date and handle all date-navigation **/
		// initial calendar load (e is null)
		// prevMonth & nextMonth buttons
		// onchange for the select fields
		function loadMonth (e, el, datepicker, chosendate) {

			// reference our years for the nextMonth and prevMonth buttons
			var mo = jQuery("select[name=month]", datepicker).get(0).selectedIndex;
			var yr = jQuery("select[name=year]", datepicker).get(0).selectedIndex;
			var yrs = jQuery("select[name=year] option", datepicker).get().length;
			
			// first try to process buttons that may change the month we're on
			if(e && jQuery(e.target).hasClass('prevMonth')) {				
				if(0 == mo && yr) {
					yr -= 1; mo = 11;
					jQuery("select[name=month]", datepicker).get(0).selectedIndex = 11;
					jQuery("select[name=year]", datepicker).get(0).selectedIndex = yr;
				} else {
					mo -= 1;
					jQuery("select[name=month]", datepicker).get(0).selectedIndex = mo;
				}
			} else if(e && jQuery(e.target).hasClass('nextMonth')) {
				if(11 == mo && yr + 1 < yrs) {
					yr += 1; mo = 0;
					jQuery("select[name=month]", datepicker).get(0).selectedIndex = 0;
					jQuery("select[name=year]", datepicker).get(0).selectedIndex = yr;
				} else { 
					mo += 1;
					jQuery("select[name=month]", datepicker).get(0).selectedIndex = mo;
				}
			}
			
			// maybe hide buttons
			if(0 == mo && !yr) jQuery("span.prevMonth", datepicker).hide(); 
			else jQuery("span.prevMonth", datepicker).show(); 
			if(yr + 1 == yrs && 11 == mo) jQuery("span.nextMonth", datepicker).hide(); 
			else jQuery("span.nextMonth", datepicker).show(); 
			
			// clear the old cells
			var cells = jQuery("tbody td", datepicker).unbind().empty().removeClass('date').removeClass('chosen');
			
			// figure out what month and year to load
			var m = jQuery("select[name=month]", datepicker).val();
			var y = jQuery("select[name=year]", datepicker).val();
			var d = new Date(y, m, 1);
			var startindex = d.getDay();
			var numdays = monthlengths[m];
			
			// http://en.wikipedia.org/wiki/Leap_year
			if(1 == m && ((y%4 == 0 && y%100 != 0) || y%400 == 0)) numdays = 29;
			
			// test for end dates (instead of just a year range)
			if(opts.startdate.constructor == Date) {
				var startMonth = opts.startdate.getMonth();
				var startDate = opts.startdate.getDate();
			}
			if(opts.enddate.constructor == Date) {
				var endMonth = opts.enddate.getMonth();
				var endDate = opts.enddate.getDate();
			}
			
			// walk through the index and populate each cell, binding events too
			for (var i = 0; i < numdays; i++) {
			
				var cell = jQuery(cells.get(i+startindex)).removeClass('chosen');
				
				// test that the date falls within a range, if we have a range
				if( 
					(yr || ((!startDate && !startMonth) || ((i+1 >= startDate && mo == startMonth) || mo > startMonth))) &&
					(yr + 1 < yrs || ((!endDate && !endMonth) || ((i+1 <= endDate && mo == endMonth) || mo < endMonth)))) {
				
					cell
						.text(i+1)
						.addClass('date')
						.hover(
							function () { jQuery(this).addClass('over'); },
							function () { jQuery(this).removeClass('over'); })
						.click(function () {
							var chosenDateObj = new Date(jQuery("select[name=year]", datepicker).val(), jQuery("select[name=month]", datepicker).val(), jQuery(this).text());
							closeIt(el, datepicker, chosenDateObj);
						});
						
					// highlight the previous chosen date
					if(i+1 == chosendate.getDate() && m == chosendate.getMonth() && y == chosendate.getFullYear()) cell.addClass('chosen');
				}
			}
		}
		
		/** closes the datepicker **/
		// sets the currently matched input element's value to the date, if one is available
		// remove the table element from the DOM
		// indicate that there is no datepicker for the currently matched input element
		function closeIt (el, datepicker, dateObj) { 
			if(dateObj && dateObj.constructor == Date)
				el.val(jQuery.fn.simpleDatepicker.formatOutput(dateObj, opts.df, opts.compareFromTo));
			datepicker.remove();
			datepicker = null;
			
			jQuery.data(el.get(0), "simpleDatepicker", { hasDatepicker : false });
			if(opts.closeaftercall == 'y') {
				fn_calCloseCallBack(el.get(0).value);	
			}			
		}

        // iterate the matched nodeset
		var datepicker;
		
		return this.each(function() {
            // functions and vars declared here are created for each matched element. so if
            // your functions need to manage or access per-node state you can defined them
            // here and use $this to get at the DOM element

			if( jQuery(this).is('img') || (jQuery(this).is('input') && 'text' == jQuery(this).attr('type'))) {

				jQuery.data(jQuery(this).get(0), "simpleDatepicker", { hasDatepicker : false });
				
				// open a datepicker on the click event
				jQuery(this).click(function (ev) {
    				 var tar = document.getElementById(ev.target.target);
    				 if(tar != null){
    					 ev.target = document.getElementById(ev.target.target);
    				 }
					var $this = jQuery(ev.target);
					if(false == jQuery.data($this.get(0), "simpleDatepicker").hasDatepicker) {
						
						// store data telling us there is already a datepicker
						jQuery.data($this.get(0), "simpleDatepicker", { hasDatepicker : true });
						
						// validate the form's initial content for a date
						var initialDate = $this.val();

						/*
						if(initialDate && dateRegEx.test(initialDate)) {
						*/
						var year, month, day, parseDate;
						if(initialDate) {
							//var chosendate = new Date(initialDate);
							if(initialDate.length >= 8) {
								if(initialDate.length == 8) {
									year = initialDate.substring(0,4);
									month = initialDate.substring(4,6);
									day = initialDate.substring(6,8);
								} else {
									parseDate = Date.parse(initialDate, opts.df).toString("yyyyMMdd");
									year = parseDate.substring(0,4);
									month = parseDate.substring(4,6);
									day = parseDate.substring(6,8);							
								}
							}
							
							var chosendate = new Date(year, month-1, day);
						}
						else if(opts.chosendate.constructor == Date) {
							var chosendate = opts.chosendate;
						}
						else if(opts.chosendate) {
							//var chosendate = new Date(opts.chosendate);
							if(opts.chosendate.length >= 8) {
								if(opts.chosendate.length == 8) {
									year = opts.chosendate.substring(0,4);
									month = opts.chosendate.substring(4,6);
									day = opts.chosendate.substring(6,8);
								} else {
									parseDate = Date.parse(opts.chosendate, opts.df).toString("yyyyMMdd");
									year = parseDate.substring(0,4);
									month = parseDate.substring(4,6);
									day = parseDate.substring(6,8);							
								}
							}
							var chosendate = new Date(year, month-1, day);
						}
						else {
							alert(today);
							var chosendate = today;
						}
							
						// insert the datepicker in the DOM
						datepicker = newDatepickerHTML();
						jQuery("body").prepend(datepicker);
						
						// position the datepicker
						var elPos = findPosition($this.get(0));
						
						/*
						alert("opts.x = " +  opts.x + " / elPos[0] = " + elPos[0] + " / elPos[1] = " + elPos[1]);
						*/
						
						var x = (parseInt(opts.x) ? parseInt(opts.x) : 0) + elPos[0];
						var y = (parseInt(opts.y) ? parseInt(opts.y) : 0) + elPos[1];
						
						jQuery(datepicker).css({ position: 'absolute', left: x, top: y });
					
						// bind events to the table controls
						jQuery("span", datepicker).css("cursor","pointer");
						jQuery("select", datepicker).bind('change', function () { loadMonth (null, $this, datepicker, chosendate); });
						jQuery("span.prevMonth", datepicker).click(function (e) { loadMonth (e, $this, datepicker, chosendate); });
						jQuery("span.nextMonth", datepicker).click(function (e) { loadMonth (e, $this, datepicker, chosendate); });
						jQuery("span.today", datepicker).click(function () { closeIt($this, datepicker, new Date()); });
						jQuery("span.close", datepicker).click(function () { closeIt($this, datepicker); });
						
						// set the initial values for the month and year select fields
						// and load the first month
						jQuery("select[name=month]", datepicker).get(0).selectedIndex = chosendate.getMonth();
						jQuery("select[name=year]", datepicker).get(0).selectedIndex = Math.max(0, chosendate.getFullYear() - opts.startyear);
						loadMonth(null, $this, datepicker, chosendate);
					}
					
				});
			}

        });

    };

   
    // finally, I like to expose default plugin options as public so they can be manipulated.  one
    // way to do this is to add a property to the already-public plugin fn

	jQuery.fn.simpleDatepicker.formatOutput = function (dateObj, df, compareFromTo) {
		var result  = dateObj.getFullYear() + "/" + leadingZeros((dateObj.getMonth() + 1), 2) + "/" + leadingZeros(dateObj.getDate(), 2);

		if(!compareDateCheck(result, compareFromTo)) { return; }
		
		result = Date.parse(result, "yyyy/MM/dd").toString(df);
		
		return result;
	};
	
	jQuery.fn.simpleDatepicker.defaults = {
		// date string matching /^\d{1,2}\/\d{1,2}\/\d{2}|\d{4}$/
		chosendate : today,
		
		// date string matching /^\d{1,2}\/\d{1,2}\/\d{2}|\d{4}$/
		// or four digit year
		//startdate : today.getFullYear() - 1, 
		startdate : new Date('2010', today.getMonth()-1, today.getDate()),
		enddate : today.getFullYear() + 9,
		
		// offset from the top left corner of the input element
		x : 18, // must be in px
		y : 18, // must be in px
		df : 'yyyy/MM/dd',
		closeaftercall: 'n',
		compareFromTo : ''
	};

})(jQuery);

function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();

	if(n.length < digits) {
		for (i=0; i<digits-n.length; i++)
		zero += '0';
	}
	return zero + n;
}

// ### TRIM
String.prototype.trim = function() { return this.replace(/(^\s*)|(\s*$)/g, ""); }

function compareDateCheck(invalue, compareFromTo) {
	//alert(compareFromTo);
	var compareResult = true;
	
	var vSplit = null;
	var compareDf = "yyyyMMdd";
	var compareObj = null;
	var compareValue = null;
	var resultValue = null;
	
	// 시작일, 종료일 날짜 비교
	if(compareFromTo != "") {
		resultValue = Date.parse(invalue, "yyyy/MM/dd").toString(compareDf);

		vSplit = compareFromTo.split(".");
		compareObj = document.getElementById(vSplit[1]);

		if(compareObj.value.trim() != "") {
			compareValue = Date.parse(compareObj.value.trim(), "yyyy/MM/dd").toString(compareDf);
			
			if(vSplit[0] == "to") {
				//alert("1");
				compareResult = compareDate(resultValue, compareValue);
			} else if(vSplit[0] == "from") {
				//alert("2");
				compareResult = compareDate(compareValue, resultValue);
			}
		}
	}
	
	return compareResult;
}

function compareDate(startDate, endDate) {
	
	//alert(startDate + " / " + endDate);
	var result = true;
	
	if((startDate != null && endDate != null) && (startDate.trim() != "" && endDate.trim() != "")) {
		if(startDate > endDate) {
			// 시작일은 종료일 보다 이전날짜 이여야 합니다.
			// The start date should be earlier than the end date.
			// var value = "<spring:message code=\"M000094\" javaScriptEscape=\"true\" />";
			alert("The start date should be earlier than the end date.");
			result = false;
		}
	} else {
		result = false;
	}
	
	return result;
}

function fn_onCheckDateField(dateObj) {
	var result = true;
	
	// 유효하지 않은 날짜입니다.
	// Date is invalid.
	// var value = "<spring:message code=\"M000106\" javaScriptEscape=\"true\" />";
	var dateValue = dateObj.value.trim();
	
	if(dateValue == "") {
		alert("Date is invalid.");
		result = false;
	}
	
	return result;
}

function fn_onCheckFtDateField(startDateObj, endDateObj) {
	var result = true;
	
	// 유효하지 않은 날짜입니다.
	// Date is invalid.
	// var value = "<spring:message code=\"M000106\" javaScriptEscape=\"true\" />";
	var startDate = startDateObj.value.trim();
	var endDate = endDateObj.value.trim();
	
	if(startDate == "" || endDate == "") {
		alert("Date is invalid.");
		result = false;
	}
	
	return result;
}

function getXYcoord(myimg) {
	if(document.layers) return myimg;
	var rd = {x:0, y:0};
	do {
		rd.x += parseInt(myimg.offsetLeft);
		rd.y += parseInt(myimg.offsetTop);
		myimg = myimg.offsetParent;
	} while(myimg);

	/*
	alert(rd.x + " / " + rd.y);
	*/
	
	return rd;
}