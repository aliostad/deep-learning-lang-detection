using System;
using System.Collections.Generic;
using System.Text;
using SchoolHaccp.Common;
using SchoolHaccp.DataAccess.Delete;

namespace SchoolHaccp.BusinessLogic
{
    public class ProcessDeleteProcess : IBusinessLogic
    {
        private Processes m_Process;

        public ProcessDeleteProcess()
        {
        }

        public void Invoke()
        {
            DeleteProcess deleteProcess = new DeleteProcess();
            deleteProcess.Process = this.m_Process;
            deleteProcess.Delete();
        }

        public Processes Process
        {
            get { return m_Process; }
            set { m_Process = value; }
        }
    }
}
