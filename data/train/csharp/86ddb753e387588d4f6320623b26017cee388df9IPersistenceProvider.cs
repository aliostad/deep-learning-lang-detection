using System;
using ADMA.Workflow.Core.Model;

namespace ADMA.Workflow.Core.Persistence
{
    public interface IPersistenceProvider
    {
        void InitializeProcess (ProcessInstance processInstance);
        void FillProcessParameters(ProcessInstance processInstance);
        void FillPersistedProcessParameters(ProcessInstance processInstance);
        void FillSystemProcessParameters(ProcessInstance processInstance);
        void SavePersistenceParameters(ProcessInstance processInstance);
        void SetWorkflowIniialized(ProcessInstance processInstance);
        void SetWorkflowIdled(ProcessInstance processInstance);
        void SetWorkflowRunning(ProcessInstance processInstance);
        void SetWorkflowFinalized(ProcessInstance processInstance);
        void SetWorkflowTerminated(ProcessInstance processInstance, ErrorLevel level, string errorMessage);
        void ResetWorkflowRunning();
        void UpdatePersistenceState(ProcessInstance processInstance, TransitionDefinition transition);
        bool IsProcessExists(Guid processId);
        ProcessStatus GetInstanceStatus(Guid processId);
        void BindProcessToNewScheme(ProcessInstance processInstance);
        void BindProcessToNewScheme(ProcessInstance processInstance, bool resetIsDeterminingParametersChanged);
    }
}
