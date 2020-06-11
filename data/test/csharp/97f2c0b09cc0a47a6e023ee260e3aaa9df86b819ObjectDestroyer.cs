using UnityEngine;
using System.Collections;

public class ObjectDestroyer : MonoBehaviour {

	// Use this for initialization
	public float lifeTime = 0;
	public float minInvokeTime = 0;
	public float maxInvokeTime = 1;
	public float startTime = 0;

	private int partIndex;
	private Rigidbody[] parts;


	void Start () {

		parts = gameObject.GetComponentsInChildren<Rigidbody> ();

		Invoke ("StartDestroy", startTime);

	}

	void StartDestroy(){

		float invokeTime = Random.Range(maxInvokeTime, maxInvokeTime);

		Invoke ("StartDestroyPart", invokeTime);

	}


	void StartDestroyPart(){

		float invokeTime = Random.Range(maxInvokeTime, maxInvokeTime);
		Rigidbody rb = parts [partIndex];

		rb.isKinematic = false;
		rb.WakeUp ();

		Debug.Log ("invoke" + partIndex);

		partIndex += 1;

		if (partIndex < parts.Length) {
			Invoke ("StartDestroyPart", invokeTime);
		} else {
			Destroy (gameObject, lifeTime);
		}
	}
}
