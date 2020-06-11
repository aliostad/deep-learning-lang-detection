// Pattern lab specific JS //

var showShowBlock = function(){
	$('.demo-show').removeClass('block-hide').addClass('block-show');
}

var hideShowBlock = function(){
	$('.demo-show').removeClass('block-show').addClass('block-hide');
}

var showHideBlock = function(){
	$('.demo-hide').removeClass('block-hide').addClass('block-show');
}

var hideHideBlock = function(){
	$('.demo-hide').removeClass('block-show').addClass('block-hide');
}

$(function () {
	$('#show').on('click', function(){
		var _this  = $(this);
		if (_this.text() === 'Show') {
			showShowBlock();
			_this.text('Hide');
		}
		else {
			hideShowBlock();
			_this.text('Show');
		}
	});
	$('#hide').on('click', function(){
		var _this  = $(this);
		if (_this.text() === 'Hide') {
			hideHideBlock();
			_this.text('Show');
		}
		else {
			showHideBlock();
			_this.text('Hide');
		}
	});
});