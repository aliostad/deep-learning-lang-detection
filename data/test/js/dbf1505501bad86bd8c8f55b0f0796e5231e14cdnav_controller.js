PortfolioApp.controller('NavController', NavController);

NavController.$inject = ['$http'];

function NavController($http) {
  var nav = this;

  nav.toggle = false;

  nav.whichNav = '';
  nav.theFunction = "nav.scrollJavaScript()";

  nav.secondNav = {
    'projects' : ['JAVA', 'RUBY', 'JAVASCIPT'],
    'background' : ['EDUCATION', 'TEACHING', 'BUSINESS DEV', 'WEB DEV']
  }

  nav.menuVanish = function(){
    nav.toggle = false
  };

  nav.home = function(){
    $('.nav-text-main').css({'color': '#173e43'});
  };
  nav.reset = function(){
    $('.nav-text-main').css({'color': '#173e43'});
    nav.toggle = false;
  };
  nav.contact = function(){
    $('.nav-text-main').css({'color': '#173e43'});
    $('#contact').css({'color': '#999999'});
    nav.toggle = false;
  };
  nav.projects = function(){
    $('.nav-text-main').css({'color': '#173e43'});
    $('#projects').css({'color': '#999999'});
    nav.toggle = true;
    nav.whichNav = 'projects';
  };
  nav.background = function(){
    $('.nav-text-main').css({'color': '#173e43'});
    $('#background').css({'color': '#999999'});
    nav.toggle = true;
    nav.whichNav = 'background';
  };


  nav.scroll = function(itemName){
    window.setTimeout(
      function(){
        if(itemName == "JAVASCIPT"){
          var $target = $("#javascript-breaker"); 
        } else if(itemName == "RUBY"){
          var $target = $("#ruby-breaker"); 
        } else if(itemName == "JAVA"){
          var $target = $("#java-breaker"); 
        } else if(itemName == "WEB DEV"){
          var $target = $("#web-breaker"); 
        } else if(itemName == "TEACHING"){
          var $target = $("#teaching-breaker"); 
        } else if(itemName == "BUSINESS DEV"){
          var $target = $("#bussiness-breaker"); 
        } else if(itemName == "EDUCATION"){
          var $target = $("#education-breaker"); 
        }
        $("body").animate({scrollTop: $target.offset().top}, "slow");
      }, 400);
  }
}