package pt.isel.adeetc.meic.pdm.common;

public class GenericEvent<T> implements IEvent<T>
{
    private IEventHandler<T> _handler;
    private IEventHandler<IEventHandler<T>> _onHandlerStateChanged;

    public GenericEvent(IEventHandler<T> handler)
    {
        _handler = handler;
    }

    public GenericEvent()
    {
    }

    public void invoke(Object sender, IEventHandlerArgs<T> arg)
    {
        if (_handler != null)
            _handler.invoke(sender, arg);
    }

    public void setEventHandler(IEventHandler<T> handler)
    {
        _handler = handler;
        triggerEventHandlerChanged(_handler);
    }

    public IEventHandler<T> removeEventHandler()
    {
        IEventHandler<T> hand = _handler;
        _handler = null;
        triggerEventHandlerChanged(_handler);
        return hand;
    }

    @Override
    public void setOnEventHandlerChanged(IEventHandler<IEventHandler<T>> handler)
    {
        _onHandlerStateChanged = handler;
    }

    private void triggerEventHandlerChanged(IEventHandler<T> handler)
    {
        if (_onHandlerStateChanged != null)
            _onHandlerStateChanged.invoke(this, new GenericEventArgs<IEventHandler<T>>(handler, null));
    }
}
