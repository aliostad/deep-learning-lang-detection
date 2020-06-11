var scroll;
var logo = $(".nav>li>a>img");
var logoEl = $(".hidden-xs");
var nav = $(".navbar-nav");
var listElement = $(".navbar-nav li");
$(document).scroll(function() {
    scroll = $(document).scrollTop();
    if(scroll > 130){
      goLeft();
    }else{
      goMiddle();
    }
})


function logoLeft(){
  logo.css("position", "fixed");
  logo.css("left", "0");
  logo.css("top", "0");
  logo.css("height", "150px");
  logo.css("width", "150px");
}
function navLeft(){
  nav.css("position", "fixed");
  nav.css("left", "-40%");
  $(".navbar-nav>li>a").css("padding", "0");
  $(".navbar-nav>li>a").css("display", "block");
  $(".navbar-nav>li").css("float", "none");
  logoEl.css("float", "left!important");
  nav.css("top", "15%");
  nav.css("background-color", "white");
}

function goLeft(){
  logoLeft();
  navLeft();
}

function goMiddle(){
  logo.css("position", "relative");
  nav.css("position", "relative");
  nav.css("left", "auto");
}



function openNav(){
  if(nav.hasClass("right")){
    nav.removeClass("right");
    nav.animate({
      left: "-=56%"
    });
  }else{
    nav.addClass("right");
    nav.animate({
      left: "+=56%"
    });
  }

}

nav.on("click", openNav);
