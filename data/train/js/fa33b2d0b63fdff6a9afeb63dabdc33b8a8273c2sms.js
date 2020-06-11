
var native_accessor = {

    send_sms: function (phone, message) {
        native_access.send_sms({"receivers":[{"name":'name', "phone":phone}]}, {"message_content":message});
    },

    receive_message: function (json_message) {
        if (typeof this.process_received_message === 'function') {
            this.process_received_message(json_message);
        }
    },

    process_received_message: function(json_message) {
        process_all_message.process_message(json_message)
//        process_message(json_message)
    }

};

function notify_message_received(message_json) {
    //console.log(JSON.stringify(message_json));
    //JSON.stringify(message_json);
    //alert(JSON.stringify(message_json.messages));
    native_accessor.receive_message(message_json);
    //phone_number=message_json.messages[0].phone;
//    notify_message_received({"messages":[{"create_date":"Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013","message":"jj5","phone":"181717833"}]})
}