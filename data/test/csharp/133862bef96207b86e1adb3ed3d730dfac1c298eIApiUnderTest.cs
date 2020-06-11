namespace Restival.ApiTests {
    public interface IApiUnderTest {
        string ApiUriPath { get; }
    }

    public class ServiceStackApi : IApiUnderTest {
        public string ApiUriPath {
            get { return ("api.servicestack"); }
        }
    }

    public class NancyApi : IApiUnderTest {
        public string ApiUriPath {
            get { return ("api.nancy"); }
        }
    }

    public class WebApiApi : IApiUnderTest {
        public string ApiUriPath {
            get { return ("api.webapi"); }
        }
    }

    public class OpenRastaApi : IApiUnderTest {
        public string ApiUriPath {
            get { return ("api.openrasta"); }
        }
    }
}
