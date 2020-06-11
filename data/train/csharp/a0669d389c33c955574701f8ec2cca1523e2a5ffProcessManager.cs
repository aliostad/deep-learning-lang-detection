using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.ComponentModel;
using System.Threading;
using System.Windows.Threading;
using System.Windows.Data;

namespace ProcessShutdownTimer
{
    public class ProcessManager
    {
        public ObservableCollection<ProcessContainer> ProcessList
        {
            get { return processList; }
            set { processList = value; }
        }
        public ObservableCollection<ProcessContainer> ScheduledList
        {
            get { return scheduledList; }
            set { scheduledList = value; }
        }
        public CollectionView ProcessView;
        public CollectionView ScheduledView;

        ObservableCollection<ProcessContainer> processList;
        ObservableCollection<ProcessContainer> scheduledList;
        

        public ProcessManager()
        {
            processList = new ObservableCollection<ProcessContainer>();
            scheduledList = new ObservableCollection<ProcessContainer>();
            RefreshProcessList();
        }

        public void RefreshProcessList()
        {
            foreach (Process process in Process.GetProcesses())
            {
                if (!processList.Any(p => p.Id == process.Id))
                {
                    processList.Add(new ProcessContainer(process.ProcessName, (int)(process.WorkingSet64 / 1024), process.Id));
                }
            }
        }

        public void ScheduleShutdown(IList processes, DateTime time)
        {

            foreach (ProcessContainer process in processes)
            {
                SetTimer(process, time);
            }

            ProcessView.Refresh();
        }

        public bool RemoveProcess(ProcessContainer processToRemove)
        {
            //Process.GetProcessById(Id).Kill();
            if (Process.GetProcessById(processToRemove.Id).ProcessName == processToRemove.ProcessName)
            {
                processList.Remove(processToRemove);
            }
            return true;
        }



        private void SetTimer(ProcessContainer process, DateTime time)
        {
            DispatcherTimer timer = new DispatcherTimer();
            timer.Tick += HandleTick;
            timer.Interval = time - DateTime.Now < TimeSpan.FromSeconds(1) ? TimeSpan.FromSeconds(1) : time - DateTime.Now;
            timer.Tag = process;
            timer.Start();
            scheduledList.Add(process);
            process.IsScheduled = true;
        }

        private void HandleTick(object sender, EventArgs e)
        {
            DispatcherTimer timer = sender as DispatcherTimer;
            ProcessContainer process = timer.Tag as ProcessContainer;
            if (timer != null && process != null)
            {
                timer.Stop();
                processList.Remove(process);
                scheduledList.Remove(process);
                Process.GetProcessById(process.Id).Kill();
            }
        }
    }
}
