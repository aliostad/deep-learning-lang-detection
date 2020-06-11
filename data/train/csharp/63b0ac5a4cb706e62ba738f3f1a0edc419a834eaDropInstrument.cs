using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections;

public class DropInstrument : MonoBehaviour, IDropHandler {

    private Instrument dragPanelInstrument;
	private SliderManager sliderManager;

	// Use this for initialization
	void Start () {
		sliderManager = GameObject.Find ("InstrumentsSlider").GetComponent<SliderManager> ();
		dragPanelInstrument = GameObject.Find("SoundAreaDragPanel").GetComponent<Instrument>();
	}
	
    public void OnDrop(PointerEventData eventData)
    {
		if (sliderManager.playMidi) {
			if (dragPanelInstrument.midiInstrument > 0)
				GetComponent<Instrument> ().InstrumentChanged (dragPanelInstrument.midiInstrument);
		}
		else
			GetComponent<Instrument> ().InstrumentChanged (dragPanelInstrument.audioFileNumber);
    }
}
