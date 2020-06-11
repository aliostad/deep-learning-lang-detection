using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestCatchType
{
    public class Class1
    {
        public static void Invoke()
        {
            Invoke();
            try
            {
                Invoke();

            }
            catch (ArgumentException e)
            {
                Invoke();
            }
            catch (IndexOutOfRangeException e)
            {
                Invoke();

            }
            Invoke();
        }
    }
}
