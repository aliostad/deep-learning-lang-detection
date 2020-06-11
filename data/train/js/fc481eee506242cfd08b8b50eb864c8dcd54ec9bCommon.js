function ShowSuccessMessage(message) {
    var options = $('#message-success').attr('data-noty-options');    
    var optionToShow = options.replace("MESSAGE", message);    
    $('#message-success').attr('data-noty-options', optionToShow);
    $('#message-success').trigger('click');
}

function ShowErrorMessage(message) {
    var options = $('#message-error').attr('data-noty-options');
    var optionToShow = options.replace("MESSAGE", message);
    $('#message-error').attr('data-noty-options', optionToShow);
    $('#message-error').trigger('click');
}

function ShowInformationMessage(message) {
    var options = $('#message-info').attr('data-noty-options');
    var optionToShow = options.replace("MESSAGE", message);
    $('#message-info').attr('data-noty-options', optionToShow);
    $('#message-info').trigger('click');
}