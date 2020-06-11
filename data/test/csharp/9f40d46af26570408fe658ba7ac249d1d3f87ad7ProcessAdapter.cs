using System.Diagnostics;

namespace CNL.IPSecurityCenter.Adapters.Diagnostics
{
    public class ProcessAdapter : IProcess
    {
        Process process;

        public ProcessAdapter(Process process)
        {
            this.process = process;   
        }

        // Properties
        public ProcessStartInfo StartInfo { get { return process.StartInfo;} set { process.StartInfo = value;} }

        // Methods
        public bool Start()   { return process.Start(); }
        public void Dispose() { process.Dispose(); }

    }
}
