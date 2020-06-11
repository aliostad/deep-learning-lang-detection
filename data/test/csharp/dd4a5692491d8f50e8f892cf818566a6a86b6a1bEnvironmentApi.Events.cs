using System;

namespace Aims.Sdk
{
    /// <summary>
    ///   Provides convenient access to the environment-specific API methods of the AIMS Platform.
    /// </summary>
    public partial class EnvironmentApi
    {
        /// <summary>
        ///   Provides convenient access to the event-related API methods of the AIMS Platform.
        /// </summary>
        public class EventsApi
        {
            private readonly EnvironmentApi _api;

            /// <summary>
            ///   Initializes a new instance of the <see cref="EventsApi"/> class.
            /// </summary>
            /// <param name="api">The API accessor.</param>
            internal EventsApi(EnvironmentApi api)
            {
                _api = api;
            }

            /// <summary>
            ///   Sends events to the API.
            /// </summary>
            /// <param name="events">The events to send.</param>
            public void Send(Event[] events)
            {
                _api.HttpHelper.Post(new Uri(_api.EnvironmentUri, "events"), events);
            }
        }
    }
}