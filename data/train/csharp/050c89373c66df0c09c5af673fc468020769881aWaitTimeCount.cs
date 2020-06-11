using System;
using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class WaitTimeCount : Katana.Singleton<WaitTimeCount>
{
	public Action Action;

    [System.Serializable]
    private class InvokeWaitSet
	{
		public float time;
		public InvokeAction invoke;
        public bool ignoreTimeScale;
        public bool active;

		public InvokeWaitSet(float _time , InvokeAction _invoke, bool _ignoreTimeScale) {
			time = _time;
			invoke = _invoke;
            ignoreTimeScale = _ignoreTimeScale;
            active = true;
        }

        public InvokeWaitSet()
        {
            time = 0;
            invoke = null;
            ignoreTimeScale = false;
            active = false;
        }
    }

    //[SerializeField]
    InvokeWaitSet[] invokeWaitSetList = new InvokeWaitSet[64];

    void Start() {
        for (int index = 0; index < invokeWaitSetList.Length; index++)
        {
            invokeWaitSetList[index] = new InvokeWaitSet();
        }

    }


	void Update()
	{
		for (int index = 0; index < invokeWaitSetList.Length; index++)
		{
            InvokeWaitSet invokeWaitSet = invokeWaitSetList[index];
            if (invokeWaitSet.active)
            {
                invokeWaitSet.time -= invokeWaitSet.ignoreTimeScale ? Time.unscaledDeltaTime : Time.deltaTime;
                if (invokeWaitSet.time <= 0.0f)
                {
                    invokeWaitSet.invoke();
                    invokeWaitSet.time = -1;
                    invokeWaitSet.active = false;
                    invokeWaitSet.invoke = null;
                }
            }

		}
	}

	public void AddCommand(float duration, InvokeAction InvokeAction ,  bool ignoreTimeScale)
	{
        for (int index = 0; index < invokeWaitSetList.Length; index++)
        {
            if (!invokeWaitSetList[index].active) {
                invokeWaitSetList[index].time = duration;
                invokeWaitSetList[index].invoke = InvokeAction;
                invokeWaitSetList[index].ignoreTimeScale = ignoreTimeScale;
                invokeWaitSetList[index].active = true;
                return;
            }
        }

        Debug.LogError("Invoke Buffer Over : Look WaitActionController And Please Modify Invoke buffer count.");
    }

}

public delegate void InvokeAction();

public static class Wait
{
	public static void InvokeAfterSeconds(float duration, InvokeAction action)
	{
		WaitTimeCount.Instance.AddCommand(duration,action , false);
    }

	public static void InvokeAfterSecondsIgnoreTimeScale(float duration, InvokeAction action)
    {
        WaitTimeCount.Instance.AddCommand(duration, action,true);
    }
}

