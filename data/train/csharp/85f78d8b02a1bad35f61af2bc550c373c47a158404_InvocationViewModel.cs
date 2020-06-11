using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

using ReflectionPresentation.Invocation;
using ReflectionPresentation.ViewModels.Commands;

namespace ReflectionPresentation.ViewModels
{
    public class InvocationViewModel : LoggedViewModel
    {
        public ICommand InvokeDirect
        {
            get
            {
                return GetLoggedCommand(DirectInvoke.Run);
            }
        }

        public ICommand InvokeMethodInfo
        {
            get
            {
                return GetLoggedCommand(MethodInfoInvoke.Run);
            }
        }

        public ICommand InvokeCachedMethodInfo
        {
            get
            {
                return GetLoggedCommand(MethodInfoCachedInvoke.Run);
            }
        }

        public ICommand InvokeInterface
        {
            get
            {
                return GetLoggedCommand(InterfaceInvoke.Run);
            }
        }

        public ICommand InvokeDelegate
        {
            get
            {
                return GetLoggedCommand(DelegateInvoke.Run);
            }
        }

        public ICommand InvokeFunc
        {
            get
            {
                return GetLoggedCommand(FuncInvoke.Run);
            }
        }

        public ICommand InvokeExpression
        {
            get
            {
                return GetLoggedCommand(ExpressionInvoke.Run);
            }
        }

        public ICommand InvokeCustomExpression
        {
            get
            {
                return GetLoggedCommand(CustomExpressionInvoke.Run);
            }
        }

        public ICommand InvokeDynamic
        {
            get
            {
                return GetLoggedCommand(DynamicTypeInvoke.Run);
            }
        }
    }
}
