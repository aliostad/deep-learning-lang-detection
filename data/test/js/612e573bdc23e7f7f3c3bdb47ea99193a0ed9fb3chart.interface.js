define(function(require, exports, module) {
	require('./chart');
	var chartShow = {};
	
	chartShow.pieChart = function(config){
		return pieChart(config);
	};
	chartShow.avaChart = function(config){
		avaChart(config);
	};
	chartShow.stockSplineChart = function(config){
		stockSplineChart(config);
	};
	chartShow.gaugeChart = function(config){
		return gaugeChart(config);
	};
	chartShow.barChart = function(config){
		barChart(config);
	};
	chartShow.memShow = function(config){
		memShow(config);
	};
	module.exports = chartShow;
	
	if(typeof(furnace) !== 'undefined'){
		furnace.clone(chartShow);
	}
});