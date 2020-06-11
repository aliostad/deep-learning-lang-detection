$(function(){
	//页面元素加载完后显示
	$('.page').show();
	//导航菜单
	$('nav>b').css({width:$('nav>a.active').width(),left:$('nav>a.active').offset().left-$('nav>a:eq(0)').offset().left});
	$('body').on('mouseenter','nav>a',function(){
		var that = $(this);
		$.delay({complete:function(){
			$('nav>b').animate({width:that.width(),left:that.offset().left-$('nav>a:eq(0)').offset().left},400);
		}});
	});
	$('body').on('mouseleave','nav',function(){
		$.delay({complete:function(){
			$('nav>b').animate({width:$('nav>a.active').width(),left:$('nav>a.active').offset().left-$('nav>a:eq(0)').offset().left},400);
		}});
	});
});