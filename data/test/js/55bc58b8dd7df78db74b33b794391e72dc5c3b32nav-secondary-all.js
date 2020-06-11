define('nav-secondary-all', ['underscore', 'widget-lite'], function(_, widgetLite){

  "use strict";

  return widgetLite.extend({

    // is the nav open?
    navOpen: false,

    // does the nav sit in-page and change content dynamically without reloading a page?
    inlineNav: false,

    init: function(element, data){

      // merge data with this
      _.extend(this, data);

      this.element = element;

      this._getElements();
      this._bindEvents();

    },

    _getElements: function(){

      this.dummy = document.createElement('div');

      this.navHead = this.element.querySelector('.nav-secondary-all__head');
      this.navBody = this.element.querySelector('.nav-secondary-all__body');
      this.navOffset = document.querySelector('.nav-secondary-all__offset') || this.dummy;
      this.navItems = this.element.querySelectorAll('.nav-secondary-all__item');
      this.navSection = this.element.querySelector('.nav-secondary-all__section');
    },

    _bindEvents: function(){

      // add action to toggle nav
      this.navHead.addEventListener('click', function(){

        this._toggleNav();

      }.bind(this), false);

      // add action to sub-nav items, if inline nav option is set
      _.each(this.navItems, function(item){

        item.onclick = this._navItemActions.bind(this, item);

      }.bind(this));

      // @TODO - add off click here

    },

    _toggleNav: function(state){

      var height = this.navBody.offsetHeight;

      if(this.navIsOpen || state === 'close'){

        this.navIsOpen = false;

        this.navHead.classList.remove('nav-secondary-all__head-on');
        this.navBody.classList.remove('nav-secondary-all__body--open');
        this.navOffset.style.cssText = "";
      }

      else {

        this.navIsOpen = true;

        this.navHead.classList.add('nav-secondary-all__head-on');
        this.navBody.classList.add('nav-secondary-all__body--open');
        this.navOffset.style.cssText = "padding-bottom:" + height + "px;-ms-transform:translateY("+ height +"px);-moz-transform:translateY("+ height +"px);-webkit-transform:translateY("+ height +"px);transform:translateY("+ height +"px)";
      }
    },

    // function to run when sub-nav item clicked
    _navItemActions: function(el, evnt){

      //for IE8 compatibility access global event
      evnt = evnt || window.event;

      if(this.inlineNav){

        evnt.preventDefault();

        this.navSection.textContent = el.textContent;
        this._toggleNav('close');


      }
    }

  });


});
