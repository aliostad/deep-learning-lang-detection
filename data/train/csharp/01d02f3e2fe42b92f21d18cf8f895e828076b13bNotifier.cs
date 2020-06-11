using System;

namespace Base
{
    public class Notifier: INotifier
    {
        public virtual void DispatchNotification(Enum notificationName)
        {
            Facade.Instance.DispatchNotification(notificationName);
        }
        public virtual void DispatchNotification(Enum notificationName, object body)
        {
            Facade.Instance.DispatchNotification(notificationName, body);
        }
        public virtual void DispatchNotification(Enum notificationName, object body, Enum enumTypeValue)
        {
            Facade.Instance.DispatchNotification(notificationName, body, enumTypeValue);
        }
    }
}
