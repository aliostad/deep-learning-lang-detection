using System.Diagnostics;

public static class ProcessExtensions
    // http://stackoverflow.com/questions/394816/how-to-get-parent-process-in-net-in-managed-way
    {
    private static string ProcessIndexedNameFromProcessId(int processId)
        {
        using (Process processPid = Process.GetProcessById(processId))
            {
            string processName        = processPid.ProcessName;
            Process[] processesByName = Process.GetProcessesByName(processName);
            string processIndexdName  = null;

            try {
                for (var index = 0; index < processesByName.Length; index++)
                    {
                    processIndexdName = index == 0 ? processName : processName + "#" + index;
                    var processIdFinder = new PerformanceCounter("Process", "ID Process", processIndexdName);
                    if ((int)processIdFinder.NextValue() == processId)
                        {
                        return processIndexdName;
                        }
                    }

                return processIndexdName;
                }
            finally
                {
                foreach (Process p in processesByName)
                    p.Dispose();
                }
            }
        }

    private static Process ParentIdFromProcessName(string processName)
        {
        var parentIdFinder = new PerformanceCounter("Process", "Creating Process ID", processName);
        int parentId = (int)parentIdFinder.NextValue();
        try
            {
            return Process.GetProcessById(parentId);
            }
        catch (System.ArgumentException)
            {
            return null;    // the parent process no longer exists
            }
        }

    public static Process Parent(this Process process)
        {
        string processIndexedName = ProcessIndexedNameFromProcessId(process.Id);
        return ParentIdFromProcessName(processIndexedName);
        }
    }