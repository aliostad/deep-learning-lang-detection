define(['config'], function(Config) {
    var message;
    var messageTimer;
    return function(state, text) {
        if (message) message.destroy();
        if (messageTimer) messageTimer.destroy();
        message = state.add.text(Config.gameWidth / 2, Config.gameHeight / 2 + 100,
            text, Config.messageTextStyle);
        message.anchor.set(0.5);
        messageTimer = state.time.create();
        messageTimer.add(1500, function() {
            message.destroy();
        });
        messageTimer.start();
    };
});