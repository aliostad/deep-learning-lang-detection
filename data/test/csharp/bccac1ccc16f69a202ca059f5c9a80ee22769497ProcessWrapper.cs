using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace aevvinject
{
    public class ProcessWrapper
    {
        private Process process;

        public Process Process
        {
            get { return process; }
            set { process = value; }
        }
        public ProcessWrapper(Process process)
        {
            this.process = process;
        }
        public override string ToString()
        {
            return process.ProcessName;
        }
        List<DLLInformation> injectedList = new List<DLLInformation>();

        internal List<DLLInformation> InjectedList
        {
            get { return injectedList; }
            set { injectedList = value; }
        }
    }
}
