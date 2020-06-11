using System.Collections.Generic;
using System.Diagnostics;

namespace Puchipro6Visualizer.Game {
    /// <summary>
    ///     子プロセスを管理する静的クラス．
    /// </summary>
    static class GenericProcessManager {
        private static readonly SynchronizedCollection<Process> _processes =
            new SynchronizedCollection<Process>();

        /// <summary>
        ///     プロセスを追加．
        /// </summary>
        /// <param name="process"></param>
        public static void Add(Process process) {
            _processes.Add(process);
        }

        /// <summary>
        ///     最初に見つかった指定したインスタンスと一致するプロセスをKill，Disposeする．
        /// </summary>
        /// <param name="process">Kill，Disposeするプロセス</param>
        public static void Destroy(Process process) {
            if (!_processes.Remove(process)) return;
            if (!process.HasExited) {
                process.Kill();
                process.WaitForExit();
            }
            process.Dispose();
        }

        /// <summary>
        ///     管理されているすべてのプロセスをKill，Disposeします．
        /// </summary>
        public static void DestroyAll() {
            foreach (var process in _processes) {
                if (!process.HasExited) {
                    process.Kill();
                    process.WaitForExit();
                }
                process.Dispose();
            }
        }
    }
}