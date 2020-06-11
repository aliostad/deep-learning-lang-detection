using System.Diagnostics;
class Program {
	static void Main() {
		if( TestIfAlreadyRunning() ) {
			System.Console.WriteLine("This app is already running!");
		} else {
			// Here, the entry point of the application.
		}
	}

	static bool TestIfAlreadyRunning() {
		Process processCurrent = Process.GetCurrentProcess();
		Process[] processes = Process.GetProcesses();
		foreach(Process process in processes)
			if( processCurrent.Id != process.Id)
				if( processCurrent.ProcessName == process.ProcessName)
					return true;
		return false;
	}
}
