namespace SmsWeb

open System;
open System.Linq;
open System.Web;
open Microsoft.Web.Infrastructure.DynamicModuleHelper;
open Ninject;
open Ninject.Web.Common;
open Microsoft.AspNet.SignalR

type NinjectResolver(kernel:IKernel) =
    let _kernel = kernel
    interface System.Web.Http.Dependencies.IDependencyResolver with 
        member this.BeginScope():Http.Dependencies.IDependencyScope = upcast this
        member this.GetService(t) =
            _kernel.TryGet(t)
        member this.GetServices(t)=
            _kernel.GetAll(t)
        member this.Dispose() = ()

type SignalRNinjectDependencyResolver(kernel: IKernel) =
    inherit DefaultDependencyResolver()

    override x.GetService(serviceType: Type) =
        let o = kernel.TryGet(serviceType)
        match o with
        | null -> base.GetService(serviceType)
        | _ -> o

    override x.GetServices(serviceType: Type): System.Collections.Generic.IEnumerable<System.Object> =
        kernel.GetAll(serviceType).Concat(base.GetServices(serviceType));

type NinjectWebCommon() =
    static member bootstrapper = new Bootstrapper();

    /// <summary>
    /// Starts the application
    /// </summary>
    static member Start() =
        DynamicModuleUtility.RegisterModule(typeof<OnePerRequestHttpModule>)
        DynamicModuleUtility.RegisterModule(typeof<NinjectHttpModule>)
        NinjectWebCommon.bootstrapper.Initialize(fun () -> NinjectWebCommon.CreateKernel());
        
    /// <summary>
    /// Stops the application.
    /// </summary>
    static member Stop() =
        NinjectWebCommon.bootstrapper.ShutDown();       

    /// <summary>
    /// Creates the kernel that will manage your application.
    /// </summary>
    /// <returns>The created kernel.</returns>
    static member CreateKernel() : IKernel =
        let kernel = new StandardKernel()
        kernel.Bind<Func<IKernel>>().ToMethod((fun ctx -> Func<IKernel>(fun () -> 
            let bs = new Bootstrapper()
            bs.Kernel))) |> ignore
        kernel.Bind<IHttpModule>().To<HttpApplicationInitializationHttpModule>() |> ignore

        NinjectWebCommon.RegisterServices(kernel)
        kernel :> IKernel

    /// <summary>
    /// Load your modules or register your services here!
    /// </summary>
    /// <param name="kernel">The kernel.</param>
    static member RegisterServices(kernel: IKernel) =
        System.Web.Http.GlobalConfiguration.Configuration.DependencyResolver <- new NinjectResolver(kernel)
        Microsoft.AspNet.SignalR.GlobalHost.DependencyResolver <- new SignalRNinjectDependencyResolver(kernel);
        kernel.Bind<SmsWeb.Services.IAuthenticationService>().ToConstant(SmsWeb.Services.AuthenticationService())|> ignore


module AssemblyAttributes =
    [<assembly: WebActivatorEx.PreApplicationStartMethod(typeof<NinjectWebCommon>, "Start")>]
    [<assembly: WebActivatorEx.ApplicationShutdownMethodAttribute(typedefof<NinjectWebCommon>, "Stop")>]
    do()