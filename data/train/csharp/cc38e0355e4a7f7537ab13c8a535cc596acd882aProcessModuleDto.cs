using System;
using System.Diagnostics;

namespace ProcHelper
{
    public class ProcessModuleDto
    {
        private readonly ProcessModule _processModule;

        public ProcessModuleDto(ProcessModule processModule)
        {
            _processModule = processModule;
        }

        public ProcessModule GetBase()
        {
            return _processModule;
        }


        public string FileName
        {
            get { return _processModule.FileName; }
        }

        public FileVersionInfo FileVersionInfo
        {
            get { return _processModule.FileVersionInfo; }
        }
    }
}
