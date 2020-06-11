using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Windows.Forms;  

namespace SCCM_Client_Repair
{
    class ProcessManager
    {

        public static void StartProcess(string filename, string args) {

            Process process = new Process();
            ProcessStartInfo processStartInfo = new ProcessStartInfo();
            processStartInfo.FileName = filename; 
            processStartInfo.Arguments = args;          
            processStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            process.StartInfo = processStartInfo;
            process.Start();            
            process.WaitForExit(300000);
            process.Dispose();
            
             
        
        }

        public static string CheckProcess(Array processList) {

            foreach (string process in processList) {
                if (Process.GetProcessesByName(process).Length > 0) {
                    return process; 
                }
            
            }

            return ""; 

        }


        public static void KillProcess(string processName)
        {

            try
            {
                Process[] proc = Process.GetProcessesByName(processName);
                proc[0].Kill();
            }

            catch { }

        }




    }
}
