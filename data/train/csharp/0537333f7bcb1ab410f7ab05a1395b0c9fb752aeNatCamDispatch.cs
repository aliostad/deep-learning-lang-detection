/* 
*   NatCam
*   Copyright (c) 2016 Yusuf Olokoba
*/

using UnityEngine;
using System;
using System.Collections;
using System.Threading;
using Ext = NatCamU.Internals.NatCamExtensions;
using Queue = System.Collections.Generic.List<System.Action>;

namespace NatCamU {
    
    namespace Internals {
        
        public sealed class NatCamDispatch {

            public bool isRunning {get {return running;}}
            
            private DispatchMode mode;
            private Thread targetThread, mainThread, workerThread;
            private Queue invocation, update, execution;
            private MonoBehaviour timesliceProvider;
            private Coroutine routine;
            private readonly object queueLock = new object();
            private volatile bool running;
            

            #region --Ctor & Dtor--

            public static NatCamDispatch Prepare (DispatchMode Mode, MonoBehaviour TimesliceProvider = null, int Rate = 15) {
                NatCamDispatch dispatch = new NatCamDispatch {
                    mode = Mode,
                    mainThread = Thread.CurrentThread,
                    timesliceProvider = TimesliceProvider,
                    invocation = new Queue(),
                    update = new Queue(),
                    execution = new Queue(),
                    running = true
                };
                dispatch.workerThread = Mode == DispatchMode.Asynchronous ? new Thread(() => dispatch.Routine<Camera>(dispatch.Update, Rate)) : null;
                dispatch.targetThread = Mode == DispatchMode.Asynchronous ? dispatch.workerThread : dispatch.mainThread;
                if (Mode == DispatchMode.Synchronous) {
                    if (dispatch.timesliceProvider) dispatch.routine = Routine<Camera>(dispatch.Update, new WaitForEndOfFrame()).Invoke(dispatch.timesliceProvider);
                    else Camera.onPostRender += dispatch.Update;
                }
                else dispatch.workerThread.Start();
                Debug.Log("NatCam: Initialized "+Mode+" Dispatcher");
                return dispatch;
            }

            public static void Release (NatCamDispatch dispatch) {
                if (dispatch == null) return;
                if (!dispatch.running) return;
                dispatch.running = false;
                if (dispatch.mode == DispatchMode.Synchronous) {
                    if (dispatch.routine != null) dispatch.routine.Terminate(dispatch.timesliceProvider);
                    else Camera.onPostRender -= dispatch.Update;
                }
                else dispatch.workerThread.Join();
                Debug.Log("NatCam: Released "+dispatch.mode+" Dispatcher");
            }

            private NatCamDispatch () {}

            ~NatCamDispatch () {
                invocation.Clear(); update.Clear(); execution.Clear();
                invocation =
                update =
                execution = null;
                mainThread =
                workerThread =
                targetThread = null;
                timesliceProvider = null;
                routine = null;
            }
            #endregion


            #region --Dispatching--

            public void Dispatch (Action action) {
                //Check that we aren't already on the target thread
                if (Thread.CurrentThread.ManagedThreadId == targetThread.ManagedThreadId) {
                    Ext.LogVerbose("Dispatch Execute");
                    action();
                }
                //Enqueue
                else lock (queueLock) {
                    Ext.LogVerbose("Dispatch Enqueue");
                    invocation.Add(action);
                }
            }

            public void DispatchContinuous (Action action) {
                lock (queueLock) {
                    Ext.LogVerbose("Dispatch Enqueue Update");
                    update.Add(action);
                }
            }

            private void Update (Camera unused) {
                //Lock
                lock (queueLock) {
                    execution.AddRange(invocation);
                    execution.AddRange(update);
                    invocation.Clear();
                }
                //Execute
                execution.ForEach(e => e());
                execution.Clear();
            }
            #endregion
            

            #region --Utility--

            private static IEnumerator Routine<T> (Action<T> action, YieldInstruction yielder) {
                while (true) {
                    yield return yielder;
                    action(default(T));
                }
            }

            private void Routine<T> (Action<T> action, int rate) {
                while (running) {
                    Thread.Sleep(1000/rate);
                    action(default(T));
                }
            }
            #endregion
        }

        public enum DispatchMode : byte {
            Synchronous = 1,
            Asynchronous = 2
        }
    }
}