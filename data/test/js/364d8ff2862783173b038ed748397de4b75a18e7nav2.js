//导航
var $nav=$('.nav').find('.li'),

$navCur=$('.nav').find('.cur').length?$('.nav').find('.cur').index():0,

$navLine=$('.nav_line');

$navLine.css('left',$navCur*$nav.eq(0).width());

$nav.mouseenter(function(){
	
	$(this).addClass('hover');

	$navLine.stop(1,0).animate({left:$(this).index()*$nav.eq(0).width()},200);

}).mouseleave(function(){

	$(this).removeClass('hover');

	$navLine.stop(1,0).animate({left:($('.nav').find('.cur').length?$('.nav').find('.cur').index():0)*$nav.eq(0).width()},200);

});