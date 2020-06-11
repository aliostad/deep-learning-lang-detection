using System;
using System.Diagnostics;
using ImpromptuInterface;

namespace ItzWarty.Processes
{
   public class ProcessProxy : IProcessProxy
   {
      public IProcess GetProcessById(int id) { return WrapProcess(Process.GetProcessById(id)); }

      public IProcess GetProcessOrNull(int id)
      {
         try {
            return GetProcessById(id);
         } catch (ArgumentException e) {
            return null; // process already exited
         }
      }

      public IProcess[] GetProcesses() { 
         var processes = Process.GetProcesses();
         return Util.Generate(processes.Length, i => WrapProcess(processes[i]));
      }

      public IProcess GetParentProcess(IProcess process) { return WrapProcess(ParentProcessUtilities.GetParentProcess(process.Id)); }

      private IProcess WrapProcess(Process process) { return process.ActLike<IProcess>(); }
   }
}
