using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class musicianSimon : Lookable {

	public singerSimon actualSinger;
	public letThemCome actualSinger2;
	int numberOfMyInstrument;

	Animator anim;

	public bool isSimon;
	

	public enum Instrument
	{
		None = 0,
		Bass = 1,
		Flute = 2,
		Guitare = 4,
		Percu = 8,
		Uku = 16
	}

	public void play()
	{
		AkSoundEngine.SetState (instrument.ToString (), instrument.ToString () + "_is" + "playing");
		anim.SetBool ("isPlayingMusic", true);
	}
	public void stop ()
	{
		AkSoundEngine.SetState (instrument.ToString (), instrument.ToString () + "_not" + "playing");
		anim.SetBool ("isPlayingMusic", false);
	}

	public Instrument instrument;

	protected override void StartLookable ()
	{
		base.StartLookable ();

		isSimon = false;

		anim = GetComponentInChildren<Animator> ();

		switch (instrument)
		{
			case Instrument.Bass:
				numberOfMyInstrument = 0;
				break;
			case Instrument.Flute:
				numberOfMyInstrument = 1;
				break;
			case Instrument.Guitare:
				numberOfMyInstrument = 2;
				break;
			case Instrument.Uku:
				numberOfMyInstrument = 3;
				break;
		}
	}

	protected override void UpdateLookable ()
	{
		base.UpdateLookable ();
	}

	public void becomeSimon()
	{
		isSimon = true;
	}

	public override void DoAction ()
	{
		base.DoAction ();
		if(isSimon)
		{
			actualSinger.choose (numberOfMyInstrument);
		}
		else
		{
			if(instrument == Instrument.Bass)
			{
				AkSoundEngine.PostEvent ("Bass_fill", gameObject);
			}
			else if (instrument == Instrument.Flute)
			{
				AkSoundEngine.PostEvent ("Flute_fill", gameObject);
			}
			else if (instrument == Instrument.Guitare)
			{
				AkSoundEngine.PostEvent ("Guit_fill", gameObject);
			}
			else if (instrument == Instrument.Uku)
			{
				AkSoundEngine.PostEvent ("Uku_fill", gameObject);
			}

			actualSinger2.moveToDestination (numberOfMyInstrument);
		}
	}

}
