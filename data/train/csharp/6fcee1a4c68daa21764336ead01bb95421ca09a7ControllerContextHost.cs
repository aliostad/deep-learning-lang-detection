using System.Web.Mvc;

namespace RealWorldMvc3.Core.Castle.Components
{
    public class ControllerContextHost
    {
        private ControllerBase controller;

        public void SetController(ControllerBase cntrl)
        {
            if (controller != null && controller.Equals(cntrl))
            {
                return;
            }
            controller = cntrl;
        }

        public ControllerContext GetContext()
        {
            if (controller == null)
            {
                return null;
            }
            return controller.ControllerContext;
        }
    }
}