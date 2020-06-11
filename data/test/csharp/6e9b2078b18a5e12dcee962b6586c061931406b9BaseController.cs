using System;
using System.Windows.Forms;
using VMS.Core.Controller;

namespace VMS.App.Controllers
{
    public class BaseController : Controller
    {
        private LoginController controller;
        private LoginForm loginForm;
        private VisitController visitController;

        public BaseController()
        {
            controller = new LoginController(this);
            loginForm = new LoginForm(controller);
            Application.Run(loginForm);
        }

        internal void Login()
        {
            loginForm.Hide();
            visitController = new VisitController(this);
        }
    }
}
