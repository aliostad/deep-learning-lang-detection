/* jshint browser: true, jquery: true */
'use strict';

$(document).ready(function(){
    $("#nav").sticky({topSpacing:0, center:true});
  });

// $(document).ready(function() {
//   var navOffset = $("#nav").offset().top;
//   // alert(navOffset);

//   $("#nav").wrap('<div class="nav-placeholder"></div>');
//   $(".nav-placeholder").height($("#nav").outerHeight());

//   $("#nav").wrapInner('<div class="nav-inner"></div>');

//   $(window).scroll(function() {
//     var scrollPosition = $(window).scrollTop();
//       // $(".status").html(scrollPosition);
//     if (scrollPosition >= navOffset) {
//       $("#nav").addClass("fixed");
//     }
//     else {
//       $("#nav").removeClass("fixed");
//     }
//   });
// });