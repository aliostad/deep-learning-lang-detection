/**
 * fixedNav - jQuery plugin that fixates a horizontal navigation element
 *            as soon as it hits the top by scrolling
 * 
 * 2012 by Christian Doebler <info@christian-doebler.net>
 * 
 * Copyright 2012 - licensed under the MIT License
 * Do not remove this copyright notice
 * 
 * Thanks,
 * Christian
 */(function(a){var b={navEl:!1,navCloneEl:!1,navClonePrevEl:!1,navTop:!1,prevCssPos:!1,setNavTop:function(){b.navCloneEl&&(b.navTop=b.navClonePrevEl.offset().top+b.navClonePrevEl.height()+2)},cloneNavEl:function(){a.each(b.navEl,function(c,d){var e=a(d),f=e.clone();f.children().hide(),f.hide(),e.before(f),b.navCloneEl=f,b.navClonePrevEl=b.navCloneEl.prev(":first"),b.navClonePrevEl.length||(b.navClonePrevEl=b.navCloneEl),b.navTop=b.navEl.offset().top+2})},toggleNavMode:function(){var c=a(window).scrollTop(),d=b.navEl;c>b.navTop&&b.navTop>0?(d.prev().show(),d.css({position:"fixed",top:0})):(b.navCloneEl&&d.prev().hide(),d.css({position:"relative"}));var e=d.css("position");e!=b.prevCssPos&&(d.trigger(e),b.prevCssPos=e)}};a.fn.fixedNav=function(){return b.navEl=a(this),b.prevCssPos=b.navEl.css("position"),b.cloneNavEl(),b.toggleNavMode(),a(window).scroll(function(){b.toggleNavMode()}),a(window).resize(function(){b.setNavTop()}),this.each(function(){var b=a(this)})}})(jQuery);