using System;

namespace InstrumentProcessorKata
{
    public class InstrumentProcessor
    {
        private readonly ITaskDispatcher _taskDispatcher;
        private readonly IInstrument _instrument;

        public InstrumentProcessor(ITaskDispatcher taskDispatcher, IInstrument instrument)
        {
            _taskDispatcher = taskDispatcher;
            _instrument = instrument;
            _instrument.Finished += (EventHandler) ((sender, args) =>
            {
                var processedTask = args as TaskEventArgs;
                _taskDispatcher.FinishedTask(processedTask.Task);
            });
        }

        public void Process()
        {
            var task = _taskDispatcher.GetTask();
            _instrument.Execute(task);
        }
    }

    public class TaskEventArgs : EventArgs
    {
        private TaskEventArgs() {}

        public TaskEventArgs(string task)
        {
            Task = task;
        }

        public string Task { get; private set; }
    }
}