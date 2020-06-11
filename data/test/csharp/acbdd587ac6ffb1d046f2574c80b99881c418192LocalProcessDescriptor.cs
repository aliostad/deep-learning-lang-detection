using System;

namespace Inceptum.Cqrs.Configuration.BoundedContext
{
    internal class LocalProcessDescriptor : DescriptorWithDependencies<Context>
    {
        public LocalProcessDescriptor(object process)
            : base(process)
        {
            if (!(process is IProcess))
            {
                throw new Exception("Process must implement IProcess interface");
            }
        }

        public LocalProcessDescriptor(Type process)
            : base(process)
        {
            if (!typeof(IProcess).IsAssignableFrom(process))
            {
                throw new Exception("Process must implement IProcess interface");
            }
        }

        public override void Process(Context context, CqrsEngine cqrsEngine)
        {
            foreach (var process in ResolvedDependencies)
            {
                context.Processes.Add(((IProcess)process));
            }
        }
    }
}