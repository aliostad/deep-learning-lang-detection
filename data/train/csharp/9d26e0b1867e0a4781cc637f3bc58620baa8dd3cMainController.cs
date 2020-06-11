namespace SmartCRM.BOL.Controllers
{
    using SmartCRM.BOL.Utilities;

    public class MainController
    {
        private MainController()
        {
            this.AccountController = AccountController.Create();
            this.ProjectDataController = ProjectDataController.Create();
        }

        public AccountController AccountController { get; private set; }

        public ProjectDataController ProjectDataController { get; private set; }

        public static MainController CreateInstance()
        {
            return new MainController();
        }
    }
}
