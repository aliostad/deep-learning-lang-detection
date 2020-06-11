function activateNav() {
  'use strict';
  $('body').addClass('nav-active');
  
  // Unbind activation listeners
  $('.toggle-nav').off('click', activateNav);
  $('header').off('swiperight', activateNav);
  
  // Bind deactivation listeners
  $('.toggle-nav').on('click', deactivateNav);
  $('header').on('swipeleft', deactivateNav);
  $('.categories li').on('click', deactivateNav);
  $('.content').on('click', deactivateNav);
}

function deactivateNav() {
  'use strict';
  $('body').removeClass('nav-active');
  
  // Unbind deactivation listeners
  $('.toggle-nav').off('click', deactivateNav);
  $('header').off('swipeleft', deactivateNav);
  $('.categories li').off('click', deactivateNav);
  $('.content').off('click', deactivateNav);
  
  // Bind activation listeners
  $('.toggle-nav').on('click', activateNav);
  $('header').on('swiperight', activateNav);
}

$(function () {
  'use strict';
  /* Sorting function */
  $('input').change(function () {
    var filter = $('input:checked');
    $('.item').show();
    if (filter.length > 0) {
      $('.item').hide();
      $.each(filter, function (i, val) {
        $('.item[data-' + val.name + '=' + val.value + ']').show();
      });
    }
  });
  
  // Add listeners for showing the nav
  $('.toggle-nav').on('click', activateNav);
  $('header').on('swiperight', activateNav);
});