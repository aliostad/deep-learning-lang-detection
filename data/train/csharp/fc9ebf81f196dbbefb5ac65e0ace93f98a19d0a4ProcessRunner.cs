using System;
using System.Diagnostics;

namespace ShovelPack.Utils
{
	public interface IProcessRunner
	{
		void RunProcess(ProcessProperties processProperties);
	}

	public class ProcessRunner : IProcessRunner
	{
		public void RunProcess(ProcessProperties processProperties)
		{
			var process = new Process
				{
					StartInfo = new ProcessStartInfo
						{
							FileName = processProperties.Executable,
							Arguments = String.Join(" ", processProperties.Arguments),
							UseShellExecute = false,
						}
				};
			process.Start();
			process.WaitForExit();
		}
	}

	public class ProcessProperties
	{
		public string Executable { get; set; }
		public string[] Arguments { get; set; }
	}
}