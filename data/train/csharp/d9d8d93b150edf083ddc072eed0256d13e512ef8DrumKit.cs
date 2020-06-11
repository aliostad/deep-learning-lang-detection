using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class DrumKit {


	public enum Instrument {HiHat, Snare, Bass, CymbalCrash, CymbalRide, TomHigh, TomMid, TomLow, Silence};
	public enum Mode {Beginner, Intermediate, Advanced};
	private static Dictionary<int, Instrument> midiCodeMap = new Dictionary<int, Instrument>();
	private static Mode currentMode = Mode.Intermediate;
	

	public static void setDifficulty(Mode newMode){
		currentMode = newMode;

		//Rebuild instrument map after changing difficulty
		DrumKit.buildIntstrumentMap ();
	}


	public static Instrument getInstrumentFromMidiCode (int midiCode){

		if (midiCodeMap.ContainsKey (midiCode)) {
			return midiCodeMap [midiCode];
		} 

		//Return silence for no mapping
		return Instrument.Silence;
	}
	
	public static void buildIntstrumentMap() {

		midiCodeMap = new Dictionary<int, Instrument>();

		switch (currentMode)
		{
			
		case Mode.Beginner:
			midiCodeMap.Add(35, Instrument.Bass);
			midiCodeMap.Add(36, Instrument.Bass);
			midiCodeMap.Add(38, Instrument.Snare);
			midiCodeMap.Add(40, Instrument.Snare);
			midiCodeMap.Add(42, Instrument.HiHat); //High Hat Open
			midiCodeMap.Add(46, Instrument.HiHat); //High Hat Close
			break;
		case Mode.Intermediate:
			midiCodeMap.Add(35, Instrument.Bass);
			midiCodeMap.Add(36, Instrument.Bass);
			midiCodeMap.Add(38, Instrument.Snare);
			midiCodeMap.Add(40, Instrument.Snare);
			midiCodeMap.Add(42, Instrument.HiHat); //High Hat Open
			midiCodeMap.Add(46, Instrument.HiHat); //High Hat Close
			midiCodeMap.Add(49, Instrument.CymbalCrash);
			midiCodeMap.Add(50, Instrument.TomHigh);
			break;
		case Mode.Advanced:
			midiCodeMap.Add(35, Instrument.Bass);
			midiCodeMap.Add(36, Instrument.Bass);
			midiCodeMap.Add(38, Instrument.Snare);
			midiCodeMap.Add(40, Instrument.Snare);
			midiCodeMap.Add(42, Instrument.HiHat); //High Hat Open
			midiCodeMap.Add(46, Instrument.HiHat); //High Hat Close
			midiCodeMap.Add(49, Instrument.CymbalCrash);
			midiCodeMap.Add(51, Instrument.CymbalRide);
			midiCodeMap.Add(47, Instrument.TomMid);
			midiCodeMap.Add(48, Instrument.TomMid);
			midiCodeMap.Add(50, Instrument.TomHigh);
			midiCodeMap.Add(45, Instrument.TomLow);
			break;
		}
	}






}



/*
//EASY
Bass
Snare
HighHat

//MED
+CymbalCrash
+TomHigh
+TomMid

//HARD
+CymbalRide
+TomLow

*/