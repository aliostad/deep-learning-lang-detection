using System;
using System.Collections.Generic;
using System.Text;

namespace CampaignMonitorAPIWrapper
{
    public class Subscribers
    {
        public static Result<List<CampaignMonitorAPI.Subscriber>> GetActive(string apiKey, string listID, DateTime addedAfter)
        {
            CampaignMonitorAPIWrapper.CampaignMonitorAPI.api _api = new CampaignMonitorAPI.api();

            object o = _api.GetSubscribers(apiKey, listID, addedAfter.ToString("yyyy-MM-dd HH:mm:ss"));

            if (o is CampaignMonitorAPI.Result)
                return new Result<List<CampaignMonitorAPI.Subscriber>>((CampaignMonitorAPI.Result)o, null);
            else
                return new Result<List<CampaignMonitorAPI.Subscriber>>(0, "Success", new List<CampaignMonitorAPI.Subscriber>((IEnumerable<CampaignMonitorAPI.Subscriber>)o));
        }

        public static Result<List<CampaignMonitorAPI.Subscriber>> GetBounced(string apiKey, string listID, DateTime bouncedAfter)
        {
            CampaignMonitorAPIWrapper.CampaignMonitorAPI.api _api = new CampaignMonitorAPI.api();

            object o = _api.GetBounced(apiKey, listID, bouncedAfter.ToString("yyyy-MM-dd HH:mm:ss"));

            if (o is CampaignMonitorAPI.Result)
                return new Result<List<CampaignMonitorAPI.Subscriber>>((CampaignMonitorAPI.Result)o, null);
            else
                return new Result<List<CampaignMonitorAPI.Subscriber>>(0, "Success", new List<CampaignMonitorAPI.Subscriber>((IEnumerable<CampaignMonitorAPI.Subscriber>)o));
        }

        public static Result<List<CampaignMonitorAPI.Subscriber>> GetUnsubscribed(string apiKey, string listID, DateTime unsubscribedAfter)
        {
            CampaignMonitorAPIWrapper.CampaignMonitorAPI.api _api = new CampaignMonitorAPI.api();

            object o = _api.GetUnsubscribed(apiKey, listID, unsubscribedAfter.ToString("yyyy-MM-dd HH:mm:ss"));

            if (o is CampaignMonitorAPI.Result)
                return new Result<List<CampaignMonitorAPI.Subscriber>>((CampaignMonitorAPI.Result)o, null);
            else
                return new Result<List<CampaignMonitorAPI.Subscriber>>(0, "Success", new List<CampaignMonitorAPI.Subscriber>((IEnumerable<CampaignMonitorAPI.Subscriber>)o));
        }

        public static Result<bool> GetIsSubscribed(string apiKey, string listID, string emailAddress)
        {
            CampaignMonitorAPIWrapper.CampaignMonitorAPI.api _api = new CampaignMonitorAPI.api();

            object o = _api.GetIsSubscribed(apiKey, listID, emailAddress);

            if (o is CampaignMonitorAPI.Result)
                return new Result<bool>((CampaignMonitorAPI.Result)o, false);
            else
                return new Result<bool>(0, "Success", Convert.ToBoolean(o));
        }

        public static Result<CampaignMonitorAPI.Subscriber> GetSingleSubscriber(string apiKey, string listID, string emailAddress)
        {
            CampaignMonitorAPIWrapper.CampaignMonitorAPI.api _api = new CampaignMonitorAPI.api();

            object o = _api.GetSingleSubscriber(apiKey, listID, emailAddress);

            if (o is CampaignMonitorAPI.Result)
                return new Result<CampaignMonitorAPI.Subscriber>((CampaignMonitorAPI.Result)o, null);
            else
                return new Result<CampaignMonitorAPI.Subscriber>(0, "Success", (CampaignMonitorAPI.Subscriber)o);
        }
    }
}
