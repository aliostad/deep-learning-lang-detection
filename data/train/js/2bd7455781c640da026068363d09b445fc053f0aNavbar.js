var mn = $(".main-nav"); //alert("mn=" + mn);
var mns = "main-nav-scrolled"; //alert("mns=" + mns);
var hdr = $('header').height(); //alert("hdr=" + hdr);

$(document).ready(function () {
    $(".main-nav").addClass("main-nav-not-scrolled");
});


$(window).scroll(function () {
    //alert("inside function");
    if ($(this).scrollTop() > 190) {
        //alert("inside if");
        $(".main-nav").addClass("main-nav-scrolled");
        $(".main-nav").removeClass("main-nav-not-scrolled");
    } else {
        //alert("inside else");
        $(".main-nav").removeClass("main-nav-scrolled");
        $(".main-nav").addClass("main-nav-not-scrolled");
    }
});