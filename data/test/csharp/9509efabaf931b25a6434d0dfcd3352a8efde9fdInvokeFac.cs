using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Slb.InversionOptimization.InversionManagerFormsApplication

{
    public class InvokeFac
    {
        public delegate R Lambda1Inp<R, I>(I x);

        public static Lambda1Inp<R, I> makeLambda1InpInvoke<R, I>(Lambda1Inp<R, I> l, System.Windows.Forms.Control c)
        {
            return delegate(I x)
            {
                if (c.InvokeRequired)
                {
                    return (R)c.Invoke(l, x); //new I[] { x });
                }
                else
                {
                    return l(x);
                }
            };
        }

        public delegate void LambdaVoid0Inp();

        public static LambdaVoid0Inp makeLambdaVoid0InpInvoke(LambdaVoid0Inp l, System.Windows.Forms.Control c)
        {
            return delegate()
            {
                if (c.InvokeRequired)
                {
                    c.BeginInvoke(l);
                }
                else
                {
                    l();
                }
            };
        }

        public delegate void LambdaVoid1Inp<I>(I x);

        public static LambdaVoid1Inp<I> makeLambdaVoid1InpInvoke<I>(LambdaVoid1Inp<I> l, System.Windows.Forms.Control c)
        {
            return delegate(I x)
            {
                if (c.InvokeRequired)
                {
                    //Console.WriteLine("c == null:" + (c == null) + " d==null: " + (d == null) + " x == null: " + (x == null));
                    c.BeginInvoke(l, x); //new I[] { x });
                    //c.BeginInvoke(d, x); //new I[] { x });
                }
                else
                {
                    l(x);
                }
            };
        }

        public delegate R Lambda0Inp<R>();

        public static Lambda0Inp<R> makeLambda0InpInvoke<R>(Lambda0Inp<R> l, System.Windows.Forms.Control c)
        {
            return delegate()
            {
                if (c.InvokeRequired)
                {
                    if (!c.IsDisposed)
                    {
                        //return (R)c.Invoke(l);
                        IAsyncResult ar = c.BeginInvoke(l);
                        return (R)c.EndInvoke(ar);
                    }
                    else return default(R);
                }
                else
                {
                    return l();
                }
            };
        }

    }
}
