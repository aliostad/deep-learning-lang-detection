namespace Mommosoft.Capi {
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Collections.ObjectModel;

    public class ControllerCollection : ReadOnlyCollection<Controller> {
        internal ControllerCollection(IList<Controller> controllers)
            : base(controllers) {
        }

        public Controller GetControllerByID(uint controllerID) {
            lock (this) {
                foreach (Controller controller in this) {
                    if (controller.ID == controllerID)
                        return controller;
                }
            }
            return null;
        }
    }
}
