using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniFramework.Extension.Helper
{
	public class InvokeHelper : MonoBehaviour
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

		class ScriptData
		{
			public MonoBehaviour script;
			public List<InvokeData> invokeList;
		}


		private List<ScriptData> scriptDataList;
		private float currentInvokeTime;

		protected  virtual void OnEnable ()
		{
			scriptDataList = new List<ScriptData> ();
			currentInvokeTime = 0;
		}

		protected  virtual void OnDisable ()
		{
			
		}

		protected virtual void Update ()
		{

			if (scriptDataList == null)
				return;
			currentInvokeTime += Time.deltaTime;
			scriptDataList.RemoveAll (o => o.script.enabled == false);

			for (int i = 0; i < scriptDataList.Count; i++) {
				for (int j = 0; j < scriptDataList [i].invokeList.Count; j++) {
					InvokeData data = scriptDataList [i].invokeList [j];
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
				scriptDataList [i].invokeList.RemoveAll ((o) => {
					return o.remove;
				});

			}
			scriptDataList.RemoveAll (o => o.invokeList == null || o.invokeList.Count == 0);

			if (scriptDataList.Count == 0) {
				this.enabled = false;
			}

		}




		public void HelperInvokeRepeating (MonoBehaviour script, string methodKey, float delay, float repeatTime, System.Action callback)
		{
			AddHelperInvoke (script, methodKey, delay, repeatTime, callback);
		}


		private void AddHelperInvoke (MonoBehaviour script, string methodKey, float delay, float repeatTime, System.Action callback)
		{

			if (this.enabled == false)
				enabled = true;
		
			ScriptData data = scriptDataList.Find (o => o.script.Equals (script));
			if (data == null) {
				data = new ScriptData ();
				data.invokeList = new List<InvokeData> ();
				data.script = script;
				currentInvokeTime = 0;
				scriptDataList.Add (data);
			}


			InvokeData invoke = new InvokeData ();
			invoke.key = methodKey;
			invoke.delay = delay;
			if (repeatTime <= 0) {
				invoke.isRepeat = false;	
			} else {
				invoke.isRepeat = true;	
			}
			invoke.repeatTime = repeatTime;
			invoke.callback = callback;
			invoke.time = currentInvokeTime;
	
			data.invokeList.Add (invoke);
		}

		public bool IsHelperInvoking (MonoBehaviour script, string methodKey)
		{
			if (this.enabled == false || scriptDataList == null)
				return false;
			ScriptData data = scriptDataList.Find (o => o.script.Equals (script));
			if (data == null) {
				return false;
			}
			if (data.invokeList.Find (o => o.key.Equals (methodKey)) == null) {
				return false;
			}
			return true;
		}

		public void CancelHelperInvoke (MonoBehaviour script)
		{
			if (scriptDataList == null)
				return;
			scriptDataList.RemoveAll (o => o.script == script);
		}

		public void CancelHelperInvoke (MonoBehaviour script, string methodKey)
		{
			if (scriptDataList == null)
				return;
			ScriptData data = scriptDataList.Find (o => o.script.Equals (script));
			if (data != null) {
				data.invokeList.RemoveAll (o => o.key == methodKey);
			}
		}
	}
}

