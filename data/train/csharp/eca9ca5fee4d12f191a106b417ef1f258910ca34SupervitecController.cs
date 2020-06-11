using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Controller
{
    public class ControllerSupervitec
    {

        private TestController controllerTest;
        private Supervitec supervitec;
        private ModuleController controllerModule;
        

        public ControllerSupervitec() {
            supervitec = Supervitec.GetSupervitec;
        }

        public TestController Test_Controller
        {
            get
            {
                if (controllerTest==null)
                {
                    controllerTest = new TestController();
                }
                return controllerTest;           
            }
        }


        public static SerialController Serial_Controller
        {
            get
            {
                return SerialController.Serial_Controller;
            }
        }
        /// <summary>
        /// 
        /// </summary>            
        public ModuleController Module_Controller
        {
            get
            {
                if (controllerModule == null)
                {
                    controllerModule = new ModuleController();
                }
                return controllerModule;
            }
        }
    }
}
