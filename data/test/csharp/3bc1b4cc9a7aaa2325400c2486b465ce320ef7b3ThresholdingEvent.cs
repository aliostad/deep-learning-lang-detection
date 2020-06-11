namespace BoardKings.Utils.ThresholdingEvent
{
    using BoardKings.Utils.DelayDispatch;
    using JellyTools.Extensions;
    using System;
    using System.Runtime.CompilerServices;
    using UnityEngine;

    public class ThresholdingEvent : IThresholdingEvent
    {
        private readonly IDelayedDispatcher _delayedDispatcher;
        private float _firstRequestTime;
        private string _lastDispatchToken;
        private float _lastRequestTime;
        private readonly float _maxDispatchWait;
        private readonly float _thresholdDurationSeconds;
        private bool _willDispatch;

        public event Action Dispatched;

        public ThresholdingEvent(IDelayedDispatcher delayedDispatcher, float thresholdDurationSeconds, float maxDispatchWait)
        {
            this._delayedDispatcher = delayedDispatcher;
            this._thresholdDurationSeconds = thresholdDurationSeconds;
            this._maxDispatchWait = maxDispatchWait;
        }

        private void PerformDispatch()
        {
            this.Dispatched.SafeInvoke();
            this._willDispatch = false;
        }

        public void RequestDispatch()
        {
            if (!this._willDispatch)
            {
                this._firstRequestTime = Time.time;
            }
            this._lastRequestTime = Time.time;
            if ((this._lastRequestTime - this._firstRequestTime) > this._maxDispatchWait)
            {
                this.PerformDispatch();
                this._firstRequestTime = Time.time;
            }
            if (this._willDispatch)
            {
                this._delayedDispatcher.Cancel(this._lastDispatchToken);
            }
            this._lastDispatchToken = this._delayedDispatcher.Dispatch(new Action(this.PerformDispatch), this._thresholdDurationSeconds);
            this._willDispatch = true;
        }
    }
}

