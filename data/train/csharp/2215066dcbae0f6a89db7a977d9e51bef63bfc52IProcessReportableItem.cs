using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProcessManager.Domain
{
    public interface IProcessReportableItem : IInventoryItem
    {
        ValueStream ValueStream { get; }
        //double WorkloadProcessed(Period period, Process process);
        //bool IsFinished(Period period, Process process);
        //bool IsInProcess(Period period, Process process);
        //bool IsQueued(Period period, Process process);
        //bool IsStarted(Period period, Process process);
        //bool IsFinished(Day day, Process process);
        //bool IsInProcess(Day day, Process process);
        //bool IsQueued(Day day, Process process);
        //bool IsStarted(Day day, Process process);
        //bool IsFinished(DateTime day, Process process);
        //bool IsInProcess(DateTime day, Process process);
        //bool IsQueued(DateTime day, Process process);
        //bool IsStarted(DateTime day, Process process);
    }
}
