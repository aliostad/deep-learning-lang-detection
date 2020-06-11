using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace Kikwak.AutoFunctionCollection
{
	
	public class DebugginLog
	{
		public static DebugginLog Instance = new DebugginLog();

		private DebuggingWindow dw = new DebuggingWindow();

		[System.Diagnostics.Conditional("DEBUG")]	
		public void Show()
		{
			if (dw == null) {
				dw = new DebuggingWindow();
				if (dw.InvokeRequired) {
					dw.BeginInvoke(new InvokeDelegate(InvokeShow));
				}
				else {
					InvokeShow();
				}
			}
			else if (dw.IsDisposed) {
				dw = new DebuggingWindow();
				if (dw.InvokeRequired) {
					dw.BeginInvoke(new InvokeDelegate(InvokeShow));
				}
				else {
					InvokeShow();
				}
			}
			else if (!dw.Visible) {
				if (dw.InvokeRequired) {
					dw.BeginInvoke(new InvokeDelegate(InvokeShow));
				}
				else {
					InvokeShow();
				}
			}
		}

		private delegate void InvokeDelegate();

		private void InvokeShow()
		{
			dw.Show();
		}

		[System.Diagnostics.Conditional("DEBUG")]
		public void AddString(string msg, string catagory)
		{
			dw.AddString(msg, catagory);
		}

	}
}
