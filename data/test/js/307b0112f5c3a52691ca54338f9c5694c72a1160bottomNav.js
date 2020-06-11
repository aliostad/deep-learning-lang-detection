$(function(){
	var navPos_hidden = '0px -478px',
		navPos_show = '0px -558px';
		
	var $navOpeBtn = $('.navOpeBtn:first'),
		$bottomNavList = $('div.bottomNavList:first'),
		$navItemUl = $('ul.navItemUl:first'),
		$navText = $('span.navText:first'),
		$containerHelper = $bottomNavList.find('div.containerHelper:first');
		
	
	$navOpeBtn.on('click',function(e){
		$navItemUl.is(':visible')?
		$containerHelper.animate({
			top:"80px"
		},'slow','swing',function(){
			$navItemUl.hide();
			$navOpeBtn.css({
				'background-position':navPos_hidden
			});
			$navText.fadeIn();
		}):
		$navText.fadeOut('fast',function(){
			$navItemUl.show();
			$containerHelper.animate({
				top:"0px"
			},'slow','swing',function(){
				$navOpeBtn.css({
					'background-position':navPos_show
				});
			});
		});
	});
});