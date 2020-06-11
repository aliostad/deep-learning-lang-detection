using System;
using System.Windows.Threading;

namespace TestCoverageVsPlugin
{
    public class VsDispatchTimer:ITimer
    {
        private DispatcherTimer _dispatchTimer =new DispatcherTimer();
        private Action _action;

        public VsDispatchTimer()
        {           
            _dispatchTimer.Tick += Elapsed;
        }
        public void Schedule(int millisecondsFromNow, Action action)
        {
            _dispatchTimer.Interval = TimeSpan.FromMilliseconds(millisecondsFromNow);
            _action = action;
            _dispatchTimer.Stop();
            _dispatchTimer.Start();

        }

        private void Elapsed(object sender, EventArgs e)
        {
            _dispatchTimer.Stop();
            _action();
            _action = null;
        }
    }
}