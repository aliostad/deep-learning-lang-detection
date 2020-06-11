using Avanade.AzureDAM.MessageBus.Dispatcher;
using Avanade.AzureDAM.MessageBus.Infrastructure;
using Avanade.AzureDAM.Messages;
using Microsoft.Azure.WebJobs;
using Microsoft.Practices.Unity;

namespace Avanade.AzureDAM.MessageBus
{
    public class MessageFunctions
    {
        private static  MessageDispatch _dispatch;
        private static  IUnityContainer _container;

        public static void Init()
        {
            _container = UnityConfiguration.GetConfiguredContainer();
            _dispatch = _container.Resolve<MessageDispatch>();
        }
        
        public static void HandleNewImageAddedMessage([QueueTrigger("newimageadded")] NewImageAdded message) => _dispatch.Dispatch(message);
        public static void HandleNewVideoAddedMessage([QueueTrigger("newvideoadded")] NewVideoAdded message) => _dispatch.Dispatch(message);
    }
}