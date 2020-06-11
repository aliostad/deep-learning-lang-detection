using System;

namespace TestUIA.Process
{
    public sealed class Process : IProcess
    {
        private readonly System.Diagnostics.Process _process;

        public Process(System.Diagnostics.Process process)
        {
            _process = process;
            _process.Exited += ProcessOnExited;
        }

        public event EventHandler Exited = delegate { };

        public int Id
        {
            get { return _process.Id; }
        }

        public string Name
        {
            get { return _process.ProcessName; }
        }

        public bool EnableRaisingEvents
        {
            get
            {
                return _process.EnableRaisingEvents;
            }

            set
            {
                _process.EnableRaisingEvents = value;
            }
        }

        private void ProcessOnExited(object sender, EventArgs eventArgs)
        {
            Exited(this, eventArgs);
        }
    }
}