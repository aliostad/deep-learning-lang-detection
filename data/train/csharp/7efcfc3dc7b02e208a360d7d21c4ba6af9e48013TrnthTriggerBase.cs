using UnityEngine;
using System.Collections;

public class TrnthTriggerBase : MonoBehaviour {
	public float delay;
	public float noise;
	public bool log;
	public bool cancelInvoke;
	public bool onEnable=true;
	public bool onDisable;
	public virtual void execute(){
		if(log)Debug.Log(name+" triggerBase");
	}
	void invokeExecute(){
		Invoke("execute",delay+Random.value*noise);
	}
	void OnEnable () {
		if(cancelInvoke)CancelInvoke();
		if(onEnable)invokeExecute();
	}
	void OnDisable(){
		if(cancelInvoke)CancelInvoke();
		if(onDisable)invokeExecute();
	}
}
