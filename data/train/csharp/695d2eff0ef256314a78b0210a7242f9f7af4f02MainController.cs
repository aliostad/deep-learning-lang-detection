using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Presentation
{
    public class MainController
    {
        private MainView _view;
        private PresentationController _presentationController;
        private SettingsController _settingsController;

        public MainController()
        {
            _view = new MainView(this);
            _settingsController = new SettingsController(this);
            _presentationController = new PresentationController(this);
        }

        public MainView getView()
        {
            return _view;
        }

        public SettingsController getSettingsController()
        {
            return _settingsController;
        }

        public PresentationController getPresentationController()
        {
            return _presentationController;
        }
        
    }
}
