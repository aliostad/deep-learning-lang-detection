using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    
    public interface ISomeApi
    {
        string TheBestMethod();
    }

    public class SomeApi : ISomeApi
    {
        private readonly IDependenceApi _dependenceApi;

        public SomeApi(IDependenceApi dependenceApi)
        {
            _dependenceApi = dependenceApi;
        }
        public string TheBestMethod()
        {
            if (_dependenceApi != null) return _dependenceApi.SomeApi();
            return "SomeApi->TheBestMethod";
        }
    }
}
