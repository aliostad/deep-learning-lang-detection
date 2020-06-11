using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace MusicVR.Wall
{
	public class InstrumentUIData : ScriptableObject {

		public enum E_InstrumentCommand 
		{
			toggleScale, 
			toggleInstrument
		};

		public List<InstrumentUIButton> Buttons;

		[System.Serializable]
		public class InstrumentUIButton
		{
			public int Width;
			public E_InstrumentCommand CommandType;
		}
		
		private static InstrumentUIData s_internalInstance;

		public static InstrumentUIData Instance
		{
			get{
				if (s_internalInstance == null)
				{
					s_internalInstance = Resources.Load<InstrumentUIData>("InstrumentUIData");
					if(s_internalInstance == null)
					{
						Debug.LogError("InstrumentUIData could not be loaded");
						return null;
					}
				}
				return s_internalInstance;
			}
		}
	}
}
