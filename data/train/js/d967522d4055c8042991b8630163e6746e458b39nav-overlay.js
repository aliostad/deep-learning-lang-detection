var ESC_KEY  = 27;
var NAV_BTN  = '#nav-toggle-btn';
var NAV_LINK = '#nav a';

function openNav() {
  $('body').attr('data-nav-open', true);
}

function closeNav() {
  $('body').attr('data-nav-open', false);
}

function toggleNav() {
  var open = ( $('body').attr('data-nav-open') === 'true' );
  if (open)
    return closeNav();
  openNav();
}
$(document).on('click', NAV_BTN, function(event) {
  event.preventDefault();
  toggleNav();
});

$(document).on('click', NAV_LINK, closeNav);

$(document).on('keydown', function(event) {
  if (typeof event !== 'undefined' && event.keyCode === ESC_KEY)
    toggleNav();
});
