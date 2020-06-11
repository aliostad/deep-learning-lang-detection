using Microbots.View.Controllers;

namespace Microbots.View.ExceptionHandlers
{
    class LevelExceptionHandler : MicrobotsExceptionHandler, ILevelController
    {
        private readonly ILevelController _levelController;

        public LevelExceptionHandler(LevelController levelController, ErrorMessagesController errorMessagesController, MessagesCollectionController messagesCollectionController) 
            : base(errorMessagesController, messagesCollectionController)
        {
            _levelController = levelController;
        }
    }
}
