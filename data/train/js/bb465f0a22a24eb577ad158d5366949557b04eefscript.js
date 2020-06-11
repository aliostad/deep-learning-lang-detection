$(document).ready(function() {

function locationAjax(handleData) {
	  $.ajax({
	    url:"http://www.telize.com/geoip?callback=",
	    success:function(data) {
	    	handleData(data);
	    }
	  });
	}

	locationAjax(function(output){
		var cityToQuery = output.city + ', ' + output.region_code;
		var cityToQuery = cityToQuery.replace(/\s/g,'');
		var queryString = 'http://api.openweathermap.org/data/2.5/weather?q=' + cityToQuery + '&units=imperial&appid=bd82977b86bf27fb59a04b61b657fb6f';
		$.ajax({
			dataType: "jsonp",
			url: queryString,
			success:function(data) {
				$('#temp').append(
					'<li>' +
						'<a href="#" class=".scroll-fade-text">' +
							cityToQuery + "  " + Math.round(data.main.temp) + " F" +
						'<img src="http://openweathermap.org/img/w/' + data.weather[0].icon + '.png">' +
						data.weather[0].main +
						'</a>' +
					'</li>'
			)}
		})
	})

	// set variables for navbar transition

	var navBarSelector = '#custom-bootstrap-menu.navbar-default';
	var navBarTStart = 200; // Start transition this many pixels from the top
	var navBarTEnd = 400;   // End transition
	var navBarCStart = [255, 255, 255, 0.43];  // Start color
	var navBarCEnd = [0, 35, 3, 1];   // End color
	var navBarCDiff = [
		navBarCEnd[0] - navBarCStart[0],
		navBarCEnd[1] - navBarCStart[1],
		navBarCEnd[2] - navBarCStart[2],
		navBarCEnd[3] - navBarCStart[3]
	];

$(document).ready(function() {
	scrollnavBarColor();
	function scrollnavBarColor() {
		var p = ($(this).scrollTop() - navBarTStart) / (navBarTEnd - navBarTStart); // % of transition
		p = Math.min(1, Math.max(0, p));
		var navBarcBg = [
			Math.round(navBarCStart[0] + navBarCDiff[0] * p),
			Math.round(navBarCStart[1] + navBarCDiff[1] * p),
			Math.round(navBarCStart[2] + navBarCDiff[2] * p),
			Math.round((navBarCStart[3] + navBarCDiff[3] * p) * 100) / 100
		];
		$(navBarSelector).css('background-color', 'rgba(' + navBarcBg.join(',') + ')');
	}
	$(document).scroll(function() {
			scrollnavBarColor();
	});
});

// set vriables for navtext transition

var navTextSelector = '.scroll-fade-text';
	var navTextTStart = 200; // Start transition this many pixels from the top
	var navTextTEnd = 250;   // End transition
	var navTextCStart = [119, 119, 119, 1];  // Start color
	var navTextCEnd = [255, 255, 255, 1];   // End color
	var navTextCDiff = [
		navTextCEnd[0] - navTextCStart[0],
		navTextCEnd[1] - navTextCStart[1],
		navTextCEnd[2] - navTextCStart[2],
		navTextCEnd[3] - navTextCStart[3]
	];

$(document).ready(function() {
	scrollnavTextColor();
	function scrollnavTextColor() {
		var p = ($(this).scrollTop() - navTextTStart) / (navTextTEnd - navTextTStart); // % of transition
		p = Math.min(1, Math.max(0, p));
		var navTextcBg = [
			Math.round(navTextCStart[0] + navTextCDiff[0] * p),
			Math.round(navTextCStart[1] + navTextCDiff[1] * p),
			Math.round(navTextCStart[2] + navTextCDiff[2] * p),
			Math.round((navTextCStart[3] + navTextCDiff[3] * p) * 100) / 100
		];
		$(navTextSelector).css('color', 'rgba(' + navTextcBg.join(',') + ')');
	}
	$(document).scroll(function() {
			scrollnavTextColor();
	});
});


})