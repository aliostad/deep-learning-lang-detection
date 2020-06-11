using System;

namespace LoginServer.Controller
{
    public static class ControllerFactory
    {
        private static UserController userController;

        /// <summary>
        /// Retourne le controlleur des utilisateurs
        /// </summary>
        /// <returns>Controlleur</returns>
        public static UserController getUserController()
        {
            if (ControllerFactory.userController == null)
            {
                ControllerFactory.userController = new UserController();
            }
            return ControllerFactory.userController;
        }
    }
}