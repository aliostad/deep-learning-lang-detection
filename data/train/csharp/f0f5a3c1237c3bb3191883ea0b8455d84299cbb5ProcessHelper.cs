using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace Utility
{
   public  class ProcessHelper
    {
       public static void CloseProcess(string processName)
       {
           Process[] processes = Process.GetProcessesByName(processName);

           foreach (Process p in processes)
           {
               p.CloseMainWindow();
               p.Kill();
           }
       }

       public static  void CloseProcess(int processId)
       {
            try
            {
                Process processes = Process.GetProcessById(processId);

                if (processes != null)
                {
                    processes.CloseMainWindow();
                    processes.Kill();
                }
            }
            catch(ArgumentException)
            {

            }
       }


       public static List<int> GetRunningProcessIds(string processName)
       {
           var processId = new List<int>();
           var processes = Process.GetProcessesByName(processName);

           foreach (Process p in processes)
           {
               processId.Add(p.Id);
           }

           return processId;
       }

       public static int GetNewProcessStarted(List<int> processIds, string processName)
       {
           var processes = Process.GetProcessesByName(processName);

           foreach (Process p in processes)
           {
               if (!processIds.Contains(p.Id))
               {
                   return p.Id;
               }
           }

           return -1;
       }
    }
}
