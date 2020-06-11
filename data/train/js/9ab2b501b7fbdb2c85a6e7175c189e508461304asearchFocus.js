jQuery(function ($){
	/*
	 * 搜索框
	 */
	$(".page .nav .nav_search .search_wrap input.search").focus(function (){
		$(this).val()=="请输入关键字搜索....." ? $(this).val("") : null;
		$(this).css("color","#777");
	});
	$(".page .nav .nav_search .search_wrap input.search").blur(function (){
		$(this).val() ? null : $(this).val("请输入关键字搜索.....");
		$(this).css("color","#aaa");
	});
	$(".page .nav .nav_search .search_wrap input.search_btn").hover(function (){
		$(this).css("background-position","-298px 0");
	},function (){
		$(this).css("background-position","-249px 0");
	});
	
	

	
	/*
	 * 设置导航默认选中
	 */
	$(".page .nav .nav_search .nav_ul li a").removeClass("show");
	$(".page .nav .nav_search .nav_ul li").eq($(".page .nav .nav_search .nav_ul").attr("navEq")).children("a").addClass('show');
	
});