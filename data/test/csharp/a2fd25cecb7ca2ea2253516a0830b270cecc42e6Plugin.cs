using System;
using System.Collections.Generic;
using System.Text;

namespace CPCText
{
    static class Plugin
    {
        static private CPCText.Controller.Editor controllerEditor;
        static public CPCText.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }

        static private CPCText.Controller.Compiler controllerCompiler;
        static public CPCText.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }
    }
}
