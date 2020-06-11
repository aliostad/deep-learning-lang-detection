// add a service
$.fn.init_add_service = function() {
  // validate the form on submit
  $(".new_service,.edit_service").submit(function () {
    if ($("#service_name").attr("value") == '') {
      alert("Please enter a service name");
      $("#service_name").focus();
      return false;
    }

    if ($("#service_duration").attr("value") == '') {
      alert("Please enter a service duration");
      $("#service_duration").focus();
      return false;
    }
    
    return true;
  })
}

$(document).ready(function() {
  $(document).init_add_service_provider();
  $(document).init_add_service();
})

// Re-bind after an ajax call
$(document).ajaxComplete(function(request, settings) {
 $(document).init_add_service_provider();
})