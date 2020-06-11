using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace XNATest
{
    public class ProcessQueue
    {
        public void Add(Process process)
        {
            _processQueue.Add(process);
        }

        public void Update(float elapsed)
        {
            if (_processQueue.Count > 0)
            {
                _processQueue[0].Update(elapsed);
                if (_processQueue[0].Finished)
                {
                    _processQueue.RemoveAt(0);
                }
            }
        }

        private readonly List<Process> _processQueue = new List<Process>();
    }
}
