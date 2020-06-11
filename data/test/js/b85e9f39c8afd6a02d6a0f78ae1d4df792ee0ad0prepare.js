module.exports = {
	process_event: function(message, callback) {


    try{

        if (message.channel.substring(0, 5) == '/meta')
             return callback(message);

         if (!message.data.response)
            message.data.response = {};

        message.clean_channel = message.channel.split('@')[1];
        message.action = message.channel.split('@')[0].split('_')[1];

        this.utils.log('message prepared', 'trace');
        this.utils.log(message, 'trace');

    }catch(e){
        message.error = 'malformed channel or message: ' + e;
    }

    callback(message);
  }
}