// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .

function toggle_active_link(nav) {
    $('#nav_home').removeClass('active_nav');
    $('#nav_books').removeClass('active_nav');
    $('#nav_blog').removeClass('active_nav');
    $('#nav_videos').removeClass('active_nav');
    $('nav_gallery').removeClass('active_nav');
    $('#nav_patas').removeClass('active_nav');
    $('#nnav_jem').removeClass('active_nav');
    $('#nav_forum').removeClass('active_nav');
  switch (nav) {
    case 'nav_books':
      $('#nav_books').addClass('active_nav');
      break;
    case 'nav_blog':
      $('#nav_blog').addClass('active_nav');
      break;
    case 'nav_videos':
      $('#nav_videos').addClass('active_nav');
      break;
    case 'nav_gallery':
      $('#nav_gallery').addClass('active_nav');
      break;
    case 'nav_patas':
      $('#nav_patas').addClass('active_nav');
      break;
    case 'nav_jem':
      $('#nav_jem').addClass('active_nav');
      break;
    case 'nav_forum':
      $('#nav_forum').addClass('active_nav');
      break;
    default:
      $('#nav_home').addClass('active_nav');
  }
}