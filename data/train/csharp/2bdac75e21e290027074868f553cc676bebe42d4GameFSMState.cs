using UnityEngine;
using System.Collections;
using System.Collections.Generic;


namespace UniFramework.Fsm
{
	public  abstract class GameFSMState : FSMState
	{
		class InvokeData
		{
			public string key = "default";
			public bool isRepeat = false;
			public float delay = 0;
			public float time;
			public float repeatTime = 0;
			public System.Action callback = null;
			public bool remove = false;
		}


		public float TimeScale = 1;

		private List<InvokeData> invokeList= new List<InvokeData> (); 

		private float currentInvokeTime;

		public override void Awake ()
		{
			base.Awake ();

		}

		public override void OnEnter (IDictionary paramDic)
		{
			base.OnEnter (paramDic);
			invokeList = new List<InvokeData> (); 
			currentInvokeTime = 0;
		}

		public override void OnExit ()
		{
			base.OnExit ();
			CancelInvoke ();
		}

		public override void OnUpdate ()
		{
			base.OnUpdate ();
			currentInvokeTime +=  Time.deltaTime *TimeScale;

			for (int i = 0; i < invokeList.Count; i++) {
				InvokeData data = invokeList [i];
				if (currentInvokeTime - data.time >= data.delay) {
					if (data.isRepeat) {
						data.delay += data.repeatTime;
					} else {
						data.remove = true;
					}
					if (data.callback != null) {
						data.callback ();
					}
				}
			}
			invokeList.RemoveAll ((o) => {
				return o.remove;
			});
		}

		public void Invoke (float delay, System.Action callback)
		{
			InvokeData invoke = new InvokeData ();
			invoke.delay = delay;
			invoke.isRepeat = false;
			invoke.callback = callback;
			invoke.time = currentInvokeTime;
			invokeList.Add (invoke);
		}

		public void Invoke (string methodKey, float delay, System.Action callback)
		{
			InvokeData invoke = new InvokeData ();
			invoke.key = methodKey; 
			invoke.delay = delay;
			invoke.isRepeat = false;
			invoke.callback = callback;
			invoke.time = currentInvokeTime;
			invokeList.Add (invoke);
		}

		public void InvokeRepeating (float delay, float repeatTime, System.Action callback)
		{
			InvokeData invoke = new InvokeData ();

			invoke.delay = delay;
			invoke.isRepeat = true;
			invoke.repeatTime = repeatTime;
			invoke.callback = callback;
			invoke.time = currentInvokeTime;
			invokeList.Add (invoke);
		}

		public void InvokeRepeating (string methodKey, float delay, float repeatTime, System.Action callback)
		{
			InvokeData invoke = new InvokeData ();
			invoke.key = methodKey;
			invoke.delay = delay;
			invoke.isRepeat = true;
			invoke.repeatTime = repeatTime;
			invoke.callback = callback;
			invoke.time = currentInvokeTime;
			invokeList.Add (invoke);
		}

		public bool IsInvoking (string methodKey)
		{
			return (invokeList.Find ((o) => {
				return o.key.Equals (methodKey);
			}) != null);
		}

		public void CancelInvoke ()
		{
			invokeList.Clear ();
		}

	}

	public class GameFSMState<S> : GameFSMState
	{
		public S ID {
			get {
				return id;
			}
		}

		private S id;

		public GameFSMState (S i)
		{
			id = i;
		}
	}
}