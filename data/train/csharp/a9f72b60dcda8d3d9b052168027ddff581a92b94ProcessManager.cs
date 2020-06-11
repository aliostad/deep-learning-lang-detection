using System.Collections.Generic;
using Microsoft.Xna.Framework;

namespace GameTools.Process
{
    public class ProcessManager
    {
        private List<MultiTickProcess> processes;

        public ProcessManager()
        {
            processes = new List<MultiTickProcess>();
        }

        public void Update(GameTime gameTime)
        {
            List<MultiTickProcess> toRemove = new List<MultiTickProcess>();
            foreach(MultiTickProcess process in processes)
            {
                process.Update(gameTime);

                if(process.Dead)
                    toRemove.Add(process);
            }

            RemoveTemporaryProcesses(toRemove);
        }

        public void AttachProcess(MultiTickProcess process)
        {
            processes.Add(process);
        }

        private void FinishProcess(MultiTickProcess process)
        {
            if(process.Next.Valid)
                processes.Add(process.Next.Data);
        }
        private void RemoveTemporaryProcesses(List<MultiTickProcess> toRemove)
        {
            foreach(MultiTickProcess process in toRemove)
            {
                processes.Remove(process);
            }
        }
        public void ShutDown()
        {
            foreach(MultiTickProcess process in processes)
            {
                process.KillProcess();
            }
        }
    }
}
