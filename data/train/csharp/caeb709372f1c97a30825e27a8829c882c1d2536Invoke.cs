using UnityEngine;
using System.Collections;

public class Invoke : MonoBehaviour {

    //Invoke method allows u to schedule a function call after some specified time delay

    public GameObject target;

	void Start ()
    {
        Invoke("SpawnObject", 2f);
        //Invoke (String containing the name of the Method we wish to call, amount of time to delay in seconds)

        InvokeRepeating("SpawnObject", 2, 1);
        //InvokeRepeating(Method, delay, delay between next method calls)

        CancelInvoke("SpawnObject");  //stops the repeating
	}
	
	void SpawnObject ()
    {
        Instantiate(target, new Vector3(0, 2, 0), Quaternion.identity);
	}
}
