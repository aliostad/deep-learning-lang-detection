using ProcessManager.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkItemHistory.DataCollection.LeadTime
{
    public class WeekRecord
    {
        public WeekRecord(int week)
        {
            this.Week = week;
        }

        public WeekRecord(int week, IEnumerable<ProcessAmount> processAmounts)
        {
            this.Week = week;
            this.AddProcessAmountCollection(processAmounts);
        }

        public int Week { get; set; }

        private List<ProcessAmount> _processAmounts;
        public List<ProcessAmount> ProcessAmounts
        {
            get
            {
                if (_processAmounts == null)
                    _processAmounts = new List<ProcessAmount>();
                return _processAmounts;
            }
        }

        public void AddProcessAmount(ProcessAmount processAmount)
        {
            this.ProcessAmounts.Add(processAmount);
        }

        public void AddProcessAmountCollection(IEnumerable<ProcessAmount> processAmounts)
        {
            this.ProcessAmounts.AddRange(processAmounts);
        }

    }

    public class ProcessAmount
    {
        public ProcessAmount(Process process, int amount, bool isEndProcess, InOut amountInOrOut)
        {
            this.Process = process;
            this.Amount = amount;
            this.IsEndProcess = isEndProcess;
            this.AmountIsInOrOut = amountInOrOut;
        }

        /// <summary>
        /// ctor for non-end process
        /// </summary>
        /// <param name="process"></param>
        /// <param name="amount"></param>
        public ProcessAmount(Process process, int amount)
            :this(process, amount, false, InOut.In)
        {}

        public bool IsEndProcess { get; set; }
        public Process Process { get; set; }
        public int Amount { get; set; }
        /// <summary>
        /// Did the amount enter (In) or leave (Out) the process this week
        /// </summary>
        public InOut AmountIsInOrOut { get; set; }
    }

    public enum InOut
    {
        In,
        Out
    }
}
