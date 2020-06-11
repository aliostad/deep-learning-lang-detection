
var navMenuIcon = document.getElementById("nav-toggle");
var navMenu = document.getElementById("mobile-menu-container");
var navBar = document.getElementById("mobile-navBar");
document.getElementById("header-nav-toggle").addEventListener("click", function () {
    navMenuIcon.classList.toggle("active");
    if (navMenuIcon.classList.contains("active")) {
        navMenu.style.display = "flex";
    } else {
        navMenu.style.display = "none";  
    }

});

navBar.addEventListener("click", function () {
    navMenuIcon.classList.toggle("active");
    if (navMenuIcon.classList.contains("active")) {
        navMenu.style.display = "flex";
    } else {
        navMenu.style.display = "none";  
    }
});