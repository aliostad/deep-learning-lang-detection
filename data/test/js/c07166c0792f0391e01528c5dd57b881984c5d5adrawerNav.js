$(function() {

  $(".drawer-btn, .drawer-wrap a").click(function() {
    var $navBody, $navWrap, $navBtn;
    var bodySpeed = 200;
    var wrapSpeed = 400;
    var opacity;
    var isLink  = $(this)[0].localName == "a";
    var isTitle = $(this).parent()[0].localName == "h1";

    // Setting
    if(isLink) {
      if(isTitle)
        $navBody = $(this).parent().next();
      else
        $navBody = $(this).parent().parent().parent();
      $navBtn  = $navBody.next();
    } else {
      $navBody = $(this).prev();
      $navBtn  = $(this);
    }
    $navWrap = $navBody.parent().parent();

    if($navWrap.attr("id") == "global_nav")
      opacity = ".8";
    else
      opacity = ".935";

    // On Active
    if(!( isTitle && !$navBtn.hasClass("active") ))
      $navBtn.toggleClass("active");

    // Change Style
    if($navBtn.hasClass("active") && !isLink) {
      $navBody.animate({"top": "48px"}, bodySpeed);
      $navWrap.animate({
        "height": "100%",
        "opacity": "1"
      }, wrapSpeed);
    }
    else {
      $navBody.animate({"top": "-1000px"}, bodySpeed);
      $navWrap.animate({
        "height": "48px",
        "opacity": opacity
      }, wrapSpeed);
    }
  });

});
