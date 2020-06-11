using System.Collections.Generic;
using System.Diagnostics;

namespace LogObserver.Interface.Services.ProcessCache
{
    public class ProcessCache : IProcessCache
    {
        private readonly Dictionary<long, ProcessModel> _processCache = new Dictionary<long, ProcessModel>();

        public ProcessModel GetProcess(long pid)
        {
            if (0 == pid)
            {
                return null;
            }

            lock (_processCache)
            {
                if (!_processCache.ContainsKey(pid))
                {
                    _processCache.Clear();

                    foreach (var actualProcess in Process.GetProcesses())
                    {
                        _processCache[actualProcess.Id] = new ProcessModel(actualProcess);
                        actualProcess.Dispose();
                    }
                }

                return _processCache.ContainsKey(pid) ? _processCache[pid] : null;
            }
        }
    }
}