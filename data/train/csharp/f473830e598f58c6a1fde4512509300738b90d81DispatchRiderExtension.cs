using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Http.Internal;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace DispatchRider.AspNetCore
{
    public static class DispatchRiderExtension
    {
        static public IApplicationBuilder UseDispatchRider(this IApplicationBuilder app)
        {
            EnableRewind(app);
            return app.UseMiddleware<DispatchRiderMiddleware>();
        }

        static private void EnableRewind(IApplicationBuilder app)
        {
            app.Use(next => async context => {
                var initialBody = context.Request.Body;
                context.Request.EnableRewind();

                await next(context);
                return;
            });

        }
        public static DispatchRiderServicesBuilder AddDispatchRider(this IServiceCollection services)
        {
            return services.AddDispatchRider(configureOptions: null);
        }

        static public DispatchRiderServicesBuilder AddDispatchRider(this IServiceCollection services, Action<DispatchRiderOptions> configureOptions)
        {
            services.TryAddTransient<IDispatchRiderService, DispatchRiderService>();
            services.Configure<FormOptions>(s => {
                s.BufferBody = true;
            });
            services.Configure(configureOptions);

            return new DispatchRiderServicesBuilder(services);
        }
    }
}