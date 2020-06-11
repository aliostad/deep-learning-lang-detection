// ReSharper disable once CheckNamespace
namespace System.Windows.Threading
{
    public static class Dispatch
    {
        private static IDispatch _defaultDispatch = CreateDefaultDispatch();        
        public static IDispatch Current
        {
            get { return _defaultDispatch; }
            set { _defaultDispatch = value; }
        }

        private static IDispatch CreateDefaultDispatch()
        {
            DefaultDispatch dispatch = new DefaultDispatch();            
            return dispatch;
        }
    }
}
