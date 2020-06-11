using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace WebSocket.helper {
  public class ProcessHandler {
    static Process assignedProcess = null;
    static bool onBackground = false;

    private static bool IsActive(Process assignedProcess) {
      Process activatedWindow = Process.GetCurrentProcess();
      return assignedProcess.Id == activatedWindow.Id;
    }

    private static bool AssignedProcessIsUpToDate() {
      return GetProcessById(assignedProcess.Id).ProcessName == assignedProcess.ProcessName;
    }

    private static Process GetProcessByName(String name) {
      return Process.GetProcessesByName(name)[0];
    }

    private static Process GetProcessById(int processId) {
      return Process.GetProcessById(processId);
    }

    public static Process GetAssignedProcess() {
      if (!AssignedProcessIsUpToDate())
        return assignedProcess = GetProcessByName(assignedProcess.ProcessName);
      else
        return assignedProcess;
    }

    public static bool GetOnBackground() {
      return onBackground;
    }

    public static void SetProcess(Process process) {
      assignedProcess = process;
    }

    public static void SetProcess(int processId) {
      assignedProcess = GetProcessById(processId);
    }

    public static void SetProcess(string processName) {
      assignedProcess = GetProcessByName(processName);
    }

    public static List<Process> GetProcessList() {
      return new List<Process>(Process.GetProcesses());
    }
  }
}
