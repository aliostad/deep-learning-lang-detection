using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace CommonSupport
{
    /// <summary>
    /// The Invoke watch mechanism looks after blocked "Invoke"s.
    /// </summary>
    internal class InvokeWatchDog
    {
        System.Timers.Timer _invokeWatchTimer = new System.Timers.Timer(250);

        List<WinFormsHelper.AsyncResultInfo> _invokeResults = new List<WinFormsHelper.AsyncResultInfo>();

        /// <summary>
        /// Constructor.
        /// </summary>
        public InvokeWatchDog()
        {
        }
        
        /// <summary>
        /// 
        /// </summary>
        ~InvokeWatchDog()
        {
            _invokeWatchTimer.Stop();
            _invokeWatchTimer = null;

            // Final warning is useless since the application is closing already and controls do not respond.
            //lock (InvokeResults)
            //{
            //    if (InvokeResults.Count > 0)
            //    {
            //        SystemMonitor.Warning("A total of [" + InvokeResults.Count + "] blocked/incomplete invokes were found.");
            //    }
            //}
        }

        /// <summary>
        /// Start the watchdog operation.
        /// </summary>
        public void Start()
        {
            lock (this)
            {
                _invokeWatchTimer.Elapsed += new System.Timers.ElapsedEventHandler(_invokeWatchTimer_Elapsed);
                _invokeWatchTimer.Start();
            }
        }

        public void Add(WinFormsHelper.AsyncResultInfo info)
        {
            if (_invokeWatchTimer.Enabled)
            {
                lock (this)
                {
                    _invokeResults.Add(info);
                }
            }
        }

        void _invokeWatchTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            lock (this)
            {
                DateTime now = DateTime.Now;
                for (int i = _invokeResults.Count - 1; i >= 0; i--)
                {
                    if (_invokeResults[i].AsyncResult.IsCompleted)
                    {
                        _invokeResults.RemoveAt(i);
                    }
                    else
                        if ((now - _invokeResults[i].PublishTime).TotalSeconds > 10)
                        {
                            SystemMonitor.Warning("Blocked invoke [" + _invokeResults[i].MethodName + "]");
                            _invokeResults.RemoveAt(i);
                        }
                }
            }
        }
    }
}
