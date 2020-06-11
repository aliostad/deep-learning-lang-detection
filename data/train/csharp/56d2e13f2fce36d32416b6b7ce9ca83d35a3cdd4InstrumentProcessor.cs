using System;

namespace CraftsmanKata.InstrumentProcessorKata
{
    public class InstrumentProcessor : IDisposable
    {
        private readonly ITaskDispatcher taskDispatcher;
        private readonly IInstrument instrument;

        public InstrumentProcessor(ITaskDispatcher taskDispatcher, IInstrument instrument)
        {
            this.taskDispatcher = taskDispatcher;
            this.instrument = instrument;
            instrument.Error += InstrumentOnError;
            instrument.Finished += InstrumentOnFinished;
        }
        
        public void Process()
        {
            string task = taskDispatcher.GetTask();
            instrument.Execute(task);
        }

        private void InstrumentOnFinished(object sender, EventArgs taskEventArgs)
        {
             taskDispatcher.FinishedTask(((TaskEventArgs)taskEventArgs).Task);
        }

        private void InstrumentOnError(object sender, EventArgs taskEventArgs)
        {
            Console.WriteLine("Error occured"); // TODO: to be able to test this, needs to be wrapped in another mockable class
        }

        public void Dispose()
        {
            instrument.Error -= InstrumentOnError;
            instrument.Finished -= InstrumentOnFinished;
        }
    }
}