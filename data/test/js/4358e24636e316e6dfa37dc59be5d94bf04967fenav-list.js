function initNavList(){
	var _navListLabel = $(".nav-list-container .nav-list-label");
	if(_navListLabel.length){
		$(".nav-list-container .nav-list li").mouseenter(function(){
			_navListLabel.animate({
				top : $(this).position().top
			} , 50);
		}).click(function(){
			$(".nav-list-container .nav-list li").removeClass('current-cat');
			$(this).addClass('current-cat');
		});

		$(".nav-list").mouseleave(function(){
			if($(".current-cat",this).length){
				_navListLabel.animate({
					top : $(".nav-list-container .nav-list .current-cat").position().top
				} , 120);
			}else{
				_navListLabel.animate({
					top : $(".nav-list-container .nav-list .home").position().top
				} , 120);
			}
		});
	}
	

}