using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading.Tasks;

namespace Discore.WebSocket.Net
{
    partial class Gateway
    {
        delegate void DispatchSynchronousCallback(DiscordApiData data);
        delegate Task DispatchAsynchronousCallback(DiscordApiData data);

        class DispatchCallback
        {
            public DispatchSynchronousCallback Synchronous { get; }
            public DispatchAsynchronousCallback Asynchronous { get; }

            public DispatchCallback(DispatchSynchronousCallback synchronous)
            {
                Synchronous = synchronous;
            }

            public DispatchCallback(DispatchAsynchronousCallback asynchronous)
            {
                Asynchronous = asynchronous;
            }
        }

        [AttributeUsage(AttributeTargets.Method)]
        class DispatchEventAttribute : Attribute
        {
            public string EventName { get; }

            public DispatchEventAttribute(string eventName)
            {
                EventName = eventName;
            }
        }

        Dictionary<string, DispatchCallback> dispatchHandlers;

        void InitializeDispatchHandlers()
        {
            dispatchHandlers = new Dictionary<string, DispatchCallback>();

            Type taskType = typeof(Task);
            Type gatewayType = typeof(Gateway);
            Type dispatchSynchronousType = typeof(DispatchSynchronousCallback);
            Type dispatchAsynchronousType = typeof(DispatchAsynchronousCallback);

            foreach (MethodInfo method in gatewayType.GetTypeInfo().GetMethods(BindingFlags.Instance | BindingFlags.NonPublic))
            {
                DispatchEventAttribute attr = method.GetCustomAttribute<DispatchEventAttribute>();
                if (attr != null)
                {
                    DispatchCallback dispatchCallback;
                    if (method.ReturnType == taskType)
                    {
                        Delegate callback = method.CreateDelegate(dispatchAsynchronousType, this);
                        dispatchCallback = new DispatchCallback((DispatchAsynchronousCallback)callback);
                    }
                    else
                    {
                        Delegate callback = method.CreateDelegate(dispatchSynchronousType, this);
                        dispatchCallback = new DispatchCallback((DispatchSynchronousCallback)callback);
                    }

                    dispatchHandlers[attr.EventName] = dispatchCallback;
                }
            }
        }
    }
}
