//////__     __               _                 _     _               _   
//////\ \   / /              | |               | |   | |             | |  
////// \ \_/ /__  _   _   ___| |__   ___  _   _| | __| |  _ __   ___ | |_ 
//////  \   / _ \| | | | / __| '_ \ / _ \| | | | |/ _` | | '_ \ / _ \| __|
//////   | | (_) | |_| | \__ \ | | | (_) | |_| | | (_| | | | | | (_) | |_ 
//////   |_|\___/ \__,_| |___/_| |_|\___/ \__,_|_|\__,_| |_| |_|\___/ \__|
//////      _                              _   _     _     _ 
//////     | |                            | | | |   (_)   | |
//////  ___| |__   __ _ _ __   __ _  ___  | |_| |__  _ ___| |
////// / __| '_ \ / _` | '_ \ / _` |/ _ \ | __| '_ \| / __| |
//////| (__| | | | (_| | | | | (_| |  __/ | |_| | | | \__ \_|
////// \___|_| |_|\__,_|_| |_|\__, |\___|  \__|_| |_|_|___(_)
//////                         __/ |                         
//////                        |___/                          

using System;
using Project290.Physics.Dynamics;

namespace Project290.Physics.Controllers
{
    [Flags]
    public enum ControllerType
    {
        GravityController = (1 << 0),
        VelocityLimitController = (1 << 1),
        AbstractForceController = (1 << 2)
    }

    public class FilterControllerData : FilterData
    {
        private ControllerType _type;

        public FilterControllerData(ControllerType type)
        {
            _type = type;
        }

        public override bool IsActiveOn(Body body)
        {
            if (body.ControllerFilter.IsControllerIgnored(_type))
                return false;

            return base.IsActiveOn(body);
        }
    }

    public class ControllerFilter
    {
        public ControllerType ControllerFlags;

        /// <summary>
        /// Ignores the controller. The controller has no effect on this body.
        /// </summary>
        /// <param name="controller">The controller type.</param>
        public void IgnoreController(ControllerType controller)
        {
            ControllerFlags |= controller;
        }

        /// <summary>
        /// Restore the controller. The controller affects this body.
        /// </summary>
        /// <param name="controller">The controller type.</param>
        public void RestoreController(ControllerType controller)
        {
            ControllerFlags &= ~controller;
        }

        /// <summary>
        /// Determines whether this body ignores the the specified controller.
        /// </summary>
        /// <param name="controller">The controller type.</param>
        /// <returns>
        /// 	<c>true</c> if the body has the specified flag; otherwise, <c>false</c>.
        /// </returns>
        public bool IsControllerIgnored(ControllerType controller)
        {
            return (ControllerFlags & controller) == controller;
        }
    }

    public abstract class Controller
    {
        public bool Enabled;
        public FilterControllerData FilterData;

        public World World;

        public Controller(ControllerType controllerType)
        {
            FilterData = new FilterControllerData(controllerType);
        }

        public abstract void Update(float dt);
    }
}