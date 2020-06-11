using ProcessUsage.Helpers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace ProcessUsage.Services
{
    public class ProcessWatcher
    {
        readonly int _checkInterval;
        Timer _timer;

        Process _previousProcess;
        Process _currentProcess;

        public ProcessWatcher(int checkInterval, Action<Process,Process> onWorkingProcessChanchged):
            this(checkInterval)
        {
            if (onWorkingProcessChanchged == null)
            {
                throw new ArgumentNullException("onWorkingProcessChanchged");
            }

            WorkingProcessChanged += new WorkingProcessChangedHandler(onWorkingProcessChanchged);
        }

        public ProcessWatcher(int checkInterval)
        {
            this._checkInterval = checkInterval;
            _timer = new Timer(_checkInterval);
            _timer.Elapsed+=OnTimerElapsed;
        }

        void OnTimerElapsed(object sender, ElapsedEventArgs e)
        {
            var newProcess = ProcessHelper.GetCurrentUserWorkingProcess();
            if (_currentProcess == null
                || newProcess.ProcessName != _currentProcess.ProcessName
                || newProcess.MainWindowTitle != _currentProcess.MainWindowTitle)
            {
                _previousProcess = _currentProcess;
                _currentProcess = newProcess;
                if (WorkingProcessChanged != null)
                {
                    WorkingProcessChanged(_previousProcess, _currentProcess);
                }
            }
        }

        public delegate void WorkingProcessChangedHandler(Process previousWotrkingProcess, Process currentWorkingProcess);
        public event WorkingProcessChangedHandler WorkingProcessChanged;

        public void Start()
        {
            _timer.Start();
        }

        public void Stop()
        {
            _timer.Stop();
        }

        public bool IsRunning { get { return _timer.Enabled; } }
    }
}
