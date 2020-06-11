using UnityEngine;
using System.Collections;

public class ControllerSelector : MonoBehaviour {

    private PlayerController _playerController;
    private CursorController _cursorController;

    public void SwitchController(bool switchToMoSix)
    {
        _playerController = GetComponent<PlayerController>();
        _cursorController = GetComponent<CursorController>();
        if (switchToMoSix)
        {
            _playerController.Deactivate();
            _cursorController.Activate();
        }
        else
        {
            _playerController.Activate();
            _cursorController.Deactivate();
        }
    }
}
