namespace EnterSentials.Framework
{
    public class EmailQueueEntry
    {
        public Email Email { get; private set; }
        public EmailDispatchCriteria DispatchCriteria { get; private set; }

        public EmailQueueEntry(Email email, EmailDispatchCriteria dispatchCriteria)
        {
            Guard.AgainstNull(email, "email");
            Guard.Against(email, e => !e.IsValidByDataAnnotations(), "Must provide valid email.", "email");
            Guard.AgainstNull(dispatchCriteria, "dispatchCriteria");
            Guard.Against(dispatchCriteria, c => !c.IsValidByDataAnnotations(), "Must provide valid dispatch criteria.", "dispatchCriteria");
            Email = email;
            DispatchCriteria = dispatchCriteria;
        }
    }
}