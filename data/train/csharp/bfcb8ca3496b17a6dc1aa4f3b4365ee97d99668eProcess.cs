using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NetInternals
{
    public class Process 
    {
        public int Pid
        {
            get { return _process.Id; }
        }

        public string Name
        {
            get { return _process.ProcessName; }
        }

        System.Diagnostics.Process _process;

        public 
        Process(System.Diagnostics.Process process)
        {
            this._process = process;
        }



        public override string ToString()
        {
            return string.Format("{0} ({1})", this.Name, this.Pid);
        }

    }
}
