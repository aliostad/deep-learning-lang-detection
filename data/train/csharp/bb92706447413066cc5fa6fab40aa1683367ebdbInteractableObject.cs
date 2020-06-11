using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(Collider), typeof(Rigidbody))]
public class InteractableObject : MonoBehaviour
{
	public UnityEvent 
	ControllerEnter, ControllerStay, ControllerExit,
	ControllerTriggerDown, ControllerTriggerStay, ControllerTriggerUp,
	TrackerEnter, TrackerStay, TrackerUp;
	public virtual void OnControllerEnter(Controller controller){ControllerEnter.Invoke();}
	public virtual void OnControllerStay(Controller controller){ControllerStay.Invoke();}
	public virtual void OnControllerExit(Controller controller){ControllerExit.Invoke();}
	public virtual void OnControllerTriggerDown(Controller controller){ControllerTriggerDown.Invoke();}
	public virtual void OnControllerTriggerStay(Controller controller){ControllerTriggerStay.Invoke();}
	public virtual void OnControllerTriggerUp(Controller controller){ControllerTriggerUp.Invoke();}
	public virtual void OnTrackerEnter(Controller controller){TrackerEnter.Invoke();}
	public virtual void OnTrackerStay(Controller controller){TrackerEnter.Invoke();}
	public virtual void OnTrackerExit(Controller controller){TrackerUp.Invoke();}
}