using System;
using System.Drawing;
using DumbBotsNET.Api;

public class AIScript : ICommand
{
    public void Think(IPlayerApi api)
    {
        if (!api.GetEnemySighted())
        {
            if ((api.GetHealth() < 100) && (api.GetNumberofVisibleMedkits() > 0))
            {
                api.GetNearestMedkit();
            }
            else
            {
                if ((api.GetAmmo() < 3) && (api.GetNumberOfVisibleBazookas() > 0))
                {
                    api.GetNearestBazooka();
                }
                else
                {
                    api.MoveToRandomLocation();
                }
            }
        }
        else
        {
            if ((api.GetHealth() < 40) && (api.GetNumberofVisibleMedkits() > 0))
            {
                api.GetNearestMedkit();
            }
            else
            {
                if (api.GetAmmo() == 0)
                {
                    api.Stop();
                    api.ShootBullet(api.GetEnemyPosition());
                }
                else
                {
                    api.Stop();
                    api.ShootRocket(api.GetEnemyPosition());
                }
            }
        }
    }
}