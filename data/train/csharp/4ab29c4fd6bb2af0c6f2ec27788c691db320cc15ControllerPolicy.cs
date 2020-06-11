using System;
using Miruken.Container;
using Miruken.Mvc.Policy;

namespace Miruken.Mvc
{
    public class ControllerPolicy : DefaultPolicy
    {
        private readonly WeakReference _controller;

        public ControllerPolicy(IController controller)
        {
            if (controller == null)
                throw new ArgumentNullException(nameof(controller));
            _controller = new WeakReference(controller);
            Track();
        }

        public IController Controller => _controller.Target as IController;

        public ControllerPolicy AutoRelease()
        {
            AutoRelease(() =>
            {
                var controller = Controller;
                if (controller == null) return;
                var context = controller.Context;
                context?.Proxy<IContainer>().Release(controller);
            });
            return this;
        }
    }
}
