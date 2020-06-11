using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RandomInstrumentOnBeat : MonoBehaviour {

	private Text text;
	private Instrument requiredInstrument = Instrument.None;
	private MusicManager music;

	// Use this for initialization
	void Start () {
		music = FindObjectOfType<MusicManager>();
		text = GetComponent<Text>();
		MusicManager.OnBar += UpdateText;
	}
	
	void UpdateText(){
		requiredInstrument = RandomInstrument();
		text.text = requiredInstrument.ToString();
	}

	Instrument RandomInstrument(){
		int instrument = Random.Range(0,3);
		return (Instrument) instrument;
	}
}
