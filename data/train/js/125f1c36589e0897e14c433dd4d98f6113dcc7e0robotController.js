 //import UnityEngine;
//import System.Collections;

class robotController extends MonoBehaviour {
	
	var navDistance : float= 1;
	var navTarget : GameObject;
	private var navAgent : NavMeshAgent;
	private var avatar : Animator;
	
	function Start () : void {	 
	navAgent = GetComponent(NavMeshAgent);	
	avatar = GetComponent.<Animator>();	
	}
	
	function Update () : void {
		
		if (!navAgent.hasPath)
		{
			if (!navAgent.pathPending)
			{
				navAgent.destination = navTarget.transform.position;
			}
		}
		else
		{
			if (navDistance < navAgent.remainingDistance)
			{
				
				avatar.SetFloat("Speed", 1.0f);
				navAgent.destination = navTarget.transform.position;
			}
			else if (navAgent.remainingDistance < navDistance)
			{
				
				avatar.SetFloat("Speed", 0.0f);
				navAgent.destination = transform.position;
			}
		}
	}
	
}
