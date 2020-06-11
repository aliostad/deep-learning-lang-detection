using SMTools.Deployment.Base;
using System;
using System.Threading.Tasks;

namespace SMTools.Deployment.Base
{
    public class ProcessBuilder
    {
        /// <summary>
        /// Raise when begining process.
        /// </summary>
        public event EventHandler OnProcessBegining;
        /// <summary>
        /// Raise when process is completed.
        /// </summary>
        public event ProcessCompletedEventHandler OnProcessCompleted;

        public IDeployProcess DeploymentProcess
        {
            get;
            set;
        }
        public ProcessBuilder(IDeployProcess process)
        {
            this.DeploymentProcess = process;
        }
        public void Start()
        {
            this.DeploymentProcess.ApplyConfiguration();
            if (OnProcessBegining != null)
            {
                OnProcessBegining(this, null);
            }
            this.DeploymentProcess.Run();
            if (OnProcessCompleted != null)
            {
                OnProcessCompleted(this, new ProcessCompletedEventArgs(this.DeploymentProcess.GetOutput()));
            }
        }

        public async Task StartAsync()
        {
            this.DeploymentProcess.ApplyConfiguration();
            if (OnProcessBegining != null)
            {
                OnProcessBegining(this, null);
            }
            Action ac = new Action(DeploymentProcess.Run);
            await Task.Run(ac);
            if (OnProcessCompleted != null)
            {
                OnProcessCompleted(this, new ProcessCompletedEventArgs(this.DeploymentProcess.GetOutput()));
            }
        }
    }
}
