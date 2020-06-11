using Units;

namespace Labyrinth
{
    public class ActiveMapLocationController
    {
        private IMapController _mapController;
        private IUnitsController _unitsController;

        public ActiveMapLocationController()
        {

        }

        public void Initialize()
        {
            _mapController = ServiceLocator.GetMapController();
            _unitsController = ServiceLocator.GetUnitsController();
            _unitsController.Player.PositionChanged += PlayerPositionChanged;
        }

        private void PlayerPositionChanged()
        {
            _mapController.UpdateCurrentPosition(_unitsController.Player.Position);
        }
    }
}