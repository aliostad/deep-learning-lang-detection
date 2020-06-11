using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Kafka.Protocol
{
    public class ApiVersionsRequest : Request
    {
        public ApiKey ApiKey => Protocol.ApiKey.ApiVersions;
        public short ApiVersion { get; }

        public ApiVersionsRequest(short apiVersion)
        {
            ApiVersion = apiVersion;
        }

        public void WriteTo(ProtocolWriter writer)
        {
            switch (ApiVersion)
            {
                case 0:
                    // Nothing to write
                    break;
                default:
                    throw new UnknownApiVersionException(ApiVersion, ApiKey);
            }
        }
    }
}
