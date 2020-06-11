using System.Diagnostics;
using XenoGears.Web.Rest.Context;

namespace XenoGears.Web.Rest.Dispatch
{
    [DebuggerNonUserCode]
    public static class RestDispatcher
    {
        public static DispatchContext Dispatch(this RestRequest req)
        {
            return req == null ? null : req.Context.Dispatch();
        }

        public static DispatchContext Dispatch(this RestContext ctx)
        {
            if (ctx == null) return null;
            var storage = ctx.Native.Items;
            var key = "XenoGears.RestContext.DispatchContext";
            if (!storage.Contains(key)) storage[key] = new DispatchContext(ctx.Request);
            return (DispatchContext)storage[key];
        }
    }
}