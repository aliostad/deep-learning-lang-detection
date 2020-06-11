using System.Collections.Generic;
using UnityEngine;
using System.Collections;


    public class InstrumentSpotlight : MonoBehaviour
    {
        private GameObject instrument;
         Light spotlightComponent;

        //NetworkView networkView;
        ObjectController ObjectController;

        public void Start()
        {
            spotlightComponent = this.GetComponent<Light>();
            //spotlightComponent.color = Color.green; //pick random

            float r = Random.Range(0f, 1f);
            float g = Random.Range(0f, 1f);
            float b = Random.Range(0f, 1f);

            spotlightComponent.color = new Color(r, g, b);

            transform.parent = GameObject.Find("LightPool").transform;
            transform.localPosition = new Vector3(0, 0, 0);

        }

		public void setInstrument(GameObject instrument) {
			this.instrument = instrument;
		
			transform.LookAt(instrument.transform.position);

		}

        public void Update()
        {
            if (instrument)
            {
                transform.LookAt(instrument.transform.position);
            }
        }
    }
