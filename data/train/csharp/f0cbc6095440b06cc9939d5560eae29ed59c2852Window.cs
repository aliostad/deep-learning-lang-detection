using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Dear.WindowControl {
    public class Window : IWindow {
        public string GetTitle() {
            return GetForegroundProcess().MainWindowTitle;
        }

        public Process GetForegroundProcess() {
            var id = WindowPInvoke.GetForegroundWindow();
            int processId;
            WindowPInvoke.GetWindowThreadProcessId(id, out processId);
            Process foregroundProcess = Process.GetProcessById(processId);
            return foregroundProcess;
        }

        public string GetProcessName() {
            return GetForegroundProcess().ProcessName;            
        }
    }
}
