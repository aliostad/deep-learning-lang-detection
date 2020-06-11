using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Windows_Ad_Plugin
{
    public static class Dispatcher
    {
        // needs to be set via the app so we can invoke onto App Thread (see App.xaml.cs)
        public static Action<Action> InvokeOnAppThread
        {
            get 
            { 
                if(_invokeOnAppThread == null && Helper.Instance.Messenger != null)
                    Helper.Instance.Messenger("Dispatcher Error: InvokeOnAppThread not set up");

                return _invokeOnAppThread;
            } 
            set
            {
                _invokeOnAppThread = value;
            } 
        }

        private static Action<Action> _invokeOnAppThread;

        // needs to be set via the app so we can invoke onto UI Thread (see App.xaml.cs)
        public static Action<Action> InvokeOnUIThread
        {
            get
            {
                if (_invokeOnUIThread == null && Helper.Instance.Messenger != null)
                    Helper.Instance.Messenger("Dispatcher Error: InvokeOnUIThread not set up");
                return _invokeOnUIThread;
            }
            set
            {
                _invokeOnUIThread = value;
            }
        }

        private static Action<Action> _invokeOnUIThread;
    }
}
