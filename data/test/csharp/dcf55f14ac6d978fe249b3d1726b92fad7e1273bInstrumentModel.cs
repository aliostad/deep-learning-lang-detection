using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstrumentModel : StudioElement {

    public string instrumentName;
    private InstrumentController controller;

    public enum InstroTypes
    {
        LeadVocal, BackupVocal, AcousticGuitar, ElectricGuitar, 
        Piano, Violin, Saxophone, Flute, Cello, Clarinet, Trumpet, Harp,
        Drums, Kick, Snare, Tom, HiHat, Cymbal

    }
    public InstroTypes type;

    public Color color;
    public AudioClip clip;

    private InstrumentType instrumentType;

    private Instrument instrument;

    // Use this for initialization
    void Start () {
        controller = GetComponent<InstrumentController>();

        // creates and auto fills default values as needed
        instrumentType = new InstrumentType(type.ToString());
        color = instrumentType.DefaultColor;
        instrument = new Instrument(instrumentName, instrumentType, color, clip);
        controller.SetInstrumentProperties(instrument);
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    //private Instrument initInstrumentProperties ()
    //{
    //    color = instrumentType.DefaultColor;
    //    instrument = new Instrument(instrumentName, instrumentType, color, clip);
    //    return instrument;
    //}

    public Instrument GetCurrentInstrumentValue()
    {
        Debug.Log("what is instro???: " + instrument);
        return instrument;
    }
}
