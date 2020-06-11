using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Controller.Processes
{
    class ProcessWatcher
    {
        //Default tick interval.
        private static readonly TimeSpan _defaultInterval = TimeSpan.FromMilliseconds(1000);
        //The name of the process to scan for.
        private readonly string _processName;
        //The timer to continuously scan.
        private Timer _processTimer;
        //The list of found processes.
        private List<Process> _processList;

        //Delegates for the process-related events.
        public delegate void NewProcessDelegate(Process process);
        public delegate void ClosedProcessDelegate(Process process);

        //Triggers when a new process is found.
        public event NewProcessDelegate NewProcess;
        //Triggers when an existing found process has closed.
        public event ClosedProcessDelegate ClosedProcess;

        public ProcessWatcher(string processName, TimeSpan interval)
        {
            this._processName = processName;
            this._processList = new List<Process>();
            this._processTimer = new Timer();
            this._processTimer.Interval = (int)interval.TotalMilliseconds;
            this._processTimer.Tick += _processTimer_Tick;
        }

        public ProcessWatcher(string processName) :
            this(processName, _defaultInterval)
        {
        }

        //Start watching the processes.
        public void Start()
        {
            //Initial call since timer waits the interval first
            //before calling.
            this.ScanProcesses();
            this._processTimer.Start();
        }

        //Stop watching the processes.
        public void Stop()
        {
            this._processTimer.Stop();
        }

        //The interval between each scan.
        public TimeSpan Interval
        {
            get { return TimeSpan.FromMilliseconds(this._processTimer.Interval); }
            set { this._processTimer.Interval = (int)value.TotalMilliseconds; }
        }

        private void _processTimer_Tick(object sender, EventArgs e)
        {
            this.ScanProcesses();
        }

        //Scan for specified processes that are either newly opened
        //or closed since the last scan.
        private void ScanProcesses()
        {
            //Grab a list of all processes based on the process name passed in.
            Process[] processes = Process.GetProcessesByName(this._processName);

            //Look for new processes.
            foreach (Process process in processes)
            {
                //New process found if not in the list.
                if (!this.ProcessExists(process))
                {
                    //Trigger NewProcess event.
                    this.NewProcess?.Invoke(process);

                    //Add new process to the list.
                    this._processList.Add(process);
                }
            }

            //Look for closed processes.
            for (int i = 0; i < this._processList.Count; i++)
            {
                Process process = this._processList[i];

                //Proccess not found.
                if (!this.ProcessExists(processes, process))
                {
                    //Trigger ClosedProcess event.
                    this.ClosedProcess?.Invoke(process);

                    //Remove process from the list.
                    this._processList.RemoveAt(i);
                    i--;
                }
            }
        }

        //Check if a process exists in the process list.
        private bool ProcessExists(Process process)
        {
            //Compare by unique Id.
            foreach (Process p in this._processList)
            {
                if (p.Id == process.Id) { return true; }
            }

            return false;
        }

        //Check if a process exists in the collection passed in.
        private bool ProcessExists(Process[] collection, Process process)
        {
            //Compare by unique Id.
            foreach (Process p in collection)
            {
                if (p.Id == process.Id) { return true; }
            }

            return false;
        }
    }
}
