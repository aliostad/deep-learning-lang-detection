using UnityEngine;
using System.Collections;

namespace WP.Controller
{
	public static class ControllerUtility
	{
		private static CONTROLLER_MODE _ControllerMode = CONTROLLER_MODE.NORMAL;
		public static CONTROLLER_MODE ControllerMode {
			get {
				return _ControllerMode;
			}
			set {
				if (_ControllerMode != value) {
					_ControllerMode = value;
					if (OnControllerModeChanged != null) {
						OnControllerModeChanged (_ControllerMode);
					}
				}
			}
		}
		
		public delegate void ControllerModeChangedHandler (CONTROLLER_MODE mode);
		public static event ControllerModeChangedHandler OnControllerModeChanged;
	}
	public enum CONTROLLER_MODE
	{
		NORMAL,
		ACTION,
	}
}
