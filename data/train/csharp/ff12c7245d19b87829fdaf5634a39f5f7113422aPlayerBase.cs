using UnityEngine;
using System.Collections;

public class PlayerBase : MonoBehaviour {

    private PlayerAnimationController _animationController;
    public PlayerAnimationController PlayerAnimationController
    {
        get
        {
            if (_animationController == null)
                _animationController = GetComponent<PlayerAnimationController>();

            return _animationController;
        }
    }

    private PlayerCollisionsController _collisionController;
    public PlayerCollisionsController PlayerCollisionsController
    {
        get
        {
            if (_collisionController == null)
                _collisionController = GetComponent<PlayerCollisionsController>();

            return _collisionController;
        }
    }

    private PlayerController _playerController;
    public PlayerController PlayerController
    {
        get
        {
            if (_playerController == null)
                _playerController = GetComponent<PlayerController>();

            return _playerController;
        }
    }
}
