namespace Ditto.Internal
{
    public class ValueAssignments : ICreateValueAssignment
    {
        private readonly IValueConverterContainer converters;
        private readonly IInvoke invoke;

        public ValueAssignments(IValueConverterContainer converters, IInvoke invoke)
        {
            this.converters = converters;
            this.invoke = invoke;
        }

        public IAssignValue Create(object destination, IDescribeMappableProperty destinationProperty)
        {
            return new ValueAssignment(destination, destinationProperty,converters, invoke);
        }
    }
}