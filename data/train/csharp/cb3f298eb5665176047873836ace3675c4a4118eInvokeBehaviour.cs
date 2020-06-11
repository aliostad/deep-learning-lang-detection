using UnityEngine;
using System.Collections;

public class InvokeBehaviour : MonoBehaviour {

	void OnGUI()
	{
		if(GUI.Button(new Rect(50, 100, 200, 50), "2s后发送消息"))
		{
			Invoke("InvokeMessage", 2);
		}		
		if(GUI.Button(new Rect(50, 200, 200, 50), "2s后发送消息"))
		{
			InvokeRepeating("InvokeMessage", 2, 3f);
		}
		if(GUI.Button(new Rect(50, 300, 200, 50), "取消发送消息"))
		{
			CancelInvoke();
		}
	}

	void InvokeMessage()
	{
		print ("invoke");
	}
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
