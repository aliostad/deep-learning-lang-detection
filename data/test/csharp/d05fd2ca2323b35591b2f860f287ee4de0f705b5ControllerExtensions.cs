using System;

namespace ResumeMaker.Extensions
{
    public static class ControllerExtensions
    {
        public static string GetControllerName(this Type controllerType)
        {
            var controllerName = controllerType.Name;
            if (controllerName.EndsWith("Controller", StringComparison.OrdinalIgnoreCase))
            {
                controllerName = controllerName.Substring(0, controllerName.Length - "Controller".Length);
            }
            return controllerName;
        }
    }
}
