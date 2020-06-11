using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameModelView : MonoBehaviour, IGame {

    private CameraController cameraControllerValue;
    public CameraController CameraController
    {
        get
        {
            return cameraControllerValue;
        }
        set
        {
            cameraControllerValue = value;
        }
    }

    private CharacterController characterControllerValue;
    public CharacterController CharacterController
    {
        get
        {
            return characterControllerValue;
        }
        set
        {
            characterControllerValue = value;
        }
    }

    private SceneController sceneControllerValue;
    public SceneController SceneController
    {
        get
        {
            return sceneControllerValue;
        }
        set
        {
            sceneControllerValue = value;
        }
    }

    public void InitCharacter(GameController gameController)
    {
        CharacterController = new CharacterController(gameController);
        CharacterController.InitModelView(this.gameObject);
    }

    public void InitScene(GameController gameController)
    {
        SceneController = new SceneController(gameController);
        SceneController.InitModelView(this.gameObject);
    }

    public void InitCamera(GameController gameController)
    {
        CameraController = new CameraController(gameController);
        CameraController.InitModelView(this.gameObject);
    }
}
