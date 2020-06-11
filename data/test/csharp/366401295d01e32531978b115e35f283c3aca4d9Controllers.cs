using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(GameController))]
[RequireComponent(typeof(GridController))]
[RequireComponent(typeof(InputController))]

public class Controllers : MonoBehaviour {

    private static GameController _gameController;
    public static GameController Game
    {
        get { return _gameController; }
    }

    private static GridController _gridController;
    public static GridController Grid
    {
        get { return _gridController; }
    }

	private static InputController _inputController;
	public static InputController Input
	{
		get { return _inputController; }
	}

	void Awake ()
    {
        _gameController = GetComponent<GameController>();
        _gridController = GetComponent<GridController>();
		_inputController = GetComponent<InputController> ();
	}
	
}
