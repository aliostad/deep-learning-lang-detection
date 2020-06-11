using Simulator.Infrastructure;

namespace TaskScheduler.Models
{
    public class ResourceRecord : Notifier
    {
        public ResourceRecord(Process process, IoBurstDescriptor burst)
        {
            this.process = process;
            this.burst = burst;
        }

        private Process process;
        private IoBurstDescriptor burst;

        public Process Process
        {
            get { return process; }
            set
            {
                process = value;
                OnPropertyChanged("Process");
            }
        }
        public IoBurstDescriptor Burst
        {
            get { return burst; }
            set
            {
                burst = value;
                OnPropertyChanged("Burst");
            }
        }

    }
}
