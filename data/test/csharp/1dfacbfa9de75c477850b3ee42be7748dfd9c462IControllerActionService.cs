using YooPoon.Core.Autofac;
using YooPoon.WebFramework.Authentication.Entity;

namespace YooPoon.WebFramework.Authentication.Services
{
    public interface IControllerActionService : IDependency
    {
        ControllerAction GetControllerAction(int id);

        ControllerAction GetControllerActionByName(string controllerName,
            string actionName);

        ControllerAction ExistOrCreate(string controllerName,
            string actionName);

        ControllerAction Update(
            ControllerAction controllerAction);

        ControllerAction Create(
            ControllerAction controllerAction);

        bool Delet(ControllerAction controllerAction);
    }
}