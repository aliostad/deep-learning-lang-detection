var topNavList = document.querySelector('#top-nav-list');
var topNavToggle = document.querySelector('#top-nav-toggle');
var  navCollasped = true;

topNavToggle.addEventListener('click',function(){
	if (navCollasped === true){
	    topNavList.classList.remove('nav-list-collapsed');
	    topNavToggle.innerHTML = '<i class="fa fa-window-close" aria-hidden="true"></i>';
	 	navCollasped = false;   
	 } else { 
		topNavList.class.add('nav-list-collapsed');
		topNavToggle.innerHTML = '<i class="fa fa-window-close" aria-hidden="true"></i>';
		navCollasped = true;
	}
});