var native_accessor = {

    send_sms: function (phone, message) {
        native_access.send_sms({"receivers": [
            {"name": 'name', "phone": phone}
        ]}, {"message_content": message});
    },

    receive_message: function (message_json) {
        if (typeof this.process_received_message === 'function') {
            this.process_received_message(message_json);
        }
    },

    process_received_message: function (message_json) {
        if (!check_message(message_json)) {
            return;
        }
        native_accessor[get_bm_or_jj(message_json)](message_json);
    },

    'BM': function (message_json) {
        SMSSignUp.check_bm_activity(SMSSignUp.reconstruct_bm_message(message_json));
    },

    'JJ': function (message_json) {
        if (!SMSBid.judge_jj_phone_is_from_bm_phone(message_json) || !SMSBid.judge_jj_content_is_price(message_json)) {
            return;
        }
        if (SMSBid.reconstruct_jj_message(message_json)) {
            SMSBid.check_jj_activity(SMSBid.reconstruct_jj_message(message_json));
        } else {
            console.log('对不起，您没有报名此次活动！');
        }
    }
};

function check_message(message_json) {
    var message_flag = message_json.messages[0].message.substring(0, 2).toUpperCase();
    if ((message_flag == 'JJ' || message_flag == 'BM') && message_json.messages[0].message.length > 2) {
        return true;
    }
}

function get_bm_or_jj(message_json) {
    return message_json.messages[0].message.substring(0, 2).toUpperCase();
}

function notify_message_received(message_json) {
//    console.log(JSON.stringify(message_json));
    //JSON.stringify(message_json);
    //alert(JSON.stringify(message_json.messages));
    native_accessor.receive_message(message_json);
    //phone_number=message_json.messages[0].phone;
}


/*
 notify_message_received({"messages": [
 {"create_date": "Tue Jan 15 15:28:44 格林尼治标准时间+0800 2013", "message": "bm1", "phone": "181717833"}
 ]})

 */