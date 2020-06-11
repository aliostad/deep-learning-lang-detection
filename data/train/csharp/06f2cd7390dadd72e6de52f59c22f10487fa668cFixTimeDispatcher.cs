using System;
using UnityEngine;

namespace Assets.Scripts.GameScripts.GameLogic.Misc
{
    [AddComponentMenu("Misc/FixTimeDispatcher")]
    public class FixTimeDispatcher : GameLogic
    {
        public event Action DispatchEventHander;
        public float DispatchInterval;
        public float DispatchCoolDownPercentage {
            get
            {
                return ((Time.fixedTime - _lastFrameTime) >= DispatchInterval)
                    ? 1.0f
                    : ((Time.fixedTime - _lastFrameTime) / DispatchInterval);
            }
        }

        private float _lastFrameTime;

        public void ResetTime () 
        {
            _lastFrameTime = Time.time;
        }

        public bool CanDispatch()
        {
            if (DispatchInterval <= 0f)
            {
                return true;
            }

            return ((Time.fixedTime - _lastFrameTime) >= DispatchInterval);
        }

        public bool Dispatch()
        {
            if (CanDispatch())
            {
                if (DispatchEventHander != null)
                {
                    DispatchEventHander();
                }
                ResetTime();
                return true;
            }
            else
            {
                return false;
            }
        }

        public void TurnDispatchable()
        {
            _lastFrameTime = -100;
        }

        protected override void Initialize()
        {
            base.Initialize();
            TurnDispatchable();
        }

        protected override void Deinitialize()
        {
        }
    }
}
