using System;
using System.ComponentModel;

namespace Vlc.DotNet.Core.Helpers
{
    internal static class EventsHelper
    {
        public static void RaiseEvent<TSender, THandler>(VlcEventHandler<TSender, THandler> handler, TSender sender, VlcEventArgs<THandler> arg)
        {
            if (handler == null)
                return;
            foreach (VlcEventHandler<TSender, THandler> singleInvoke in handler.GetInvocationList())
            {
                var syncInvoke = singleInvoke.Target as ISynchronizeInvoke;
                if (syncInvoke == null)
                {
                    singleInvoke.DynamicInvoke(new object[] {sender, arg});
                    continue;
                }
                //if (syncInvoke is Control && ((Control)syncInvoke).IsDisposed)
                //    continue;
                try
                {
                    if (syncInvoke.InvokeRequired)
                        syncInvoke.Invoke(singleInvoke, new object[] {sender, arg});
                    else
                        singleInvoke(sender, arg);
                }
                catch (ObjectDisposedException)
                {
                    //Because IsDisposed was true and IsDisposed could be false now...
                    continue;
                }
            }
        }
    }
}