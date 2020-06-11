using System;
using System.Drawing;
using DumbBotsNET.Api;

public class AIScript : ICommand
{
	private static Point _enemyPosition;

	private static readonly Random Entropy = new Random();
	private const double Dodge = 0.5;

	public void Think(IPlayerApi api)
    {
	    if (api.GetEnemySighted())
	    {
		    ShootAndRun(api);
			return;
	    }

	    RunForItem(api);
    }

	public static bool IsDodge()
	{
		return Entropy.NextDouble() < Dodge;
	}

	private static void ShootAndRun(IPlayerApi api)
	{
		if (IsDodge())
		{
			if ((api.GetHealth() < 40) && (api.GetNumberofVisibleMedkits() > 0))
			{
				api.GetNearestMedkit();
				return;
			}

			if (api.GetNumberOfVisibleBazookas() > 0)
			{
				api.GetNearestBazooka();	
			}
			else
			{
				api.MoveToRandomLocation();
			}
			
			return;
		}

		Shoot(api);

		_enemyPosition = api.GetEnemyPosition();
	}

	private static void Shoot(IPlayerApi api)
	{
		if (api.GetAmmo() == 0)
		{
			api.Stop();
			api.ShootBullet(AimPistol(api));
		}
		else
		{
			api.Stop();
			api.ShootRocket(AimRocket(api));
		}
	}

	private static Point Aim(IPlayerApi api, int factor)
	{
		var pos = api.GetEnemyPosition();
		if (_enemyPosition != null)
		{
			var deltaX = pos.X - _enemyPosition.X;
			var deltaY = pos.Y - _enemyPosition.Y;

			//todo: add distance

			return new Point(pos.X + factor * deltaX, pos.Y + factor * deltaY);
		}

		return pos;
	}

	private static Point AimPistol(IPlayerApi api)
	{
		return Aim(api, 20);
	}

	private static Point AimRocket(IPlayerApi api)
	{
		return Aim(api, 40);
	}

	private static void RunForItem(IPlayerApi api)
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
}