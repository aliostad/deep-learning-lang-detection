using BeanstreamDotNetSDK.APIs;
using BeanstreamDotNetSDK.APIs.Interfaces;
using BeanstreamDotNetSDK.Globals;

namespace BeanstreamDotNetSDK
{
    public class BeanStreamService
    {
        public BeanStreamService(string merchantId, string profilesApiPasscode = null, string paymentsApiPasscode = null,
            string reportingApiPasscode = null)
        {
            Configuration.MerchantId = merchantId;
            Configuration.ProfilesApiPasscode = profilesApiPasscode;
            Configuration.PaymentsApiPasscode = paymentsApiPasscode;
            Configuration.ReportingApiPasscode = reportingApiPasscode;

            ProfilesAPI = new ProfilesAPI();
            ReportsAPI = new ReportsAPI();
            PaymentsAPI = new PaymentsAPI();
        }

        public IProfilesAPI ProfilesAPI { get; set; }
        public IReportsAPI ReportsAPI { get; set; }
        public IPaymentsAPI PaymentsAPI { get; set; }
    }
}
