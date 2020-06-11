 //import UnityEngine;
//import System.Collections;

class navHospital extends MonoBehaviour {
	
	var navDistance : float= 3;
	var navTarget : GameObject;
	private var navAgent : NavMeshAgent;
	
	function Start () : void {	 
	navAgent = GetComponent(NavMeshAgent);	
	var obj = new Array (GameObject.FindGameObjectsWithTag("Player"));
	navTarget=obj[0];
		
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
				navAgent.destination = navTarget.transform.position;
			}
			else if (navAgent.remainingDistance < navDistance)
			{
				navAgent.destination = transform.position;
			}
		}
		
		
		 
	
		//print (navAgent.remainingDistance);
	}
	
}
