using System;
using System.Collections.Generic;
using System.Text;

namespace CPCBigFile
{
    static class Plugin
    {
        static private CPCBigFile.Controller.Editor controllerEditor;
        static public CPCBigFile.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }

        static private CPCBigFile.Controller.Compiler controllerCompiler;
        static public CPCBigFile.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }
    }
}
