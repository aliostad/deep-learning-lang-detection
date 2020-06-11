using System;

namespace OptimizedLoadBalance
{
    class Program
    {
        static void Main(string[] args)
        {
            var loadBalancer1 = LoadBalancer.GetLoadBalancer();
            var loadBalancer2 = LoadBalancer.GetLoadBalancer();
            var loadBalancer3 = LoadBalancer.GetLoadBalancer();
            var loadBalancer4 = LoadBalancer.GetLoadBalancer();

            if (loadBalancer1 == loadBalancer2 && loadBalancer2 == loadBalancer3 && loadBalancer3 == loadBalancer4)
                Console.WriteLine("Same Instance\n");

            var loadBalancer = LoadBalancer.GetLoadBalancer();
            for (int i = 0; i < 15; i++)
            {
                var serverName = loadBalancer.NextServer.Name;
                Console.WriteLine("Dispatch request to: " + serverName);
            }

            Console.ReadKey();
        }
    }
}
