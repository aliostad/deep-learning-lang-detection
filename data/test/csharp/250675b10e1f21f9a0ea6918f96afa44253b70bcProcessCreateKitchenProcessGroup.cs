using System;
using System.Collections.Generic;
using System.Text;
using SchoolHaccp.Common;
using SchoolHaccp.DataAccess.Insert;

namespace SchoolHaccp.BusinessLogic
{
    public class ProcessCreateKitchenProcessGroup : IBusinessLogic
    {
        private KitchenProcessGroup m_KitchenProcessGroup;

        public ProcessCreateKitchenProcessGroup()
        {
        }

        public void Invoke()
        {
            CreateKitchenProcessGroup createkitchenProcessGroup = new CreateKitchenProcessGroup();
            createkitchenProcessGroup.KitchenProcessGroup = this.m_KitchenProcessGroup;
            createkitchenProcessGroup.Insert();
            this.m_KitchenProcessGroup = createkitchenProcessGroup.KitchenProcessGroup;
        }

        public KitchenProcessGroup kitchenProcessGroup
        {
            get { return m_KitchenProcessGroup; }
            set { m_KitchenProcessGroup = value; }
        }
    }
}
