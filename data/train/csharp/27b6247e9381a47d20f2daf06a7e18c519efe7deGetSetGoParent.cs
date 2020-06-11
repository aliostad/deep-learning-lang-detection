using UnityEngine;
using System.Collections;

public class GetSetGoParent : MonoBehaviour
{

	public GameObject[] getSetGo;

	// Use this for initialization
	public void StartGetSetGo ()
	{
		Invoke ("InvokeGet", 0);
	}
	
	void InvokeGet ()
	{
		getSetGo [0].SetActive (true);
		Invoke ("InvokeSet", 1);
		Sound.Instance.PlayBing2 ();
	}

	void InvokeSet ()
	{
		getSetGo [1].SetActive (true);
		Invoke ("InvokeGo", 1);
		Sound.Instance.PlayBing2 ();
	}

	void InvokeGo ()
	{
		getSetGo [2].SetActive (true);
		Invoke ("End", 1);
		Sound.Instance.PlayBing2 ();
	}

	void End ()
	{
		GameManager.Instance.GameStateChangeTo (GameState.Play);
	}
}
