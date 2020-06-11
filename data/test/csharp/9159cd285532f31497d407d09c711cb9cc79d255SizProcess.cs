namespace Sizmon.Domain
{
    using System.Diagnostics;
    using Newtonsoft.Json.Linq;

    public class SizProcess : IToJson
    {
        private readonly Process processInfo;

        public SizProcess(Process processInfo)
        {
            this.processInfo = processInfo;
        }

        public JObject ToJson()
        {
            if (processInfo != null)
            {
                var json = new JObject();

                json["ProcessName"] = processInfo.ProcessName;
                json["WorkingSet64"] = processInfo.WorkingSet64;

                return json;
            }

            else
                return null;
        }
    }
}
