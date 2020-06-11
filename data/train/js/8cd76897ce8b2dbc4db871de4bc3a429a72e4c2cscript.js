var topNavList = document.querySelector('#top-nav-list');
var topNavToggle = document.querySelector('#top-nav-toggle');
var navCollapsed = true;

topNavToggle.addEventListener('click', function(){
	if(navCollapsed === true){
		topNavList.classList.remove('nav-list-collapsed');
		topNavToggle.innerHTML = '<i class="fa fa-times" aria-hidden="true"></i>';
		navCollapsed = false;
	} else {
		topNavList.classList.add('nav-list-collapsed');
		topNavToggle.innerHTML = '<i class="fa fa-bars" aria-hidden="true"></i>';
		navCollapsed = true;
	}
});