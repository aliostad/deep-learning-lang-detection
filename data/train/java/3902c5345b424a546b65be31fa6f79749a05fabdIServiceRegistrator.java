package cz.cuni.mff.d3s.been.pluger;

public interface IServiceRegistrator {

    <I, C extends I> C registerService(Class<I> serviceInterface, C serviceImplementationInstance);
    <I, C extends I> C registerService(Class<I> serviceInterface, Class<C> serviceImplementation);
    <I, C extends I> C registerService(String serviceName, Class<I> serviceInterface, C serviceImplementationInstance);
    <I, C extends I> C registerService(String serviceName, Class<I> serviceInterface, Class<C> serviceImplementation);
    <C> C registerService(Class<C> serviceImplementation);
    <C> C registerService(C serviceImplementationInstance);
    <C> C registerService(String serviceName, Class<C> serviceImplementation);
    <C> C registerService(String serviceName, C serviceImplementationInstance);

}
