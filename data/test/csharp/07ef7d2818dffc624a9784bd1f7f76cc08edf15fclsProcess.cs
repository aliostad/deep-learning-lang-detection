using System;
using System.Collections.Generic;
using System.Text;

namespace WindowsCOR
{
    public abstract class IProcess
    {
        protected IProcess objProcess;
        public void setProcess(IProcess _process)
        {
            objProcess = _process;
        }
        public abstract void runProcess();
    }
    public class clsProcess1 : IProcess
    {
        public override void runProcess()
        {
            Console.WriteLine("Run process 1");
            if (objProcess != null)
            {
                objProcess.runProcess();
            }
        }
    }
    public class clsProcess2 : IProcess
    {
        public override void runProcess()
        {
            Console.WriteLine("Run process 2");
            if (objProcess != null)
            {
                objProcess.runProcess();
            }
        }
    }
    public class clsProcess3 : IProcess
    {
        public override void runProcess()
        {
            Console.WriteLine("Run process 3");
            if (objProcess != null)
            {
                objProcess.runProcess();
            }
        }
    }
}
