using NEventStore;
using NEventStore.Dispatcher;

namespace Inceptum.Cqrs.EventSourcing
{
    public static class DispatchSchedulerWireupExtensions
    {
        public static DispatchSchedulerWireup UsingDispatchScheduler(this Wireup wireup)
        {
            return wireup.UsingDispatchScheduler(null);
        }

        public static DispatchSchedulerWireup UsingDispatchScheduler(this Wireup wireup, IDispatchCommits dispatcher)
        {
            return new DispatchSchedulerWireup(wireup, dispatcher);
        }
    }
}