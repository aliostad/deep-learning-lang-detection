using System;
using System.Threading;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace BattleSystem
{
    /// <summary>
    /// Invoke(Interval in Seconds).
    /// </summary>
    public class Invoke
    {
        private static object _lock = new object();

        private int NextInvokeId = 0;
        private static Dictionary<int,InvokeHandler> InvokingList;

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.Invoke"/> class.
        /// </summary>
        private Invoke()
        {
            InvokingList = new Dictionary<int, InvokeHandler>();
        }

        static Invoke instance;

        /// <summary>
        /// Gets the Instance.
        /// </summary>
        /// <value>The instance.</value>
        static public Invoke Instance
        {
            get
            {
                lock (_lock)
                {
                    if (instance == null)
                        instance = new Invoke();
                }
                return instance;
			
            }
        }

        /// <summary>
        /// Invokes the once.
        /// </summary>
        /// <returns>The once.</returns>
        /// <param name="action">Action.</param>
        /// <param name="delay">Delay.</param>
        public int InvokeOnce(Action action, float delay)
        {
            return InvokeRepeating(action, 1, delay);
        }

        /// <summary>
        /// Invokes the repeating.
        /// </summary>
        /// <returns>The repeating.</returns>
        /// <param name="action">Action.</param>
        /// <param name="count">Count.</param>
        /// <param name="delay">Delay.</param>
        public int InvokeRepeating(Action action, int count, float delay)
        {
            return InvokeRepeating(action, count, delay, delay);
        }

        /// <summary>
        /// Invokes the repeating.
        /// </summary>
        /// <returns>The repeating.</returns>
        /// <param name="action">Action.</param>
        /// <param name="count">Count.</param>
        /// <param name="delay">Delay.</param>
        /// <param name="period">Period.</param>
        public int InvokeRepeating(Action action, int count, float delay, float period)
        {
            lock (_lock)
            {
                do
                    NextInvokeId++; while (InvokingList.ContainsKey(NextInvokeId));
            
                InvokeHandler invokeHandler = new InvokeHandler(action, count, delay, period, NextInvokeId, RemoveInvokeFromDictionary);
                InvokingList.Add(NextInvokeId, invokeHandler);
            }

//            int t1, t2;
//            ThreadPool.GetMaxThreads(out t1, out t2);
//            Debug.LogError("Worker Threads: " + t1 + ", Threads: " + t2);

            return NextInvokeId;
        }

        /// <summary>
        /// Removes the invoke from dictionary.
        /// </summary>
        /// <param name="invokeId">Invoke identifier.</param>
        private void RemoveInvokeFromDictionary(int invokeId)
        {
            lock (_lock)
            {
                if (InvokingList.ContainsKey(invokeId))
                    InvokingList.Remove(invokeId);
//                Debug.LogError("InvokingList: " + InvokingList.Count);
            }
        }

        /// <summary>
        /// Stops the invoke.
        /// </summary>
        /// <param name="invokeId">Invoke identifier.</param>
        public void StopInvoke(int invokeId)
        {
            lock (_lock)
            {
                if (InvokingList.ContainsKey(invokeId))
                {
                    InvokeHandler invokeHandler = InvokingList [invokeId];
                    invokeHandler.DestroyInvoke();
                }
            }
        }

        /// <summary>
        /// Gets the invoke handler.
        /// </summary>
        /// <returns>The invoke handler.</returns>
        /// <param name="invokeId">Invoke identifier.</param>
        public InvokeHandler GetInvokeHandler(int invokeId)
        {
            lock (_lock)
            {
                if (InvokingList.ContainsKey(invokeId))
                    return InvokingList [invokeId];
            }
            return null;
        }

        /// <summary>
        /// Changes the period.
        /// </summary>
        /// <param name="invokeId">Invoke identifier.</param>
        /// <param name="period">Period.</param>
        public void ChangePeriod(int invokeId, float period)
        {
            ChangePeriod(invokeId, period, period);
        }

        /// <summary>
        /// Changes the period.
        /// </summary>
        /// <param name="invokeId">Invoke identifier.</param>
        /// <param name="delay">Delay.</param>
        /// <param name="period">Period.</param>
        public void ChangePeriod(int invokeId, float delay, float period)
        {
            lock (_lock)
            {
                if (InvokingList.ContainsKey(invokeId))
                {
                    InvokeHandler invokeHandler = InvokingList [invokeId];
                    invokeHandler.ChangePeriod(delay, period);
                }
            }
        }

        /// <summary>
        /// Removes all invokes.
        /// </summary>
        public void RemoveAllInvokes()
        {
            lock (_lock)
            {
                while (InvokingList.Count > 0)
                    InvokingList.Values.Last().DestroyInvoke();

                System.GC.Collect();
            }
        }

        /// <summary>
        /// Releases unmanaged resources and performs other cleanup operations before the
        /// <see cref="BattleSystem.Invoke"/> is reclaimed by garbage collection.
        /// </summary>
        ~Invoke()
        {
//            Debug.LogError("~Invoke");
//            RemoveAllInvokes();
        }
    }

    public class InvokeHandler
    {
        private int InvokeId;
        private Action<int> OnInvokeDestroy;

        private AutoResetEvent autoEvent;
        private InvokeChecker statusChecker;
        private Timer stateTimer;

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.InvokeHandler"/> class.
        /// </summary>
        /// <param name="action">Action.</param>
        /// <param name="delay">Delay.</param>
        /// <param name="invokeId">Invoke identifier.</param>
        /// <param name="onInvokeDestroy">On invoke destroy.</param>
        public InvokeHandler(Action action, float delay, int invokeId, Action<int> onInvokeDestroy):this(action,1,delay,invokeId,onInvokeDestroy)
        {

        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.InvokeHandler"/> class.
        /// </summary>
        /// <param name="action">Action.</param>
        /// <param name="count">Count.</param>
        /// <param name="delay">Delay.</param>
        /// <param name="invokeId">Invoke identifier.</param>
        /// <param name="onInvokeDestroy">On invoke destroy.</param>
        public InvokeHandler(Action action, int count, float delay, int invokeId, Action<int> onInvokeDestroy):this(action,count,delay,delay,invokeId,onInvokeDestroy)
        {

        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.InvokeHandler"/> class.
        /// </summary>
        /// <param name="action">Action.</param>
        /// <param name="count">Count.</param>
        /// <param name="delay">Delay.</param>
        /// <param name="period">Period.</param>
        /// <param name="invokeId">Invoke identifier.</param>
        /// <param name="onInvokeDestroy">On invoke destroy.</param>
        public InvokeHandler(Action action, int count, float delay, float period, int invokeId, Action<int> onInvokeDestroy)
        {
            InvokeId = invokeId;
            OnInvokeDestroy = onInvokeDestroy;

            autoEvent = new AutoResetEvent(false);
		
            statusChecker = new InvokeChecker(count, action, DestroyInvoke);
		
            // Create an inferred delegate that invokes methods for the timer.
            TimerCallback tcb = statusChecker.CheckStatus;

            // Create a timer that signals the delegate to invoke 
            Console.WriteLine("{0} Creating timer.\n", 
		                  DateTime.Now.ToString("h:mm:ss.fff"));

            stateTimer = new Timer(tcb, autoEvent, new TimeSpan((long)(TimeSpan.TicksPerSecond * delay)), new TimeSpan((long)(TimeSpan.TicksPerSecond * period)));
        }

        /// <summary>
        /// Changes the Period of Invoke.
        /// </summary>
        /// <param name="period">Period(Seconds).</param>
        public void ChangePeriod(float period)
        {
            ChangePeriod(period, period);
        }

        /// <summary>
        /// Changes the Period of Invoke.
        /// </summary>
        /// <param name="delay">Delay(Seconds).</param>
        /// <param name="period">Period(Seconds).</param>
        public void ChangePeriod(float delay, float period)
        {
            stateTimer.Change(new TimeSpan((long)(TimeSpan.TicksPerSecond * delay)), new TimeSpan((long)(TimeSpan.TicksPerSecond * period)));
        }

        public void DestroyInvoke()
        {
//            Debug.LogError("DestroyInvoke");
            stateTimer.Dispose();
            if (OnInvokeDestroy != null)
                OnInvokeDestroy(InvokeId);

        }
    }

    /// <summary>
    /// Invoke checker.
    /// </summary>
    class InvokeChecker
    {
        private int invokeCount;
        private int  maxCount;

        Action action;
        Action onInvokeEnd;

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.InvokeChecker"/> class.
        /// </summary>
        /// <param name="count">Repeat Count. Set -1 for Infinite.</param>
        /// <param name="onInvokeEnd">On invoke end.</param>
        public InvokeChecker(int count, Action onInvokeEnd)
        {
            invokeCount = 0;
            maxCount = count;
            this.onInvokeEnd = onInvokeEnd;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BattleSystem.InvokeChecker"/> class.
        /// </summary>
        /// <param name="count">Repeat Count. Set -1 for Infinite.</param>
        /// <param name="action">Function to Execute.</param>
        /// <param name="onInvokeEnd">On invoke end.</param>
        public InvokeChecker(int count, Action action, Action onInvokeEnd):this(count,onInvokeEnd)
        {
            this.action = action;
        }
	
        /// <summary>
        /// Checks the status. This method is called by the timer delegate.
        /// </summary>
        /// <param name="stateInfo">State info.</param>
        public void CheckStatus(System.Object stateInfo)
        {
            AutoResetEvent autoEvent = (AutoResetEvent)stateInfo;
            invokeCount++;
//            Console.WriteLine("{0} Checking status {1,2}.", 
//		                  DateTime.Now.ToString("h:mm:ss.fff"), 
//                              (invokeCount).ToString());
//            Debug.Log(string.Format("{0} Checking status {1,2}.",
//                DateTime.Now.ToString("h:mm:ss.fff"),
//                (invokeCount).ToString()));

            if (invokeCount == maxCount)
            {
                if (onInvokeEnd != null)
                    onInvokeEnd();
                // Reset the counter and signal Main.
                //invokeCount = 0;
                //autoEvent.Set();
            }

            try
            {
                if (action != null)
                    action();
//                if (!Application.isPlaying)
//                    Invoke.Instance.RemoveAllInvokes();
            } catch (Exception ex)
            {
                Console.WriteLine("Exception in Invoking: " + ex.ToString());
            }
        }
    }
}