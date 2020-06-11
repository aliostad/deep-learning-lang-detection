using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HairBufferUpdater : MonoBehaviour {

	public hBuffUpdater updater;

			
	// Use this for initialization
	public void Live() {
		if( updater == null){
			updater = GetComponent<hBuffUpdater>();
		}

	 	ExtraEnable();

		updater.OnBeforeCollisionDispatch += BeforeCollisionDispatch;
		updater.OnAfterCollisionDispatch += AfterCollisionDispatch;

		updater.OnBeforeConstraintDispatch += BeforeConstraintDispatch;
		updater.OnAfterConstraintDispatch += AfterConstraintDispatch;
	}

	public void Die(){

		updater.OnBeforeCollisionDispatch -= BeforeCollisionDispatch;
		updater.OnAfterCollisionDispatch -= AfterCollisionDispatch;

		updater.OnBeforeConstraintDispatch -= BeforeConstraintDispatch;
		updater.OnAfterConstraintDispatch -= AfterConstraintDispatch;
	}


	public virtual void ExtraEnable(){}
	public virtual void BeforeCollisionDispatch(ComputeShader computeShader , int _kernel){}
	public virtual void AfterCollisionDispatch(ComputeShader computeShader , int _kernel){}
	public virtual void BeforeConstraintDispatch(ComputeShader computeShader , int _kernel){}
	public virtual void AfterConstraintDispatch(ComputeShader computeShader , int _kernel){}
	

}
