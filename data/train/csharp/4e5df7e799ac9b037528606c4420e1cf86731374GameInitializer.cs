using UnityEngine;
using System.Collections;

public class GameInitializer : MonoBehaviour {
	
	private GameController gameController;
	private InputController inputController;
	private ColorController colorController;
		
	void Awake()
	{
		gameController = GameController.Instance;
		inputController = InputController.Instance;
		colorController = ColorController.Instance;

		gameController.transform.parent = this.transform;
		inputController.transform.parent = this.transform;
		colorController.transform.parent = this.transform;
	}
}
