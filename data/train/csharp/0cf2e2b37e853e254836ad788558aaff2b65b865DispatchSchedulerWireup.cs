using System;
using NEventStore;
using NEventStore.Dispatcher;
using NEventStore.Persistence;

namespace Inceptum.Cqrs.EventSourcing
{
    public class DispatchSchedulerWireup : Wireup
    {
        public DispatchSchedulerWireup(Wireup wireup, IDispatchCommits dispatcher)
            : base(wireup)
        {
            DispatchTo(dispatcher ?? new NullDispatcher());
            Container.Register<IScheduleDispatches>(c => new DispatchScheduler(c.Resolve<IDispatchCommits>(), c.Resolve<IPersistStreams>()));
        }

        public DispatchSchedulerWireup DispatchTo(IDispatchCommits instance)
        {
            Container.Register(instance);
            return this;
        }

        internal Action GetDispatchScheduler()
        {
            return () => ((DispatchScheduler)Container.Resolve<IScheduleDispatches>()).Initialize();
        }

        
    }
}