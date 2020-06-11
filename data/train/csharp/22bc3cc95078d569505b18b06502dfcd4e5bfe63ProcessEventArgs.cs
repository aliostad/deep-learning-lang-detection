namespace ZodiacGlass
{
    using System;
    using System.Diagnostics;
    using System.Reflection;

    internal class ProcessEventArgs : EventArgs
    {
        [DebuggerBrowsable(DebuggerBrowsableState.Never)]
        private readonly Process process;
        
        public ProcessEventArgs(Process process)
        {
            if (process == null)
                throw new ArgumentNullException(MethodBase.GetCurrentMethod().GetParameters()[0].Name);

            this.process = process;
        }

        public Process Process
        {
            get { return this.process; }
        }
    }
}
