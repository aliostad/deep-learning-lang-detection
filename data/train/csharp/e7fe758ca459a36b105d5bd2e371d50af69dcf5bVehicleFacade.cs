using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignPatterns.Facade
{
    public class VehicleFacade : IVehicleFacade
    {
        private readonly IEngineController _engineController;
        private readonly ITransmissionController _transmissionController;
        private readonly ITractionControlController _tractionControlController;
        private readonly ITachometerController _tachometerController;

        public VehicleFacade(IEngineController engineController, ITransmissionController transmissionController,
    ITractionControlController tractionControlController, ITachometerController tachometerController)
        {
            _engineController = engineController;
            _transmissionController = transmissionController;
            _tractionControlController = tractionControlController;
            _tachometerController = tachometerController;
        }

        public void Start()
        {
            _engineController.Start();
            _tractionControlController.Enable();
        }

        public void Accelerate()
        {
            _tachometerController.Rpm += 500;
            if (_tachometerController.Rpm >= _tachometerController.Limit || _transmissionController.Gear == 0)
            {
                _transmissionController.ShiftUp();
            }
        }

        public void Brake()
        {
            _tachometerController.Rpm -= 500;
            if (_tachometerController.Rpm <= 1500)
                _transmissionController.ShiftDown();

        }

        public void Off()
        {
            _tractionControlController.Disable();
            _engineController.Stop();
        }
    }
}
