using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstrumentView : StudioElement {

    private InstrumentController controller;

    private Renderer rend;
    private Color color;

    // Use this for initialization
    void Start () {
        controller = GetComponent<InstrumentController>();
        rend = GetComponent<Renderer>();
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public void UpdateInstrumentProperties(Transform instrumentTransform, Instrument instrument)
    {
        transform.localScale = instrumentTransform.localScale;
        transform.localPosition = instrumentTransform.localPosition;

        rend.material.color = instrument.Color;
    }

    // TODO subscribe this to a model action
    private void SetInstrumentMaterialColor(Color color)
    {
        rend.material.color = color;
    }
}
