using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthControllerController : MonoBehaviour {
	[SerializeField] private HealthHint m_healthControllerPrefab;
	[SerializeField] private Transform m_container;
	private static HealthControllerController m_controllerValue = null;
	private static HealthControllerController m_controller {
		get {
			if( m_controllerValue == null ) {
				m_controllerValue = FindObjectOfType<HealthControllerController>();
			}
			return m_controllerValue;
		}
	}
    public static HealthHint CreateHealthBar( HealthController healthController) {
        HealthHint hc = Instantiate( m_controller.m_healthControllerPrefab );
		hc.SetFollow( healthController.transform );
		hc.transform.SetParent( m_controller.m_container );
		return hc;
    }
}
