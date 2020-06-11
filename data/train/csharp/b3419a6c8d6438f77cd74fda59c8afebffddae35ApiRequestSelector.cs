using KyaniCan.Mobile.Common.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KyaniCan.Mobile.Service
{
    public class ApiRequestSelector<T>
    {
        private readonly PriorityType _priority;
        private readonly IApiRequest<T> _apiRequest;

        public ApiRequestSelector(IApiRequest<T> apiService, PriorityType priority)
        {
            _priority = priority;
            _apiRequest = apiService;
        }

        public T GetApiRequestByPriority()
        {
            T apiRequest;

            switch (_priority)
            {
                case PriorityType.Speculative:
                    apiRequest = _apiRequest.Speculative;
                    break;
                case PriorityType.UserInitiated:
                    apiRequest = _apiRequest.UserInitiated;
                    break;
                case PriorityType.Background:
                    apiRequest = _apiRequest.Background;
                    break;
                default:
                    apiRequest = _apiRequest.UserInitiated;
                    break;
            }

            return apiRequest;
        }
    }
}
