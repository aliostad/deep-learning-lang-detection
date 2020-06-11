using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tester.Exceptions; 
using Tester.Strings;
using WinApi.Kernel32; 

namespace Tester
{
    public class Applications
    {

        private List<Process> process = new List<Process>();

        
        public Applications(int processID)
        {

            IntPtr handle = Kernel32Functions.OpenProcess(0x400 | 0x010, false, Convert.ToUInt32(processID));

            if(handle != IntPtr.Zero && handle != null)
            {
                this.process.Add(new Process(handle)); 

            }
            else
            {
                throw new ProcessNotFoundException(ErrorMessages.CouldNotFindPid); 
            }
        }
        public Applications(string processName)
        {
            System.Diagnostics.Process[] proc = System.Diagnostics.Process.GetProcessesByName(processName);

            if (proc == null || proc.Length == 0)
                throw new ProcessNotFoundException(ErrorMessages.CouldNotFindProcessName);
            else
            {
                for(int x = 0; x < proc.Length; x++)
                {
                    this.process.Add(new Process(proc[x])); 
                }
            }
        }

        public Applications(string processName, string description)
        {
            System.Diagnostics.Process[] proc = System.Diagnostics.Process.GetProcessesByName(processName);

            if (proc == null || proc.Length == 0)
                throw new ProcessNotFoundException(ErrorMessages.CouldNotFindProcessName);
            else
            {
                for (int x = 0; x < proc.Length; x++)
                {
                    Process tempProcess = new Process(proc[x]); 

                    if(tempProcess.processDescription.Contains(description))
                    {
                        this.process.Add(new Process(proc[x]));
                    }
                }
            }
        }

        #region get/set 

        public List<Process> VisibleProcesses
        {
            get
            {
                if(process.Count > 0)
                {
                    List<Process> lstProcess = new List<Process>(); 
                    foreach(Process proc in process)
                    {
                        if(proc.visibleWindows.Count > 0)
                        {
                            lstProcess.Add(proc); 
                        }
                    }
                    return lstProcess; 
                }
                return new List<Process>();
            }
        }

        public List<Process> Processes
        {
            get
            {
                if (process.Count > 0)
                    return process;

                return new List<Process>(); 
            }
        }

        #endregion

       

        //TODO : Startup application. 


    }
}
