"use strict";
document.addEventListener('DOMContentLoaded',function(){
	var navButton = document.querySelector('.nav-button'),
	nav = document.querySelector('#nav'),
	navOpen = false;
	navButton.addEventListener('click',function(event){
		document.documentElement.classList.toggle('js-nav');
		navOpen = !navOpen;
		event.stopPropagation();
		event.preventDefault();
	},false);
	document.documentElement.addEventListener('click', function() {
    if(navOpen) {
      this.classList.remove('js-nav');
      navOpen = !navOpen;
    }
  }, false)
  nav.addEventListener('click', function(event) {
    if(navOpen) {
      event.stopPropagation();
    }
  }, false);
},false);