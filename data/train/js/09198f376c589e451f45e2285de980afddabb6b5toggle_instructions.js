$(function () {
  var $showInstructions = $('.show-instructions a'),
    $hideInstructions = $('.hide-instructions a'),
    $instructions = $('#instructions');

  $hideInstructions.parent().show();

  $showInstructions.bind('click', function (e) {
    e.preventDefault();
    $(this).parent().hide();
    $hideInstructions.parent().show();
    $instructions.show();
  });

  $hideInstructions.bind('click', function (e) {
    e.preventDefault();
    $(this).parent().hide();
    $instructions.hide();
    $showInstructions.parent().show();
  });
});
