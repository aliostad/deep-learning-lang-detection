using System;
using System.Diagnostics;
using System.Linq;
using DFWin.Core.Constants;

namespace DFWin.Core.Services
{
    public interface IProcessService
    {
        Process GetCurrentProcess();
        bool TryGetDwarfFortressProcess(out Process process);
        bool IsDwarfFortressAvailable();
    }

    public class ProcessService : IProcessService
    {
        public Process GetCurrentProcess()
        {
            return Process.GetCurrentProcess();
        }

        public bool TryGetDwarfFortressProcess(out Process process)
        {
            try
            {
                process = Process.GetProcessesByName(Names.DwarfFortressProcess).FirstOrDefault();
                return process != null;
            }
            catch (Exception e)
            {
                DfWin.Warn("Unable to get Dwarf Fortress process: " + e);
                process = null;
                return false;
            }
        }

        public bool IsDwarfFortressAvailable()
        {
            return TryGetDwarfFortressProcess(out Process process);
        }
    }
}
