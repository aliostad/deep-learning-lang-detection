using System.Collections.Generic;

namespace TheBall.CORE
{
    public class CreateProcessImplementation
    {
        public static Process GetTarget_Process(string processDescription, string executingOperationName, SemanticInformationItem[] initialArguments)
        {
            Process process = new Process
                {
                    ProcessDescription = processDescription,
                    ExecutingOperation = new SemanticInformationItem(executingOperationName, null),
                };
            process.InitialArguments.AddRange(initialArguments);
            process.SetLocationAsOwnerContent(InformationContext.CurrentOwner, process.ID);
            return process;
        }

        public static ProcessContainer GetTarget_OwnerProcessContainer()
        {
            var processContainer = ProcessContainer.RetrieveFromOwnerContent(InformationContext.CurrentOwner, "default");
            if (processContainer == null)
            {
                processContainer = new ProcessContainer();
                processContainer.SetLocationAsOwnerContent(InformationContext.CurrentOwner, "default");
            }
            return processContainer;
        }

        public static void ExecuteMethod_AddProcessObjectToContainerAndStoreBoth(ProcessContainer ownerProcessContainer, Process process)
        {
            if(ownerProcessContainer.ProcessIDs == null)
                ownerProcessContainer.ProcessIDs = new List<string>();
            ownerProcessContainer.ProcessIDs.Add(process.ID);
            ownerProcessContainer.StoreInformation();
            process.StoreInformation();
        }

        public static CreateProcessReturnValue Get_ReturnValue(Process process)
        {
            return new CreateProcessReturnValue {CreatedProcess = process};
        }
    }
}