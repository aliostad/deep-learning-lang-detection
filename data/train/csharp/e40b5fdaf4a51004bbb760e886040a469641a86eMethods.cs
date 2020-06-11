using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Threading;

namespace Taskkill.Models
{
    public class Methods
    {
        public void GetProcessList(ObservableCollection<Process> processList)
        {
            Process[] processes = Process.GetProcesses();
            List<Process> guiProcesses = new List<Process>();
            foreach (Process process in processes)
            {
                if (process.MainWindowHandle.ToInt32() > 0)
                    guiProcesses.Add(process);
            }
            if (guiProcesses.Count != processList.Count)
            {
                processList.Clear();
                foreach (Process process in processes)
                {
                    if (process.MainWindowHandle.ToInt32() > 0)
                    {
                        processList.Add(process);
                    }
                }
            }
        }

        public void KillSelectedTask(Process process)
        {
            process.Kill();
        }

        public void KillAllTasks(ObservableCollection<Process> processList )
        {
            foreach (Process process in processList)
            {
                if (process.MainWindowTitle != "Taskkill")
                    process.Kill();
            }
        }
    }
}
