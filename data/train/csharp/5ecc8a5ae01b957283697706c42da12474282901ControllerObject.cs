using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ViveController
{
    public class ControllerObject
    {
        private GameObject _controller;
        private HapticController _hapticController;
        private GrabController _grabController;
        public GameObject controller
        {
            get { return _controller; }
            set
            {
                _controller = value;
                _hapticController = _controller.GetComponent<HapticController>();
                _grabController = _controller.GetComponent<GrabController>();
            }
        }

        public HapticController hapticController
        {
            get { return _hapticController; }
        }

        public GrabController grabController
        {       
            get { return _grabController; }
        }

        public SteamVR_Controller.Device device
        {
            get 
            {
                SteamVR_TrackedObject sto = _controller.GetComponent<SteamVR_TrackedObject>();
                return SteamVR_Controller.Input((int)sto.index);
            }
        }
        
    }
}
