$(function() {

	//头部图片轮播
	$(".slide-banner").slideFade();	

	//切换效果
	function tabNav(el) {

		$(el).on("click",function() {
			var $this = $(this),
				index = $this.index();

				$this.addClass("active")
				.siblings().removeClass("active")
				.parents(".head").siblings().children().eq(index).fadeIn()
				.siblings().fadeOut();
		});

	};

	//禅茶一味
	tabNav(".section-2 .tab-nav li");
	//静以修身
	tabNav(".section-3 .tab-nav li");
	//善缘佛堂
	tabNav(".section-4 .tab-nav li");
	//匠人匠心
	tabNav(".section-5 .tab-nav li");
	//中医养生
	tabNav(".section-6 .tab-nav li");
	//回归自然
	tabNav(".section-7 .tab-nav li");


});