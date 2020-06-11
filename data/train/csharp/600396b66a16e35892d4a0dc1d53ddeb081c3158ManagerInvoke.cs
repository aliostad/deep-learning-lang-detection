using System;
using System.Threading;
using System.Threading.Tasks;

namespace InvokeCount
{
    public class ManagerInvoke
    {
        public TimeSpan TimeInvoke { get; }//part interval
        public TimeSpan Interval { get; }//all interval

        private bool firstSet;
        private int countInvokeMethod;
        private int countInvokeMethodInInterval;
        private long symInvokeMethodInInterval;
        private StatisticStructure statisticStructure;
        private Task taskInternal;
        private Task taskExternal;
        private CancellationTokenSource cancelTokenSource;
        private CancellationToken cancellationToken;

        public ManagerInvoke(TimeSpan timeInvoke, TimeSpan interval)
        {
            TimeInvoke = timeInvoke;
            Interval = interval;
            statisticStructure = new StatisticStructure();
            firstSet = true;
        }
        public void Invoke()
        {
            Interlocked.Increment(ref countInvokeMethod);
        }
        public void Start()
        {
            countInvokeMethod = 0;
            cancelTokenSource = new CancellationTokenSource();
            cancellationToken = cancelTokenSource.Token;
            taskInternal = Task.Factory.StartNew(TimeInvokeDispatcher);
            taskExternal = Task.Factory.StartNew(IntervalDispatcher);
        }
        public void Stop()
        {
            cancelTokenSource.Cancel();
            firstSet = false;
            countInvokeMethod = 0;
            countInvokeMethodInInterval = 0;
            symInvokeMethodInInterval = 0;
        }
        private async void TimeInvokeDispatcher()
        {
            try { await Task.Delay(TimeInvoke, cancellationToken); }
            catch (TaskCanceledException e) { return; }

            ProccessInvoke();
            TimeInvokeDispatcher();
        }
        private async void IntervalDispatcher()
        {

            try { await Task.Delay(Interval, cancellationToken); }
            catch (TaskCanceledException e) { return; }
            InvokeCountedValue();

            IntervalDispatcher();
        }

        private void ProccessInvoke()
        {
            lock (statisticStructure)
            {
                StatisticProcces(countInvokeMethod);
                OnCountInvoke(countInvokeMethod);
                countInvokeMethod = 0;
            }
        }

        private void InvokeCountedValue()
        {
            lock (statisticStructure)
            {
                ProccesMiddleValue();
                OnStatistic(statisticStructure);
                statisticStructure.MiddleCountInvoke = 0;
                statisticStructure.MinCountInvoke = 0;
                statisticStructure.MaxCountInvoke = 0;
                symInvokeMethodInInterval = 0;
                countInvokeMethodInInterval = 0;
            }
            firstSet = true;
        }

        private void ProccesMiddleValue()
        {
            if (countInvokeMethodInInterval != 0)
                statisticStructure.MiddleCountInvoke = ((double)symInvokeMethodInInterval /
                                                        countInvokeMethodInInterval);
        }

        private void StatisticProcces(int count)
        {
            FindMinMax(count);
            symInvokeMethodInInterval += count;
            Interlocked.Increment(ref countInvokeMethodInInterval);
        }

        private void FindMinMax(int count)
        {
            if (firstSet)
            {
                statisticStructure.MinCountInvoke = count;
                firstSet = false;
            }
            if (count < statisticStructure.MinCountInvoke)
                statisticStructure.MinCountInvoke = count;
            if (count > statisticStructure.MaxCountInvoke)
                statisticStructure.MaxCountInvoke = count;
        }

        public event EventHandler<int> CountInvoke;
        public event EventHandler<StatisticStructure> Statistic;

        protected virtual void OnCountInvoke(int e)
        {
            CountInvoke?.Invoke(this, e);
        }
        protected virtual void OnStatistic(StatisticStructure e)
        {
            Statistic?.Invoke(this, e);
        }
    }
}