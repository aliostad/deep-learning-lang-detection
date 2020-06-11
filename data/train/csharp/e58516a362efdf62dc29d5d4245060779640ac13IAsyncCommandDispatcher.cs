using System.Threading.Tasks;

namespace Cheers.Cqrs.Write
{
    /// <summary>
    /// Define an asynchronous command dispatcher
    /// </summary>
    public interface IAsyncCommandDispatcher
    {
        /// <summary>
        /// Dispatch a command asynchronously.
        /// </summary>
        /// <param name="command">Command to dispatch</param>
        /// <returns>Result</returns>
        Task<TResult> Dispatch<TCommand, TResult>(TCommand command)
            where TCommand : ICommand;

        /// <summary>
        /// Dispatch a command asynchronously.
        /// </summary>
        /// <param name="command">Command to dispatch</param>
        Task Dispatch<TCommand>(TCommand command)
            where TCommand : ICommand;
    }
}

