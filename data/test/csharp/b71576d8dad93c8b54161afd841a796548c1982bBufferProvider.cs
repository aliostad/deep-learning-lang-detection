using AltConsole.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AltConsole
{
    public sealed class BufferProvider
    {
        public IExternalProcess ExternalProcess;
        public event OutHandler ProcessOut;

        public void ProcessIn(char[] chars)
        {
            var process = ExternalProcess;
            if(process != null)
                process.ProcessIn(chars);
        }

        public BufferProvider()
        {

        }

        public void SetExternalProcess(IExternalProcess externalProcess)
        {
            externalProcess.ProcessOut += OnProcessOut;
            ExternalProcess = externalProcess;
        }

        private void OnProcessOut(char[] output)
        {
            var evnt = ProcessOut;
            if (evnt != null)
                ProcessOut(output);
        }
    }
}
