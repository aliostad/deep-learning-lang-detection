using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LiveNation.Testing.Domain.Framework
{
    public class Process : IProcess
    {
        private readonly System.Diagnostics.Process _process;

        public System.Diagnostics.ProcessStartInfo StartInfo
        {
            get
            {
            	return _process.StartInfo;
            }
			set
			{
				_process.StartInfo = value;
			}
        }

        public Process(System.Diagnostics.Process process)
        {
            _process = process;
        }

        public bool Start()
        {
            return _process.Start();
        }
    }
}
