var closeNav, insideNav, navBtn, navLinks, navTop, openNav, toggleNav, waitToCloseNav;

navTop = $('.nav-top');

navBtn = $('.nav-btn');

navLinks = $('.nav-top a');

insideNav = false;

openNav = function() {
  navTop.setAttribute('data-state', 'expanded');
  return navBtn.setAttribute('data-state', 'active');
};

closeNav = function() {
  navTop.setAttribute('data-state', 'collapsed');
  return navBtn.setAttribute('data-state', 'inactive');
};

toggleNav = function() {
  if (navTop.getAttribute('data-state') === 'expanded') {
    return closeNav();
  } else {
    return openNav();
  }
};

waitToCloseNav = function() {
  return setTimeout(function() {
    if (!insideNav) {
      return closeNav();
    }
  }, 100);
};

navBtn.on('click', function(e) {
  e.preventDefault();
  return toggleNav();
});

navBtn.on('focus', function(e) {
  insideNav = true;
  return openNav();
});

navBtn.on('blur', function(e) {
  insideNav = false;
  return waitToCloseNav();
});

navLinks.on('focus', function(e) {
  insideNav = true;
  return openNav();
});

navLinks.on('blur', function(e) {
  insideNav = false;
  return waitToCloseNav();
});
