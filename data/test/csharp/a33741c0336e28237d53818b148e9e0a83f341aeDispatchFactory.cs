using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EC;
namespace siqi.Logic.Dispatch
{
    public class DispatchFactory
    {
        private Dispatch.RoomDispatcher mRoomDispatcher;

        private Dispatch.DeskDispatcher mDeskDispatcher;

        private Dispatch.Dispatcher mTalkDispather;

        private Dispatch.Dispatcher mLoginDispather;

        private Dispatch.Dispatcher mGlobalDispather;

        private Dictionary<Type, Dispatcher> mDispatcherMap = new Dictionary<Type, Dispatcher>();

        public DispatchFactory(Interfaces.ISiqiServer server)
        {
            //
            mLoginDispather = new Dispatch.Dispatcher();
            mTalkDispather = new Dispatch.Dispatcher();
            mGlobalDispather = new Dispatch.Dispatcher();
            mRoomDispatcher = new Dispatch.RoomDispatcher(server);
            mDeskDispatcher = new Dispatch.DeskDispatcher(); 
        }
        public void Initialize()
        {
            Register<Protocol.Login, Handlers.LoginHandler>(mLoginDispather);

            Register<Protocol.Talk, Handlers.TalkHandler>(mTalkDispather);

            Register<Protocol.ListRoom, Dispatch.Handlers.ListRoomHandler>(mGlobalDispather);
            Register<Protocol.SelectRoom, Dispatch.Handlers.SelectRoomHandler>(mGlobalDispather);
            Register<Protocol.SelectDesk, Handlers.SelectDeskHandler>(mGlobalDispather);
            Register<Protocol.GetRoom, Handlers.GetRoomHandler>(mGlobalDispather);
        }

        private void Register<MSG, HANDLER>(Dispatch.Dispatcher dispatcher) where HANDLER : IMessageHandler, new()
        {
            mDispatcherMap[typeof(MSG)] = dispatcher;
            dispatcher.Register<MSG, HANDLER>();
        }

        public void Route(MessageToken message)
        {
            Dispatcher dispatch = null;
            if (mDispatcherMap.TryGetValue(message.Message.GetType(), out dispatch))
            {
                dispatch.Add(message);
            }
            else
            {
                "{0} message handler not found!".Log4Error(message.Message.GetType());
            }
            
        }
    }
}
