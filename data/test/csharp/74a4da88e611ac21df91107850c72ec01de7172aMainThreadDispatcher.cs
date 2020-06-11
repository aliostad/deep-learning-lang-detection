using System;
using System.Collections.Generic;
using System.Threading;
using Tools;
using UnityEngine;
namespace Frankfort.Threading.Internal
{
	public static class MainThreadDispatcher
	{
		private static TSafeQueue<DispatchAction> dispatchActions = new TSafeQueue<DispatchAction>();
		private static bool helperCreated;
		public static int currentFrame = 0;
		private static TSafeQueue<Action> _actions = new TSafeQueue<Action>();
		private static List<DelayedQueueItem> _delayed = new List<DelayedQueueItem>();
		private static List<DelayedQueueItem> _currentDelayed = new List<DelayedQueueItem>();
		public static bool IsEnable
		{
			get
			{
				bool flag = MainThreadDispatcher.dispatchActions == null || MainThreadDispatcher.dispatchActions.Count < 1;
				return !flag;
			}
		}
		public static void QueueOnMainThread(Action action)
		{
			MainThreadDispatcher.QueueOnMainThread(action, 0f);
		}
		public static void QueueOnMainThread(Action action, float time)
		{
			bool flag = time != 0f;
			if (flag)
			{
				List<DelayedQueueItem> delayed = MainThreadDispatcher._delayed;
				Monitor.Enter(delayed);
				try
				{
					MainThreadDispatcher._delayed.Add(new DelayedQueueItem
					{
						time = Time.time + time,
						action = action
					});
				}
				finally
				{
					Monitor.Exit(delayed);
				}
			}
			else
			{
				MainThreadDispatcher._actions.Enqueue(action);
			}
		}
		public static void RunActioin()
		{
			bool flag = MainThreadDispatcher._actions.Count < 1;
			if (!flag)
			{
				Action action = MainThreadDispatcher._actions.Dequeue();
				bool flag2 = action != null;
				if (flag2)
				{
					action();
				}
			}
		}
		public static void RunDelayAction()
		{
			bool flag = MainThreadDispatcher._delayed.Count < 1;
			if (!flag)
			{
				List<DelayedQueueItem> delayed = MainThreadDispatcher._delayed;
				Monitor.Enter(delayed);
				try
				{
					MainThreadDispatcher._currentDelayed.Clear();
					int num;
					for (int i = 0; i < MainThreadDispatcher._delayed.Count; i = num + 1)
					{
						DelayedQueueItem delayedQueueItem = MainThreadDispatcher._delayed[i];
						bool flag2 = delayedQueueItem.time <= Time.time;
						if (flag2)
						{
							MainThreadDispatcher._currentDelayed.Add(delayedQueueItem);
						}
						num = i;
					}
					for (int j = 0; j < MainThreadDispatcher._currentDelayed.Count; j = num + 1)
					{
						DelayedQueueItem item = MainThreadDispatcher._currentDelayed[j];
						MainThreadDispatcher._delayed.Remove(item);
						num = j;
					}
					for (int k = 0; k < MainThreadDispatcher._currentDelayed.Count; k = num + 1)
					{
						DelayedQueueItem delayedQueueItem2 = MainThreadDispatcher._currentDelayed[k];
						delayedQueueItem2.action();
						num = k;
					}
				}
				finally
				{
					Monitor.Exit(delayed);
				}
			}
		}
		public static void Init()
		{
			bool flag = !MainThreadDispatcher.helperCreated;
			if (flag)
			{
				MainThreadDispatcher.CreateHelperGameObject();
			}
		}
		private static void CreateHelperGameObject()
		{
			GameObject gameObject = new GameObject("MainThreadDispatchHelper");
			MainThreadDispatchHelper mainThreadDispatchHelper = gameObject.AddComponent<MainThreadDispatchHelper>();
            UnityEngine.Object arg_1F_0 = mainThreadDispatchHelper;
			gameObject.hideFlags = HideFlags.HideInInspector;
			arg_1F_0.hideFlags = HideFlags.HideInInspector;
            UnityEngine.Object.DontDestroyOnLoad(gameObject);
			MainThreadDispatcher.helperCreated = true;
		}
		public static void DispatchActionsIfPresent()
		{
			bool isEnable = MainThreadDispatcher.IsEnable;
			if (isEnable)
			{
				DispatchAction dispatchAction = MainThreadDispatcher.dispatchActions.Dequeue();
				bool flag = !dispatchAction.Executed;
				if (flag)
				{
					dispatchAction.ExecuteDispatch();
				}
			}
		}
		public static void DispatchToMainThread(CallBack dispatchCall, bool waitForExecution = false, bool safeMode = true)
		{
			bool flag = MainThreadWatchdog.CheckIfMainThread();
			if (flag)
			{
				bool flag2 = dispatchCall != null;
				if (flag2)
				{
					dispatchCall();
				}
			}
			else
			{
				ThreadDispatchAction<object> threadDispatchAction = new ThreadDispatchAction<object>();
				MainThreadDispatcher.dispatchActions.Enqueue(threadDispatchAction);
				threadDispatchAction.Init(dispatchCall, waitForExecution, safeMode);
			}
		}
		public static void DispatchToMainThread<T>(CallBackArg<T> dispatchCall, T dispatchArgument, bool waitForExecution = false, bool safeMode = true)
		{
			bool flag = MainThreadWatchdog.CheckIfMainThread();
			if (flag)
			{
				bool flag2 = dispatchCall != null;
				if (flag2)
				{
					dispatchCall(dispatchArgument);
				}
			}
			else
			{
				ThreadDispatchAction<T> threadDispatchAction = new ThreadDispatchAction<T>();
				MainThreadDispatcher.dispatchActions.Enqueue(threadDispatchAction);
				threadDispatchAction.Init(dispatchCall, dispatchArgument, waitForExecution, safeMode);
			}
		}
		public static object DispatchToMainThreadReturn<T>(CallBackArgRturn<T> dispatchCall, T dispatchArgument, bool safeMode = true)
		{
			bool flag = MainThreadWatchdog.CheckIfMainThread();
			object result;
			if (flag)
			{
				bool flag2 = dispatchCall != null;
				if (flag2)
				{
					result = dispatchCall(dispatchArgument);
				}
				else
				{
					result = null;
				}
			}
			else
			{
				ThreadDispatchAction<T> threadDispatchAction = new ThreadDispatchAction<T>();
				MainThreadDispatcher.dispatchActions.Enqueue(threadDispatchAction);
				threadDispatchAction.Init(dispatchCall, dispatchArgument, safeMode);
				result = threadDispatchAction.dispatchExecutionResult;
			}
			return result;
		}
		public static object DispatchToMainThreadReturn(CallBackReturn dispatchCall, bool safeMode = true)
		{
			bool flag = MainThreadWatchdog.CheckIfMainThread();
			object result;
			if (flag)
			{
				bool flag2 = dispatchCall != null;
				if (flag2)
				{
					result = dispatchCall();
				}
				else
				{
					result = null;
				}
			}
			else
			{
				ThreadDispatchAction<object> threadDispatchAction = new ThreadDispatchAction<object>();
				MainThreadDispatcher.dispatchActions.Enqueue(threadDispatchAction);
				threadDispatchAction.Init(dispatchCall, safeMode);
				result = threadDispatchAction.dispatchExecutionResult;
			}
			return result;
		}
		public static T DispatchToMainThreadReturn<T>(CallBackReturn<T> dispatchCall, bool safeMode = true)
		{
			bool flag = MainThreadWatchdog.CheckIfMainThread();
			T result;
			if (flag)
			{
				bool flag2 = dispatchCall != null;
				if (flag2)
				{
					result = dispatchCall();
				}
				else
				{
					result = default(T);
				}
			}
			else
			{
				ThreadDispatchAction<T> threadDispatchAction = new ThreadDispatchAction<T>();
				MainThreadDispatcher.dispatchActions.Enqueue(threadDispatchAction);
				threadDispatchAction.Init(dispatchCall, safeMode);
				result = threadDispatchAction.dispatchExecutionResult2;
			}
			return result;
		}
	}
}
