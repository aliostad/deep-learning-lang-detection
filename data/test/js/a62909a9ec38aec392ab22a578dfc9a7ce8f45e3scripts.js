$(document).ready(function() {
  $("form").submit(function(event) {
    $('#match , #hugh , #sofia , #rupert , #emily').hide();

    var gender = $('#gender').val();
    var age = parseInt($('#age').val());


    if (age >= 40 && gender === 'male') {
      $('#match').show();
       $("#hugh").show();
    }

    else if (age >= 40 && gender === 'female') {
      $('#match').show();
       $("#sofia").show();
    }

    else if (age <  40 && gender === 'male') {
      $('#match').show();
       $("#rupert").show();
    }

   else {
      $('#match').show();
       $("#emily").show();
    }
    event.preventDefault();
  });
});
