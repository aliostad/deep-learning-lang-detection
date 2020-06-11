using UnityEngine;
using System.Collections;

public class sendStatementEvent : EventScript
{
    public override void ClickAction()
    {
        ShortcutController _controller = GameObject.Find("WillshortCut").GetComponent<ShortcutController>();

        if (_controller.IsAppearing)
        {
            _controller.Disappear();
        }
        
        _controller = GameObject.Find("KeyBoardShortCut1").GetComponent<ShortcutController>();

        if (!_controller.IsAppearing)
        {
            _controller.Appear();
        }
        _controller = GameObject.Find("KeyBoardShortCut2").GetComponent<ShortcutController>();

        if (!_controller.IsAppearing)
        {
            _controller.Appear();
        }

        _controller = GameObject.Find("KeyBoardShortCut3").GetComponent<ShortcutController>();

        if (!_controller.IsAppearing)
        {
            _controller.Appear();
        }
        _controller = GameObject.Find("KeyBoardShortCut4").GetComponent<ShortcutController>();

        if (!_controller.IsAppearing)
        {
            _controller.Appear();
        }
    }
}
