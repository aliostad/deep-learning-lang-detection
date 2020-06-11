using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;

namespace Uniframework
{
    /// <summary>
    /// 网络远程调用数据包
    /// </summary>
    [Serializable]
    public class NetworkInvokePackage
    {
        private NetworkInvokeType invokeType = NetworkInvokeType.Unknown;
        private string sessionId;
        private ClientType clientType = ClientType.SmartClient;
        private HybridDictionary context;

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="invokeType">调用类型</param>
        /// <param name="sessionId">调用者会话标识</param>
        public NetworkInvokePackage(NetworkInvokeType invokeType, string sessionId)
        {
            this.invokeType = invokeType;
            this.sessionId = sessionId;
            context = new HybridDictionary();
        }

        /// <summary>
        /// 构造函数（重载）
        /// </summary>
        /// <param name="invokeType">调用类型</param>
        /// <param name="sessionId">调用者会话标识</param>
        /// <param name="clientType">客户端类型</param>
        public NetworkInvokePackage(NetworkInvokeType invokeType, string sessionId, ClientType clientType)
            : this(invokeType, sessionId)
        {
            this.clientType = clientType;
        }

        /// <summary>
        /// 调用类型
        /// </summary>
        public NetworkInvokeType InvokeType
        {
            get { return invokeType; }
        }

        /// <summary>
        /// 调用者会话标识
        /// </summary>
        public string SessionId
        {
            get { return sessionId; }
        }

        /// <summary>
        /// 客户端类型
        /// </summary>
        public ClientType ClientType
        {
            get { return clientType; }
        }

        /// <summary>
        /// 调用包上下文用于存放相关的调用的详细信息，服务器端接收到调用包对此进行解析
        /// </summary>
        public HybridDictionary Context
        {
            get { return context; }
        }
    }

    /// <summary>
    /// 网络远程调用类型
    /// </summary>
    [Serializable]
    public enum NetworkInvokeType
    { 
        /// <summary>
        /// 未知调用
        /// </summary>
        Unknown,
        /// <summary>
        /// Ping
        /// </summary>
        Ping,
        /// <summary>
        /// 远程调用
        /// </summary>
        Invoke,
        /// <summary>
        /// 注册会话
        /// </summary>
        Register,
        /// <summary>
        /// 获取服务
        /// </summary>
        RemoteService
    }

    /// <summary>
    /// 客户端类型
    /// </summary>
    [Serializable]
    public enum ClientType
    { 
        /// <summary>
        /// 智能客户端
        /// </summary>
        SmartClient,
        /// <summary>
        /// 移动客户端
        /// </summary>
        Mobile
    }
}
