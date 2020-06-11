app.factory('messageType', function() {
    return {
        decipher: function(message) {
            var data;
            if(message.search('!spotify ') != -1) {
                data = "song-info";
                message = message.substring(9, message.length);
            }
            else if(message.search('!youtube ') != -1) {
                data = "youtube-info";
                message = message.substring(9, message.length);
            }
            else if(message.search('!maps ') != -1) {
                data = "maps-info";
                message = message.substring(6, message.length);
            }
            else {
                data = "chat-message";
            }

            return {data: data, text: message};
        }
    };
});