using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VSMFacadePattern.Controllers;

namespace VSMFacadePattern
{
    class VehicleFacade:IVehicleFacade
    {
        private readonly IEngineController _engineController;
        private readonly ITractionController _tractionController;
        private readonly ITransmissionController _transmissionController;
        private readonly ITachometerController _tachometerController;

        public VehicleFacade(IEngineController engineController
                             ,ITractionController tractionController
                             , ITransmissionController transmissionController
                              , ITachometerController tachometerController)
        {
            _engineController = engineController;
            _tachometerController = tachometerController;
            _tractionController = tractionController;
            _transmissionController = transmissionController;

        }

        public void Start()
        {
            _engineController.Start();
            _tractionController.Enable();
        }

        public void Accelerate()
        {
            _tachometerController.Rpm += 500;
            if (_tachometerController.Rpm>=_tachometerController.Limit || _transmissionController.Gear ==0)     
            {
                _transmissionController.ShiftUp(); 
            }
        }
        public void Brake()
        {
            _tachometerController.Rpm -= 500;
            if (_tachometerController.Rpm <=1500)
            {
                _transmissionController.ShiftDown();
            }
        }

        public void Off()
        {
            _tractionController.Disable();
            _engineController.Stop();
        }
    }

  
}
