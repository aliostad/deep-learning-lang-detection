/**
 * Created by Raul on 5/19/2014.
 */
function messageViewModel()
{
    var self = this;
    self.message = ko.observable();
    self.header = ko.observable();
    self.isWinMessage = ko.observable(false);
    self.isLostMessage = ko.observable(false);

    self.resetMessageType = function(){
        self.isWinMessage(false);
        self.isLostMessage(false);
    };

    self.standardMessage = function (messageText, messageHeader)
    {
        self.resetMessageType();
        self.message(messageText);
        self.header(messageHeader);
        $('#messageModal').modal();
    };
    self.winMessage = function (messageText, messageHeader)
    {
        self.standardMessage(messageText, messageHeader);
        self.isWinMessage(true);
    };
    self.lostMessage = function (messageText, messageHeader)
    {
        self.standardMessage(messageText, messageHeader);
        self.isLostMessage(true);
    };

}