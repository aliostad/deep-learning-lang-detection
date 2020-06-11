using System;
using System.Collections.Generic;
using System.Text;

namespace CPCRawBitmap
{
    static class Plugin
    {
        static private CPCRawBitmap.Controller.Compiler controllerCompiler;
        static public CPCRawBitmap.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }

        static private CPCRawBitmap.Controller.Editor controllerEditor;
        static public CPCRawBitmap.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }
    }
}
