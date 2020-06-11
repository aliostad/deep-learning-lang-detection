using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IPC
{
    public class MessageDispatcher
    {
        private static MessageDispatcher instance = new MessageDispatcher();
        public static MessageDispatcher Instance { get { return instance; } }
        private MessageDispatcher() { }

        public delegate void OnDispatchHandler(IMessage message);
        public event OnDispatchHandler OnDispatch;
        public void Dispatch(IMessage message)
        {
            if (OnDispatch != null) OnDispatch(message);
        }
    }
}
