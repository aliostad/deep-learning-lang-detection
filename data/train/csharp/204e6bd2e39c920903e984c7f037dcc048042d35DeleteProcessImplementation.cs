namespace TheBall.CORE
{
    public class DeleteProcessImplementation
    {
        public static Process GetTarget_Process(string processId)
        {
            return ObjectStorage.RetrieveFromOwnerContent<Process>(InformationContext.CurrentOwner, processId);
        }

        public static ProcessContainer GetTarget_OwnerProcessContainer()
        {
            return ObjectStorage.RetrieveFromOwnerContent<ProcessContainer>(InformationContext.CurrentOwner, "default");
        }

        public static void ExecuteMethod_ObtainLockRemoveFromContainerAndDeleteProcess(string processID, Process process, ProcessContainer ownerProcessContainer)
        {
            if (process == null)
            {
                if (ownerProcessContainer != null && ownerProcessContainer.ProcessIDs != null)
                {
                    ownerProcessContainer.ProcessIDs.Remove(processID);
                    ownerProcessContainer.StoreInformation();
                }
            }
            else
            {
                string lockEtag = process.ObtainLockOnObject();
                if (lockEtag == null)
                    return;
                try
                {
                    if (ownerProcessContainer != null)
                    {
                        ownerProcessContainer.ProcessIDs.Remove(process.ID);
                        ownerProcessContainer.StoreInformation();
                    }
                    process.DeleteInformationObject();
                }
                finally
                {
                    process.ReleaseLockOnObject(lockEtag);
                }
            }

        }
    }
}