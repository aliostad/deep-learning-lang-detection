
import './bootstrap';

const app = new Vue({
    el: '#app'
});


//Menu Toggle
const menuToggle = document.getElementById("nav-toggle");
menuToggle.addEventListener("click", toggleNav);

const menu = [].forEach.call( document.querySelectorAll( "#nav-menu a" ), function ( a ) {
    a.addEventListener( 'click', toggleNav);
    //console.log(a);
});

function toggleNav() {
    var nav = document.getElementById("nav-menu");
    var className = nav.getAttribute("class");
    if(className == "nav-right nav-menu") {
        nav.className = "nav-right nav-menu is-active";
    } else {
        nav.className = "nav-right nav-menu";
    }
}