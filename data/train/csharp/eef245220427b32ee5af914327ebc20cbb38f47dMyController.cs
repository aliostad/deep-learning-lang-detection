using UnityEngine;
using System.Collections;

public class MyController : MonoBehaviour {

    public enum Side
    {
        side1,
        side2
    }

	public static GameController gc
	{
		get {return GetGameController (); }
	}
	public static ClickController cc
	{
		get {return GetClickController (); }
	}



    public static GameController GetGameController()
    {
        GameController gameController = null;

        GameObject gameControllerObject = GameObject.FindWithTag("GameController");
        if (gameControllerObject != null)
        {
            gameController = gameControllerObject.GetComponent<GameController>();
        }

        if (gameController == null)
        {
            Debug.Log("Cant find gameController script");
        }

        return gameController;
    }


	public static ClickController GetClickController()
	{
		ClickController clickController = null;

		GameObject gameControllerObject = GameObject.FindWithTag("GameController");
		if (gameControllerObject != null)
		{
			clickController = gameControllerObject.GetComponentInChildren<ClickController>();
		}

		if (clickController == null)
		{
			Debug.Log("Cant find clickController script");
		}

		return clickController;
	}
}
