using System.ComponentModel;

namespace Perenis.Core.Component.Events
{
    /// <summary>
    /// Represents object aware of an <see cref="ISynchronizeInvoke"/> implementation to be used when 
    /// invoking event handlers in the implementing class.
    /// </summary>
    public interface ISynchronizeInvokeAware
    {
        /// <summary>
        /// The <see cref="ISynchronizeInvoke"/> to be used for invoking event handlers.
        /// </summary>
        ISynchronizeInvoke SynchronizeInvoke { get; }
    }
}