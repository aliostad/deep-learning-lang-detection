using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Machine.Specifications;
using ParallelMSpecRunner.Utils;

namespace ParallelMSpecRunner.Tests
{
    public class When_invoke_once_is_used
    {
        static InvokeOnce<bool> InvokeOnce;
        static int CallTimes;

        Establish context = () => {
            InvokeOnce = new InvokeOnce<bool>(Action);
            CallTimes = 0;
        };

        private static void Action(bool value)
        {
            CallTimes++;
        }

        Because of = () => {
            InvokeOnce.Invoke(true);
            InvokeOnce.Invoke(true);
            InvokeOnce.Invoke(true);
        };

        It should_invoke_the_action_only_once = () => {
            CallTimes.ShouldEqual(1);
        };
        
    }
}
