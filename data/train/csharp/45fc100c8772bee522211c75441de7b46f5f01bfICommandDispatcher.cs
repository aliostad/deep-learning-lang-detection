namespace Cheers.Cqrs.Write
{
    /// <summary>
    /// Define a command dispatcher
    /// </summary>
    public interface ICommandDispatcher
    {
        /// <summary>
        /// Dispatch a command
        /// </summary>
        /// <param name="command">Command to dispatch</param>
        /// <returns>Result</returns>
        TResult Dispatch<TCommand, TResult>(TCommand command)
            where TCommand : ICommand;

        /// <summary>
        /// Dispatch the specified command.
        /// </summary>
        /// <param name="command">Command.</param>
        void Dispatch<TCommand>(TCommand command) 
            where TCommand : ICommand;
    }
}

