using UnityEngine;
using System.Collections;

public class WeaponControllerP : MonoBehaviour {

    PlayerController playerController;

    void Start()
    {
        playerController = transform.root.GetComponentInParent<PlayerController>();
    }

    public void OnTriggerEnter(Collider col)
    {
        
        SkeletonController skelController = col.GetComponent<SkeletonController>();
        if (skelController != null)
        {
            skelController.CurrentHealth -= playerController.Attack / 5;
        }

        ZombieController zombController = col.GetComponent<ZombieController>();
        if (zombController != null)
        {
            zombController.CurrentHealth -= playerController.Attack / 5;
        }

        MonsterControllerV2 monstController = col.GetComponent<MonsterControllerV2>();
        if (monstController != null)
        {
            monstController.CurrentHealth -= playerController.Attack / 5;
        }

        GolemControllerV2 golemController = col.GetComponent<GolemControllerV2>();
        if (golemController != null)
        {
            golemController.CurrentHealth -= playerController.Attack / 6;
        }

        BossController bossController = col.GetComponent<BossController>();
        if (bossController != null)
        {
            bossController.health -= playerController.Attack / 15;
        }
    }
}
