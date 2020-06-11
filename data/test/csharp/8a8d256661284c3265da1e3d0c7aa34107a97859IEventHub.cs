using System;
using System.Linq;
using System.Text;
using System.Threading;
using System.Collections.Generic;

namespace NthDeveloper.AppFramework.Events
{
    public interface IEventHub
    {
        SynchronizationContext SynchronizationContext { get; set; }

        int GetSubscriberCount(Type type);
        void Publish<T>();
        void Publish<T>(T eventData);
        void Publish<T>(T eventData, InvokeOption invokeOption);
        void Reset();
        void Subscribe<T>(Action<T> handler);
        void Subscribe<T>(Action<T> handler, InvokeOption invokeOption);
        void Subscribe<T>(Action<T> handler, InvokeOption invokeOption, InvokePriority priority);
        void Subscribe<T>(Action<T> handler, InvokeOption invokeOption, InvokePriority priority, int delay);
        void Subscribe<T>(Action<T> handler, InvokeOption invokeOption, int delay);
        void Unsubscribe<T>(Action<T> handler);
    }

    public enum InvokeOption
    {
        ThreadPool,
        UIThread,
        Blocking,
    }

    public enum InvokePriority
    {
        Lowest,
        Low,
        Normal,
        High,
        Highest
    }
}
