using UnityEngine;
using System.Collections;

public class WeekPointFlash : MonoBehaviour {

	// Use this for initialization
	void Start () {
		this.gameObject.SetActive (false);


		Invoke ("flashing", 0.1f);
	}
	
	// Update is called once per frame
	void FixedUpdate () {
	

	
	}
	void flashing()
	{
		//CancelInvoke ();
		this.gameObject.SetActive (true);
		Invoke ("showoff", 0.5f);


	}
	void showoff()
	{
		CancelInvoke ();
		this.gameObject.SetActive (false);
		Invoke ("show", 0.5f);

	}
	void show()
	{
		CancelInvoke ();
		this.gameObject.SetActive (true);
		Invoke ("showoff", 0.5f);
	}
}
