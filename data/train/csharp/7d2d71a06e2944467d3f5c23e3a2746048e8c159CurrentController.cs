using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace JInput {

    public class CurrentController : MonoBehaviour {

        private Controller m_Controller;
        public static Controller currentController { get { return m_Singleton.m_Controller; } }

        [Range(0, 5)]
        public int m_ControllerIndex = 0;

        private static CurrentController m_Singleton;

        void Awake() {
            m_Singleton = this;
            getController();
        }
        void OnEnable() {
            m_Singleton = this;
            getController();
        }

        // Update is called once per frame
        void Update() {
            getController();
        }

        private void updateController() {
            m_Controller = InputManager.getController(m_ControllerIndex);
        }

        private void getController() {
            updateController();

            if (m_Controller == null) {
                m_ControllerIndex--;
                if (m_ControllerIndex == -1) {
                    m_ControllerIndex = 0;
                    return;
                }
                updateController();
            }
        }


    }

}