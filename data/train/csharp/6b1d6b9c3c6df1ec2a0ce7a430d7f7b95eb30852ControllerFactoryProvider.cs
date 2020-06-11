using System;
using System.Linq;
using System.Reflection;

namespace KiraNet.GutsMvc.Implement
{
    public class ControllerFactoryProvider: IControllerFactoryProvider
    {
        private readonly ControllerCollection _controllerCollection;
        private readonly IControllerFactory _controllerFactory;
        private static ControllerCache _cache = new ControllerCache();

        public ControllerFactoryProvider(IControllerProvider controllerProvider, IControllerFactory controllerFactory =null)
        {
            if (controllerProvider == null)
                throw new ArgumentNullException(nameof(controllerProvider));

            _controllerCollection = controllerProvider.GetControllerCollection();

            _controllerFactory = controllerFactory ?? new ControllerFactory(); // 如果没有指定的IControllerFactory,则使用默认的ControllerFactory
        }

        public Func<ControllerContext, Controller> CreateControllerFactory(ControllerDescriptor descriptor)
        {
            if (descriptor == null)
                throw new ArgumentNullException(nameof(descriptor));

            // 先查看缓存中是否有该Controller
            if (!_cache.TryGetController(descriptor.ControllerName, out var controllerTypeInfo))
            {
                controllerTypeInfo = _controllerCollection
                        .Where(type =>
                        {
                            if (type.IsDefined(typeof(RouteControllerAttribute), true))
                            {
                                var routeController = type.GetCustomAttribute<RouteControllerAttribute>().RouteController;
                                if (String.Equals(routeController.ToLower().Replace("controller", ""), descriptor.ControllerName, StringComparison.OrdinalIgnoreCase))
                                {
                                    return true;
                                }
                            }

                            if (String.Equals(type.Name.ToLower().Replace("controller",""), descriptor.ControllerName, StringComparison.OrdinalIgnoreCase))
                            {
                                return true;
                            }

                            return false;
                        }).FirstOrDefault();


                if (controllerTypeInfo == null)
                {                  
                    throw new InvalidOperationException($"无法找到指定的控制器：{descriptor.ControllerName}");
                }
                else
                {
                    _cache.TryAddOrUpdateController(descriptor.ControllerName, controllerTypeInfo);
                }
            }

            descriptor.ControllerType = controllerTypeInfo;

            return context =>
            {
                if (context == null)
                    throw new ArgumentNullException(nameof(context));

                context.ControllerInfo = controllerTypeInfo;
                context.ControllerDescriptor = descriptor;
                var controller = _controllerFactory.CreateController(context);

                // 对一些必要的属性进行赋值
                controller.RouteEntity = context.RouteEntity;

                return controller;
            };
        }

        public Action<ControllerContext, Controller> CreateControllerReleaser(ControllerDescriptor descriptor)
        {
            if (descriptor == null)
                throw new ArgumentNullException(nameof(descriptor));
            

            var controllerType = descriptor.ControllerType;
            if (controllerType == null)
                throw new ArgumentException($"ControllerFactoryProvider.CreateControllerFactory()方法的参数descriptor.ControllerType不可为空。");

            return _controllerFactory.DisposeController;
        }
    }

    //public class ControllerFactoryProvider : IControllerFactoryProvider
    //{
    //    private readonly IControllerActivatorProvider _activatorProvider;
    //    private readonly Func<ControllerContext, Controller> _factoryCreateController;
    //    private readonly Action<ControllerContext, Controller> _factoryReleaseController;
    //    private readonly IControllerPropertyActivator[] _propertyActivators;

    //    public ControllerFactoryProvider(
    //        IControllerActivatorProvider activatorProvider,
    //        IControllerFactory controllerFactory,
    //        IEnumerable<IControllerPropertyActivator> propertyActivators)
    //    {
    //        if (controllerFactory == null)
    //        {
    //            throw new ArgumentNullException(nameof(controllerFactory));
    //        }

    //        _activatorProvider = activatorProvider ?? throw new ArgumentNullException(nameof(activatorProvider));

    //        if (controllerFactory.GetType() != typeof(ControllerFactory))
    //        {
    //        _factoryCreateController = controllerFactory.CreateController;
    //        _factoryReleaseController = controllerFactory.DisposeController;
    //        }

    //        _propertyActivators = propertyActivators.ToArray();
    //    }

    //    public Func<ControllerContext, Controller> CreateControllerFactory(ControllerActionDescriptor descriptor)
    //    {
    //        if (descriptor == null)
    //        {
    //            throw new ArgumentNullException(nameof(descriptor));
    //        }

    //        var controllerType = descriptor.ControllerTypeInfo?.AsType();
    //        if (controllerType == null)
    //        {
    //            throw new ArgumentException($"ControllerFactoryProvider.CreateControllerFactory()方法的参数descriptor.ControllerTypeInfo不可为空。");
    //        }

    //        if (_factoryCreateController != null)
    //        {
    //            return _factoryCreateController;
    //        }

    //        var controllerActivator = _activatorProvider.CreateActivator(descriptor);
    //        var propertyActivators = GetPropertiesToActivate(descriptor);
    //        Controller CreateController(ControllerContext controllerContext)
    //        {
    //            var controller = controllerActivator(controllerContext);
    //            for (var i = 0; i < propertyActivators.Length; i++)
    //            {
    //                var propertyActivator = propertyActivators[i];
    //                propertyActivator(controllerContext, controller);
    //            }

    //            return controller;
    //        }

    //        return CreateController;
    //    }

    //    public Action<ControllerContext, Controller> CreateControllerReleaser(ControllerActionDescriptor descriptor)
    //    {
    //        if (descriptor == null)
    //        {
    //            throw new ArgumentNullException(nameof(descriptor));
    //        }

    //        var controllerType = descriptor.ControllerTypeInfo?.AsType();
    //        if (controllerType == null)
    //        {
    //            throw new ArgumentException($"ControllerFactoryProvider.CreateControllerFactory()方法的参数descriptor.ControllerTypeInfo不可为空。");
    //        }

    //        if (_factoryReleaseController != null)
    //        {
    //            return _factoryReleaseController;
    //        }

    //        return _activatorProvider.CreateReleaser(descriptor);
    //    }

    //    private Action<ControllerContext, Controller>[] GetPropertiesToActivate(ControllerActionDescriptor actionDescriptor)
    //    {
    //        var propertyActivators = new Action<ControllerContext, Controller>[_propertyActivators.Length];
    //        for (var i = 0; i < _propertyActivators.Length; i++)
    //        {
    //            var activatorProvider = _propertyActivators[i];
    //            propertyActivators[i] = activatorProvider.GetActivatorDelegate(actionDescriptor);
    //        }

    //        return propertyActivators;
    //    }
    //}
}
