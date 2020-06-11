using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OAI.Tools
{
    class OAIInvokeID
    {
        private const int MAXIMUM_INVOKE = 65535;
        private static int InvokeID = 0;
	
        public static int Next()
        {
            InvokeID++;

            if (MAXIMUM_INVOKE <= InvokeID)
            {
                return Reset();
            }

            return InvokeID;
        }
	
        public static int Reset()
        {
            return (InvokeID = 1);
        }

        public static int Prev()
        {
            InvokeID--;

            if (1 > InvokeID)
            {
                return Reset();
            }

            return InvokeID;
        }
    }
}
