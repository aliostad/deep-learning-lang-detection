 // monkey patching
 String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

var libsw = new LibSpaceWalk();

// ==== Logging Data ====
var logData = [];
var filteredData = [];

var showState = {
	show: 'show',
	hide: 'hide',
	faded: 'faded'
}
var showTrace = showState.show;
var showDebug = showState.show;
var showInfo = showState.show;
var showWarn = showState.show;
var showError = showState.show;
var showFatal = showState.show;

function nextShowState(state) {
	if (state === showState.show)
		return showState.faded;
	else if (state == showState.faded)
		return showState.hide;
	else
		return showState.show;
}
	
libsw.onMessage = function(data) {
	if (data.type === 'core.simpleLog.message') {
		addLog(data.payload);
		d3.select('#lineCounter')
			.text(logData.length);
	}
}



libsw.onSessionStarted = function() {
		
	// post new session
	d3.select('#log').append('div')
		.attr('class', 'sessionMarker')
		.text('new session started...');
}

function addLog(datum) {
	logData.push(datum);
	d3.select('#lineCounter')
		.text(logData.length);
	
	d3.select('#log').selectAll('div.logEntry')
		.data(logData)
			.enter().append('div')
				.attr('class', function(d) { return 'logEntry ' + d.level; })
				.html(function(d) { return d.message; })
				.style('opacity', function(d) {
					if (((showTrace === showState.faded) && d.level === 'trace') ||
						((showDebug === showState.faded) && d.level === 'debug') ||
						((showInfo === showState.faded) && d.level === 'info') ||
						((showWarn === showState.faded) && d.level === 'warn') ||
						((showError === showState.faded) && d.level === 'error') ||
						((showFatal === showState.faded) && d.level === 'fatal')) {
						return '0.5';					
					} else
						return '1';
				})
				.style('display', function(d) {
					if (((showTrace === showState.hide) && d.level === 'trace') ||
						((showDebug === showState.hide) && d.level === 'debug') ||
						((showInfo === showState.hide) && d.level === 'info') ||
						((showWarn === showState.hide) && d.level === 'warn') ||
						((showError === showState.hide) && d.level === 'error') ||
						((showFatal === showState.hide) && d.level === 'fatal')) {
						return 'none';					
					} else
						return 'block';
				})
}


function toggleCube(state, name, cls) {
	if (state === showState.show) {
		d3.select(name)
			.transition()
				.duration(200)
				.style('opacity', 1);
				
		d3.selectAll('div.log div.' + cls)
			.style('opacity', 1)
			.style('display', 'block');
	}
	else if (state === showState.faded) {
		d3.select(name)
			.transition()
				.duration(200)
				.style('opacity', 0.5);
		
		d3.selectAll('div.log div.' + cls)
			.style('opacity', 0.5)
			.style('display', 'block');
	}
	
	else if (state === showState.hide) {
		d3.select(name)
			.transition()
				.duration(200)
				.style('opacity', 0.1);
				
		d3.selectAll('div.log div.' + cls)
			.style('opacity', 0.1)
			.style('display', 'none');
	}
}

function init() {	
	
	$('#toggleTrace').click(function() {
		showTrace = nextShowState(showTrace);
		toggleCube(showTrace, '#toggleTrace', 'trace');
	});
	
	$('#toggleInfo').click(function() {
		showInfo = nextShowState(showInfo);
		toggleCube(showInfo, '#toggleInfo', 'info');
	});
	
	$('#toggleDebug').click(function() {
		showDebug = nextShowState(showDebug);
		toggleCube(showDebug, '#toggleDebug', 'debug');
	});
	
	$('#toggleWarn').click(function() {
		showWarn = nextShowState(showWarn);
		toggleCube(showWarn, '#toggleWarn', 'warn');
	});
	
	$('#toggleError').click(function() {
		showError = nextShowState(showError);
		toggleCube(showError, '#toggleError', 'error');
	});
	
	$('#toggleFatal').click(function() {
		showFatal = nextShowState(showFatal);
		toggleCube(showFatal, '#toggleFatal', 'fatal');
	});
	
	var clearLog = function() {
		logData = [];
		d3.select('#lineCounter')
			.text('--');
		
		d3.selectAll('div.log div')
			.remove();
	}
	$('#clearLog').click(clearLog);
	
	var clearScalar = function() {
		scalarData = [];
		
		d3.selectAll('div.scalar div')
			.remove();
		
		d3.select('#scalar').append('div')
			.attr('id', 'scalar-session-' + sessionID)
	}
	$('#clearScalar').click(clearScalar);
}


var readyStateCheckInterval = setInterval(function() {
	   if (document.readyState === "complete") {
		   init();
		   clearInterval(readyStateCheckInterval);
	   }
}, 10);

// ================================= util ================================
function round(value, decimals) {
	decimals = decimals || 0;
	var v = value * Math.pow(10, decimals);
	return Math.round(v) / Math.pow(10, decimals);
}

function last(arr) {
	return arr[arr.length-1];
}