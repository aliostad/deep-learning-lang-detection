using System;
using System.Collections.Generic;
using System.Text;

namespace CPCCloud
{
    static class Plugin
    {
        static private CPCCloud.Controller.Compiler controllerCompiler;
        static public CPCCloud.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }

        static private CPCCloud.Controller.Editor controllerEditor;
        static public CPCCloud.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }
    }
}
