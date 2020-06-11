using FireOnWheels.Dispatch.Helper;
using FireOnWheels.Messages;
using NServiceBus;
using NServiceBus.Logging;

namespace FireOnWheels.Dispatch
{
    public class DispatchOrderHandler:IHandleMessages<DispatchOrderCommand>
    {
        private readonly IBus bus;

        public DispatchOrderHandler(IBus bus)
        {
            this.bus = bus;
        }

        private static readonly ILog Logger = 
            LogManager.GetLogger(typeof(DispatchOrderHandler));
        public void Handle(DispatchOrderCommand order)
        {
            Logger.InfoFormat("----------------->Order dispatched to address: {0}", order.AddressTo);
            //EmailSender.SendEmailToDispatch(order);
            bus.Reply<IOrderDispatchedMessage>(e => {});
        }
    }
}
