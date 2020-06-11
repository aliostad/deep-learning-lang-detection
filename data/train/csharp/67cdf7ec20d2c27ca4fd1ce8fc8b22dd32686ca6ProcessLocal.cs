using System;
using System.Collections;
using System.Collections.Generic;
using System.Management;
using System.Text;

namespace Wmi.Process
{
    public class ProcessLocal:IProcessObject 
    {
 
        ConnectionOptions options;
        ManagementScope connectionScope;

        public ProcessLocal()
        {
            options = ProcessConnection.ProcessConnectionOptions();
            connectionScope = ProcessConnection.ConnectionScope(
                                     Environment.MachineName, options);
        }
      
        public ArrayList ProcessProperties(string processName)
        {
            ArrayList alProperties = new ArrayList();
            alProperties = ProcessMethod.ProcessProperties(connectionScope, 
                                                           processName);
            return alProperties;
        }
        public string CreateProcess(string processPath)
        {
            return ProcessMethod.StartProcess(Environment.MachineName, processPath);
        }
   
        public void SetPriority(string processName, ProcessPriority.priority priority)
        {
            ProcessMethod.ChangePriority(connectionScope, processName, priority);
        }
        public string GetProcessOwner(string processName)
        {
            return ProcessMethod.ProcessOwner(connectionScope, processName);
        }
        public string GetProcessOwnerSID(string processName)
        {
            return ProcessMethod.ProcessOwnerSID(connectionScope, processName);
        }

    }
}
