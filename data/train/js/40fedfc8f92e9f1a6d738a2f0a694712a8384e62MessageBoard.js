(function(win, doc, $, undefined){
	"use strict";
	var BMAP = win.BMAP || {};
	var message = "Welcome :)";

	var MessageBoard = function(){
		this.messageEl = $("#message-board");
		this.put(message);
	}
	
	MessageBoard.prototype.put = function(m){
		this.message = m;
		this.messageEl.text(this.message);
	};

	MessageBoard.prototype.putTemporary = function(message){
		var that = this;
		that.messageEl.fadeOut("slow", function(){
			that.messageEl.html(message).fadeIn("slow");
		});
		
		setTimeout(function(){		
			that.messageEl.fadeOut("slow", function(){
				that.messageEl.html(that.message).fadeIn("slow");
			});
		},3000);	
	};

	MessageBoard.prototype.putWarning = function(message){
		alert(message);
	};

	MessageBoard.prototype.get = function(){
		return message;
	};

	BMAP.MessageBoard = MessageBoard;
	win.BMAP = BMAP;
})(window, document, jQuery);
