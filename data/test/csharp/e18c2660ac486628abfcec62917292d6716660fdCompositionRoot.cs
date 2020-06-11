using System;
using System.Configuration;
using Ninject.Modules;
using NLog;
using MCO.Applications.WebDispatchPerformance;
using MCO.Applications.WebDispatchPerformance.Classes;
using MCO.Applications.WebDispatchPerformance.Interfaces;
using MCO.Data.WebDispatchPerformance;
using MCO.Data.WebDispatchPerformance.Models;
using MCO.Data.WebDispatchPerformance.Interfaces;
using MCO.Services.WebDispatchPerformance;
using MCO.Services.WebDispatchPerformance.Interfaces;
using Ninject;

namespace MCO.Applications.WebDispatchPerformance
{
    public class CompositionRoot
    {
        private static IKernel NinjectKernel;

        public static void Wire(INinjectModule module)
        {
            NinjectKernel = new StandardKernel(module);
        }

        public static T Resolve<T>()
        {
            return NinjectKernel.Get<T>();
        }
    }
}
