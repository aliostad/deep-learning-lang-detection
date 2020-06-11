using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcApp
{
    public class MyControllerActionInvoker : ControllerActionInvoker
    {
        protected override ControllerDescriptor GetControllerDescriptor(ControllerContext controllerContext)
        {
            ControllerDescriptor controllerDescriptor = base.GetControllerDescriptor(controllerContext);
            if (controllerDescriptor is ReflectedControllerDescriptor)
            {
                return new MyReflectedControllerDescriptor(controllerDescriptor.ControllerType);
            }
            return controllerDescriptor;
        }
    }
}