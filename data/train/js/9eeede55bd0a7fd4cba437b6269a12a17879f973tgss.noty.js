function show_message(message,message_type){
    
    noty({
        text: message,
        type: message_type        
    });
}

function show_success_message(message){
    show_message(message,'success');
}

function show_warning_message(message){
    show_message(message,'warning');
}

function show_error_message(message){
    show_message(message,'error');
}

function show_information_message(message){
    show_message(message,'information');
}

function show_alert_message(message){
    show_message(message,'alert');
}

$(document).ready(function(){
    if ($('#notification-message').length>0) {
        var message_type=$('#notification-message').data('message-type');
        var message=$('#notification-message').html();
        
        if (message_type=='success'){
            show_success_message(message);
        }else if (message_type=='warning'){
            show_warning_message(message);
        }else if (message_type=='error'){
            show_error_message(message);
        }else if (message_type=='information'){
            show_information_message(message);
        }else {
            show_alert_message(message);
        }        
    }    
});