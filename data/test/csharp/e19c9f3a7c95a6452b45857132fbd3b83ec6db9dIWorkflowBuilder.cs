using System;
using System.Collections.Generic;
using ADMA.Workflow.Core.Cache;
using ADMA.Workflow.Core.Model;

namespace ADMA.Workflow.Core.Builder
{
    public interface IWorkflowBuilder
    {
        ProcessInstance CreateNewProcess(Guid processId,
                                         string processName,
                                         IDictionary<string, IEnumerable<object>> parameters);

        ProcessInstance CreateNewProcessScheme(Guid processId,
                                               string processName,
                                               IDictionary<string, IEnumerable<object>> parameters);

        ProcessInstance GetProcessInstance(Guid processId);

        ProcessDefinition GetProcessScheme(Guid schemeId);

        void SetCache(IParsedProcessCache cache);

        void RemoveCache();

        ProcessDefinition GetProcessScheme(string processName);

        ProcessDefinition GetProcessScheme(string processName, IDictionary<string, IEnumerable<object>> parameters);

       
    }

}
