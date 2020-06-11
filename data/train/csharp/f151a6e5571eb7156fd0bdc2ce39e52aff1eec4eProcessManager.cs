using System.Collections.Generic;

namespace Vienna.Processes
{
    public class ProcessManager
    {
        protected List<Process> ProcessList;

        public ProcessManager()
        {
            ProcessList = new List<Process>();
        }

        public ProcessCounter UpdateProcesses(long delta)
	    {
            var counter = new ProcessCounter();

            for (var i = 0; i < ProcessList.Count; i++)
            {
                var process = ProcessList[i];

                // process is uninitialized, so initialize it
                if (process.State == ProcessState.Uninitialized)
                    process.OnInit();

                // give the process an update tick if it's running
                if (process.State == ProcessState.Running)
                    process.OnUpdate(delta);

                // check to see if the process is dead
                if (process.IsDead)
                {
                    HandleDeadProcess(process, ref counter);
                }          
            }

	        return counter;
	    }

	    public void AttachProcess(Process process)
        {
            ProcessList.Add(process);
        }

        public void AbortAllProcesses(bool immediate)
        {
            for (var i = 0; i < ProcessList.Count; i++)
            {
                var process = ProcessList[i];
                if (!process.IsAlive) continue;

                process.State = ProcessState.Aborted;
                
                if (!immediate) continue;
                process.OnAbort();
                ProcessList.Remove(process);
            }
        }

        public int Count
        {
            get { return ProcessList.Count; }
        }

        public void Clear()
        {
            ProcessList.Clear();
        }

        private void HandleDeadProcess(Process process, ref ProcessCounter counter)
        {
            var successCount = 0;
            var failCount = 0;

            // run the appropriate exit function
            switch (process.State)
            {
                case ProcessState.Succeeded:
                    process.OnSuccess();
                    var child = process.RemoveChild();
                    if (child != null)
                        AttachProcess(child);
                    else
                        ++successCount; // only counts if the whole chain completed
                    break;

                case ProcessState.Failed:
                    process.OnFail();
                    ++failCount;
                    break;

                case ProcessState.Aborted:
                    process.OnAbort();
                    ++failCount;
                    break;

            }

            // remove the process and destroy it
            process.Destroy();
            ProcessList.Remove(process);

            counter.Fail += failCount;
            counter.Success += successCount;
        }
    }
}