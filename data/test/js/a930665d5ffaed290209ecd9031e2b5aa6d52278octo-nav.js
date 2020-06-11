;(function(){
  var $octoNav = $('[octo-nav]'),
    $octoNavPageContent = $('[octo-nav-page-content]'),
    $octoNavControl = $('[octo-nav-control]'),
    $octoNavNavigation = $('[octo-nav-navigation]'),
    animationTime = 500;
  $octoNavNavigation.on('click', function(event) {
    $target = $(event.target);
    if ($target.attr('octo-nav-link') !== undefined) {
      var hash = $target[0].hash,
        $hash = $(hash);
      if(hash !== undefined && hash.indexOf('#') === 0) {
        event.preventDefault();
        $octoNavPageContent.find('[octo-nav-scrollable]')
          .stop(true, true)
          .animate({
            scrollTop: $hash.offset().top + $hash.parent().scrollTop()
          }, animationTime);
        setTimeout(function(){
          $octoNavPageContent.removeClass('show-nav');
        }, animationTime);
      }
    }
  });
  $octoNavPageContent.on('click', function(event) {
    if ($octoNavPageContent.hasClass('show-nav') && $(event.target).attr('octo-nav-control') === undefined) {
      $octoNavPageContent.removeClass('show-nav');
    } else if ($(event.target).attr('octo-nav-control') !== undefined) {
      $octoNavPageContent.toggleClass('show-nav');
    }
  });
})();
