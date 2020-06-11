using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ControllerManager))]
public abstract class ControllerFunctionality : MonoBehaviour
{
    public ControllerManager controllerManager { get; private set; }

    public ControllerInformation nonActiveController { get; set; }

    private ControllerInformation _activeController;
    public ControllerInformation ActiveController
    {
        get
        {
            return _activeController;
        }
        set
        {
            _activeController = value;
        }
    }
    public ControllerFunctionalityInformation info { private get; set; }

    protected virtual void Awake()
    {
        controllerManager = GetComponent<ControllerManager>();
        StartCoroutine(WaitForControllerInitialized());
    }

    private void Update()
    {
        ControllerInformation[] trackedObjs = new ControllerInformation[] { };
        try
        {
            trackedObjs = controllerManager.controllerInfos;
        }
        catch (System.NullReferenceException)
        {
            Debug.LogError("The controllers are not turned on, or you have a problem.");
        }

        //foreach of the controllers
        foreach (ControllerInformation controller in trackedObjs)
        {
            //if the controller is not ready (yet)
            if (controllerManager.GetController(controller.trackedObj) == null)
            {
                Debug.LogWarning("The Controller: " + controller + " is not ready (yet).");
                //go to the next controller
                continue;
            }
            if (ActiveController != null)
            {
                if (controller == ActiveController)
                {
                    ActiveControllerUpdate(controller);
                }
                else
                {
                    NonActiveControllerUpdate(controller);
                }
            }
            AnyControllerUpdate(controller);
        }
    }

    IEnumerator WaitForControllerInitialized()
    {
        while (controllerManager.controllerInfos == null)
        {
            yield return 0;
        }
        OnControllerInitialized();
    }

    /// <summary>
    /// This method gets called every frame for the active Controller
    /// </summary>
    /// <param name="controller">The active Controller</param>
    protected abstract void ActiveControllerUpdate(ControllerInformation controller);
    /// <summary>
    /// This method gets called every frame for every non active Controller
    /// </summary>
    /// <param name="controller">The non active Controller</param>
    protected abstract void NonActiveControllerUpdate(ControllerInformation controller);
    /// <summary>
    /// This method gets called every frame for every Controller
    /// </summary>
    /// <param name="controller">The Controller</param>
    protected abstract void AnyControllerUpdate(ControllerInformation controller);
    /// <summary>
    /// This method gets called as soon as the controllers are intialized
    /// </summary>
    protected virtual void OnControllerInitialized()
    {
        if (info != null)
        {
            foreach (var item in controllerManager.controllerInfos)
            {
                item.AddFunctionalityInfo(info);
            }
        }
    }

}
