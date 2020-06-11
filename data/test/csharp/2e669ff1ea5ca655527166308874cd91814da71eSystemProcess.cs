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

        public SystemProcess(IProcessInfo processInfo, IUser user, IMachineInfo machineInfo) : base(processInfo.Id, processInfo.ParentProcessId, processInfo.Name, processInfo.Description, processInfo.Symbol, user)
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

    public class ProcessState<TEntity> :ProcessState, IProcessState<TEntity> where TEntity : IEntityId
    {
        public ProcessState(ISystemProcess process, TEntity entity, IStateInfo info) : base(process, info)
        {
            Entity = entity;
        }

        public TEntity Entity { get; }
    }

    public class ProcessStateList<TEntity> : ProcessState, IProcessStateList<TEntity> where TEntity : IEntityId
    {
        public ProcessStateList(ISystemProcess process, TEntity entity, IEnumerable<TEntity> entitySet, IEnumerable<TEntity> selectedEntities, IProcessStateInfo stateInfo) : base(process, stateInfo)
        {
            Entity = entity;
            EntitySet = entitySet;
            SelectedEntities = selectedEntities;
        }

        public TEntity Entity { get; }
        public IEnumerable<TEntity> EntitySet { get; }
        public IEnumerable<TEntity> SelectedEntities { get; }
        
    }
}