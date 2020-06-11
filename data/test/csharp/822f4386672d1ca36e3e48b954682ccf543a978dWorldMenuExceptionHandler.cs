using Microbots.View.Controllers;

namespace Microbots.View.ExceptionHandlers
{
    class LevelSelectExceptionHandler : MicrobotsExceptionHandler, ILevelSelectController
    {
        private readonly ILevelSelectController _levelSelectController;

        public LevelSelectExceptionHandler(LevelSelectController levelSelectController, ErrorMessagesController errorMessagesController, MessagesCollectionController messagesCollectionController) 
            : base(errorMessagesController, messagesCollectionController)
        {
            _levelSelectController = levelSelectController;
        }
    }
}
