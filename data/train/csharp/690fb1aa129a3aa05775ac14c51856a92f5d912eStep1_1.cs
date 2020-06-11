using UnityEngine;
using System.Collections;

public class Step1_1: MonoBehaviour {

    GameObject[] cubes = new GameObject[10];
    int N = 0;

	// Use this for initialization
	void Start () {
        for(int i=0;i<10;i++) cubes[i] = transform.Find("/Cube ("+i.ToString()+")").gameObject;
        Invoke("DestroyGameObject", 1f);
        Invoke("DestroyGameObject", 2f);
        Invoke("DestroyGameObject", 3f);
        Invoke("DestroyGameObject", 4f);
        Invoke("DestroyGameObject", 5f);
        Invoke("DestroyGameObject", 6f);
        Invoke("DestroyGameObject", 7f);
        Invoke("DestroyGameObject", 8f);
        Invoke("DestroyGameObject", 9f);
        Invoke("DestroyGameObject", 10f);
    }

    // Update is called once per frame
    void Update () {
	
	}

    void DestroyGameObject ()
    {
        Destroy(cubes[N++]);
    }
}
