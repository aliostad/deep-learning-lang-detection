using UnityEngine;
using System.Collections;

public class ControllerFactory {
    public static ControllerBase create(PlayerIndex player)
    {
        ControllerBase controller = null;
        switch (player)
        {
            case PlayerIndex.P1:
                controller = new ControllerP1();
                break;
            case PlayerIndex.P2:
                controller = new ControllerP2();
                break;
            case PlayerIndex.P3:
                controller = new ControllerP3();
                break;
            case PlayerIndex.P4:
                controller = new ControllerP4();
                break;
        }
        return controller;
    }
}
