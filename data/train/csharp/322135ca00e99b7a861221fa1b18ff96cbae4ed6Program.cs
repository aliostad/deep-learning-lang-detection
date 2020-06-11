using NetApi;
using System;

namespace TraderApiTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("test");
            ////XtTraderApi pTraderApi = XtTraderApi.createXtTraderApi("192.168.1.117:56000");
            XtTraderApi pTraderApi = XtTraderApi.createXtTraderApi("114.113.231.66:56001‍");
            Callback pcallback = new Callback();
            pTraderApi.setCallback(pcallback);
            pTraderApi.init();
            pTraderApi.join();
            Console.ReadLine();
        }
    }
}
