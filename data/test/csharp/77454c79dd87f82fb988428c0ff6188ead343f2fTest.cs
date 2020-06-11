using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FacadePattern
{
    public class Facade
    {
        public void Test()
        {
            IAModuleApi aapi = new AModuleApi();
            aapi.TestA();
            IBModuleApi bapi = new BModuleApi();
            bapi.TestB();
            ICModuleApi capi = new CModuleApi();
            capi.TestC();
        }
    }

    public interface IAModuleApi
    {
        void TestA();
    }

    public class AModuleApi : IAModuleApi
    {
        public void TestA()
        {
            Console.WriteLine("使用了AModuleApi");
        }
    }

    public interface IBModuleApi
    {
        void TestB();
    }

    public class BModuleApi : IBModuleApi
    {
        public void TestB()
        {
            Console.WriteLine("使用了BModuleApi");
        }
    }

    public interface ICModuleApi
    {
        void TestC();
    }

    public class CModuleApi : ICModuleApi
    {
        public void TestC()
        {
            Console.WriteLine("使用了CModuleApi");
        }
    }


}
