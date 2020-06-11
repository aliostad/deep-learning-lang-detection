/* NAV.FIXED */
if(document.querySelector('header'))
	var header = document.querySelector('header');
var nav = document.querySelector('nav');
var navOffset = nav.offsetTop;
var navHeight = nav.offsetHeight;
var spanNavFixed = document.createElement('span');

navFixed();
window.addEventListener('scroll', navFixed);

function navFixed() {
	var scroll = window.pageYOffset;

	if(scroll > navOffset) {
		if(document.querySelector('header'))
			header.style.position = 'relative';
		nav.classList.add('fixed');
		spanNavFixed.style.display = 'block';
		spanNavFixed.style.height = navHeight+'px';
		nav.parentNode.insertBefore(spanNavFixed, nav.nextSibling);
	}
	else {
		nav.classList.remove('fixed');
		if(document.querySelector('header'))
			header.style.position = 'fixed';
		spanNavFixed.style.height = '0px';
	}
} // end navFixed()
/* END NAV.FIXED */