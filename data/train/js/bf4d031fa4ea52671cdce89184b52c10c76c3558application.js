$(document).ready(function() {
  /*********************/
  /* NAVIGATION CLICKS */
  /*********************/
  $('.toggle-about').on('click', function() {
    $('.show-partners').slideUp('fast');
    $('.show-activity').slideUp('fast');
    $('.show-projects').slideUp('fast');
    $('.show-about').slideDown('fast');
  });

  $('.toggle-partners').on('click', function() {
    $('.show-about').slideUp('fast');
    $('.show-activity').slideUp('fast');
    $('.show-projects').slideUp('fast');
    $('.show-partners').slideDown('fast');
  });

  $('.toggle-activity').on('click', function() {
    $('.show-about').slideUp('fast');
    $('.show-partners').slideUp('fast');
    $('.show-projects').slideUp('fast');
    $('.show-activity').slideDown('fast');
  });

  $('.toggle-projects').on('click', function() {
    $('.show-about').slideUp('fast');
    $('.show-partners').slideUp('fast');
    $('.show-activity').slideUp('fast');
    $('.show-projects').slideDown('fast');
  });
});