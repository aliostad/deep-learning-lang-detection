using Projector.Controllers;

namespace Projector
{
    public interface IController
    {
        void Update(
            PubSubController pubSubController,
            TwitterRetrieveController twitterRetrieveController,
            TwitterProcessingController twitterProcessingController,
            ClientListController clientListController,
            ClientSelectionController clientSelectionController,
            StreamController streamController,
            FfmpegProcessController ffmpegProcessController);
    }
}