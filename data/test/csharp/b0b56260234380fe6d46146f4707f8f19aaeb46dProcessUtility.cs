using System.Diagnostics;

namespace nModule.Utilities
{
    /// <summary>
    /// Utility methods for .NET's Process objects
    /// </summary>
    public class ProcessUtility
    {
        /// <summary>
        /// Not Completely Implemented
        /// </summary>
        /// <param name="processPath"></param>
        /// <param name="processArguments"></param>
        /// <returns></returns>
        public static Process LaunchExternalProcess(string processPath, string processArguments)
        {
            return LaunchExternalProcess(processPath, processArguments, false, false, null);
        }

        /// <summary>
        /// Not Completely Implemented
        /// </summary>
        /// <param name="processPath"></param>
        /// <param name="processArguments"></param>
        /// <param name="startProcess"></param>
        /// <param name="waitForExit"></param>
        /// <param name="processDataCapturer"></param>
        /// <returns></returns>
        public static Process LaunchExternalProcess(string processPath, string processArguments, bool startProcess, bool waitForExit, IProcessDataCapturer processDataCapturer)
        {
            var externalProcess = new Process();
            var externalProcessStartInfo = new ProcessStartInfo
            {
                Arguments = processArguments,
                FileName = processPath,
                RedirectStandardInput = true,
                RedirectStandardError = true,
                RedirectStandardOutput = true,
                CreateNoWindow = true,
                UseShellExecute = false
            };
            externalProcess.StartInfo = externalProcessStartInfo;
            if (processDataCapturer != null)
            {
                processDataCapturer.Process = externalProcess;
            }
            if (startProcess)
            {
                externalProcess.Start();
            }
            if (processDataCapturer != null && startProcess)
            {
                externalProcess.BeginOutputReadLine();
                externalProcess.BeginErrorReadLine();
            }
            if (waitForExit)
                externalProcess.WaitForExit();
            return externalProcess;
        }
    }
}
