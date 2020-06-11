using System;

namespace Facade
{
    public class VehicleFacade : IVehicleFacade
    {
        private readonly IEngineController _engineController;
        private readonly ITransmissionController _transmissionController;
        private readonly ITractionControlController _tractionControlController;
        private readonly ITachometerController _tachometerController;

        private const int RpmValue = 500;
        private const int RpmThreshold = 1500;

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
            if (_engineController.Running)
            {
                _tractionControlController.Enable();
            }
        }

        public void Accelerate()
        {
            if (_transmissionController.Gear == 0)
            {
                _transmissionController.ShiftUp();
                _tachometerController.Rpm += RpmValue;
            }
            else if (_tachometerController.Rpm >= _tachometerController.Limit && _transmissionController.Gear < _transmissionController.MaxGear)
            {
                _transmissionController.ShiftUp();
                _tachometerController.Rpm = RpmThreshold;
            }
            else if (_tachometerController.Rpm >= _tachometerController.Limit && _transmissionController.Gear == _transmissionController.MaxGear)
            {
                Console.WriteLine("Imminent overheating - you need to brake !!!");
            }
            else
            {
                _tachometerController.Rpm += RpmValue;
            }
        }

        public void SlowDown()
        {
            _tachometerController.Rpm -= RpmValue;
            if (_tachometerController.Rpm <= RpmThreshold && _transmissionController.Gear > 0)
            {
                _transmissionController.ShiftDown();
                _tachometerController.Rpm = RpmThreshold;
            }
        }

        public void BrakeUntilItStops()
        {
            while (_tachometerController.Rpm > 0)
            {
                SlowDown();
                System.Threading.Thread.Sleep(100);
            }
        }

        public void Off()
        {
            _tractionControlController.Disable();
            _engineController.Stop();
        }
    }
}