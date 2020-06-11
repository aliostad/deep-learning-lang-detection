/**
 * @author [dbxiao]
 * @date   [2015-08-27]
 * @widget [nav]
 * @desc   [导航栏]
 */

var nav = function(option){
	this._option = {

	};
	$.extend(this._option, option);
	this.init();
};

nav.view = {};

nav.prototype = {

	/** [init 程序入口] */
	init : function(){
		this.view();
		this.handle();
	},

	/** [view 初始化DOM] */
	view : function(){
		nav.view = {
			"WGT_NAV" : $("._WGT_NAV")
		};
	},

	/** [handle 事件绑定] */
	handle : function(){
		var _this = this;
		var data = {};
		nav.view.WGT_NAV.on("click", ".nav-item", function(){
			nav.view.WGT_NAV.find(".on").removeClass("on");
			$(this).addClass("on");
			data.nav = $(this).attr("nav-data");
			//广播
			webos.broadcast.trigger("WGT_NAV_CHANGE", data);
		});
	}
};

module.exports = nav;