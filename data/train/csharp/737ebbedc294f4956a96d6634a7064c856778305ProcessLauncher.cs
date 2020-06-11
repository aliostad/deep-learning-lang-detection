using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace NinoJS.Resources
{
    public class ProcessLauncher
    {
        public void Start(string path)
        {
            Process process = new Process();
            ProcessStartInfo info = new ProcessStartInfo(path);
            process.StartInfo = info;
            process.Start();
        }
        public void Start(string path, string argument)
        {
            Process process = new Process();
            ProcessStartInfo info = new ProcessStartInfo(path);
            info.Arguments = argument;
            process.StartInfo = info;
            process.Start(); ;
        }
    }
}
