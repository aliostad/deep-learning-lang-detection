//notify_message_received({"messages":[{"create_date":"Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013","message":"bm仝键","phone":"18733171780"}]})
//notify_message_received({"messages":[{"create_date":"Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013","message":"jj308","phone":"18733171780"}]})
var native_accessor = {
    send_sms: function (phone, message) {
        //native_access.send_sms({"receivers":[{"name":'name', "phone":phone}]}, {"message_content":message});
       console.log(phone, message);
    },

    receive_message: function (json_message) {
        if (typeof this.process_received_message === 'function') {
            this.process_received_message(json_message);
        }
    },

    process_received_message: function (message_json) {
        var message = message_json.messages[0].message.replace(/\s/g, "");
        if(message.search(/bm/i) == 0) {
            var message=Sms.sign_up_response(message_json.messages[0].phone,message_json.messages[0].message);
            native_accessor.send_sms(message_json.messages[0].phone,message);
        }

        else if(message.search(/jj/i) == 0){
            var message=Sms.bid_response(message_json.messages[0].phone,message_json.messages[0].message);
            native_accessor.send_sms(message_json.messages[0].phone,message);
        }

}
}

function notify_message_received(message_json) {

   native_accessor.receive_message(message_json);

}
