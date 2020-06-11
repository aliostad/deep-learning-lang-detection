
namespace CSharpSamples
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Stores information about a particular dispatch action
    /// </summary>
    /// <typeparam name="T">The type of the payload of the dispatch action.</typeparam>
    public class DispatchRegistration<T>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DispatchRegistration&lt;T&gt;"/> class.
        /// </summary>
        public DispatchRegistration()
        {
        }

        /// <summary>
        /// Gets or sets the name of the dispatch action.
        /// </summary>
        /// <value>The name of the dispatch action.</value>
        public string Name
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the dispatch action.
        /// </summary>
        /// <value>The dispatch action.</value>
        public Func<T, DispatchResult> DispatchAction
        {
            get;
            set;
        }
    }
}
