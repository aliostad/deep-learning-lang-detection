using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using ProcessKiller;
using System.IO;

namespace ProcessServiceWorker
{
    public class ProcessWorker
    {
        public static Action<string> LogEvent;
        public static List<string> stopped_processes = new List<string>();

        private static void Log(string message)
        {
            if (null != LogEvent)
            {
                LogEvent(message);
            }
        }

        public static void StopProcess(string process)
        {
            Process[] prc = null;
            Log("Ищем процессы");
            prc = System.Diagnostics.Process.GetProcesses();
            Log("Всего нашли "+ prc.Count());
            Log("Ищем процесс " + process);
            prc = System.Diagnostics.Process.GetProcessesByName(process);
            Log("Всего нашли " + prc.Count());

            if (prc!=null){
                Log("Начинаем вырубать " + prc.Count() + " " + process);
                prc.ToList<Process>().ForEach(a =>
                {
                    try
                    {
                        string name=a.ProcessName;
                        a.Kill();
                        Log("Process Stopped: " + name);
                        File.AppendAllText(Program.successPath, "1");
                        //stopped_processes.Add(a.MainModule.FileName);
                    }
                    catch (Exception ex)
                    {
                        Log("Process Stopped Error: " + a.ProcessName + "Error: " + ex.Message);
                       // throw new Exception(ex.Message);
                    }
                });
            }
        }

        public static void StopProcess(List<string> process)
        {
            process.ForEach(a => StopProcess(a));
        }

        public static void StartProcess(string process_name)
        {

            Process process = null;
            try
            {
                process = new Process();
                process.StartInfo.FileName = process_name;
                //process.StartInfo.pa
                process.StartInfo.CreateNoWindow = false;
                process.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
                process.StartInfo.UseShellExecute = false;
                process.Start();
                Log("Process Started: " + process_name);
            }
            catch (Exception ex)
            {
                Log("Process Started Error: " + process_name + " Error: " + ex.Message);
                throw new Exception(ex.Message);
            }
        }

        public static void StartProcess(List<string> process)
        {
            process.ForEach(a => StartProcess(a));
        }
    }
}
