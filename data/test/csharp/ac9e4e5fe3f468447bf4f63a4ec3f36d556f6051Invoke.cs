using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace Intact.ParallelLib
{    
    internal class Invoke : ParallelConstruct
    {
        private WaitHandle[] waitHandles;

        #region public InvokeExecution()

        public Invoke()
        {
            ThreadPool.SetMaxThreads(processorCount, processorCount);
            waitHandles = new WaitHandle[processorCount];
        }

        #endregion

        public void InvokeExecution(params InvokeAction[] actions)
        {
            chunk = (actions.Length) / processorCount;
            int start = 0;
            int end = chunk;

            for (int i = 1; i <= processorCount; i++)
            {
                int x = i - 1;
                waitHandles[x] = new ManualResetEvent(false);
                InvokePart invokePart = new InvokePart();
                for(int j = start; j <= end; j++)
                    invokePart.InvokationParts.Add(actions[j]);
                ConstantInvokeSynchronisationContainer invokeSynchronisationContainer =
                    new ConstantInvokeSynchronisationContainer((ManualResetEvent)waitHandles[x], invokePart);
                ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        ConstantInvokeSynchronisationContainer localinvokeSynchronisationContainer = (ConstantInvokeSynchronisationContainer)state;
                        InvokePart localInvokePart = localinvokeSynchronisationContainer.InvokePart_;
                        try
                        {
                            foreach (InvokeAction invokeAction in localInvokePart.InvokationParts)
                            {
                                invokeAction.Invoke();
                            }                                               
                        }
                        finally
                        {
                            localinvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, invokeSynchronisationContainer);
                start = end + 1;
                end = end + chunk;
            }
            WaitHandle.WaitAll(waitHandles);
        }

        public void InvokeExecution(ExecutionConstancyEnum executionConstancy, InvokeAction[] actions)
        {
            if (executionConstancy == ExecutionConstancyEnum.Constant)
            {
                InvokeExecution(actions);
            }
            else
            {
                ParallelQueue<InvokePart>[] parallelQueues = new ParallelQueue<InvokePart>[processorCount];
                chunk = (actions.Length) / processorCount;
                int start = 0;
                int end = chunk;

                for (int i = 1; i <= processorCount; i++)
                {
                    int x = i - 1;
                    waitHandles[x] = new ManualResetEvent(false);
                    ParallelQueueFiller parallelQueueFiller = new ParallelQueueFiller();
                    List<InvokeAction> perProcessorInvokeActions = new List<InvokeAction>();
                    for (int j = start; j <= end; j++)
                    {
                        perProcessorInvokeActions.Add(actions[j]);
                    }
                    ParallelQueue<InvokePart> parallelQueue = parallelQueueFiller.FillWithInvoke(perProcessorInvokeActions.ToArray());
                    parallelQueues[x] = parallelQueue;
                    UnconstantInvokeSynchronisationContainer unconstantInvokeSynchronisationContainer =
                        new UnconstantInvokeSynchronisationContainer((ManualResetEvent)waitHandles[x], parallelQueue, parallelQueues);
                    ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        UnconstantInvokeSynchronisationContainer localUnconstantInvokeSynchronisationContainer =
                            (UnconstantInvokeSynchronisationContainer)state;
                        ParallelQueue<InvokePart> localparallelQueue = localUnconstantInvokeSynchronisationContainer.ParallelQueue;
                        ParallelQueue<InvokePart>[] localparallelQueues = localUnconstantInvokeSynchronisationContainer.ParallelQueues;
                        try
                        {
                            bool localQueueIsEmpty = false;
                            while (!localQueueIsEmpty)
                            {
                                InvokePart invokePart = localparallelQueue.Dequeue();
                                if (invokePart != null)
                                {
                                    foreach (InvokeAction localInvokeAction in invokePart.InvokationParts)
                                    {
                                        localInvokeAction.Invoke();
                                    }
                                }
                                else
                                {
                                    localQueueIsEmpty = true;
                                }
                            }
                            foreach (ParallelQueue<InvokePart> localForegnParallelQueue in localparallelQueues)
                            {
                                if (localForegnParallelQueue != localparallelQueue)
                                {
                                    bool localForegnQueueIsEmpty = false;
                                    while (!localForegnQueueIsEmpty)
                                    {
                                        InvokePart invokePart = localForegnParallelQueue.Steal();
                                        if (invokePart != null)
                                        {
                                            foreach (InvokeAction localInvokeAction in invokePart.InvokationParts)
                                            {
                                                localInvokeAction.Invoke();
                                            }
                                        }
                                        else
                                        {
                                            localForegnQueueIsEmpty = true;
                                        }
                                    }
                                }
                            }
                        }
                        finally
                        {
                            localUnconstantInvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, unconstantInvokeSynchronisationContainer);
                    start = end + 1;
                    end = end + chunk;
                }
                WaitHandle.WaitAll(waitHandles);
            }
        }

        public void InvokeExecution<T>(T value, params InvokeAction<T>[] actions)
        {
            chunk = (actions.Length) / processorCount;
            int start = 0;
            int end = chunk;

            for (int i = 1; i <= processorCount; i++)
            {
                int x = i - 1;
                waitHandles[x] = new ManualResetEvent(false);
                InvokePart<T> invokePart = new InvokePart<T>();
                invokePart.Value = value;
                for (int j = start; j <= end; j++)
                    invokePart.InvokationParts.Add(actions[j]);
                ConstantInvokeSynchronisationContainer<T> invokeSynchronisationContainer =
                    new ConstantInvokeSynchronisationContainer<T>((ManualResetEvent)waitHandles[x], invokePart);
                ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        ConstantInvokeSynchronisationContainer<T> localinvokeSynchronisationContainer = (ConstantInvokeSynchronisationContainer<T>)state;
                        InvokePart<T> localInvokePart = localinvokeSynchronisationContainer.InvokePart_;
                        try
                        {
                            foreach (InvokeAction<T> invokeAction in localInvokePart.InvokationParts)
                            {
                                invokeAction.Invoke(localInvokePart.Value);
                            }
                        }
                        finally
                        {
                            localinvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, invokeSynchronisationContainer);
                start = end + 1;
                end = end + chunk;
            }
            WaitHandle.WaitAll(waitHandles);
        }

        public void InvokeExecution<T>(T value, ExecutionConstancyEnum executionConstancy, InvokeAction<T>[] actions)
        {
            if (executionConstancy == ExecutionConstancyEnum.Constant)
            {
                InvokeExecution<T>(value, actions);
            }
            else
            {
                ParallelQueue<InvokePart<T>>[] parallelQueues = new ParallelQueue<InvokePart<T>>[processorCount];
                chunk = (actions.Length) / processorCount;
                int start = 0;
                int end = chunk;

                for (int i = 1; i <= processorCount; i++)
                {
                    int x = i - 1;
                    waitHandles[x] = new ManualResetEvent(false);
                    ParallelQueueFiller parallelQueueFiller = new ParallelQueueFiller();
                    List<InvokeAction<T>> perProcessorInvokeActions = new List<InvokeAction<T>>();
                    for (int j = start; j <= end; j++)
                    {
                        perProcessorInvokeActions.Add(actions[j]);
                    }
                    ParallelQueue<InvokePart<T>> parallelQueue = parallelQueueFiller.FillWithInvoke<T>(perProcessorInvokeActions.ToArray(), value);
                    parallelQueues[x] = parallelQueue;
                    UnconstantInvokeSynchronisationContainer<T> unconstantInvokeSynchronisationContainer =
                        new UnconstantInvokeSynchronisationContainer<T>((ManualResetEvent)waitHandles[x], parallelQueue, parallelQueues);
                    ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        UnconstantInvokeSynchronisationContainer<T> localUnconstantInvokeSynchronisationContainer =
                            (UnconstantInvokeSynchronisationContainer<T>)state;
                        ParallelQueue<InvokePart<T>> localparallelQueue = localUnconstantInvokeSynchronisationContainer.ParallelQueue;
                        ParallelQueue<InvokePart<T>>[] localparallelQueues = localUnconstantInvokeSynchronisationContainer.ParallelQueues;
                        try
                        {
                            bool localQueueIsEmpty = false;
                            while (!localQueueIsEmpty)
                            {
                                InvokePart<T> invokePart = localparallelQueue.Dequeue();
                                if (invokePart != null)
                                {
                                    foreach (InvokeAction<T> localInvokeAction in invokePart.InvokationParts)
                                    {
                                        localInvokeAction.Invoke(invokePart.Value);
                                    }
                                }
                                else
                                {
                                    localQueueIsEmpty = true;
                                }
                            }
                            foreach (ParallelQueue<InvokePart<T>> localForegnParallelQueue in localparallelQueues)
                            {
                                if (localForegnParallelQueue != localparallelQueue)
                                {
                                    bool localForegnQueueIsEmpty = false;
                                    while (!localForegnQueueIsEmpty)
                                    {
                                        InvokePart<T> invokePart = localForegnParallelQueue.Steal();
                                        if (invokePart != null)
                                        {
                                            foreach (InvokeAction<T> localInvokeAction in invokePart.InvokationParts)
                                            {
                                                localInvokeAction.Invoke(invokePart.Value);
                                            }
                                        }
                                        else
                                        {
                                            localForegnQueueIsEmpty = true;
                                        }
                                    }
                                }
                            }
                        }
                        finally
                        {
                            localUnconstantInvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, unconstantInvokeSynchronisationContainer);
                    start = end + 1;
                    end = end + chunk;
                }
                WaitHandle.WaitAll(waitHandles);
            }
        }

        public void InvokeExecution<T1, T2>(T1 value1, T2 value2, params InvokeAction<T1, T2>[] actions)
        {
            chunk = (actions.Length) / processorCount;
            int start = 0;
            int end = chunk;

            for (int i = 1; i <= processorCount; i++)
            {
                int x = i - 1;
                waitHandles[x] = new ManualResetEvent(false);
                InvokePart<T1, T2> invokePart = new InvokePart<T1, T2>();
                invokePart.Value1 = value1;
                invokePart.Value2 = value2;
                for (int j = start; j <= end; j++)
                    invokePart.InvokationParts.Add(actions[j]);
                ConstantInvokeSynchronisationContainer<T1, T2> invokeSynchronisationContainer =
                    new ConstantInvokeSynchronisationContainer<T1, T2>((ManualResetEvent)waitHandles[x], invokePart);
                ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        ConstantInvokeSynchronisationContainer<T1, T2> localinvokeSynchronisationContainer = (ConstantInvokeSynchronisationContainer<T1, T2>)state;
                        InvokePart<T1, T2> localInvokePart = localinvokeSynchronisationContainer.InvokePart_;
                        try
                        {
                            foreach (InvokeAction<T1, T2> invokeAction in localInvokePart.InvokationParts)
                            {
                                invokeAction.Invoke(localInvokePart.Value1, localInvokePart.Value2);
                            }
                        }
                        finally
                        {
                            localinvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, invokeSynchronisationContainer);
                start = end + 1;
                end = end + chunk;
            }
            WaitHandle.WaitAll(waitHandles);
        }

        public void InvokeExecution<T1, T2>(T1 value1, T2 value2, ExecutionConstancyEnum executionConstancy, InvokeAction<T1, T2>[] actions)
        {
            if (executionConstancy == ExecutionConstancyEnum.Constant)
            {
                InvokeExecution<T1, T2>(value1, value2, actions);
            }
            else
            {
                ParallelQueue<InvokePart<T1, T2>>[] parallelQueues = new ParallelQueue<InvokePart<T1, T2>>[processorCount];
                chunk = (actions.Length) / processorCount;
                int start = 0;
                int end = chunk;

                for (int i = 1; i <= processorCount; i++)
                {
                    int x = i - 1;
                    waitHandles[x] = new ManualResetEvent(false);
                    ParallelQueueFiller parallelQueueFiller = new ParallelQueueFiller();
                    List<InvokeAction<T1, T2>> perProcessorInvokeActions = new List<InvokeAction<T1, T2>>();
                    for (int j = start; j <= end; j++)
                    {
                        perProcessorInvokeActions.Add(actions[j]);
                    }
                    ParallelQueue<InvokePart<T1, T2>> parallelQueue = parallelQueueFiller.FillWithInvoke<T1, T2>(perProcessorInvokeActions.ToArray(), value1, value2);
                    parallelQueues[x] = parallelQueue;
                    UnconstantInvokeSynchronisationContainer<T1, T2> unconstantInvokeSynchronisationContainer =
                        new UnconstantInvokeSynchronisationContainer<T1, T2>((ManualResetEvent)waitHandles[x], parallelQueue, parallelQueues);
                    ThreadPool.QueueUserWorkItem(
                    delegate(object state)
                    {
                        UnconstantInvokeSynchronisationContainer<T1, T2> localUnconstantInvokeSynchronisationContainer =
                            (UnconstantInvokeSynchronisationContainer<T1, T2>)state;
                        ParallelQueue<InvokePart<T1, T2>> localparallelQueue = localUnconstantInvokeSynchronisationContainer.ParallelQueue;
                        ParallelQueue<InvokePart<T1, T2>>[] localparallelQueues = localUnconstantInvokeSynchronisationContainer.ParallelQueues;
                        try
                        {
                            bool localQueueIsEmpty = false;
                            while (!localQueueIsEmpty)
                            {
                                InvokePart<T1, T2> invokePart = localparallelQueue.Dequeue();
                                if (invokePart != null)
                                {
                                    foreach (InvokeAction<T1, T2> localInvokeAction in invokePart.InvokationParts)
                                    {
                                        localInvokeAction.Invoke(invokePart.Value1, invokePart.Value2);
                                    }
                                }
                                else
                                {
                                    localQueueIsEmpty = true;
                                }
                            }
                            foreach (ParallelQueue<InvokePart<T1, T2>> localForegnParallelQueue in localparallelQueues)
                            {
                                if (localForegnParallelQueue != localparallelQueue)
                                {
                                    bool localForegnQueueIsEmpty = false;
                                    while (!localForegnQueueIsEmpty)
                                    {
                                        InvokePart<T1, T2> invokePart = localForegnParallelQueue.Steal();
                                        if (invokePart != null)
                                        {
                                            foreach (InvokeAction<T1, T2> localInvokeAction in invokePart.InvokationParts)
                                            {
                                                localInvokeAction.Invoke(invokePart.Value1, invokePart.Value2);
                                            }
                                        }
                                        else
                                        {
                                            localForegnQueueIsEmpty = true;
                                        }
                                    }
                                }
                            }
                        }
                        finally
                        {
                            localUnconstantInvokeSynchronisationContainer.ManualResetEvent_.Set();
                        }
                    }, unconstantInvokeSynchronisationContainer);
                    start = end + 1;
                    end = end + chunk;
                }
                WaitHandle.WaitAll(waitHandles);
            }
        }

    }
}
