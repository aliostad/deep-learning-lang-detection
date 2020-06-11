using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SunRpc.Core;
using SunSocket.Server.Interface;

namespace SunRpc.Server
{
    public class ProxyFactory
    {
        public RpcServerConfig config;
        public ProxyFactory(RpcServerConfig config)
        {
            this.config = config;
            invokeDict = new ConcurrentDictionary<uint, RpcInvoke>();
        }
        public ConcurrentDictionary<uint, RpcInvoke> invokeDict;
        public RpcInvoke GetInvoke(uint SessionId)
        {
            RpcInvoke invoke;
            invokeDict.TryGetValue(SessionId, out invoke);
            return invoke;
        }
    }
}
