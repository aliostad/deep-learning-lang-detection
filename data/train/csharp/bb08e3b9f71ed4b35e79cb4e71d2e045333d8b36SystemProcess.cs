using System.Collections.Generic;
using SystemInterfaces;

namespace RevolutionEntities.Process
{
    public class SystemProcess : Process, ISystemProcess
    {
        public SystemProcess(IProcess process, IMachineInfo machineInfo) : base(process.Id,process.ParentProcessId,process.Name,process.Description, process.Symbol, process.User)
        {
            MachineInfo = machineInfo;
        }

        public SystemProcess(ISystemProcessInfo systemProcessInfo, IUser user, IMachineInfo machineInfo) : base(systemProcessInfo.Id, systemProcessInfo.ParentProcessId, systemProcessInfo.Name, systemProcessInfo.Description, systemProcessInfo.Symbol, user)
        {
            MachineInfo = machineInfo;
        }

        public IMachineInfo MachineInfo { get; }
   
    }

    public class ProcessState : IProcessState
    {
        public ProcessState(ISystemProcess process, IProcessStateInfo stateInfo)
        {
            StateInfo = stateInfo;
            Process = process;
            ProcessId = process.Id;
        }

        public int ProcessId { get; }
        public IProcessStateInfo StateInfo { get; }
        public ISystemProcess Process { get; }
    }

    public class ProcessStateEntity :ProcessState, IProcessStateEntity
    {
        public ProcessStateEntity(ISystemProcess process, IDynamicEntity entity, IStateInfo info) : base(process, info)
        {
            Entity = entity;
        }

        public IDynamicEntity Entity { get; set; }
    }

    public class ProcessStateList : ProcessState, IProcessStateList
    {
        public ProcessStateList(ISystemProcess process, IDynamicEntity entity, IEnumerable<IDynamicEntity> entitySet, IEnumerable<IDynamicEntity> selectedEntities, IProcessStateInfo stateInfo) : base(process, stateInfo)
        {
            Entity = entity;
            EntitySet = entitySet;
            SelectedEntities = selectedEntities;
        }

        public IDynamicEntity Entity { get; }
        public IEnumerable<IDynamicEntity> EntitySet { get; }
        public IEnumerable<IDynamicEntity> SelectedEntities { get; }
        
    }
}