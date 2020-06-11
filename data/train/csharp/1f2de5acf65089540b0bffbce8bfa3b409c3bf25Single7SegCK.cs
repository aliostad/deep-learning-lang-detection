namespace Pigmeo.Displays.SevenSegments {
	/// <summary>
	/// Single Seven Segment display. Common cathode without dot point
	/// </summary>
	public class Single7SegCK {
		private Delegates.SetBool WriteSegmentA;
		private Delegates.SetBool WriteSegmentB;
		private Delegates.SetBool WriteSegmentC;
		private Delegates.SetBool WriteSegmentD;
		private Delegates.SetBool WriteSegmentE;
		private Delegates.SetBool WriteSegmentF;
		private Delegates.SetBool WriteSegmentG;

		/// <summary>
		/// Single Seven Segment display. Common cathode without dot point
		/// </summary>
		/// <param name="SegmentAWriter">Segment A</param>
		/// <param name="SegmentBWriter">Segment B</param>
		/// <param name="SegmentCWriter">Segment C</param>
		/// <param name="SegmentDWriter">Segment D</param>
		/// <param name="SegmentEWriter">Segment E</param>
		/// <param name="SegmentFWriter">Segment F</param>
		/// <param name="SegmentGWriter">Segment G</param>
		public Single7SegCK(Delegates.SetBool SegmentAWriter, Delegates.SetBool SegmentBWriter, Delegates.SetBool SegmentCWriter, Delegates.SetBool SegmentDWriter, Delegates.SetBool SegmentEWriter, Delegates.SetBool SegmentFWriter, Delegates.SetBool SegmentGWriter) {
			WriteSegmentA = SegmentAWriter;
			WriteSegmentB = SegmentBWriter;
			WriteSegmentC = SegmentCWriter;
			WriteSegmentD = SegmentDWriter;
			WriteSegmentE = SegmentEWriter;
			WriteSegmentF = SegmentFWriter;
			WriteSegmentG = SegmentGWriter;
		}

		/// <summary>
		/// Turns off all segments
		/// </summary>
		public void TurnOFF() {
			WriteSegmentA.Invoke(false);
			WriteSegmentB.Invoke(false);
			WriteSegmentC.Invoke(false);
			WriteSegmentD.Invoke(false);
			WriteSegmentE.Invoke(false);
			WriteSegmentF.Invoke(false);
			WriteSegmentG.Invoke(false);
		}

		/// <summary>
		/// Turns on all segments. Useful for testing them
		/// </summary>
		public void TurnAllOn() {
			WriteSegmentA.Invoke(true);
			WriteSegmentB.Invoke(true);
			WriteSegmentC.Invoke(true);
			WriteSegmentD.Invoke(true);
			WriteSegmentE.Invoke(true);
			WriteSegmentF.Invoke(true);
			WriteSegmentG.Invoke(true);
		}

		/// <summary>
		/// Shows a given character on the display
		/// </summary>
		/// <remarks>
		/// You should always pass constant characters, as in obj.SetValue('A') or obj.SetValue('3'). If you pass variable characters as in "char c = '5'; obj.SetValue(c);" a lot more code will be included in your application. It's unavoidable
		/// </remarks>
		/// <param name="character">Character to show</param>
		public void SetValue(char character) {
			switch(character) {
				case '0':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case '1':
					WriteSegmentA.Invoke(false);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(false);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(false);
					break;
				case '2':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(false);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(true);
					break;
				case '3':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(true);
					break;
				case '4':
					WriteSegmentA.Invoke(false);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(false);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case '5':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case '6':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case '7':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(false);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(false);
					break;
				case '8':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case '9':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(false);
					WriteSegmentE.Invoke(false);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case 'A':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(false);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case 'a':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(true);
					break;
				case 'B':
					goto case 'b';
				case 'b':
					WriteSegmentA.Invoke(false);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case 'C':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(false);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(false);
					break;
				case 'c':
					WriteSegmentA.Invoke(false);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(false);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(true);
					break;
				case 'D':
					goto case 'd';
				case 'd':
					WriteSegmentA.Invoke(false);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(true);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(false);
					WriteSegmentG.Invoke(true);
					break;
				case 'E':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(false);
					WriteSegmentC.Invoke(false);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				case 'e':
					WriteSegmentA.Invoke(true);
					WriteSegmentB.Invoke(true);
					WriteSegmentC.Invoke(false);
					WriteSegmentD.Invoke(true);
					WriteSegmentE.Invoke(true);
					WriteSegmentF.Invoke(true);
					WriteSegmentG.Invoke(true);
					break;
				default:
					TurnOFF();
					break;
			}
		}
	}
}
