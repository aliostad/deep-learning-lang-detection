using System;
using Leap;

namespace Theremin
{
    public class LeapController : ILeapController
    {
        private static LeapController leapController = null;

        private Controller controller;

        public static ILeapController GetController()
        {
            return leapController ?? (leapController = new LeapController());
        }

        private LeapController()
        {
            var listener = new LeapListener();
            controller = new Controller(listener);
            Listener = listener;
        }

        public ILeapListener Listener { get; private set; }
    }

    public interface ILeapController 
    {
        ILeapListener Listener { get; }
    }
}