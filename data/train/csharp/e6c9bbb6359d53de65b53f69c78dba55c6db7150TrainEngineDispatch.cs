using System;
using System.Collections;
using System.Text;
using System.Threading;
        
namespace Noea.TogSim.Model
{
    /// <summary>
    /// Here is 3 kinds of di
    /// </summary>
    public abstract class TrainEngineDispatch:ITrainEngineDispatch
    {
        #region ITrainEngineDispatch Members

        ArrayList _trains;

        public ArrayList Trains
        {
            get { return _trains; }
            set { _trains = value; }
        }

        public TrainEngineDispatch()
        {
        }
        public TrainEngineDispatch(ArrayList trains)
        {
            _trains = trains;
        }

        public abstract void Create();

        public void Create(System.Collections.ArrayList trains)
        {
            Trains = trains;
            Create();
        }
        public abstract void Dispose();

        #endregion
    }

  
    public class FixedTimeDispatch : TrainEngineDispatch
    {
        Thread _dispatchThread;
        bool _doRun;

        public FixedTimeDispatch() : base() { }
        public FixedTimeDispatch(ArrayList trains) : base(trains) { }
        public override void Create()
        {
            _doRun = true;
            Thread _dispatchThread = new Thread(new ThreadStart(this.Dispatch));
            _dispatchThread.Name = String.Format("Dispatch thread");
            _dispatchThread.Priority = ThreadPriority.Lowest;
            _dispatchThread.Start();
        }

        public void Dispatch()
        {
            while (_doRun)
            {
                foreach (ITrainSet train in base.Trains)
                {
                    double secs = (double)train.Engine.Interval / 1000.0;
                    if (train.LocoDriver is ILocoDriverExtended) ((ILocoDriverExtended)train.LocoDriver).UpdateState(null);
                    train.Engine.UpdatePosition(secs);
                    Thread.Sleep(train.Engine.Interval);
                }
            }
            //Console.WriteLine("fixedTime: Dispathing finished");
        }
        public override void Dispose()
        {
            //Console.WriteLine("FixedTime dispose");

            _doRun = false;
            if (_dispatchThread != null)
            {
                //Console.WriteLine("FixedTime: Aborting thread");
                _dispatchThread.Priority = ThreadPriority.AboveNormal; //Så den ikke venter på at afbryde.
                _dispatchThread.Abort();
            }

        }
    }
}
