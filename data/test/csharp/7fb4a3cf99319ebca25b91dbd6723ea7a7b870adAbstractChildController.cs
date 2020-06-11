using System;
using System.Collections.Generic;

namespace PipBenchmark.Gui.Shell
{
    public abstract class AbstractChildController
    {
        private MainController _mainController;

        protected AbstractChildController(MainController mainController)
        {
            _mainController = mainController;
        }

        public MainController MainController
        {
            get { return _mainController; }
        }

        public IMainView MainView
        {
            get { return _mainController.View; }
        }
    }
}
