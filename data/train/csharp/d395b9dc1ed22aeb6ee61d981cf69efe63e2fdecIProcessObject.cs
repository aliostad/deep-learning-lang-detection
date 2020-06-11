using System.Collections;

namespace com.bp.remoteservices.wmi.process {
    public interface IProcessObject {
        ArrayList RunningProcesses();
        ArrayList ProcessProperties(string processName);
        string CreateProcess(string processPath, string processName, string arguments);
        void TerminateProcess(string processName);
        void SetPriority(string processName, ProcessPriority.priority priority);
        string GetProcessOwner(string processName);
        string GetProcessOwnerSID(string processName);
    }
}
