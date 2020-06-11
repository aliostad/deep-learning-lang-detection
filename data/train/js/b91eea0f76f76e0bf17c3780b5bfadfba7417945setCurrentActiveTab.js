function setCurrentActive() {
    var url = window.location.pathname;
    var pageName = url.substring(url.lastIndexOf('/') + 1);
    var navLinks = document.getElementById("nav").children;
    var navBtns = [];
    var navBtnRef = [];
    navBtns.length = 4;
    navBtnRef.length = 4;
    //alert("hello");
    //alert(navBtnRef.length);

    if (navLinks.length > 0) {
        for (i = 0; i < navLinks.length; i++) {
            navBtns[i] = navLinks[i].firstElementChild;
            navBtnRef[i] = navBtns[i].getAttribute("href");
        }
    }
    //alert(pageName);
    if (navBtns.length > 0) {
        for (i = 0; i < navBtns.length; i++) {
            if (navBtnRef[i] == pageName) {
                navBtns[i].id = "active";
                break;
            }

        }
        //alert(navBtns[0].id);
    }
}
