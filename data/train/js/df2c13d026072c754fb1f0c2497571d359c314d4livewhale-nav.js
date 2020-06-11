
var livewhaleNav = function(selector){
  this.subNavs = [];
  $(selector + ' .lw_has_subnav').hover(this.show, this.hide);
  return this;
};

livewhaleNav.prototype.show = function(){
  var subNav = $(this).children('.lw_subnav');
  if (subNav.length > 0) {
    window.livewhaleNav.subNavs.push(subNav[0]);
    subNav.show();
  }
  return;
};

livewhaleNav.prototype.hide = function(){
  var subNavs = window.livewhaleNav.subNavs, subNav;
  while (subNavs.length > 0) {
    subNav = $(subNavs[subNavs.length - 1]);
    if ($(this) == subNav || $(this).has(subNav)) {
      subNav.hide();
      subNavs.pop();
    } else {
      return;
    }
  }
  return;
};


$(document).ready(function(){
  window.livewhaleNav = new livewhaleNav('#nav');
});
