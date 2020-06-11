namespace PaintDotNet.Dynamic
{
    using PaintDotNet.Diagnostics;
    using System;
    using System.Reflection;

    public static class DynamicInvokeUtil
    {
        public static IDynamicInvoke Adapt(object target, bool allowPrivate)
        {
            Validate.IsNotNull<object>(target, "target");
            return new DynamicInvokeViaReflectionDispatch(target, (BindingFlags.Public | BindingFlags.Instance) | (allowPrivate ? BindingFlags.NonPublic : BindingFlags.Default));
        }

        public static IDynamicInvoke TryGetOrWrap(object target)
        {
            Validate.IsNotNull<object>(target, "target");
            IDynamicInvoke invoke = target as IDynamicInvoke;
            if (invoke != null)
            {
                return invoke;
            }
            Type[] types = new Type[] { typeof(string), typeof(object[]) };
            MethodInfo invokeMethodInfo = target.GetType().GetMethod("OnInvokeDynamicMethod", BindingFlags.NonPublic | BindingFlags.Instance, null, types, null);
            if (invokeMethodInfo == null)
            {
                return null;
            }
            return new DynamicInvokeViaPrivateOnInvokeDynamicMethod(target, invokeMethodInfo);
        }

        private sealed class DynamicInvokeViaPrivateOnInvokeDynamicMethod : IDynamicInvoke
        {
            private readonly MethodInfo invokeMethodInfo;
            private readonly object target;

            public DynamicInvokeViaPrivateOnInvokeDynamicMethod(object target, MethodInfo invokeMethodInfo)
            {
                this.target = target;
                this.invokeMethodInfo = invokeMethodInfo;
            }

            public object InvokeDynamicMethod(string name, object[] args)
            {
                object[] parameters = new object[] { name, args };
                return this.invokeMethodInfo.Invoke(this.target, parameters);
            }
        }

        private sealed class DynamicInvokeViaReflectionDispatch : IDynamicInvoke
        {
            private readonly BindingFlags bindingFlags;
            private readonly object target;

            public DynamicInvokeViaReflectionDispatch(object target, BindingFlags bindingFlags)
            {
                this.target = target;
                this.bindingFlags = bindingFlags;
            }

            public object InvokeDynamicMethod(string name, object[] args) => 
                this.target.GetType().GetMethod(name, this.bindingFlags)?.Invoke(this.target, args);
        }
    }
}

