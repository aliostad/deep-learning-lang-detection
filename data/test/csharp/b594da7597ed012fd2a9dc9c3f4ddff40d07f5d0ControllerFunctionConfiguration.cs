using JetBrains.Annotations;
using LrControl.Core.Mapping;

namespace LrControl.Core.Configurations
{
    public class ControllerFunctionConfiguration
    {
        [UsedImplicitly]
        public ControllerFunctionConfiguration()
        {
        }

        public ControllerFunctionConfiguration(ControllerFunction controllerFunction)
        {
            ControllerKey = new ControllerConfigurationKey(controllerFunction.Controller);
            FunctionKey = controllerFunction.Function?.Key;
        }

        public ControllerConfigurationKey ControllerKey { get; set; }
        public string FunctionKey { get; set; }
    }
}