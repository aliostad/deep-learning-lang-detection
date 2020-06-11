namespace Squire.Decoupled.Queries
{
    using Microsoft.Practices.ServiceLocation;
    using Squire.Setup;
    using Squire.Validation;

    public static class AppSetupQueryExtensions
    {
        public static IAdvancedAppSetup<T, IDispatchQuery> UseContainerQueryDispatch<T>(this IAppSetup<T> setup, IServiceLocator locator)
        {
            return setup.UseQueryDispatch(new IocQueryDispatcher(locator));
        }

        public static IAdvancedAppSetup<T, IDispatchQuery> UseQueryDispatch<T>(this IAppSetup<T> setup, IDispatchQuery dispatch)
        {
            dispatch.VerifyParam("dispatch").IsNotNull();
            return new AdvancedAppSetup<T, IDispatchQuery>(setup, dispatch);
        }
    }
}
