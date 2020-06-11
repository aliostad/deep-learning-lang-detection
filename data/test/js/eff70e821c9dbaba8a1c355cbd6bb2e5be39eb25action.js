var dispatch = require('../dispatch');

module.exports = {
	setOption: function(data, opts) {
		dispatch.set_option(data, opts);
	},
	setTheme: function(data) {
		dispatch.set_theme(data);
	},
	destroy: function() {
		dispatch.destroy();
	},
	reset: function() {
		dispatch.reset();
	},
	resize: function() {
		dispatch.resize();
	},
	addSeries: function(data) {
		dispatch.add_series(data);
	},
	removeSeries: function(data) {
		dispatch.remove_series(data);
	},
	showSeries: function(data) {
		dispatch.show_series(data);
	},
	hideSeries: function(data) {
		dispatch.hide_series(data);
	},
	clickSeries: function(data) {
		dispatch.click_series(data);
	},
	hoverSeries: function(data) {
		dispatch.hover_series(data);
	},
	dragPoint: function(data) {
		dispatch.drag_point(data);
	},
	addPoint: function(data) {
		dispatch.add_point(data);
	},
	removePoint: function(data) {
		dispatch.remove_point(data);
	},
	clickPoint: function(data) {
		dispatch.click_point(data);
	},
	hoverPoint: function(data) {
		dispatch.hover_point(data);
	},
	dragTitle: function(data) {
		dispatch.drag_title(data);
	},
	addAxis: function(data) {
		dispatch.add_axis(data);
	},
	removeAxis: function(data) {
		dispatch.remove_axis(data);
	},
	exports: function(data) {
		dispatch.exports(data);
	}
}