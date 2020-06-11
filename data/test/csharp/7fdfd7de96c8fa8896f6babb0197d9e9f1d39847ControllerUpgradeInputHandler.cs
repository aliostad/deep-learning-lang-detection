using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

[RequireComponent(typeof(SteamVR_TrackedController))]
public class ControllerUpgradeInputHandler : MonoBehaviour {

    public HackerHand hand;
    public UpgradeLaserPointer laserPointer;
    
    private SteamVR_TrackedController controller;

    void Awake()
    {
        controller = GetComponent<SteamVR_TrackedController>();
    }

    void OnEnable()
    {
        controller.MenuButtonClicked += Controller_MenuButtonClicked;
        controller.TriggerClicked += Controller_TriggerClicked;
        controller.TriggerUnclicked += Controller_TriggerUnclicked;
        controller.Gripped += Controller_Gripped;
        controller.Ungripped += Controller_Ungripped;
        controller.PadClicked += Controller_PadClicked;
        controller.PadTouched += Controller_PadTouched;
        controller.PadUntouched += Controller_PadUntouched;
        Debug.Log("now using controller " + controller.controllerIndex);
    }

    void OnDisable()
    {
        controller.TriggerClicked -= Controller_TriggerClicked;
        controller.TriggerUnclicked -= Controller_TriggerUnclicked;
        controller.PadClicked -= Controller_PadClicked;
        controller.PadTouched -= Controller_PadTouched;
        controller.PadUntouched -= Controller_PadUntouched;
        Debug.Log("no longer using controller " + controller.controllerIndex);
    }

    private void Controller_MenuButtonClicked(object sender, ClickedEventArgs e)
    {
        GameData.Instance.hackerIsReady = true;
    }

    private void Controller_TriggerClicked(object sender, ClickedEventArgs e)
    {
        laserPointer.Activate();
    }

    private void Controller_TriggerUnclicked(object sender, ClickedEventArgs e)
    {
    }

    private void Controller_Gripped(object sender, ClickedEventArgs e)
    {
    }

    private void Controller_Ungripped(object sender, ClickedEventArgs e)
    {
    }

    private void Controller_PadTouched(object sender, ClickedEventArgs e)
    {
    }

    private void Controller_PadUntouched(object sender, ClickedEventArgs e)
    {
    }


    private void Controller_PadClicked(object sender, ClickedEventArgs e)
    {
    }


}
