$(function() {
	// 导航
	(function(){
		//滑动导航
		var start_on = {
				nav_2:$('#nav .nav_2_on').position().left,
				nav_3:$('#nav .nav_3_on').position().left,
			};
		$('#nav .nav_4 li').on({
			mouseover : function () {
				var hover_on = $(this).first().position();
				$('#nav .nav_2').animate({
					left : hover_on.left + 20,			
				},
				100,
				function(){
					$('#nav .nav_3').animate({
						left : - hover_on.left
					},200);
				});	
			},
			mouseout : function () {
				$('#nav .nav_2').animate({
					left : start_on.nav_2,			
				},
				1,
				function(){
					$('#nav .nav_3').animate({
						left : start_on.nav_3
					},2);
				});
			}
		});
	})();
});