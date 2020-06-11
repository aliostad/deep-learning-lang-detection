using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Collections;
using System.Threading;
using System.IO;

namespace Monitor_Process
{
    //This will be the monitor class for all the process
    class MonitorProcess
    {
        string someData; // Testin Variable

        private int _totalNumberOfProcess; // total number of process
        private int _processToBeActive; // process to be active at any time
        private int _logAfterProcess; // log to be made after process
        private int _currentActiveProcess; // currently active process
        private int _activeProcesscount; // active process count at any instant

        private DateTime _processExitCode;
        private Process someNewProcess;
        private Process currentProcess;

        List<int> processBuffer = new List<int>();

        public MonitorProcess()
        {
            this.someData = "hello";
        }
        // This Constructor will be used to initialize all the parameters
        public MonitorProcess(int _totalNumberOfProcess, int _processToBeActive, int _logAfterProcess)
        {
            this._logAfterProcess = _logAfterProcess;
            this._processToBeActive = _processToBeActive;
            this._totalNumberOfProcess = _totalNumberOfProcess;
            this.someData = "hello";
            this._currentActiveProcess = 0;
            this._activeProcesscount = 0;
        }

        // This Will be the starting process
        public void startProcess()
        {
            for (int i = 1; i <= this._processToBeActive; i++)
            {
                this.someNewProcess = new Process();

                someNewProcess.StartInfo.FileName = "iexplore.exe";
                string curDir = Directory.GetCurrentDirectory();
                someNewProcess.StartInfo.Arguments = String.Format("file:///{0}\\map\\myMaps.html", curDir);
                someNewProcess.EnableRaisingEvents = true;
                someNewProcess.Exited += (sender, name) => myProcess_Exited(someNewProcess, someNewProcess.Id);
                someNewProcess.Start();

                this._currentActiveProcess++;
                this._activeProcesscount++;
                processBuffer.Add(someNewProcess.Id);
            }
        }

        public void afterStart()
        {
            //if (this.processBuffer.Count < this._processToBeActive)
            //{
                this.someNewProcess = new Process();
               

                someNewProcess.StartInfo.FileName = "iexplore.exe";
                string curDir = Directory.GetCurrentDirectory();
                someNewProcess.StartInfo.Arguments = String.Format("file:///{0}\\map\\myMaps.html", curDir);                //someNewProcess.WaitForExit();
                someNewProcess.EnableRaisingEvents = true;
                someNewProcess.Exited += (sender, name) => myProcess_Exited(someNewProcess, someNewProcess.Id);
                someNewProcess.Start();

                this._currentActiveProcess++;
                this._activeProcesscount++;
                processBuffer.Add(someNewProcess.Id);
            //}
        }
        // Handle Exited event and display process information. 
        private void myProcess_Exited(object sender, int proName)
        {
            try
            {
                Process currentProcess = Process.GetProcessById(proName);
                currentProcess.Close();
                if (currentProcess.HasExited)
                {
                    currentProcess.Kill();
                }

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        public string getSomeData()
        {
            return this.someData;
        }
        public DateTime getProcessExitCode()
        {
            return this._processExitCode;
        }
    }
}
