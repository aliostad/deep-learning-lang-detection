using UnityEngine;
using System.Collections;

public class GameController : MonoBehaviour {

    private App app;
    private TriangleController triangleController;
    private CircleController circleController;
    private BulletController bulletController;
    private BarrierController barrierController;
    private UIController uiController;


	void Start () 
    {
        Init();
	}

    private void Init()
    {
        Cache();

        triangleController.Init();
        circleController.Init();
        bulletController.Init();
        barrierController.Init();
        uiController.Init();
    }

    private void Cache()
    {
        app = App.Instance;
        triangleController = app.controller.triangle;
        circleController = app.controller.circle;
        bulletController = app.controller.bullet;
        barrierController = app.controller.barrier;
        uiController = app.controller.ui;
    }
}
