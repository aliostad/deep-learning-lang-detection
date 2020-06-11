using System;

namespace GestionServer.Controller
{
    public static class ControllerFactory
    {
        private static GestionController gestionController;
        private static DeckController deckController;
        private static UserController userController;

        /// <summary>
        /// Retourne l'instance du controlleur de gestion
        /// </summary>
        /// <returns>Controlleur</returns>
        public static GestionController getGestionController()
        {
            if(ControllerFactory.gestionController == null)
            {
                ControllerFactory.gestionController = new GestionController();
            }
            return ControllerFactory.gestionController;
        }

        /// <summary>
        /// Retourne l'instance du controlleur des decks
        /// </summary>
        /// <returns>Controlleur</returns>
        public static DeckController getDeckController()
        {
            if (ControllerFactory.deckController == null)
            {
                ControllerFactory.deckController = new DeckController();
            }
            return ControllerFactory.deckController;
        }

        /// <summary>
        /// Retourne l'instance du controlleur de l'utilisateur
        /// </summary>
        /// <returns>Controlleur</returns>
        public static UserController getUserController()
        {
            if(ControllerFactory.userController == null)
            {
                ControllerFactory.userController = new UserController();
            }
            return ControllerFactory.userController;
        }
    }
}