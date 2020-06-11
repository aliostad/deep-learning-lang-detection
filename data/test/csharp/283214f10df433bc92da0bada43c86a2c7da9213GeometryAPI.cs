using GoogleMapsAPI.NET.API.Client;
using GoogleMapsAPI.NET.API.Common;
using GoogleMapsAPI.NET.API.Geometry.Types;

namespace GoogleMapsAPI.NET.API.Geometry
{
    /// <summary>
    /// Geometry API
    /// </summary>
    public class GeometryAPI : MapsAPI
    {

        #region Properties

        /// <summary>
        /// Spherical geometry
        /// </summary>
        public SphericalGeometry Spherical { get; } = new SphericalGeometry();

        #endregion

        #region Constructors

        /// <summary>
        /// Create a new instance
        /// </summary>
        /// <param name="client">API client</param>
        public GeometryAPI(MapsAPIClient client) : base(client)
        {
        }

        #endregion

    }
}