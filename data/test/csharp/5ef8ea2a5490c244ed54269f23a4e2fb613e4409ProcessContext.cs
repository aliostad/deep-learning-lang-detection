using Newtonsoft.Json;
using System;

namespace HA.Common
{
    [Serializable]
    [JsonObject]
    public class ProcessContext : IProcessContext
    {
        public ProcessContext()
        {
        }
        [JsonConstructor]
        public ProcessContext(Guid processId, string processtype, uint totalNumberOfMessages, uint messageNumber, bool isLastMesssage)
        {
            this.ProcessId = processId;
            this.ProcessType = processtype;
            this.TotalNumberOfMessages = totalNumberOfMessages;
            this.MessageNumber = messageNumber;
            this.IsLastMessage = isLastMesssage;
        }

        public Guid ProcessId
        {
            get;
            set;
        }

        public string ProcessType
        {
            get;
            set;
        }

        public uint TotalNumberOfMessages
        {
            get;
            set;
        }

        public uint MessageNumber
        {
            get;
            set;
        }

        public bool IsLastMessage
        {
            get;
            set;
        }        
    }

    public class ProcessContextUtil
    {
        public static  ProcessContext GetNextProcessContext(ProcessContext thisProcessContext)
        {

            if (thisProcessContext.IsLastMessage)
                return thisProcessContext;

            if (thisProcessContext.MessageNumber == thisProcessContext.TotalNumberOfMessages)
            {
                thisProcessContext.IsLastMessage = true;
                return thisProcessContext;
            }

            ProcessContext processContext = new ProcessContext();
            ProcessContextUtil.AssignFrom(processContext, thisProcessContext);
            processContext.MessageNumber = processContext.MessageNumber + 1;
            processContext.IsLastMessage = processContext.MessageNumber == processContext.TotalNumberOfMessages;
            return processContext;
        }

        public static void AssignFrom(IProcessContext processContext, IProcessContext thisproc)
        {
            if (processContext != null)
            {
                thisproc.IsLastMessage = processContext.IsLastMessage;
                thisproc.ProcessId = processContext.ProcessId;
                thisproc.ProcessType = processContext.ProcessType;
                thisproc.MessageNumber = processContext.MessageNumber;
                thisproc.TotalNumberOfMessages = processContext.TotalNumberOfMessages;
            }
            else
            {
                throw new ArgumentNullException("processContext");
            }
        }

        public static void AssignTo(IProcessContext processContext, IProcessContext thisproc)
        {
            if (processContext != null && processContext is ProcessContext)
            {
                processContext.IsLastMessage = thisproc.IsLastMessage;
                processContext.ProcessId = thisproc.ProcessId;
                processContext.ProcessType = thisproc.ProcessType;
                processContext.MessageNumber = thisproc.MessageNumber;
                processContext.TotalNumberOfMessages = thisproc.TotalNumberOfMessages;
            }
            else
            {
                throw new ArgumentNullException("processContext");
            }
        }

        public static ProcessContext GetContextForNewProcess(string processType)
        {
            ProcessContext processContext = new ProcessContext();
            processContext.ProcessType = processType;
            processContext.ProcessId = Guid.NewGuid();
            processContext.MessageNumber = 1;
            processContext.TotalNumberOfMessages = 1;
            processContext.IsLastMessage = true;
            return processContext;
        }

        public static ProcessContext GetContextForNewProcess(string processType, uint totalNumberOfMessages = 1)
        {
            ProcessContext processContext = new ProcessContext();
            processContext.ProcessType = processType;
            processContext.ProcessId = Guid.NewGuid();
            processContext.MessageNumber = 1;
            processContext.TotalNumberOfMessages = totalNumberOfMessages;
            processContext.IsLastMessage = totalNumberOfMessages > 1;
            return processContext;
        }

    }
}
