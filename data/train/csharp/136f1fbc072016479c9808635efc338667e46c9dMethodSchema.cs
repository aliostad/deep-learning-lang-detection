using System.Reflection;

namespace Cvv.WebUtility.Mvc
{
    internal class MethodSchema
    {
        private string _methodName;

#if MEDIUMLEVEL
        private MethodInfo _invokeHandler;
#else
        private FastInvokeHandler _invokeHandler;
#endif
        private ParameterInfo[] _parameters;
        private bool _isStatic;

#if MEDIUMLEVEL
        public MethodSchema(string methodName, MethodInfo invokeHandler, ParameterInfo[] parameters, bool isStatic)
        {
            _methodName = methodName;
            _invokeHandler = invokeHandler;
            _parameters = parameters;
            _isStatic = isStatic;
        }
#else
        public MethodSchema(string methodName, FastInvokeHandler invokeHandler, ParameterInfo[] parameters, bool isStatic)
        {
            _methodName = methodName;
            _invokeHandler = invokeHandler;
            _parameters = parameters;
            _isStatic = isStatic;
        }
#endif

        public string MethodName
        {
            get { return _methodName; }
        }

#if MEDIUMLEVEL
        public MethodInfo InvokeHandler
        {
            get { return _invokeHandler; }
        }
#else
        public FastInvokeHandler InvokeHandler
        {
            get { return _invokeHandler; }
        }
#endif

        public ParameterInfo[] Parameters
        {
            get { return _parameters; }
        }

        public bool IsStatic
        {
            get { return _isStatic; }
        }
    }
}
