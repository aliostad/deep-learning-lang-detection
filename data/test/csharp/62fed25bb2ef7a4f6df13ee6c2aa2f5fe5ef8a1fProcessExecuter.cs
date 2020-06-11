using System.Collections.Generic;

namespace ProcessStateMachineStub
{
    public class ProcessExecuter : ProcessExecuterBase
    {
        private readonly ReadyState _readyState;

        public ProcessExecuter(ReadyState readyState)
        {
            _readyState = readyState;
        }

        public override void Execute(Process process)
        {
            var state = process.ProcessState ?? _readyState;
            state.Execute(process);

            foreach (var childProcess in process.Children ?? new List<Process>())
            {
                Execute(childProcess);
            }
        }
    }
}