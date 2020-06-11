using Common.ProcessExecution.Abstraction;
using Common.ProcessExecution.Model;

namespace Common.ProcessExecution
{
    public class LongRunningExecutor : ILongRunningExecutor
    {
        private IOutputProcessExecutor _executor;
        private readonly IProcessFactory _processFactory;
        private readonly ProcessInstructions _instructions;

        public string Output => _executor.Output;

        public LongRunningExecutor(IProcessFactory processFactory, IOutputProcessExecutor outputProcessExecutor)
        {
            _processFactory = processFactory;
            _executor = outputProcessExecutor;
        }

        public void Execute(string program, string arguments)
        {
            var instructions = new ProcessInstructions
            {
                Program = program,
                Arguments = arguments
            };

            if (_executor.ProcessInstance == null)
                _executor.ProcessInstance = _processFactory.Create(instructions);
                
            _executor.Execute();
        }

        public void Dispose()
        {
            if (_executor.ProcessInstance != null)
            {
                _executor.ProcessInstance.Kill();
                _executor.ProcessInstance.Dispose();
            }
        }
    }
}