function Telegram(DispatchTime,Sender,Receiver,Msg,ExtraInfo) {
    this.Sender = Sender;
    this.Receiver = Receiver;
    this.Msg = Msg;
    this.DispatchTime = DispatchTime;
    this.ExtraInfo = ExtraInfo;
}

var SmallestDelay= 0.25;

Telegram.prototype.compare = function(T) {
    return (Math.abs(this.DispatchTime-T.DispatchTime) < SmallestDelay) &&
        (this.Sender == T.Sender) &&
        (this.Receiver == T.Receiver) &&
        (this.Msg == T.Msg);
}
Telegram.prototype.lesser = function(T) {
    if(this.compare(T)) return false;
    else return this.DispatchTime < T.DispatchTime;
}
