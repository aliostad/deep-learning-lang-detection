using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProcessNote.Model
{
    public class SystemProcess
    {
        private string comment;
        private Process process;

        public SystemProcess(Process process)
        {
            this.Process = process;
            Comment = "";
        }

        public string Comment
        {
            get
            {
                return comment;
            }

            set
            {
                comment = value;
            }
        }

        public Process Process
        {
            get
            {
                return process;
            }

            set
            {
                process = value;
            }
        }
    }
}
