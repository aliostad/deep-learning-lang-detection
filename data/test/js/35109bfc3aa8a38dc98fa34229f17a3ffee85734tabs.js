$(document).ready(function(){
	var $tabs = $('.tabs');
	for(var p = 0, pL = $tabs.length; p < pL; ++p){
		var $tab = $($tabs[p]),
			$navLis = $('nav li', $tab),
			$sections = $('section', $tab);
		for(var i = 0, iL = $navLis.length; i < iL; ++i){
			var navLi = $navLis[i];
			navLi.$section = $('#section-'+$(navLi).attr('data-section'));
			navLi.$sections = $sections;
			navLi.$navLis = $navLis;
			$(navLi).click(function(){
				this.$sections.hide();
				this.$section.show();
				this.$navLis.removeClass('act');
				$(this).addClass('act');
			});
			if(i == 0){
				navLi.$section.show();
				$(navLi).addClass('act');
			} else{
				navLi.$section.hide();
			}
		}
	}
});
