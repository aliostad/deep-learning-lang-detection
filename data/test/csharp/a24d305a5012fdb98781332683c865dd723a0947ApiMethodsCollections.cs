namespace MobileApp.Core.Services.HttpService
{
    using System;
    using System.Collections.Generic;

    internal class ApiMethodsCollections
    {
        #region Fields

        private static readonly Dictionary<ApiMethodType, Lazy<ApiMethod>> LazyCollection = new Dictionary<ApiMethodType, Lazy<ApiMethod>>
                    {
                        {
                            ApiMethodType.GetAuth, new Lazy<ApiMethod>( () => new ApiMethod("auth?instance={INSTANCE}&userId={USERID}&pin={PIN}&version={VERSION}"))
                        },
                        {
                            ApiMethodType.GetAuthOut, new Lazy<ApiMethod>( () => new ApiMethod("auth/out"))
                        },
                        {
                            ApiMethodType.GetContacts, new Lazy<ApiMethod>( () => new ApiMethod("account/contacts"))
                        },
                        {
                            ApiMethodType.GetDevices, new Lazy<ApiMethod>( () => new ApiMethod("account/devices"))
                        },
                        {
                            ApiMethodType.GetVoicemails, new Lazy<ApiMethod>( () => new ApiMethod("account/voicemail"))
                        },
                        {
                            ApiMethodType.GetQueues, new Lazy<ApiMethod>( () => new ApiMethod("account/queues"))
                        },
                        {
                            ApiMethodType.GetNumbers, new Lazy<ApiMethod>( () => new ApiMethod("account/numbers"))
                        },
                        {
                            ApiMethodType.GetVoicemailMedia, new Lazy<ApiMethod>( () => new ApiMethod("account/voicemail/{MEDIAID}/raw", mediaRequest: true))
                        },
                        {
                            ApiMethodType.PutAccount, new Lazy<ApiMethod>( () => new ApiMethod("account", MethodType.PUT, true))
                        },
                        {
                            ApiMethodType.PutAccountStatus, new Lazy<ApiMethod>( () => new ApiMethod("account/status", MethodType.PUT, true))
                        },
                        {
                            ApiMethodType.PutVoicemails, new Lazy<ApiMethod>( () => new ApiMethod("account/voicemail", MethodType.PUT, true))
                        },
                        {
                            ApiMethodType.PutNumbers, new Lazy<ApiMethod>( () => new ApiMethod("account/numbers", MethodType.PUT, true))
                        },
                        {
                            ApiMethodType.PostReport, new Lazy<ApiMethod>( () => new ApiMethod("monitor/report/{USER}", MethodType.POST, true, contentType: "application/octet-stream"))
                        },
                        {
                            ApiMethodType.GetTransfer, new Lazy<ApiMethod>( () => new ApiMethod("account/contacts/{USERID}/transfer"))
                        },
                        {
                            ApiMethodType.GetChannels, new Lazy<ApiMethod>( () => new ApiMethod("account/contacts/channels"))
                        },
                        {
                            ApiMethodType.GetRegisteredDevices, new Lazy<ApiMethod>( () => new ApiMethod("account/contacts/devices"))
                        }
                    };

        #endregion

        public static ApiMethod GetMethod(ApiMethodType type)
        {
            return LazyCollection[type].Value;
        }
    }
}