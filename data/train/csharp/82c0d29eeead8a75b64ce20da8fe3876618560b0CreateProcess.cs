using System;
using System.Collections.Generic;
using System.Text;
using SchoolHaccp.Common;
using SchoolHaccp.DataAccess.Insert;

namespace SchoolHaccp.BusinessLogic
{
    public class ProcessCreateProcess : IBusinessLogic
    {
        private Processes m_Process;

        public ProcessCreateProcess()
        {
        }
        public void Invoke()
        {
        }

        public int Insert()
        {
            int nProcessId;
            CreateProcess createProcess = new CreateProcess();
            createProcess.Process = this.m_Process;
            nProcessId = createProcess.Insert();
            this.m_Process = createProcess.Process;
            return nProcessId;
        }

        public Processes Process
        {
            get { return m_Process; }
            set { m_Process = value; }
        }
    }
}