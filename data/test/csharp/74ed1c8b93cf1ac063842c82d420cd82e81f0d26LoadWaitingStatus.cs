using Experior.Core.Loads;
using System;

namespace Experior.Dematic.Base.Devices
{
    public class LoadWaitingStatus
    {
        public event EventHandler<LoadWaitingChangedEventArgs> OnLoadWaitingChanged;

        public void SetLoadWaiting(bool loadWaiting, bool loadDeleted)
        {
            LoadWaiting = loadWaiting;
            WaitingLoad = null;
            if (OnLoadWaitingChanged != null)
                OnLoadWaitingChanged(this, new LoadWaitingChangedEventArgs(loadWaiting, loadDeleted, null));
        }

        public void SetLoadWaiting(bool loadWaiting, bool loadDeleted, Load waitingLoad)
        {
            LoadWaiting = loadWaiting;
            WaitingLoad = waitingLoad;
            if (OnLoadWaitingChanged != null)
                OnLoadWaitingChanged(this, new LoadWaitingChangedEventArgs(loadWaiting, loadDeleted, waitingLoad));
        }

        private bool _LoadWaiting = false;
        public bool LoadWaiting
        {
            get { return _LoadWaiting; }
            set { _LoadWaiting = value; }
        }

        private Load _WaitingLoad = null;
        public Load WaitingLoad
        {
            get { return _WaitingLoad; }
            set { _WaitingLoad = value; }
        }

    }
}
