using System;
using System.Collections.Generic;
using System.Text;

namespace CPCBitmap
{
    static class Plugin
    {
        static private CPCBitmap.Controller.Compiler controllerCompiler;
        static public CPCBitmap.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }

        static private CPCBitmap.Controller.Editor controllerEditor;
        static public CPCBitmap.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }
    }
}
