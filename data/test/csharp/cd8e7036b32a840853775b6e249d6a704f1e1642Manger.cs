using System;
using System.Collections.Generic;

namespace kozit.System.Threading
{
    public class Manger
    {

        static List<Process> ProcessPool = new List<Process>();
        
        public static void Tick()
        {
            foreach (Process p in ProcessPool)
            {
                if (p.State == ProcessState.Aborted)
                {
                    ProcessPool.Remove(p);
                }
                else if (p.State == ProcessState.Running)
                {
                    p.Tick();
                }

            }
        }

        public static void StartProcess(Process p)
        {
            if (GetProcess(p.Name) == null)
            {

                ProcessPool.Add(p);
            }
        }

        public static Process GetProcess(int PID)
        {
            Process r = null;

            foreach (Process p in ProcessPool)
            {
                if (p.PID == PID)
                {
                    r = p;
                    break;
                }
            }
            return r;
        }

        public static Process GetProcess(string Name)
        {
            Process r = null;


            foreach (Process p in ProcessPool)
            {
                if (p.Name == Name)
                {
                    r = p;
                    break;
                }
            }
            
            return r;
        }

    }
}
