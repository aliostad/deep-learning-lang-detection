using System;
using System.Collections.Generic;
using System.Text;

using SchoolHaccp.Common;
using SchoolHaccp.DataAccess.Insert;

namespace SchoolHaccp.BusinessLogic
{
    public class ProcessCreateProcessGroup : IBusinessLogic
    {
        private ProcessGroup m_ProcessGroup;

        public ProcessCreateProcessGroup()
        {
        }

        public void Invoke()
        {
            CreateProcessGroup createProcessGroup = new CreateProcessGroup();
            createProcessGroup.ProcessGroup = this.m_ProcessGroup;
            createProcessGroup.Insert();
            this.m_ProcessGroup = createProcessGroup.ProcessGroup;
        }

        public ProcessGroup ProcessGroup
        {
            get { return m_ProcessGroup; }
            set { m_ProcessGroup = value; }
        }
    }
}
