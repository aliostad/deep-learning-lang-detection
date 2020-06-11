using UI.Factory;

namespace UI.Controller
{
    public class ControllerFactory
    {
        public ControllerFactory(ComponentContainer instance)
        {
            StatusController = new StatusController(instance.ApplicationWindow.StatusTextBlock);
            PanelController = new PanelController(instance.ApplicationWindow.Panel, instance.ServiceFcatory);
            AvailableServicesController = new AvailableServicesController(instance.ApplicationWindow.ToolBar, PanelController);
        }


        internal StatusController StatusController { get; }

        internal AvailableServicesController AvailableServicesController { get; }

        internal  PanelController PanelController { get; }
    }
}