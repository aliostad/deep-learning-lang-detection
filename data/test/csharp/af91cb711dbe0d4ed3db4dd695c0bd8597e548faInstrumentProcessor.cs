namespace KataInstrumentProcessor
{
    using System;
    using System.Collections.Generic;

    public class InstrumentProcessor : IInstrumentProcessor
    {
        #region 

        private IInstrument instrument;

        private ITaskDispatcher taskDispatcher;

        private Queue<string> currentTasks = new Queue<string>();

        private IConsole console;

        #endregion

        public InstrumentProcessor(IInstrument instrument, ITaskDispatcher taskDispatcher, IConsole console)
        {
            this.instrument = instrument;
            this.taskDispatcher = taskDispatcher;
            this.console = console;

            this.instrument.Finished += (sender, args) =>
                {
                    this.taskDispatcher.FinishedTask(currentTasks.Dequeue());
                };

            this.instrument.Error += (sender, args) =>
                { this.console.WriteLine(currentTasks.Dequeue()); };
        }

        public void Process()
        {
            var task = this.taskDispatcher.GetTask();
            this.currentTasks.Enqueue(task);
            this.instrument.Execute(task);
        }
    }
}