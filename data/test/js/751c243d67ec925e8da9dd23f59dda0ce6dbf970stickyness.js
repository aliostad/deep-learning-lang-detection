(function() {
  if (!window.FA) window.FA = {};
  if (FA.Nav) {
    if (window.console && console.warn) console.warn('FA.Nav has already been defined');
    return;
  }

  FA.Nav = {
    
    // TARGET NODES BY VERSION
    // PHPBB2   : .bodyline > table + table
    // PHPBB3   : #page-header .navlinks
    // PUNBB    : #pun-navlinks
    // INVISION : #submenu
    targetNode : '#page-header .navlinks',
    
    customNav : '', // custom navlinks
    
    keepDefault : true, // keep the default navlinks
    collapsible : true, // show hide button
    
    
    // offset states
    offsets : {
      tbVisible : {
        bottom : 30,
        top : '31px' // change to 30px if there's no border on your toolbar
      },
      
      tbHidden : {
        bottom : 0,
        top : '0px'
      },
      
      toggler : '30px'
    },
    
    activeOffset : {}, // active offset for the sticky nav
    
    visible : false, // sticky nav is visible
    
    // check the state of the static nav
    checkState : function() {
      if (!FA.Nav.animating) {
        var hidden = FA.Nav.barStatic.getBoundingClientRect().bottom <= FA.Nav.activeOffset.bottom;
      
        if (hidden && FA.Nav.barSticky.style.top != FA.Nav.activeOffset.top) {
          if (FA.Nav.toggler) FA.Nav.toggler.style.top = FA.Nav.offsets.toggler;
          FA.Nav.barSticky.style.top = FA.Nav.activeOffset.top;
          FA.Nav.visible = true;
        } else if (!hidden && FA.Nav.barSticky.style.top != '-30px') {
          if (FA.Nav.toggler) FA.Nav.toggler.style.top = '-30px';
          FA.Nav.barSticky.style.top = '-30px';
          FA.Nav.visible = false;
        }
      }
    },
    
    animating : false, // sticky nav is animating
    
    // animate the sticky nav when the toolbar is toggled
    animate : function() {
      if (FA.Nav.visible) {
        FA.Nav.animating = true;
        FA.Nav.barSticky.style.transition = 'none';
      
        $(FA.Nav.barSticky).animate({
          top : FA.Nav.activeOffset.top
        }, function() {
          FA.Nav.barSticky.style.transition = '';
          FA.Nav.animating = false;
          FA.Nav.checkState();
        });
      }
    },
    
    // toggle sticky navigation and remember preference via cookies
    toggle : function() {
      if (FA.Nav.barSticky.style.width == '100%') {
        my_setcookie('fa_sticky_nav', 'hidden');
        FA.Nav.barSticky.style.width = '0%';
      } else {
        my_setcookie('fa_sticky_nav', 'shown');
        FA.Nav.barSticky.style.width = '100%';
      }
      return false;
    }
    
  };
  
  $(function() {
    // set default offsets based on toolbar state
    FA.Nav.activeOffset = (my_getcookie('toolbar_state') == 'fa_hide' || !_userdata.activate_toolbar) ? FA.Nav.offsets.tbHidden : FA.Nav.offsets.tbVisible;
    if (!_userdata.activate_toolbar) FA.Nav.offsets.toggler = '0px';
    
    // find the static nav
    FA.Nav.barStatic = document.querySelector ? document.querySelector(FA.Nav.targetNode) : $(FA.Nav.targetNode)[0]; // static nav
    
    if (FA.Nav.barStatic) {
      FA.Nav.barSticky = FA.Nav.barStatic.cloneNode(FA.Nav.keepDefault); // clone static nav
      if (FA.Nav.customNav) FA.Nav.barSticky.insertAdjacentHTML('beforeEnd', FA.Nav.customNav);
      FA.Nav.barSticky.id = 'fa_sticky_nav';
      FA.Nav.barSticky.style.width = my_getcookie('fa_sticky_nav') == 'hidden' ? '0%' : '100%';
      FA.Nav.barSticky.style.top = '-30px';
          
      document.body.appendChild(FA.Nav.barSticky); // append the sticky one
          
      // sticky nav toggler
      if (FA.Nav.collapsible) {
        FA.Nav.toggler = document.createElement('A');
        FA.Nav.toggler.id = 'fa_sticky_toggle';
        FA.Nav.toggler.href = '#';
        FA.Nav.toggler.style.top = '-30px';
        FA.Nav.toggler.onclick = FA.Nav.toggle;
          
        document.body.appendChild(FA.Nav.toggler);
      };
        
      window.onscroll = FA.Nav.checkState; // check state on scroll
      FA.Nav.checkState(); // startup check
      
      // toolbar modifications
      $(function() {
        // animate sticky nav and change offsets when the toolbar is toggled
        $('#fa_hide').click(function() {
          FA.Nav.activeOffset = FA.Nav.offsets.tbHidden;
          FA.Nav.animate();
        });
        
        $('#fa_show').click(function() {
          FA.Nav.activeOffset = FA.Nav.offsets.tbVisible;
          FA.Nav.animate();
        });
      });
    }
  });
}());
