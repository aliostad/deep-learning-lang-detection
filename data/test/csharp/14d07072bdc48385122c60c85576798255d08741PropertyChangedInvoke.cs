using System;
using System.Windows.Threading;

namespace Put.io.Core.InvokeSynchronising
{
    public class PropertyChangedInvoke : IPropertyChangedInvoke
    {
        private Dispatcher InvokeReference { get; set; }

        public PropertyChangedInvoke(Dispatcher invokeReference)
        {
            InvokeReference = invokeReference;
        }

        public bool RequiresInvoke()
        {
            return !InvokeReference.CheckAccess();
        }

        public void HandleCall(Action<string> raisePropertyChanged, string propertyName)
        {
            if (RequiresInvoke())
            {
                InvokeReference.BeginInvoke(() => raisePropertyChanged(propertyName));
                return;
            }

            raisePropertyChanged(propertyName);
        }

        public void HandleCall(Action toCall)
        {
            if (RequiresInvoke())
            {
                InvokeReference.BeginInvoke(toCall);
                return;
            }

            toCall();
        }
    }
}