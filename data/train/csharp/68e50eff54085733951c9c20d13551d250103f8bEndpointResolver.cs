// Copyright 2011-2016 Global Software Innovation Pty Ltd
using System;
using System.Collections.Generic;
using System.Linq;
using ReadiNow.Connector.Interfaces;
using EDC.ReadiNow.Model;

namespace ReadiNow.Connector.Service
{
    /// <summary>
    /// Resolves the endpoint resource that backs an API URI.
    /// </summary>
    class EndpointResolver : IEndpointResolver
    {
        /// <summary>
        /// Determine the API and Endpoint entities that an apiPath is referring to.
        /// </summary>
        /// <param name="apiPath">The relative API, relative to the API controller address.</param>
        /// <param name="apiOnly">If true, only resolve the API portion.</param>
        /// <returns>Entity IDs f the API and Endpoint.</returns>
        public EndpointAddressResult ResolveEndpoint( string[] apiPath, bool apiOnly )
        {
            // Handle empty address
            if ( apiPath == null || apiPath.Length == 0 )
                return new EndpointAddressResult( 0, 0 );

            // Determine API
            Api api = GetApi( apiPath [ 0 ] );
            long apiId = api?.Id ?? 0;

            long endpointId = 0;
            if ( !apiOnly && apiPath.Length > 1 && api != null )
            {
                endpointId = GetEndpoint( api, apiPath [ 1 ] );
            }

            EndpointAddressResult result = new EndpointAddressResult( apiId, endpointId );
            return result;
        }


        /// <summary>
        /// Determine the specific Api resource referenced by the URI part.
        /// </summary>
        /// <param name="apiPart">The part of the URI that references the API. Namely the first part after the common connector address.</param>
        /// <returns>The API resource.</returns>
        private Api GetApi( string apiPart )
        {
            List<Api> apis = Entity.GetByField<Api>( apiPart, "core:apiAddress", Api.ApiEnabled_Field, Api.ApiAddress_Field )
                .Where( api => api != null && api.ApiEnabled == true )
                .Where( api => string.CompareOrdinal( api.ApiAddress, apiPart) == 0 ) // enforce case sensitivity
                .Take(2).ToList();

            if ( apis.Count == 0 )
                throw new EndpointNotFoundException( "Unknown API name." );

            if (apis.Count == 2)
                throw new ConnectorConfigException( string.Format( Messages.MultipleApiHaveSameAddress, apiPart ) );

            return apis [ 0 ];
        }


        /// <summary>
        /// Determine the specific ApiEndpoint resource referenced by the URI part.
        /// </summary>
        /// <param name="api">The API on which the endpoint should be found.</param>
        /// <param name="endpointPart">The text name of just the endpoint (excludes the API path).</param>
        /// <returns>The Endpoint resource ID.</returns>
        private long GetEndpoint( Api api, string endpointPart )
        {
            if ( api == null )
                throw new ArgumentNullException( "api" ); // assert false

            List<ApiEndpoint> endpoints = api.ApiEndpoints
                .Where( endpoint => endpoint != null )
                .Where( endpoint => string.CompareOrdinal( endpoint.ApiEndpointAddress, endpointPart ) == 0 ) // enforce case sensitivity
                .Where( endpoint => endpoint.ApiEndpointEnabled == true )
                .Take( 2 ).ToList( );

            if ( endpoints.Count == 0 )
                throw new EndpointNotFoundException( "Unknown API endpoint name." );

            if ( endpoints.Count == 2 )
                throw new ConnectorConfigException( string.Format( Messages.MultipleEndpointsHaveSameAddress, endpointPart) );

            return endpoints [ 0 ].Id;
        }
    }
}
