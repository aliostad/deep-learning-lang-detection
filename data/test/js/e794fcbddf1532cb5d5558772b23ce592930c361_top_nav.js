(function(mainNav){
  var $_main, $_navIcon;

  $_main = $( '.main-container' );
  $_navIcon = $( '<i class="fa"></i>' );
  
  var addIcon = function(targetNav) {
    targetNav.before( $_navIcon );
  }

  var expand = function(targetNav) {
    $_navIcon.removeClass( 'open' ).addClass( 'close' );
    targetNav.removeClass( 'collapsed' ).addClass( 'expanded' );
  }

  // Collapse the navigation when anything outside of the nav is clicked
  var collapse = function(targetNav) {
    $_navIcon.removeClass( 'close' ).addClass( 'open' );
    targetNav.removeClass( 'expanded' ).addClass( 'collapsed' );
  }

  // Clear mobile classes on desktop and larger
  var clear = function(targetNav) {
    $_navIcon.removeClass( 'open close' );
    targetNav.removeClass( 'collapsed expanded' );
  }

  mainNav.toggle = function (nav) {
    nav = $( nav );

    
    // Add navigation icon
    addIcon( nav );
    
    // Collapse the navigation to start
    if (!nav.hasClass('collapsed') && !nav.hasClass('expanded')) {
      $_navIcon.addClass('open');
      nav.addClass( 'collapsed' );
    }

    // When the hamburger/close icon is clicked
    $_navIcon.on( 'click', function(){ 
      if (nav.hasClass('collapsed')){
        // Expand the navigation 
        expand(nav); 
      } else if (nav.hasClass('expanded')){
        // Collapse the navigation 
        collapse(nav);
      }
    });

    // Collapse the navigation when anything outside of the nav 
    // is clicked
    $_main.on(    'click', function(){ collapse(nav); });
  };
})(this.topNav = {});
