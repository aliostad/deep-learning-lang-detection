using System;

namespace AutoProcessor
{
    public class Processor
    {
        private Process _headProcess;

        public Processor(Process headProcess)
        {
            _headProcess = headProcess;
        }

        public void Start()
        {
            if (_headProcess == null)
                throw new ArgumentNullException("Head process is null");

            var currentProcess = _headProcess;

            while (currentProcess != null)
            {
                currentProcess.Start();

                currentProcess = currentProcess.NextProcess;
            }
        }
    }
}
