using System;
using System.Runtime.InteropServices;

namespace RemoteControlSystem.Client
{
	[ComVisible(true)]
	public interface IRCClient
	{
		void WaitForProcessStart(string processName);

		bool WaitForProcessStart(string processName, int millisecond);

		void WaitForProcessStop(string processName);

		bool WaitForProcessStop(string processName, int millisecond);

		bool StartProcess(string processName);

		bool StopProcess(string processName);

		void StartAllProcess();

		void StopAllProcess();
	}
}
