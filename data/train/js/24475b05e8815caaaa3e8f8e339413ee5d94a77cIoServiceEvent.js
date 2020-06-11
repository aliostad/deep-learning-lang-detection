/**
 * Created by longjia.xiang on 2016/7/27.
 */

var IoServiceEvent = function (type,session,attachment) {

    this.type = type;
    this.session = session;
    this.attachement = attachment;

    /** Òì³£²¶»ñ*/
    IoServiceEvent.EXCEPTION_CAUSED = "exceptionCaused";
    /** */
    IoServiceEvent.MESSAGE_RECIEVED = "messageRecieved";

    IoServiceEvent.MESSAGE_SEND = "messageSend";

    IoServiceEvent.SERVICE_ACTIVATED = "serviceActivateD";

    IoServiceEvent.SERVICE_CLOSED = "serviceClosed";

    IoServiceEvent.SERVICE_DEACTIVATED = "serviceDeactivated";

    IoServiceEvent.SESSION_CLOSED = "sessionClosed";

    IoServiceEvent.SESSION_CREATED = "sessionCreated";

    IoServiceEvent.SESSION_IDLED = "sessionIdled";
};

module.exports = IoServiceEvent;