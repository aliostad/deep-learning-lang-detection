using System;
using System.Collections.Generic;
using System.Text;

using DSC.Business.Entity;
using DSC.Business.Entity.Enums;

namespace DSC.Business.Interface.Managers
{

    /// <summary>
    /// Defines process management API.
    /// </summary>
    public interface IProcessManager
    {
        Process StartProcess(ProcessType processType);
        Process StartProcess(ProcessType processType, string additionalData);
        Process UpdateOrBegin(Process proc);
        Process UpdateOrBegin(ProcessType processType, string additionalData);
        ApiResult EndProcess(Guid processId);
        bool IsProcessRunning(ProcessType processType);
    }
}
