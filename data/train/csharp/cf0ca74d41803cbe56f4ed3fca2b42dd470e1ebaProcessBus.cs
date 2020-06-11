using System.Threading.Tasks;
using MyCQRS.Domain.Events;
using MyCQRS.Messaging;

namespace MyCQRS.ProcessManagers
{
    public class ProcessBus : IProcessBus
    {
        private readonly IProcessFactory _processFactory;

        private readonly ICommandBus _commandBus;

        public ProcessBus(IProcessFactory processFactory, ICommandBus commandBus)
        {
            _processFactory = processFactory;

            _commandBus = commandBus;
        }


        public async Task HandleAsync<T>(T @event) where T : Event
        {
            var process = _processFactory.Process<T>();
            if (process == null)
            {
                return;
            }
            await process.ProcessAsync(@event, _commandBus);
        }
    }
}