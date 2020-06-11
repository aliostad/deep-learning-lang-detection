//notify_message_received({"messages":[{"create_date":"Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013","message":"bm仝键","phone":"18733171780"}]})
//notify_message_received({"messages":[{"create_date":"Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013","message":"jj308","phone":"18733171780"}]})
var native_accessor = {
    send_sms: function (phone, message) {
//        native_access.send_sms({"receivers": [
//            {"name": 'name', "phone": phone}
//        ]}, {"message_content": message});
        console.log(phone, message);
    },
    receive_message: function (json_message) {
        if (typeof this.process_received_message === 'function') {
            this.process_received_message(json_message);
        }
    },
    process_received_message: function (json_message) {
        if(Message.check_status(json_message)){
            native_accessor.send_sms(json_message.messages[0].phone, "对不起活动尚未开始")
            return;
        }
        if (Message.check_activity_status_bm(json_message)) {
            native_accessor.send_sms(json_message.messages[0].phone, "您已报名成功，请勿重复报名")
            return;
        }
        if (Message.check_activity_status(json_message) && !Message.check_activity_status_bm(json_message)) {
            Message.save_message(json_message)
            native_accessor.send_sms(json_message.messages[0].phone, "恭喜您已报名成功")
            Message.refresh()
            return;
        }
        if(Message.check_message_j(json_message)){
            native_accessor.send_sms(json_message.messages[0].phone, "竞价尚未开始")
            return
        }
        if (Message.check_message_phone(json_message) && Message.check_message_jj(json_message) && Message.check_bid_phone(json_message)) {
            native_accessor.send_sms(json_message.messages[0].phone, "请勿重复竞价")
            return
        }

        if (Message.check_message_phone(json_message) && Message.check_message_jj(json_message)) {
            Message.save_bid_message(json_message)
            native_accessor.send_sms(json_message.messages[0].phone, "恭喜您已竞价成功")
            Message.refresh_bid()
            return
        }

    }
}

function notify_message_received(message_json) {
    //console.log(JSON.stringify(message_json));
    //JSON.stringify(message_json);
    //alert(JSON.stringify(message_json.messages));
    native_accessor.receive_message(message_json);
    //phone_number=message_json.messages[0].phone;
}


