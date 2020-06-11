namespace Frankfort.Threading.Internal
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using UnityEngine;
    using ZYSGameFramework.Util;

    public static class MainThreadDispatcher
    {
        private static SafeQueue<Action> _actions = new SafeQueue<Action>();
        private static List<DelayedQueueItem> _currentDelayed = new List<DelayedQueueItem>();
        private static List<DelayedQueueItem> _delayed = new List<DelayedQueueItem>();
        public static int currentFrame = 0;
        private static SafeQueue<DispatchAction> dispatchActions = new SafeQueue<DispatchAction>();
        private static bool helperCreated;

        private static void CreateHelperGameObject()
        {
            GameObject target = new GameObject("MainThreadDispatchHelper");
            target.AddComponent<MainThreadDispatchHelper>().hideFlags = target.hideFlags = HideFlags.HideInInspector | HideFlags.HideInHierarchy;
            UnityEngine.Object.DontDestroyOnLoad(target);
            helperCreated = true;
        }

        public static void DispatchActionsIfPresent()
        {
            if (IsEnable)
            {
                DispatchAction action = dispatchActions.Dequeue();
                if (!action.Executed)
                {
                    action.ExecuteDispatch();
                }
            }
        }

        public static void DispatchToMainThread(CallBack dispatchCall, bool waitForExecution = false, bool safeMode = true)
        {
            if (MainThreadWatchdog.CheckIfMainThread())
            {
                if (dispatchCall != null)
                {
                    dispatchCall();
                }
            }
            else
            {
                ThreadDispatchAction<object> t = new ThreadDispatchAction<object>();
                dispatchActions.Enqueue(t);
                t.Init(dispatchCall, waitForExecution, safeMode);
            }
        }

        public static void DispatchToMainThread<T>(CallBackArg<T> dispatchCall, T dispatchArgument, bool waitForExecution = false, bool safeMode = true)
        {
            if (MainThreadWatchdog.CheckIfMainThread())
            {
                if (dispatchCall != null)
                {
                    dispatchCall(dispatchArgument);
                }
            }
            else
            {
                ThreadDispatchAction<T> t = new ThreadDispatchAction<T>();
                dispatchActions.Enqueue(t);
                t.Init(dispatchCall, dispatchArgument, waitForExecution, safeMode);
            }
        }

        public static object DispatchToMainThreadReturn(CallBackReturn dispatchCall, bool safeMode = true)
        {
            if (MainThreadWatchdog.CheckIfMainThread())
            {
                if (dispatchCall != null)
                {
                    return dispatchCall();
                }
            }
            else
            {
                ThreadDispatchAction<object> t = new ThreadDispatchAction<object>();
                dispatchActions.Enqueue(t);
                t.Init(dispatchCall, safeMode);
                return t.dispatchExecutionResult;
            }
            return null;
        }

        public static T DispatchToMainThreadReturn<T>(CallBackReturn<T> dispatchCall, bool safeMode = true)
        {
            if (MainThreadWatchdog.CheckIfMainThread())
            {
                if (dispatchCall != null)
                {
                    return dispatchCall();
                }
            }
            else
            {
                ThreadDispatchAction<T> t = new ThreadDispatchAction<T>();
                dispatchActions.Enqueue(t);
                t.Init(dispatchCall, safeMode);
                return t.dispatchExecutionResult2;
            }
            return default(T);
        }

        public static object DispatchToMainThreadReturn<T>(CallBackArgRturn<T> dispatchCall, T dispatchArgument, bool safeMode = true)
        {
            if (MainThreadWatchdog.CheckIfMainThread())
            {
                if (dispatchCall != null)
                {
                    return dispatchCall(dispatchArgument);
                }
            }
            else
            {
                ThreadDispatchAction<T> t = new ThreadDispatchAction<T>();
                dispatchActions.Enqueue(t);
                t.Init(dispatchCall, dispatchArgument, safeMode);
                return t.dispatchExecutionResult;
            }
            return null;
        }

        public static void Init()
        {
            if (!helperCreated)
            {
                CreateHelperGameObject();
            }
        }

        public static void QueueOnMainThread(Action action)
        {
            QueueOnMainThread(action, 0f);
        }

        public static void QueueOnMainThread(Action action, float time)
        {
            if (time != 0f)
            {
                List<DelayedQueueItem> list = _delayed;
                lock (list)
                {
                    DelayedQueueItem item = new DelayedQueueItem {
                        time = Time.time + time,
                        action = action
                    };
                    _delayed.Add(item);
                }
            }
            else
            {
                _actions.Enqueue(action);
            }
        }

        public static void RunActioin()
        {
            if (_actions.Count >= 1)
            {
                Action action = _actions.Dequeue();
                if (action != null)
                {
                    action();
                }
            }
        }

        public static void RunDelayAction()
        {
            if (_delayed.Count >= 1)
            {
                List<DelayedQueueItem> list = _delayed;
                lock (list)
                {
                    int num2;
                    _currentDelayed.Clear();
                    for (int i = 0; i < _delayed.Count; i = num2 + 1)
                    {
                        DelayedQueueItem item = _delayed[i];
                        if (item.time <= Time.time)
                        {
                            _currentDelayed.Add(item);
                        }
                        num2 = i;
                    }
                    for (int j = 0; j < _currentDelayed.Count; j = num2 + 1)
                    {
                        DelayedQueueItem item2 = _currentDelayed[j];
                        _delayed.Remove(item2);
                        num2 = j;
                    }
                    for (int k = 0; k < _currentDelayed.Count; k = num2 + 1)
                    {
                        DelayedQueueItem item3 = _currentDelayed[k];
                        item3.action();
                        num2 = k;
                    }
                }
            }
        }

        public static bool IsEnable
        {
            get
            {
                if ((dispatchActions == null) || (dispatchActions.Count < 1))
                {
                    return false;
                }
                return true;
            }
        }
    }
}

