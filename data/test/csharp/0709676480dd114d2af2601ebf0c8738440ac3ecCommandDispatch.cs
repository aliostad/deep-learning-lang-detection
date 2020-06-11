using UnityEngine;
using System;
using Utils;

namespace ToluaContainer.Container
{
    [AddComponentMenu("ToluaContainer/Command dispatch")]
    public class CommandDispatch : NamespaceCommandBehaviour
    {
        /// <summary>
        /// 要调用的 command 的类型
        /// </summary>
        protected Type commandType;

        /// <summary>
        /// 当脚步初始化时调用
        /// </summary>
        protected void Awake()
        {
            commandType = TypeUtils.GetType(commandNamespace, commandName);
        }

        /// <summary>
        /// 发送 command.
        /// </summary>
        public void DispatchCommand()
        {
            CommanderUtils.DispatchCommand(commandType);
        }

        /// <summary>
        /// 发送 command.
        /// </summary>
        public void DispatchCommand(params object[] parameters)
        {
            CommanderUtils.DispatchCommand(commandType, parameters);
        }
    }
}