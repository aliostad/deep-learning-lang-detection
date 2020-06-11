function preload(arrayOfImages) {
  $(arrayOfImages).each(function(){
    $('<img/>')[0].src = this;
  });
}

var current_show;
$(function() {
  var height = $('#navigation').height();
  $('#nav_extend').css('height', height - 10);

  current_show = $("#shows a.selected").attr('data-show');
});

$('#shows a').live('click', function() {
  if(animation_lock == true) {
    return false;
  }

  $('#shows a').removeClass('selected');
  $(this).addClass('selected');

  var show = $(this).attr('data-show');
  // $('#show-desc-' + current_show).slideUp(500, function() {
  //     $('#show-desc-' + show).slideDown(500);
  //   });
  $('#show-desc-' + show).slideDown(500, function() {
    $('#show-desc-' + current_show).slideUp(500);
    current_show = show;
  });
  //$('.show-desc').css('display', 'none');
  //$('#show-desc-' + show).css('display', 'block');

  change_to($('#show'), '/images/show' + show + '.jpg');
  return false;
});