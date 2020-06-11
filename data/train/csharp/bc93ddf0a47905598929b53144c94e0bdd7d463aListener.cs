using System;
using System.Threading;

namespace Invoice_Manager
{
    public class Listener
    {
        private int invokeCount;
        private int maxCount;

        public Listener()
        {
            invokeCount = 0;
            maxCount = 5;
        }
        public void Handle(Object stateInfo)
        {
            AutoResetEvent autoEvent = (AutoResetEvent)stateInfo;
            ++invokeCount;

            if (invokeCount == maxCount)
            {
                invokeCount = 0;
                App.Manager.Save();
                autoEvent.Set();
            }
        }
    }
}
