using System;
using System.Collections.Generic;

namespace Processor
{
    public class  Processor
    {
        private bool _wasError = false;

        public void DoProcess(List<IProcess> processList)
        {
            foreach (var proc in processList)
                Process(proc);
        }

        private void Process (IProcess process)
        {
            if (_wasError && !process.AlwaysProcess)
                return;
            try
            {
                process.ToProcess();
            }
            catch (Exception e)
            {
                _wasError = true;
            }
        }
    }

    public interface IProcess
    {
        void ToProcess();
        bool AlwaysProcess { get; set; }
    }
}
