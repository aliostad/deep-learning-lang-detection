using Nintaco;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelloNintaco
{
    class Program
    {
        private readonly RemoteAPI api = ApiSource.API;

        public void launch()
        {
            api.addFrameListener(renderFinished);
            api.addStatusListener(statusChanged);
            api.addActivateListener(apiEnabled);
            api.addDeactivateListener(apiDisabled);
            api.addStopListener(dispose);
            api.run();
        }

        private void apiEnabled()
        {
            Console.WriteLine("API enabled");
            //api.reset(); // Uncomment this to reset the console
        }

        private void apiDisabled()
        {
            Console.WriteLine("API disabled");
        }

        private void dispose()
        {
            Console.WriteLine("API stopped");
        }

        private void statusChanged(String message)
        {
            Console.WriteLine("Status message: {0}", message);
        }


        private void renderFinished()
        {
            ApiSource.API.writeGamepad(0, GamepadButtons.Left, true);

            if(DateTime.Now.Second %4 == 0)
            {
                ApiSource.API.writeGamepad(0, GamepadButtons.A, true);
            }

        }
        static void Main(string[] args)
        {
            ApiSource.initRemoteAPI("localhost", 9999);

            new Program().launch();
        }
    }
}
