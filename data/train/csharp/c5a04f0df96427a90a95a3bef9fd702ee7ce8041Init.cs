using System;
using System.Collections.Generic;
using System.Reflection;

using Agrotera.Scripting;
using Agrotera.Core.Entities.Controllers;

using Agrotera.DefaultControllers.Simple;
using Agrotera.DefaultControllers.Complex;
using Agrotera.DefaultControllers.SubSystems;

namespace Agrotera.DefaultControllers
{
    public class Init : IScript
    {
        public void InitAgroteraScript()
        {
            // just register the default controllers
            ControllerCache.RegisterController(typeof(Default));
			ControllerCache.RegisterController(typeof(Multiplexer));

			ControllerCache.RegisterController(typeof(Spinner));
			ControllerCache.RegisterController(typeof(Mover));

			ControllerCache.RegisterController(typeof(PowerSystemController));
			ControllerCache.RegisterController(typeof(SensorSystemController));

			ControllerCache.RegisterController(typeof(VesselController));
			ControllerCache.RegisterController(typeof(ShipController));
			ControllerCache.RegisterController(typeof(StationController));

		}
    }
}
