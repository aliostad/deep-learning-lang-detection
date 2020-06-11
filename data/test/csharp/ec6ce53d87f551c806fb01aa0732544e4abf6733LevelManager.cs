using UnityEngine;
using System.Collections;

public class LevelManager : MonoBehaviour {

    public GameObject[] levels;
    public int loadedLevels;
    public Animator goalAnimator;
    public GameObject goal;


    // Use this for initialization
    void Start () {
        loadedLevels = 0;
        for (int i = 1; i < levels.Length; i++) {
            levels[i].gameObject.SetActive(false);
        }
	}
	
	// Update is called once per frame
	void Update () {

	}

    void LoadLevel() {
        loadedLevels++;
        Invoke("BlinkIn", 0.05f);
        Invoke("BlinkOut", 0.1f);
        Invoke("BlinkIn", 0.15f);
        Invoke("BllinkOut", 0.2f);
        Invoke("BlinkIn", 0.25f);
        Invoke("BlinkOut", 0.3f);
        Invoke("BlinkIn", 0.35f);
        Invoke("BllinkOut", 0.45f);
        Invoke("BlinkIn", 0.5f);
        Invoke("BlinkOut", 0.55f);
        Invoke("BlinkIn", 0.6f);
        Invoke("BllinkOut", 0.65f);
        Invoke("BlinkIn", 0.7f);
    }

    void BlinkIn() {
        levels[loadedLevels].gameObject.SetActive(true);
    }

    void BlinkOut() {
        levels[loadedLevels].gameObject.SetActive(false);
    }
}
