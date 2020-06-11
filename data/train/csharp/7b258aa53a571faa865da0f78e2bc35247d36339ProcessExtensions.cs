using System;
using System.Diagnostics;

namespace DevUtils.Elas.Tasks.Core.Diagnostics.Extensions
{
	static class ProcessExtensions
	{
		/// <summary>
		/// Gets the parent process of the current process.
		/// </summary>
		/// <returns>An instance of the Process class.</returns>
		public static Process GetParentProcess()
		{
			return GetParentProcess(Process.GetCurrentProcess());
		}

		/// <summary>
		/// Gets the parent process of specified process.
		/// </summary>
		/// <param name="id">The process id.</param>
		/// <returns>An instance of the Process class.</returns>
		public static Process GetParentProcess(int id)
		{
			var process = Process.GetProcessById(id);
			return GetParentProcess(process);
		}

		public static Process GetParentProcess(this Process process)
		{
			var pbi = NativeMethods.QueryInformationProcess(process.Handle, 0);

			try
			{
				return Process.GetProcessById(pbi.InheritedFromUniqueProcessId.ToInt32());
			}
			catch (ArgumentException)
			{
				// not found
				return null;
			}
		}
	}
}