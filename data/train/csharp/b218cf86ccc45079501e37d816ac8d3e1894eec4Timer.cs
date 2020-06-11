using UnityEngine;
using System.Collections;
using UnityEngine.Events;

public class Timer : MonoBehaviour {

    public UnityEvent onTime;
    public float interval;
    float timeToInvoke;
    public bool repeat = true;

    void Start()
    {
        timeToInvoke = Time.time + interval;
    }

    void Update()
    {
        if (timeToInvoke < Time.time && timeToInvoke!=0)
        {
            onTime.Invoke();
            if (repeat)
            {
                timeToInvoke = Time.time + interval;
            }
            else
            {
                timeToInvoke = 0;
            }
        }
    }

}
