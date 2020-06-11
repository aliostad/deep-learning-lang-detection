using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CPU_Scheduling_Simulator
{
    public class CPU
    {
        private List<Process> allCPUProcesses;
        private List<Process> fifoSched;
        private List<Process> rrSched;
        private List<Process> normalSched;
        private Process runningProcess;
        private int currentCycle;

        public Process RunningProcess { get { return runningProcess;  } }
        public int TimeQuantum { get; set; }
        public int CurrentCycle { get { return currentCycle; } }
        public bool IsFinished 
        {
            get
            {
                foreach (Process iProcess in allCPUProcesses)
                {
                    if(!iProcess.Status.Equals(ProcessStatus.Finished))
                    {
                        return false;
                    }
                }

                return true;
            }
        }
        public Process[] FifoSched
        {
            get
            {
                return fifoSched.ToArray();
            }
        }
        public Process[] RRSched
        {
            get
            {
                return rrSched.ToArray();
            }
        }
        public Process[] NormalSched
        {
            get
            {
                return normalSched.ToArray();
            }
        }
        public double AvgTA
        {
            get
            {                
                int sum = 0;
                foreach (Process iProcess in allCPUProcesses)
                {
                    sum += iProcess.TurnaroundTime;
                }

                return sum / allCPUProcesses.Count;
            }
        }
        public double AvgWT
        {
            get
            {
                int sum = 0;
                foreach (Process iProcess in allCPUProcesses)
                {
                    sum += iProcess.WaitingTime;
                }

                return sum / allCPUProcesses.Count;
            }
        }
        public double AvgRT
        {
            get
            {
                int sum = 0;
                foreach (Process iProcess in allCPUProcesses)
                {
                    sum += iProcess.ResponseTime;
                }

                return sum / allCPUProcesses.Count;
            }
        }

        public CPU(List<Process> initialJobs, int timeQuantum)
        {
            this.currentCycle = 0;
            this.TimeQuantum = timeQuantum;
            this.allCPUProcesses = initialJobs;
            this.runningProcess = Process.Empty;
            fifoSched = new List<Process>();
            rrSched = new List<Process>();
            normalSched = new List<Process>();
            
            foreach(Process iProcess in allCPUProcesses)
            {
                switch (iProcess.Type)
                {
                    case ProcessType.N:
                        normalSched.Add(iProcess);
                        break;
                    case ProcessType.PR:
                        rrSched.Add(iProcess);
                        break;
                    case ProcessType.NPR:
                        fifoSched.Add(iProcess);
                        break;
                }

                iProcess.TimeElapsed = currentCycle;
            }

            normalSched.Sort(CompareProcessCycle);
        }

        public void Reset()
        {
            currentCycle = 0;
            this.runningProcess = Process.Empty;
            foreach (Process iProcess in allCPUProcesses)
            {
                iProcess.Reset();
            }
            normalSched.Sort(CompareProcessCycle);
        }

        public void EditProcess(int jobNumber, int CPUCycle)
        {
            if(allCPUProcesses[jobNumber].Type.Equals(ProcessType.N))
            {
                normalSched.Sort(CompareProcessCycle);
            }
        }

        public void RunNextCycle()
        {            
            SetNextRunningProcess();
            this.runningProcess.Update(currentCycle);
            this.currentCycle++;

            if (this.IsFinished)
            {
                this.currentCycle--;
            }
        }

        private void SetNextRunningProcess()
        {            
            bool fifoProcessFound = false, rrProcessFound = false, normalProcessFound = false;
            Process processCanidate = Process.Empty;

            foreach (Process iProcess in allCPUProcesses)
            {
                iProcess.TimeElapsed = currentCycle;
            }

            if (runningProcess.CurrentCPUCycle <= 0)
            {
                runningProcess.Status = ProcessStatus.Finished;
            }
            else if (runningProcess.Type.Equals(ProcessType.PR)
                && ((runningProcess.InitialCPUCycle-runningProcess.CurrentCPUCycle) % this.TimeQuantum == 0))
            {
                runningProcess.Status = ProcessStatus.Waiting;
            }

            if (runningProcess.Status.Equals(ProcessStatus.Finished)
                || (runningProcess.Type.Equals(ProcessType.PR) && runningProcess.Status.Equals(ProcessStatus.Waiting)))
            {
                foreach (Process iProcess in normalSched)
                {
                    if ((iProcess.ArrivalTime <= currentCycle
                            && !iProcess.Status.Equals(ProcessStatus.Finished))
                            && !normalProcessFound)
                    {
                        processCanidate = iProcess;
                        normalProcessFound = true;
                    }
                }
            }

            if (runningProcess.Type.Equals(ProcessType.N)
                || (runningProcess.Type.Equals(ProcessType.NPR) && ((runningProcess.Status.Equals(ProcessStatus.Finished))))
                || (runningProcess.Type.Equals(ProcessType.PR) && (runningProcess.Status.Equals(ProcessStatus.Finished) || runningProcess.Status.Equals(ProcessStatus.Waiting))))
            {
                int shortestTime = 0;

                foreach (Process iProcess in rrSched)
                {
                    if (iProcess.ArrivalTime <= currentCycle
                        && !((iProcess.Status.Equals(ProcessStatus.Finished)) || (iProcess.Status.Equals(ProcessStatus.Waiting)))
                        && !rrProcessFound)
                    {
                        shortestTime = iProcess.CurrentCPUCycle;
                        processCanidate = iProcess;
                        rrProcessFound = true;
                    }
                }
            }

            if(runningProcess.Type.Equals(ProcessType.N)
                || runningProcess.Type.Equals(ProcessType.PR)
                || (runningProcess.Type.Equals(ProcessType.NPR) && runningProcess.Status.Equals(ProcessStatus.Finished)))
            {
                foreach (Process iProcess in fifoSched)
                {                    if (iProcess.ArrivalTime <= currentCycle && !iProcess.Status.Equals(ProcessStatus.Finished) && !fifoProcessFound)
                    {
                        processCanidate = iProcess;
                        fifoProcessFound = true;
                    }
                }
            }

            if (!(processCanidate.Equals(Process.Empty) || processCanidate.Equals(runningProcess) || processCanidate.Status.Equals(ProcessStatus.Finished)))
            {
                if (!(runningProcess.Status.Equals(ProcessStatus.Finished) || runningProcess.Status.Equals(ProcessStatus.Waiting)))
                {
                        runningProcess.Status = ProcessStatus.Ready;
                }
                processCanidate.Status = ProcessStatus.Running;

                runningProcess = processCanidate;
            }

            foreach (Process iProcess in allCPUProcesses)
            {
                if (iProcess.Status.Equals(ProcessStatus.Hold) && iProcess.ArrivalTime <= this.currentCycle)
                {
                    iProcess.Status = ProcessStatus.Ready;
                }
            }

            if (CheckIfNewRoundReady(rrSched))
            {
                foreach (Process iProcess in rrSched)
                {
                    if (iProcess.Status.Equals(ProcessStatus.Waiting))
                    {
                        iProcess.Status = ProcessStatus.Ready;
                    }
                }
            }
        }

        private bool CheckIfNewRoundReady(List<Process> roundRobinQueue)
        {
            foreach (Process iProcess in roundRobinQueue)
            {
                if (!(iProcess.Status.Equals(ProcessStatus.Waiting)||iProcess.Status.Equals(ProcessStatus.Finished)))
                {
                    return false;
                }
            }

            return true;
        }

        private int CompareProcessCycle(Process firstProcess, Process secondProcess)
        {
            return firstProcess.InitialCPUCycle - secondProcess.InitialCPUCycle;
        }

        private int CompareArrivalTime(Process firstProcess, Process secondProcess)
        {
            return firstProcess.ArrivalTime - secondProcess.ArrivalTime;
        }
    }
}
