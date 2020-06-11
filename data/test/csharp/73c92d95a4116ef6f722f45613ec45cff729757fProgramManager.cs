using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace RamTector
{
    class ProgramManager
    {
        ProcessCalculator processCalc;
        bool showCpu = false;
        public ProgramManager()
        {
            processCalc = new ProcessCalculator();
            processCalc.RefreshTime = new TimeSpan(0, 0, 0, 2, 0);
            processCalc.AddProcess("Skype", true);
            processCalc.AddProcess("ramtector");
            processCalc.AddProcess("steam");
            processCalc.AddProcess("Firefox");
            processCalc.AddProcess("Notepad");
            processCalc.AddProcess("Microsoft.StickyNotes");
            processCalc.AddProcess("Calculator");
            processCalc.AddProcess("MSIAfterBurner");
            processCalc.AddProcess("Taskmgr");
            processCalc.AddProcess("Ressource Monitor");
            processCalc.AddProcess("powershell");
            processCalc.AddProcess("skype");
            processCalc.AddProcess("Windows Explorer");
            processCalc.AddProcess("texstudio");
            processCalc.AddProcess("Discord");
            processCalc.AddProcess("devenv");
            processCalc.AddProcess("TeamViewer");
            processCalc.AddProcess("Chrome");
            processCalc.AddProcess("EthDcrMiner64");
        }

        public void MainLoop()
        {
            while (true)
            {
                processCalc.UpdateWatchedProcesses();
                PrintResults(processCalc.WatchedProcesses);
                Thread.Sleep(processCalc.RefreshTime);
            }
        }
        private void PrintResults(Dictionary<string, WachtedProcess> dict)
        {
            Console.Clear();
            foreach (var item in dict)
            {
                Console.WriteLine($"{item.Key} Ram: {item.Value.Memory.MemValue} {item.Value.Memory.Prefix} {(this.showCpu ? $"CPU: {Math.Round(item.Value.CpuPercent, 2)}": "")} {(item.Value.Grouped ? $"Group Size {item.Value.GroupCount}" : "")}");
            }
            Console.WriteLine($"{(this.showCpu ? $"\n\nTotal Cpu: {processCalc.TotalCpuUtilization} \nNotice: Cpu Values are work in progress and may never be added correctly to the project" : "" )}");
            
        }
    }
}
