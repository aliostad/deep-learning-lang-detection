using System;
using System.Collections;
using System.Management;

namespace com.bp.remoteservices.wmi.process {
    public class ProcessLocal : IProcessObject {
        
        #region "fields"
        ConnectionOptions options;
        ManagementScope connectionScope;
        #endregion


        #region "constructors"
        public ProcessLocal() {
            options = ProcessConnection.ProcessConnectionOptions();
            connectionScope = ProcessConnection.ConnectionScope(
                                     Environment.MachineName, options);
        }
        #endregion

        
        #region "polymorphic methods"
        public ArrayList RunningProcesses() {
            ArrayList alProcesses = new ArrayList();
            alProcesses = ProcessMethod.RunningProcesses(connectionScope);
            return alProcesses;
        }
        public ArrayList ProcessProperties(string processName) {
            ArrayList alProperties = new ArrayList();
            alProperties = ProcessMethod.ProcessProperties(connectionScope,
                                                           processName);
            return alProperties;
        }
        public string CreateProcess(string processPath, string processName, string arguments) {
            return ProcessMethod.StartProcess(Environment.MachineName, processPath + processName + " " + arguments);
        }
        public string CreateCMDProcess(string processPath, string processName, string arguments) {
            return ProcessMethod.StartProcess(Environment.MachineName, processPath + processName + " " + arguments);
        }
        public void TerminateProcess(string processName) {
            ProcessMethod.KillProcess(connectionScope, processName);
        }
        public void SetPriority(string processName, ProcessPriority.priority priority) {
            ProcessMethod.ChangePriority(connectionScope, processName, priority);
        }
        public string GetProcessOwner(string processName) {
            return ProcessMethod.ProcessOwner(connectionScope, processName);
        }
        public string GetProcessOwnerSID(string processName) {
            return ProcessMethod.ProcessOwnerSID(connectionScope, processName);
        }
        #endregion
    }
}