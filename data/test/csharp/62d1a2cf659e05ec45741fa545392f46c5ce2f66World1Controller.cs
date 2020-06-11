using UnityEngine;

public class World1Controller : World
{
    private static GroundController groundController;
    private static CeilingController ceilingController;
    private static LeftWallController leftWallController;
    private static RightWallController rightWallController;
    private static FrontWallController frontWallController;
    private static BackWallController backWallController;

    void Start()
    {
        groundController = GetComponentInChildren<GroundController>();
        ceilingController = GetComponentInChildren<CeilingController>();
        leftWallController = GetComponentInChildren<LeftWallController>();
        rightWallController = GetComponentInChildren<RightWallController>();
        frontWallController = GetComponentInChildren<FrontWallController>();
        backWallController = GetComponentInChildren<BackWallController>();
    }

    public override Vector3 GetWorldCenter()
    {
        float x = (leftWallController.transform.position.x + rightWallController.transform.position.x) / 2;
        float y = (ceilingController.transform.position.y + groundController.transform.position.y) / 2;
        float z = (frontWallController.transform.position.z + backWallController.transform.position.z) / 2;
        return new Vector3(x, y, z);
    }
}