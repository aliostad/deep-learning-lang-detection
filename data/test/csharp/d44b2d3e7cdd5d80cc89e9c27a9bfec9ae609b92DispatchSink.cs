using System;
using ASC.Notify.Engine;
using ASC.Notify.Messages;

namespace ASC.Notify.Sinks
{
    class DispatchSink : Sink
    {
        private readonly string senderName;
        private readonly DispatchEngine dispatcher;

        public DispatchSink(string senderName, DispatchEngine dispatcher)
        {
            if (dispatcher == null) throw new ArgumentNullException("dispatcher");
            
            this.dispatcher = dispatcher;
            this.senderName = senderName;
        }

        public override SendResponse ProcessMessage(INoticeMessage message)
        {
            return dispatcher.Dispatch(message, senderName);
        }

        public override void ProcessMessageAsync(INoticeMessage message)
        {
            dispatcher.Dispatch(message, senderName);
        }
    }
}