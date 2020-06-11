using UnityEngine.UI;
using UnityEngine;

public class Settings : MonoBehaviour 
{
	public static bool controllerEnabled = true;

	public Text controllerText;

	public delegate void ControllerToggle(bool b);
	public static ControllerToggle ControllerToggleEvent;

	private void Start()
	{
		// Load Settings

		// Controller Enabled
		int ce = PlayerPrefs.GetInt("ControllerEnabled");
		ToggleController(ce == 1);
	}

	public void TC() { ToggleController(!controllerEnabled); }

	public void ToggleController(bool b)
	{
		controllerEnabled = b;

		if(ControllerToggleEvent != null)
			ControllerToggleEvent(controllerEnabled);

		controllerText.text = "Controller: ";
		controllerText.text += controllerEnabled ? "Enabled" : "Disabled";

		int ce = controllerEnabled ? 1 : 0;
		PlayerPrefs.SetInt("ControllerEnabled", ce);
	}
}
