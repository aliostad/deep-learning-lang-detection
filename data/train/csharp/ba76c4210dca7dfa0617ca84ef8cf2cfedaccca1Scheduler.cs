using Diese.Scheduling.Controllers;

namespace Diese.Scheduling
{
    public class Scheduler<T> : SchedulerBase<Scheduler<T>.Controller, T>
    {
        protected override Controller CreateController(SchedulerGraph<T>.Vertex vertex)
        {
            return new Controller(this, vertex);
        }

        public class Controller : IRelativeController<Controller, T>, IPriorityController<Controller>
        {
            protected readonly PriorityController<Controller, T> PriorityController;
            protected readonly RelativeController<Controller, T> RelativeController;

            public Controller(SchedulerBase<Controller, T> scheduler, SchedulerGraph<T>.Vertex vertex)
            {
                PriorityController = new PriorityController<Controller,T>(scheduler, vertex);
                RelativeController = new RelativeController<Controller, T>(scheduler, vertex);
            }

            public Controller After(T item)
            {
                RelativeController.After(item);
                return this;
            }

            public Controller Before(T item)
            {
                RelativeController.Before(item);
                return this;
            }

            public Controller AtEnd()
            {
                PriorityController.AtEnd();
                return this;
            }

            public Controller AtStart()
            {
                PriorityController.AtStart();
                return this;
            }

            void IRelativeController<T>.Before(T item)
            {
                RelativeController.Before(item);
            }

            void IRelativeController<T>.After(T item)
            {
                RelativeController.After(item);
            }

            void IPriorityController.AtStart()
            {
                PriorityController.AtStart();
            }

            void IPriorityController.AtEnd()
            {
                PriorityController.AtEnd();
            }
        }
    }
}