using UnityEngine;
using System.Collections;

//Sources for controlling the audiosources in game
//also able to record

public class script_InstrumentPoolManager : MonoBehaviour {

    private AudioClip instrumentRecording;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

	}

	// Tell all instruments in the instrumentpool to stop playing
	// should be used when avatar is moved
	void StopAll()
	{
		InstrumentBehaviour[] instruments = this.gameObject.GetComponentsInChildren<InstrumentBehaviour> ();

		foreach (InstrumentBehaviour instrument in instruments) {
            instrument.Stop();
		}
	}

    void Record()
    {
        InstrumentBehaviour[] instruments = this.gameObject.GetComponentsInChildren<InstrumentBehaviour>();
        System.Collections.Generic.List<AudioSource> audioSources = new System.Collections.Generic.List<AudioSource>();
        
        foreach (InstrumentBehaviour instrument in instruments)
        {
            if (instrument.GetComponent<AudioSource>())
                audioSources.Add(instrument.GetComponent<AudioSource>());

            
        }

        //TODO: pipe audiosources into clip to save recording

    }

    void EndRecording()
    {

    }

    void Playback()
    {
        
    }
}
