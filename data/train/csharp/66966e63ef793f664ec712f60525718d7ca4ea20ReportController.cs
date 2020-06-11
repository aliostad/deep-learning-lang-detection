using GestionRapportsVisite.Gui.Data;
using GestionRapportsVisite.Gui.Windows;

namespace GestionRapportsVisite.Gui.Controllers
{
    public sealed class ReportController : Controller<ReportForm>
    {
        private readonly MenuController _menuController;
        private readonly LoginController _loginController;

        public VISITEUR CurrentVisitor => this._loginController.CurrentUser;

        public ReportController(MenuController menuController, LoginController loginController) : base()
        {
            this._menuController = menuController;
            this._loginController = loginController;
        }

        public void OpenMenu()
        {
            this.Visible = false;
            this._menuController.Visible = true;
        }
    }
}
