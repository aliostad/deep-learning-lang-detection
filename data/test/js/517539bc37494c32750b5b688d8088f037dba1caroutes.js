module.exports = function( app , config ) {
    var api = require( "../controllers/api" )( config )
        , oauth = require( "../controllers/oauth" )( config )
        , alipay = require( "../controllers/alipay" )( config , app );

    //api routes
    //user
    app.post( "/api/do_login" , api.doLogin );
    app.get( "/api/users/" , api.getUserList );
    app.post( "/api/upload_files" , api.uploadFiles );
    app.post( "/api/user/" , api.updateUser );
    app.get( "/api/user/" , api.getUser );
    app.get( "/api/should_display_contact_info/" , api.shouldDisplayContactInfo );
    app.get( "/api/update_brower_status/" , api.updateBrowerStatus );
    app.post( "/api/reg/" , api.reg );

    //gift
    app.get( "/api/gifts/" , api.getGiftList );
    app.post( "/api/send_gift/" , api.sendGift );

    //payment_recoreds
    app.get( "/api/payment_recoreds/" , api.getPaymentRecordList );

    //msg
    app.get( "/api/get_exist_talk_betweet_two_users/" , api.getExistTalkBetweetTwoUsers );
    app.get( "/api/msgs/" , api.getMsgList );
    app.get( "/api/chat_items" , api.getMsgListByGroup );
    app.post( "/api/send_msg" , api.sendMsg );
    app.post( "/api/set_back_account" , api.setBankAccount );
    app.post( "/api/withdraw_cash" , api.withdrawCash );

    //最新状态
    app.get( "/api/new_msgs/" , api.getNewMsgs );
    app.get( "/api/new_gifts/" , api.getNewGifts );
    app.get( "/api/new_visitors/" , api.getNewVisitors );

    //pay
    app.get( "/alipay/init_trade/" , alipay.initTrade );

    //oauth
    app.get( "/oauth/authorize/:type" , oauth.authorize );
    app.get( "/oauth/redirect/:type" , oauth.redirect );

    //diary
    app.get( "/api/diaries" , api.getDiaryList );
    app.get( "/api/diary" , api.getDiaryDetail );
    app.post( "/api/diary" , api.addNewDiary );
    app.post( "/api/update_diary" , api.updateDiary );
    app.get( "/api/diary_comments" , api.getCommentListByDiaryId );
    app.post( "/api/add_new_comment" , api.addCommentToADiary );
}
