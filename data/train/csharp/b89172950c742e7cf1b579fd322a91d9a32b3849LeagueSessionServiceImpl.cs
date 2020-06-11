using Dargon.LeagueOfLegends.Processes;
using ItzWarty;
using ItzWarty.Processes;
using NLog;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Dargon.LeagueOfLegends.Session {
   public class LeagueSessionServiceImpl : LeagueSessionService
   {
      private static readonly Logger logger = LogManager.GetCurrentClassLogger();

      private readonly IProcessProxy processProxy;
      private readonly LeagueProcessWatcherService leagueProcessWatcherService;

      private readonly Dictionary<int, LeagueSession> sessionsByProcessId = new Dictionary<int, LeagueSession>();
      private readonly object synchronization = new object();

      public event LeagueSessionCreatedHandler SessionCreated;

      public LeagueSessionServiceImpl(IProcessProxy processProxy,  LeagueProcessWatcherService leagueProcessWatcherService) {
         this.processProxy = processProxy;
         this.leagueProcessWatcherService = leagueProcessWatcherService;

         leagueProcessWatcherService.RadsUserKernelLaunched += HandleLeagueProcessLaunched;
         leagueProcessWatcherService.LauncherLaunched += HandleLeagueProcessLaunched;
         leagueProcessWatcherService.PatcherLaunched += HandleLeagueProcessLaunched;
         leagueProcessWatcherService.AirClientLaunched += HandleLeagueProcessLaunched;
         leagueProcessWatcherService.GameClientLaunched += HandleLeagueProcessLaunched;
      }

      public ILeagueSession GetProcessSessionOrNull(int processId) { return sessionsByProcessId.GetValueOrDefault(processId); }

      private void HandleLeagueProcessLaunched(LeagueProcessDetectedArgs e)
      {
         lock (synchronization) {
            var processId = e.ProcessDescriptor.ProcessId;
            var process = processProxy.GetProcessOrNull(processId);

            if (process == null) {
               logger.Error("League process " + processId + " of type " + e.ProcessType + " quit too quickly!");
               return;
            }

            logger.Info("Handling process " + processId + " launch");

            if (e.ProcessType == LeagueProcessType.RadsUserKernel && sessionsByProcessId.Any()) {
               var sessions = sessionsByProcessId.Values.Distinct();
               var session = sessions.First();
               IProcess foregroundProcess;
               if (session.TryGetProcess(LeagueProcessType.GameClient, out foregroundProcess) ||
                   session.TryGetProcess(LeagueProcessType.PvpNetClient, out foregroundProcess) ||
                   session.TryGetProcess(LeagueProcessType.Launcher, out foregroundProcess)) {
                  var foregroundProcessDerp= Process.GetProcessById(foregroundProcess.Id);

                  List<IntPtr> processWindowHandles = new List<IntPtr>();
                  foreach (ProcessThread thread in foregroundProcessDerp.Threads) {
                     WinAPI.EnumThreadWindows(thread.Id, (hWnd, lparam) => {
                        processWindowHandles.Add(hWnd);
                        return true;
                     }, IntPtr.Zero);
                  }

                  foreach (var processWindowHandle in processWindowHandles) {
                     if (WinAPI.IsWindowVisible(processWindowHandle)) {
                        WinAPI.SetForegroundWindow(processWindowHandle);
                        WinAPI.ShowWindow(processWindowHandle, WinAPI.WindowShowStyle.Minimize);
                        WinAPI.ShowWindow(processWindowHandle, WinAPI.WindowShowStyle.Restore);
                     }
                  }

                  Process.GetProcessById(process.Id).Kill();
                  return;
               }
            }

            process.EnableRaisingEvents = true;
            process.Exited += (a, b) => HandleLeagueProcessQuit(process, e.ProcessType);

            if (process.HasExited) {
               logger.Info("Process " + process.Id + " exited too quickly!");
            }

            bool processKilled = false; // todo: event for process detected allowing for duplicate RUK kill
            if (!processKilled) {
               LeagueSession session;
               var parentProcessId = e.ProcessDescriptor.ParentProcessId;
               if (!sessionsByProcessId.TryGetValue(parentProcessId, out session)) {
                  logger.Info("Creating new session for " + processId + " as parent process not found " + parentProcessId);
                  session = new LeagueSession();
                  OnSessionCreated(new LeagueSessionCreatedArgs(session));
               }
               logger.Info("Adding process " + processId + " to session " + session);
               logger.Info("!");
               session.HandleProcessLaunched(process, e.ProcessType);
               sessionsByProcessId.Add(processId, session);
               logger.Info("==> " + sessionsByProcessId.Count);
            }
         }
      }

      private void HandleLeagueProcessQuit(IProcess process, LeagueProcessType processType)
      {
         logger.Info("Handling process " + process.Id + " quit");
         LeagueSession session;
         if (sessionsByProcessId.TryGetValue(process.Id, out session)) {
            logger.Info("Session for " + process.Id + " found!");
            session.HandleProcessQuit(process, processType);
            sessionsByProcessId.Remove(process.Id);
         } else {
            logger.Error("Session for " + process.Id + " not found!");
         }
      }

      protected virtual void OnSessionCreated(LeagueSessionCreatedArgs e)
      {
         LeagueSessionCreatedHandler handler = SessionCreated;
         if (handler != null) handler(this, e);
      }
   }
}
