using System;
using Common.Logging;

namespace Dispatch.Core
{
    public class DispatchApplicationService
    {
        private readonly DispatchStorage _storage;
        private readonly Action<OrderDispatchedEvent> _onDispatched;
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        public DispatchApplicationService(DispatchStorage storage, Action<OrderDispatchedEvent> onDispatched)
        {
            _storage = storage;
            _onDispatched = onDispatched;
        }

        public void Handle(DispatchOrderCommand command)
        {
            Log.InfoFormat("Dispatching Order {0}", command.Order.OrderId);
            var dispatchTime = DateTime.UtcNow;
            var done = command.Order.Dispatched(dispatchTime);
            _storage.OrderDispatched(done, dispatchTime);
            var e = new OrderDispatchedEvent(done);
            _onDispatched(e);
        }
    }
}