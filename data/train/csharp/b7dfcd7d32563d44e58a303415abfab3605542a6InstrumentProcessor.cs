namespace InstrumentProcessorKata
{
    using System;

    public class InstrumentProcessor : IInstrumentProcessor, IDisposable
    {
        private bool _disposed;
        private readonly IInstrument instrument;

        private ITaskDispatcher dispatcher;

        private IConsoleWriter consoleWriter;

        public InstrumentProcessor(ITaskDispatcher taskDispatcher, IInstrument instrument, IConsoleWriter console)
        {
            this.consoleWriter = console;
            this.dispatcher = taskDispatcher;
            this.instrument = instrument;

            this.instrument.Finished += this.InstrumentOnFinished;
            this.instrument.Error += this.InstrumentOnError;
        }

        public void Process()
        {
            var task = this.dispatcher.GetTask();
            this.instrument.Execute(task);
        }

        private void InstrumentOnError(object sender, EventArgs eventArgs)
        {
            var instrumentErrorEventArgs = (InstrumentErrorEventArgs)eventArgs;
            this.consoleWriter.WriteLine(instrumentErrorEventArgs.Message);
        }

        private void InstrumentOnFinished(object sender, EventArgs eventArgs)
        {
            var instrumentFinishedEventArgs = (InstrumentFinishedEventArgs)eventArgs;
            this.dispatcher.FinishedTask(instrumentFinishedEventArgs.Task);
        }

        ~InstrumentProcessor()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (_disposed) return;

            if (disposing)
            {
                // free other managed objects that implement IDisposable only
                RemoveAllListeners();
            }


            _disposed = true;
        }

        private void RemoveAllListeners()
        {
            this.instrument.Error -= this.InstrumentOnError;
            this.instrument.Finished -= this.InstrumentOnFinished;
        }
    }
}