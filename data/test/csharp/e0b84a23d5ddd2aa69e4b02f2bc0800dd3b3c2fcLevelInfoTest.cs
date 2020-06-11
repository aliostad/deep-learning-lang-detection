using UnityEngine;
using System.Collections;

public class LevelInfoTest : MonoBehaviour {

    void Awake()
    {
        TestController.startx = 0;
        TestController.starty = 1;
        TestController.startz = 0;
        TestController.endx = 0;
        TestController.endy = 3;
        TestController.endz = 0;
        TestController.maxx = 8;
        TestController.maxy = 4;
        TestController.maxz = 6;
        TestController.map = new int[TestController.maxx, TestController.maxy, TestController.maxz];
    }
}
