var mobileNav = {
	init : function(){

		mobileNav.handleNav();
		mobileNav.handleSearch();

	},

	handleNav : function(){
		$('#nav-toggle').click(function(e){

			if($('body').hasClass('nav-expanded')){ //close
				$('body').removeClass('nav-expanded');
				$('#mobile-nav').hide();
			} else{ //open
				$('body').addClass('nav-expanded');
				$('#mobile-nav, #primary-nav').show().height($('body').height());
			}

			e.preventDefault();
		})
	},

	handleSearch : function(){

		$('#search-toggle').click(function(e){
			$('#utility-search').toggle();

			e.preventDefault();
		})

	}
}

$(function(){
	mobileNav.init();
})
