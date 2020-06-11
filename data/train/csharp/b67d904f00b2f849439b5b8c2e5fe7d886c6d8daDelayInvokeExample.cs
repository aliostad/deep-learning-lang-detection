using UnityEngine;
using System;
using System.Collections;
using UnityOps;
using UnityOps.UnityAsync;

public class DelayInvokeExample : MonoBehaviour
{
    #region properties
    int startFrame;
    float startTime;
    #endregion

    #region override unity methods
    void Start()
    {
        startFrame = Time.frameCount;
        startTime = Time.realtimeSinceStartup;

        // use InvokeAfterDelay
        InvokeAfterDelay.Call(() =>
        {
            Debug.Log(string.Format("InvokeAfterDelay called! delayedTime: {0}", Time.realtimeSinceStartup - startTime));
        }, 1.0f);

        // use InvokeAfterFrame
        InvokeAfterFrame.Call(() =>
        {
            Debug.Log(string.Format("InvokeAfterFrame called! startFrame: {0}, currentFrame: {1}", startFrame, Time.frameCount));
        }, 5);

        // use InvokeNextFrame
        InvokeNextFrame.Call(() =>
        {
            Debug.Log(string.Format("InvokeNextFrame called! startFrame: {0}, currentFrame: {1}", startFrame, Time.frameCount));
        });

        // Exception Handling of InvokeAfterDelay
        InvokeAfterDelay invokeAfterDelay = InvokeAfterDelay.Call(() =>
        {
            throw new Exception("Exception from InvokeAfterDelay");
        }, 2.0f);
        invokeAfterDelay.Error += (sender, e) =>
        {
            Debug.Log(e.Errors.ExceptionCause.Message);
        };

        // Exception Handling of InvokeAfterFrame
        InvokeAfterFrame invokeAfterFrame = InvokeAfterFrame.Call(() =>
        {
            throw new Exception("Exception from InvokeAfterFrame");
        }, 5);
        invokeAfterFrame.Error += (sender, e) =>
        {
            Debug.Log(e.Errors.ExceptionCause.Message);
        };

        // Exception Handling of InvokeNextFrame
        InvokeNextFrame invokeNextFrame = InvokeNextFrame.Call(() =>
        {
            throw new Exception("Exception from InvokeNextFrame");
        });
        invokeNextFrame.Error += (sender, e) => {
            Debug.Log(e.Errors.ExceptionCause.Message);
        };
    }
    #endregion

    #region private methods
    #endregion
}

