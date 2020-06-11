using Core.Controllers;
using Game.Controllers.Asteroids;
using Game.Controllers.Players;

namespace Game.Controllers
{
    public class AGameController : GameController
    {
        public AsteroidController asteroidController { get; private set; }
        public PlayerController playerController { get; private set; }
        public StatisticsController statisticsController { get; private set; }
        public ScreenWrappingController screenWrappingController { get; private set; }

        public AGameController() {
            controllers.Add(statisticsController = new StatisticsController());
            controllers.Add(playerController = new PlayerController());
            controllers.Add(asteroidController = new AsteroidController(statisticsController));
            controllers.Add(screenWrappingController = new ScreenWrappingController(
                asteroidController.asteroidsPools, playerController.controlledPlayer));
        }
    }
}