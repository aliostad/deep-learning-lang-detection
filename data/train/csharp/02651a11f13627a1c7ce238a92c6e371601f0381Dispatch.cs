using NServiceBus.Extensibility;

namespace NServiceBus.FluentOptions
{
    public class Dispatch : MessageOption
    {
        private Dispatch()
        {
        }

        public static Dispatch Immediately { get; } = new Dispatch();

        internal override void Apply(ExtendableOptions options)
        {
            options.RequireImmediateDispatch();
        }

        internal override bool IsApplied(ExtendableOptions options)
        {
            return options.RequiredImmediateDispatch();
        }
    }
}