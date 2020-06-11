//Definitions Class
//Created by: Garrett Moody
//Created: 07/10/2015
using UnityEngine;
using System.Collections;

public class Definitions : MonoBehaviour
{
	#region Instruments
	//Instruments
	public class Instrument
	{
		private int ID;
		private string Name;

		public Instrument(int ID, string Name)
		{
			this.ID = ID;
			this.Name = Name;
		}
	}
	
	public readonly Instrument VOCAL = new Instrument(0, "Vocal");
	public readonly Instrument GUITAR = new Instrument(1, "Guitar");
	public readonly Instrument BASS = new Instrument(2, "Bass");
	public readonly Instrument DRUMS = new Instrument(3, "Drums");
	public readonly Instrument KEYBOARD = new Instrument(4, "Keyboard");
	public readonly Instrument TRUMPET = new Instrument(5, "Trumpet");
	public readonly Instrument SAX = new Instrument(6, "Sax");
	public readonly Instrument BANJO = new Instrument(7, "Banjo");

	#endregion

	#region Constants

	//Gender
	public const bool MALE = true;
	public const bool FEMALE = false;

	#endregion
}