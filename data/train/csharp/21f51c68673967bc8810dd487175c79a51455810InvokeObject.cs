using UnityEngine;
using System.Collections;

public delegate void InvokeMethod();

public class InvokeObject : ISpecialUpdate {

	public InvokeObject(InvokeMethod method,float time)
    {
        _method = method;
        _timestamp = Time.time + time;
    }

    private InvokeMethod _method = null;
    private float _timestamp = 0.0f;

    public void SpecialUpdate()
    {
        if(Time.time > _timestamp)
        {
            if (_method != null)
            {
                _method();
            }
            GameMaster.Instance.DerigsterSpecialUpdate(this);
        }
    }
}
