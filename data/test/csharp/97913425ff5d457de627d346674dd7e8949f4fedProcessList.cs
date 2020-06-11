using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Diagnostics;
using System.IO;

// ERROR: Porpoises have not been balanced
namespace SIEM_Project.Classes
{
    // Update Events
    public delegate void Event_NewProcess1(ProcessInfo tempProcess);
    public delegate void Event_UpdateProcess1(ProcessInfo tempProcess);
    public delegate void Event_CloseProcess1(ProcessInfo tempProcess);
    
    public class ProcessList
    {
        public static DataManager dm = new DataManager();

        public static event Event_NewProcess1 Call_NewProcess;
        public static event Event_UpdateProcess1 Call_UpdateProcess;
        public static event Event_CloseProcess1 Call_CloseProcess;

        public static ProcessInfo[] processList;
        public static int processIndex;

        public static void Init()
        {

        }

        /// <summary>
        /// Update the process infomration
        /// </summary>
        public static void UpdateProcessList()
        {
            Process[] newProcessList = Process.GetProcesses();

            //UpdateCpuUsage(newProcessList);
            UpdateExistingProcesses(newProcessList);
            AddNewProcesses(newProcessList);            
        }

        /// <summary>
        /// Updates the process list
        /// </summary>
        /// <param name="newProcessList"></param>
        public static void UpdateExistingProcesses(Process[] newProcessList)
        {
            ProcessInfo[] tempProcessList = new ProcessInfo[newProcessList.Length];
            processIndex = 0;

            // updates the cpu usage of already loaded processes
            if (processList == null)
            {
                processList = new ProcessInfo[newProcessList.Length];
                return;
            }

            foreach (ProcessInfo tempProcess in processList)
            {
                Process currentProcess = ProcessExists(newProcessList, processIndex);

                if (currentProcess == null)
                {
                    Call_CloseProcess(tempProcess);
                }
                else
                {
                    tempProcessList[processIndex] = GetProcessInfo(tempProcess, currentProcess);
                    Call_UpdateProcess(tempProcess);
                }
            }

            processList = tempProcessList;
        }

        /// <summary>
        /// Checks to see if the process has already been encountered
        /// </summary>
        /// <param name="newProcessList"></param>
        /// <param name="pID"></param>
        /// <returns></returns>
        private static Process ProcessExists(Process[] newProcessList, int pID)
        {
            foreach (Process tempProcess in newProcessList)
            {
                if (tempProcess.Id == pID)
                {
                    return tempProcess;
                }
            }

            // Process hasn't been found yet, return null
            return null;
        }

        public static ProcessHistory GetProcessHistory(int pID)
        {
            foreach (ProcessInfo tempProcess in processList)
            {
                if (tempProcess.ID == pID)
                {
                    return tempProcess.processHistory;
                }
            }

            return null;
        }

        /// <summary>
        /// Updates the process information 
        /// </summary>
        /// <param name="tempProcess"></param>
        /// <param name="currentProcess"></param>
        /// <returns></returns>
        private static ProcessInfo GetProcessInfo(ProcessInfo tempProcess, Process currentProcess)
        {
            if (currentProcess.Id == 0)
            {
                
            }
            else
            {
                // TODO::Update the temporary process info here
            }

            return tempProcess;
        }

        private static void AddNewProcesses(Process[] newProcessList)
        {
            foreach (Process newProcess in newProcessList)
            {
                if (!ProcessInfoExists(newProcess))
                {
                    AddNewProcess(newProcess);
                }
            }
        }

        private static void AddNewProcess(Process newProcess)
        {
            // Skip the system process
            if (newProcess.Id != 0 && newProcess.Id != 4)
            {
                ProcessInfo newProcessInfo = new ProcessInfo();

                // TODO::Initialize the process info here
                newProcessInfo.Name = newProcess.ProcessName;
                newProcessInfo.ID = newProcess.Id;
                newProcessInfo.processHistory = dm.GetProcessHistory(newProcess.ProcessName);

                processList[processIndex++] = newProcessInfo;
                Call_NewProcess(newProcessInfo);
            }
        }

        private static bool ProcessInfoExists(Process newProcess)
        {
            if (processList == null)
                return false;

            foreach (ProcessInfo tempProcess in processList)
                if (tempProcess != null && tempProcess.ID == newProcess.Id)
                    return true;

            return false;
        }
    }

    public class ProcessInfo
    {
        // Basic Process information
        public string Name;
        public int ID;
        public ProcessHistory processHistory;
    }
}
