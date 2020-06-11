$(document).ready(function() {
  $('.btn-blue').click(function() {
    $('.nav-green').addClass('nav-blue').removeClass("nav-green nav-red nav-white")
    $('.nav-red').addClass('nav-blue').removeClass("nav-green nav-red nav-white")
    $('.nav-white').addClass('nav-blue').removeClass("nav-green nav-red nav-white")
  });

  $('.btn-red').click(function() {
    $('.nav-green').addClass('nav-red').removeClass("nav-green nav-blue nav-white")
    $('.nav-blue').addClass('nav-red').removeClass("nav-green nav-blue nav-white")
    $('.nav-white').addClass('nav-red').removeClass("nav-green nav-blue nav-white")
  });

  $('.btn-green').click(function() {
    $('.nav-blue').addClass('nav-green').removeClass("nav-red nav-blue nav-white")
    $('.nav-red').addClass('nav-green').removeClass("nav-red nav-blue nav-white")
    $('.nav-white').addClass('nav-green').removeClass("nav-red nav-blue nav-white")
  });

  $('.btn-white').click(function() {
    $('.nav-blue').addClass('nav-white').removeClass("nav-red nav-blue nav-green")
    $('.nav-red').addClass('nav-white').removeClass("nav-red nav-blue nav-green")
    $('.nav-green').addClass('nav-white').removeClass("nav-red nav-blue nav-green")
  });
});