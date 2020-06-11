using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HIPHttpApi
{
    internal class PhoneCallEndpoint
    {
        public static string PhoneStatus(uint? account)
        {
            string api = "/api/phone/status";

            if (account.HasValue)
                api = string.Concat(api, "?account=", account);

            return api;
        }

        internal static string Callstatus(uint? session)
        {
            string api = "/api/call/status";

            if (session.HasValue)
                api = string.Concat(api, "?session=", session);

            return api;
        }

        internal static string CallDial(string number)
        {
            string api = "/api/call/dial";
            
            api = string.Concat(api, "?number=", number);
            
            return api;
        }

        internal static string CallAnswer(uint session)
        {
            string api = "/api/call/answer";
            
            api = string.Concat(api, "?session=", session);
            
            return api;
        }

        internal static string CallHangup(uint session, HangupReason reason)
        {
            string api = "/api/call/dail";

            api = string.Concat(api, "?session=", session);
            api = string.Concat(api, "&reason=", reason.ToString().ToLower());

            return api;
        }
    }

    public enum SessionDirection
    {
        Unknown,
        Incoming,
        Outgoing
    }

    public enum SessionState
    {
        Unknown,
        Connecting,
        Ringing,
        Connected
    }

    public enum HangupReason
    {
        Normal,
        Rejected,
        Busy
    }
}
