using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Loqui.Generation
{
    public class MethodAPI : IEnumerable<string>
    {
        public string[] API { get; private set; }
        public string[] OptionalAPI { get; private set; }

        public MethodAPI(
            string[] api,
            string[] optionalAPI)
        {
            this.API = api;
            this.OptionalAPI = optionalAPI;
        }

        public MethodAPI(
            params string[] api)
        {
            this.API = api;
            this.OptionalAPI = new string[] { };
        }

        public IEnumerator<string> GetEnumerator()
        {
            foreach (var item in this.API)
            {
                yield return item;
            }
            foreach (var item in this.OptionalAPI)
            {
                yield return item;
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.GetEnumerator();
        }
    }
}
