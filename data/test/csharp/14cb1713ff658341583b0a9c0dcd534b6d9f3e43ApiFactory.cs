using Overrustlelogs.Api.Interfaces;
using Overrustlelogs.ViewModels.Interfaces;

namespace Overrustlelogs.ViewModels.Factories {
    public class ApiFactory : IApiFactory {
        private readonly IApiChannels _apiChannels;
        private readonly IApiDays _apiDays;
        private readonly IApiLogs _apiLogs;
        private readonly IApiMentions _apiMentions;
        private readonly IApiMonths _apiMonths;
        private readonly IApiUserlogs _apiUserlogs;

        public ApiFactory(IApiChannels apiChannels, IApiMonths apiMonths, IApiDays apiDays,
            IApiLogs apiLogs, IApiUserlogs apiUserlogs, IApiMentions apiMentions) {
            _apiChannels = apiChannels;
            _apiMonths = apiMonths;
            _apiDays = apiDays;
            _apiLogs = apiLogs;
            _apiUserlogs = apiUserlogs;
            _apiMentions = apiMentions;
        }

        public IApiChannels GetApiChannels() {
            return _apiChannels;
        }

        public IApiMonths GetApiMonths() {
            return _apiMonths;
        }

        public IApiDays GetApiDayss() {
            return _apiDays;
        }

        public IApiLogs GetApiLogss() {
            return _apiLogs;
        }

        public IApiUserlogs GetApiUserlogs() {
            return _apiUserlogs;
        }

        public IApiMentions GetApiMentions() {
            return _apiMentions;
        }
    }
}