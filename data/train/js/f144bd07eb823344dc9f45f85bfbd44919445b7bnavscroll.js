!function(exports){
  'use strict';
  var scrollY = 0;

  function isScrollDown(){
    return exports.scrollY > scrollY
  }

  function Navscroll(){
    this.nav = document.getElementsByClassName('nav-main')[0];
    this.page = document.getElementById('main-content');
    this.pollifyScrollY = (exports.scrollY === undefined ? true : false) ;
    if( this.pollifyScrollY ) { console.log('Navscroll: window.scrollY use pollify') }
    this.attachEvents();
  }

  Navscroll.prototype.attachEvents = function(){
    exports.document.onscroll = function(event){
      if( this.pollifyScrollY ){
        exports.scrollY = exports.document.documentElement.scrollTop;
      }
      this.scrollEvent(event);
      scrollY = exports.scrollY;
    }.bind(this);
    scrollY = 0;
  };

  Navscroll.prototype.scrollEvent = function(e){
    var nav = this.nav.getBoundingClientRect();
    var page = this.page.getBoundingClientRect();

    if( nav.height < exports.document.documentElement.clientHeight ){
      this.scrollEventSmallMenu(nav, page);
    }else{
      this.scrollEventBigMenu(nav, page);
    }
  };

  Navscroll.prototype.scrollEventBigMenu = function(nav, page){
    if( isScrollDown() ){
      if(
        nav.top <= 0 &&
        page.bottom < exports.document.documentElement.clientHeight &&
        this.nav.classList.contains('nav-main-to-top')
      ) {
        this.nav.classList.remove('nav-main-to-top');
        this.nav.classList.add('nav-main-to-bottom');
        return;
      }

      if(
        nav.top <= 0 &&
        nav.bottom <= exports.document.documentElement.clientHeight &&
        ( this.nav.classList.contains('nav-main-to-top') ||
          this.nav.classList.contains('nav-main-to-position')
        )
      ) {
        this.nav.classList.remove('nav-main-to-top');
        this.nav.classList.remove('nav-main-to-position');
        this.nav.classList.add('nav-main-fixed-bottom');
        this.nav.style.removeProperty('top');
      }else if(
        nav.bottom >= page.bottom &&
        ( this.nav.classList.contains('nav-main-fixed-bottom') ||
          this.nav.classList.contains('nav-main-to-position')
        )
      ) {
        this.nav.classList.remove('nav-main-fixed-bottom');
        this.nav.classList.add('nav-main-to-bottom');
        this.nav.style.removeProperty('top');
      }else if(
        nav.bottom >= 0 &&
        this.nav.classList.contains('nav-main-fixed-top')
      ) {
        this.nav.classList.remove('nav-main-fixed-top');
        this.nav.classList.add('nav-main-to-position');
        this.nav.style.top = page.top * (-1) + nav.top + "px";
      }
    } else {
      if(
        nav.top <= 0 &&
        this.nav.classList.contains('nav-main-fixed-bottom')
      ) {
        this.nav.classList.remove('nav-main-fixed-bottom');
        this.nav.classList.add('nav-main-to-position');
        this.nav.style.top = page.top * (-1) + nav.top + "px";
      }else if(
        nav.top >= 0 &&
        this.nav.classList.contains('nav-main-to-position')
      ) {
        this.nav.classList.remove('nav-main-to-position')
        this.nav.classList.add('nav-main-fixed-top');
        this.nav.style.removeProperty('top');
      }else if(
        nav.top >= 0 &&
        this.nav.classList.contains('nav-main-to-bottom')
      ) {
        this.nav.classList.remove('nav-main-to-bottom');
        this.nav.classList.add('nav-main-fixed-top');
      }else if(
        nav.top <= page.top &&
        this.nav.classList.contains('nav-main-fixed-top')
      ) {
        this.nav.classList.remove('nav-main-fixed-top');
        this.nav.classList.add('nav-main-to-top');
      }
    }
  };

  Navscroll.prototype.scrollEventSmallMenu = function(nav, page){
    if( isScrollDown() ){
      if(
        nav.top <= 0 &&
        page.bottom < exports.document.documentElement.clientHeight &&
        nav.height < page.bottom &&
        this.nav.classList.contains('nav-main-to-top')
      ) {
        this.nav.classList.remove('nav-main-to-top');
        this.nav.classList.add('nav-main-fixed-top');
        return;
      }else if(
        nav.top <= 0 &&
        page.bottom < exports.document.documentElement.clientHeight &&
        this.nav.classList.contains('nav-main-to-top')
      ) {
        this.nav.classList.remove('nav-main-to-top');
        this.nav.classList.add('nav-main-to-bottom');
        return;
      }

      if(
          nav.top <= 0 &&
          this.nav.classList.contains('nav-main-to-top')
      ) {
        this.nav.classList.remove('nav-main-to-top');
        this.nav.classList.add('nav-main-fixed-top');
      }else if(
        nav.bottom >= page.bottom &&
        ( this.nav.classList.contains('nav-main-fixed-top') ||
          this.nav.classList.contains('nav-main-fixed-bottom')
        )
      ) {
        this.nav.classList.remove('nav-main-fixed-top');
        this.nav.classList.remove('nav-main-fixed-bottom');
        this.nav.classList.add('nav-main-to-bottom');
      }
    } else {
      if(
        page.top >= 0 &&
        this.nav.classList.contains('nav-main-fixed-top')
      ) {
        this.nav.classList.remove('nav-main-fixed-top');
        this.nav.classList.add('nav-main-to-top');
      }else if(
        nav.top <= page.top &&
        this.nav.classList.contains('nav-main-fixed-bottom')
      ){
        this.nav.classList.remove('nav-main-fixed-bottom');
        this.nav.classList.add('nav-main-to-top');
      }else if(
        nav.top >= 0 &&
        this.nav.classList.contains('nav-main-to-bottom')
      ) {
        this.nav.classList.remove('nav-main-to-bottom')
        this.nav.classList.add('nav-main-fixed-top')
      }
    }
  };

  exports.navscroll = new Navscroll;
  console.log('Navscroll is loaded');
}(window)
