using System.Threading;
using System.Threading.Tasks;

namespace SharperArchitecture.Common.Commands
{
    public interface ICommandDispatcher
    {
        void Dispatch(ICommand command);

        TResult Dispatch<TResult>(ICommand<TResult> command);

        Task DispatchAsync(IAsyncCommand command);

        Task<TResult> DispatchAsync<TResult>(IAsyncCommand<TResult> command);

        Task DispatchAsync(IAsyncCommand command, CancellationToken cancellationToken);

        Task<TResult> DispatchAsync<TResult>(IAsyncCommand<TResult> command, CancellationToken cancellationToken);
    }
}
