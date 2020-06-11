using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteamVR_ChangeControllerIndex : MonoBehaviour {

    public enum Controller_Type
    {
        RIGHT=0,
        LEFT=1,
        MAT=2,
        NONE=-1
    }

    /// <summary>
    /// コントローラのインデックス更新許可
    /// </summary>
    private bool is_admit_change_device_index;
    public bool IsAdmitChangeDeviceIndex
    {
        set
        {
            foreach (SteamVR_TrackedObject c in controller)
                c.IsAdmitDevieIndexChange = value;
        }
    }


    public List<SteamVR_TrackedObject> controller;
    [SerializeField]
    private Controller_Type select_controller;

	// Use this for initialization
	void Start ()
    {
        select_controller = Controller_Type.NONE;
	}
	
	// Update is called once per frame
	void Update ()
    {
		if(Input.GetKeyUp(KeyCode.F1))
        {
            if(select_controller != Controller_Type.NONE)
            {
                SteamVR_TrackedObject.EIndex index = controller[(int)select_controller].index;
                controller[(int)select_controller].index = controller[(int)Controller_Type.RIGHT].index;
                controller[(int)Controller_Type.RIGHT].index = index;
                select_controller = Controller_Type.NONE;
            }
            else select_controller = Controller_Type.RIGHT;
        }

        if (Input.GetKeyUp(KeyCode.F2))
        {
            if (select_controller != Controller_Type.NONE)
            {
                SteamVR_TrackedObject.EIndex index = controller[(int)select_controller].index;
                controller[(int)select_controller].index = controller[(int)Controller_Type.LEFT].index;
                controller[(int)Controller_Type.LEFT].index = index;
                select_controller = Controller_Type.NONE;
            }
            else select_controller = Controller_Type.LEFT;
        }

        if (Input.GetKeyUp(KeyCode.F3))
        {
            if (select_controller != Controller_Type.NONE)
            {
                SteamVR_TrackedObject.EIndex index = controller[(int)select_controller].index;
                controller[(int)select_controller].index = controller[(int)Controller_Type.MAT].index;
                controller[(int)Controller_Type.MAT].index = index;
                select_controller = Controller_Type.NONE;
            }
            else select_controller = Controller_Type.MAT;
        }
    }
}
