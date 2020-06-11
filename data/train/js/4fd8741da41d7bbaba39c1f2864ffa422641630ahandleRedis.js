module.exports = function(channel, message) {
    var self = this;

    if (message.rooms) {    // Room message
        message.rooms.forEach(function(room) {
            message.data.room = room;
            self.in(room).emit(message.channel || 'message', message.data);
        });

    } else if (message.player) {    // Individual message
        var socket = this.sockets.connected[message.player];

        if (socket) {
            socket.emit(message.channel || 'message', message.data);
        }
    }
};