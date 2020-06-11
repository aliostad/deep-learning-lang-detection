using System;

namespace LostPolygon.Envoy {
    /// <summary>
    /// An attribute specifying the default dispatch type for an event.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = true)]
    public class DefaultDispatchTypeAttribute : Attribute {
        /// <summary>
        /// Initializes a new instance of the <see cref="DefaultDispatchTypeAttribute"/> class.
        /// </summary>
        /// <param name="dispatchType">
        /// Default dispatch type that will be used for an event.
        /// </param>
        public DefaultDispatchTypeAttribute(EventDispatchType dispatchType) {
            DispatchType = dispatchType;
        }

        /// <summary>
        /// Gets the Default dispatch type that will be used for an event.
        /// </summary>
        public EventDispatchType DispatchType { get; private set; }
    }
}