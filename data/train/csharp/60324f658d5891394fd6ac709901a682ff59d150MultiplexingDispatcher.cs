namespace CR.MessageDispatch.Core
{
    public class MultiplexingDispatcher<TMessage> : IDispatcher<TMessage>
    {
        private readonly IDispatcher<TMessage>[] _dispatchers; 

        public MultiplexingDispatcher(params IDispatcher<TMessage>[] dispatchers)
        {
            _dispatchers = dispatchers;
        }

        public void Dispatch(TMessage message)
        {
            foreach(var dispatcher in _dispatchers)
                dispatcher.Dispatch(message);
        }
    }
}